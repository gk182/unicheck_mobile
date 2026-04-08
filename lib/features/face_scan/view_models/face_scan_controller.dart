import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Size;
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:unicheck_mobile/app/common/routes.dart';
import 'package:unicheck_mobile/features/bottom_navigation/view_models/navigation_controller.dart';
import 'package:unicheck_mobile/features/home_page/view_models/home_controller.dart';
import 'package:unicheck_mobile/core/api/api_exceptions.dart';
import 'package:unicheck_mobile/features/face_scan/models/check_in_response_model.dart';
import 'package:unicheck_mobile/services/api/attendance_api_service.dart';
import 'package:unicheck_mobile/services/location_service/location_service.dart';

// ── Trạng thái luồng face scan ─────────────────────────────────────────────
enum FaceScanState {
  initializing, // Đang khởi tạo camera + GPS
  waitingGps, // Camera sẵn sàng, đang chờ GPS
  scanning, // Sẵn sàng quét (GPS ok)
  processing, // Đang chụp + gửi API
  success, // Điểm danh thành công
  error, // Có lỗi
}

/// Controller điểm danh: Camera → MLKit → GPS → POST /api/attendance/check-in
class FaceScanController extends GetxController {
  // ── Dependencies ───────────────────────────────────────────────────────────
  final AttendanceApiService _attendanceApi = Get.find<AttendanceApiService>();
  final LocationService _locationService = LocationService();

  // ── Params truyền từ QrScanPage ───────────────────────────────────────────
  final String qrToken;
  FaceScanController({required this.qrToken});

  // ── State ──────────────────────────────────────────────────────────────────
  FaceScanState state = FaceScanState.initializing;

  String instructionText = 'Đang khởi tạo camera...';
  String errorMessage = '';
  bool showManualButton = false;
  bool faceDetected = false;

  // Dữ liệu GPS
  double? _latitude;
  double? _longitude;
  String locationText = 'Đang lấy vị trí...';
  bool isLocationValid = false;

  // Kết quả check-in thật từ server
  CheckInResponseModel? checkInResult;

  // ── Camera & MLKit ─────────────────────────────────────────────────────────
  CameraController? cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _isCameraDisposed = false;

  // ── Timer: hiện nút chụp thủ công sau 10 giây ────────────────────────────
  Timer? _manualButtonTimer;

  // ── Getters ────────────────────────────────────────────────────────────────
  bool get isInitializing =>
      state == FaceScanState.initializing || state == FaceScanState.waitingGps;
  bool get isScanning => state == FaceScanState.scanning;
  bool get isProcessing => state == FaceScanState.processing;
  bool get isSuccess => state == FaceScanState.success;
  bool get isError => state == FaceScanState.error;

  @override
  void onInit() {
    super.onInit();
    _initFaceDetector();
    _initCamera();
  }

  @override
  void onClose() {
    _manualButtonTimer?.cancel();
    _stopCameraAndCleanup();
    super.onClose();
  }

  // ── Khởi tạo MLKit ─────────────────────────────────────────────────────────
  void _initFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // cần smilingProbability
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  // ── Khởi tạo Camera, sau đó lấy GPS ───────────────────────────────────────
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup:
            Platform.isAndroid
                ? ImageFormatGroup.nv21
                : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();
      _isCameraDisposed = false;

      // Camera xong → lấy GPS song song
      _setState(FaceScanState.waitingGps);
      instructionText = 'Đang lấy vị trí GPS...';
      update();

      await _fetchGps();
    } catch (e) {
      _setError('Lỗi khởi tạo camera. Vui lòng cấp quyền camera và thử lại.');
    }
  }

  // ── Lấy GPS thật từ Geolocator ─────────────────────────────────────────────
  Future<void> _fetchGps() async {
    try {
      final position = await _locationService.getCurrentPosition();

      if (position == null) {
        _setError(
          'Không thể lấy GPS. Vui lòng bật vị trí và cấp quyền cho ứng dụng.',
        );
        return;
      }

      _latitude = position.latitude;
      _longitude = position.longitude;
      isLocationValid = true;

      // Thử lấy địa chỉ textual (không làm chậm luồng nếu thất bại)
      _fetchPlacemark(position.latitude, position.longitude);

      debugPrint('[FaceScan] GPS: lat=$_latitude, lng=$_longitude');

      // GPS ok → bắt đầu quét
      _startScanning();
    } catch (e) {
      _setError('Không thể lấy GPS: ${e.toString()}');
    }
  }

  /// Lấy địa danh hiển thị — không chặn luồng chính
  void _fetchPlacemark(double lat, double lng) async {
    try {
      final placemark = await _locationService.getPlacemarkFromCoordinates(
        lat,
        lng,
      );
      if (placemark != null) {
        locationText =
            '${placemark.street ?? placemark.locality ?? 'Vị trí hiện tại'}';
      } else {
        locationText = '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
      }
      update();
    } catch (_) {
      locationText = '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
      update();
    }
  }

  // ── Bắt đầu quét khuôn mặt ────────────────────────────────────────────────
  void _startScanning() {
    _setState(FaceScanState.scanning);
    instructionText = 'Giữ khuôn mặt trong khung hình\nđể điểm danh';
    showManualButton = false;
    faceDetected = false;
    errorMessage = '';
    update();

    _startImageStream();
    _startManualButtonTimer();
  }

  void _startImageStream() {
    cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting || !isScanning || _isCameraDisposed) return;
      _isDetecting = true;

      try {
        final inputImage = _convertToInputImage(image);
        if (inputImage == null) return;

        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          if (!faceDetected) {
            faceDetected = true;
            update();
          }

          Object? leftEyeOpenProb = faces.first.leftEyeOpenProbability;
          Object? rightEyeOpenProb = faces.first.rightEyeOpenProbability;

          // Kiểm tra xem mắt có mở không (để tránh nhắm mắt lúc chụp)
          double leftOpen = (leftEyeOpenProb is double) ? leftEyeOpenProb : 1.0;
          double rightOpen =
              (rightEyeOpenProb is double) ? rightEyeOpenProb : 1.0;

          if (leftOpen > 0.5 && rightOpen > 0.5) {
            await _processCapture();
          }
        } else {
          if (faceDetected) {
            faceDetected = false;
            update();
          }
        }
      } catch (_) {
        // bỏ qua lỗi frame đơn lẻ
      } finally {
        if (!isProcessing) _isDetecting = false;
      }
    });
  }

  // ── Timer hiện nút chụp thủ công sau 10 giây ─────────────────────────────
  void _startManualButtonTimer() {
    _manualButtonTimer?.cancel();
    _manualButtonTimer = Timer(const Duration(seconds: 5), () {
      if (isScanning) {
        showManualButton = true;
        instructionText =
            'Không thể tự động chụp.\nNhấn nút bên dưới để chụp thủ công.';
        update();
      }
    });
  }

  // ── Nút chụp thủ công ─────────────────────────────────────────────────────
  Future<void> manualCapture() async {
    if (!isScanning || isProcessing) return;
    await _processCapture();
  }

  // ── Core: Chụp ảnh → Base64 → GPS → POST /api/attendance/check-in ─────────
  Future<void> _processCapture() async {
    if (!isScanning || _isCameraDisposed) return;

    _manualButtonTimer?.cancel();
    showManualButton = false;
    _isDetecting = true;

    // Dừng camera stream ngay để không xử lý thêm frame
    await cameraController?.stopImageStream();

    _setState(FaceScanState.processing);
    instructionText = 'Đang xác thực khuôn mặt...';
    update();

    try {
      // 1. Chụp ảnh
      final XFile photo = await cameraController!.takePicture();
      final bytes = await File(photo.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      debugPrint('[FaceScan] Ảnh chụp: ${bytes.length} bytes');

      // 2. Đảm bảo có GPS (phải có trước khi vào _processCapture)
      if (_latitude == null || _longitude == null) {
        throw Exception('Chưa có dữ liệu GPS.');
      }

      instructionText = 'Đang gửi dữ liệu lên server...';
      update();

      // 3. Gọi API thật — POST /api/attendance/check-in
      final result = await _attendanceApi.checkIn(
        qrToken: qrToken,
        faceImageBase64: base64Image,
        latitude: _latitude!,
        longitude: _longitude!,
      );

      checkInResult = result;
      _handleSuccess(result);
    } on NetworkException catch (e) {
      _setError(e.message);
    } on ApiException catch (e) {
      _handleApiError(e);
    } catch (e) {
      _setError('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
    } finally {
      _isDetecting = false;
    }
  }

  // ── Xử lý thành công ────────────────────────────────────────────────
  void _handleSuccess(CheckInResponseModel result) async {
    _setState(FaceScanState.success);
    instructionText =
        result.status == 'LATE'
            ? 'Điểm danh thành công! (Trễ giờ)'
            : 'Điểm danh thành công!';
    update();

    // Chờ 2 giây để user thấy màn kết quả
    await Future.delayed(const Duration(seconds: 2));

    // Cập nhật HomeController trực tiếp (không cần navigate lại)
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().onCheckInSuccess(status: result.status);
    }

    // Chuyển về tab Home (index 0) và pop tất cả các route đến BottomNavigationView
    if (Get.isRegistered<NavigationController>()) {
      Get.find<NavigationController>().changePage(0);
    }
    Get.until((route) => route.settings.name == Routes.bottomNavigationView);
  }

  // ── Xử lý lỗi API 400 theo từng message server ────────────────────────────
  void _handleApiError(ApiException e) async {
    final msg = e.message;
    debugPrint('[FaceScan] ApiException: $msg (status=${e.statusCode})');

    // QR hết hạn → Quay về QR Scanner để quét lại
    if (msg.contains('hết hạn') || msg.contains('expired')) {
      _setError(
        'QR code đã hết hạn.\nVui lòng quét lại mã mới trên màn chiếu.',
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.back(); // Quay về QR Scanner
      return;
    }

    // Đã điểm danh rồi → Về Home
    if (msg.contains('đã điểm danh')) {
      _setError('Bạn đã điểm danh cho buổi học này rồi.');
      await Future.delayed(const Duration(seconds: 2));
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().onCheckInSuccess(status: 'PRESENT');
      }
      if (Get.isRegistered<NavigationController>()) {
        Get.find<NavigationController>().changePage(0);
      }
      Get.until((route) => route.settings.name == Routes.bottomNavigationView);
      return;
    }

    // Quá 30 phút → Không thể điểm danh
    if (msg.contains('30 phút') || msg.contains('quá giờ')) {
      _setError('Đã quá 30 phút kể từ đầu giờ học.\nKhông thể điểm danh.');
      return;
    }

    // Chưa đăng ký khuôn mặt → về FaceRegistrationPage
    if (msg.contains('chưa đăng ký khuôn mặt') ||
        msg.contains('chưa đăng ký')) {
      _setError('Sinh viên chưa đăng ký khuôn mặt.');
      await Future.delayed(const Duration(seconds: 2));
      Get.until((route) => route.settings.name == Routes.bottomNavigationView);
      Get.toNamed(Routes.faceRegistrationPage);
      return;
    }

    // Không có trong danh sách lớp
    if (msg.contains('không có trong danh sách')) {
      _setError('Bạn không có trong danh sách lớp học này.');
      return;
    }

    // Lỗi khác (khuôn mặt không khớp, v.v.)
    _setError(msg.isNotEmpty ? msg : 'Xác thực thất bại. Vui lòng thử lại.');
  }

  void _setError(String message) {
    errorMessage = message;
    instructionText = 'Xác thực thất bại';
    _setState(FaceScanState.error);
    update();
  }

  // ── Thử lại sau khi lỗi ───────────────────────────────────────────────────
  Future<void> resetAndTryAgain() async {
    errorMessage = '';
    showManualButton = false;
    faceDetected = false;
    _isCameraDisposed = false;

    // Nếu GPS đã có thì quét lại trực tiếp
    if (isLocationValid) {
      _startScanning();
    } else {
      _setState(FaceScanState.waitingGps);
      instructionText = 'Đang lấy lại vị trí GPS...';
      update();
      await _fetchGps();
    }
  }

  // ── Dọn dẹp ───────────────────────────────────────────────────────────────
  Future<void> _stopCameraAndCleanup() async {
    _isCameraDisposed = true;
    _manualButtonTimer?.cancel();
    try {
      if (cameraController != null &&
          cameraController!.value.isInitialized &&
          cameraController!.value.isStreamingImages) {
        await cameraController!.stopImageStream();
      }
    } catch (_) {}
    try {
      await cameraController?.dispose();
    } catch (_) {}
    try {
      await _faceDetector.close();
    } catch (_) {}
  }

  void _setState(FaceScanState newState) {
    state = newState;
  }

  // ── Convert CameraImage → InputImage cho MLKit ────────────────────────────
  InputImage? _convertToInputImage(CameraImage image) {
    if (cameraController == null) return null;
    final camera = cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var compensated = sensorOrientation;
      if (camera.lensDirection == CameraLensDirection.front) {
        compensated = (sensorOrientation + 0) % 360;
        compensated = (360 - compensated) % 360;
      } else {
        compensated = (sensorOrientation - 0 + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(compensated);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }
    if (image.planes.isEmpty) return null;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }
}
