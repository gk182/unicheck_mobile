import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unicheck_mobile/app/common/routes.dart';
import 'package:unicheck_mobile/core/api/api_exceptions.dart';
import 'package:unicheck_mobile/services/api/student_api_service.dart';

enum FaceRegState {
  initializing, // Đang khởi tạo camera
  scanning, // Camera đang chạy, chờ nhận diện mặt
  detected, // Đã phát hiện mặt, đang chờ (feedback cho user)
  capturing, // Đang chụp ảnh
  uploading, // Đang gửi lên server
  success, // Thành công
  error, // Lỗi
}

class FaceRegistrationController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  FaceRegState state = FaceRegState.initializing;
  String instructionText = 'Đang khởi tạo camera...';
  String errorMessage = '';
  bool showManualButton = false;
  bool faceDetected = false;

  // ── Camera & MLKit ────────────────────────────────────────────────────────
  CameraController? cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _isCameraDisposed = false;

  // ── Timer ─────────────────────────────────────────────────────────────────
  Timer? _manualButtonTimer;

  // ── Getters ───────────────────────────────────────────────────────────────
  bool get isInitializing => state == FaceRegState.initializing;
  bool get isScanning =>
      state == FaceRegState.scanning || state == FaceRegState.detected;
  bool get isProcessing =>
      state == FaceRegState.capturing || state == FaceRegState.uploading;
  bool get isSuccess => state == FaceRegState.success;
  bool get isError => state == FaceRegState.error;

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

  // ── Khởi tạo MLKit Face Detector ─────────────────────────────────────────
  void _initFaceDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true, // Nhận smilingProbability
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
    _faceDetector = FaceDetector(options: options);
  }

  // ── Khởi tạo Camera ───────────────────────────────────────────────────────
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup:
            Platform.isAndroid
                ? ImageFormatGroup.nv21
                : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();
      _isCameraDisposed = false;

      _setState(FaceRegState.scanning);
      instructionText = 'Giữ khuôn mặt trong khung hình\nđể đăng kí';
      update();

      _startImageStream();
      _startManualButtonTimer();
    } catch (e) {
      _setState(FaceRegState.error);
      errorMessage =
          'Lỗi khởi tạo camera. Vui lòng cấp quyền camera và thử lại.';
      instructionText = errorMessage;
      update();
    }
  }

  // ── Image Stream & Face Detection ─────────────────────────────────────────
  void _startImageStream() {
    cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting || isProcessing || _isCameraDisposed) return;
      _isDetecting = true;

      try {
        final inputImage = _convertToInputImage(image);
        if (inputImage == null) return;

        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;

          // Cập nhật feedback trạng thái phát hiện mặt
          if (!faceDetected) {
            faceDetected = true;
            update();
          }

          Object? leftEyeOpenProb = face.leftEyeOpenProbability;
          Object? rightEyeOpenProb = face.rightEyeOpenProbability;

          double leftOpen = (leftEyeOpenProb is double) ? leftEyeOpenProb : 1.0;
          double rightOpen =
              (rightEyeOpenProb is double) ? rightEyeOpenProb : 1.0;

          // Khi đủ điều kiện (mở mắt) → tự động chụp
          if (leftOpen > 0.5 &&
              rightOpen > 0.5 &&
              state == FaceRegState.scanning) {
            await _captureAndUpload();
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

  // ── Timer hiển thị nút chụp thủ công sau 5 giây ─────────────────────────
  void _startManualButtonTimer() {
    _manualButtonTimer?.cancel();
    _manualButtonTimer = Timer(const Duration(seconds: 5), () {
      if (state == FaceRegState.scanning) {
        showManualButton = true;
        instructionText =
            'Không thể tự động chụp.\nNhấn nút bên dưới để chụp thủ công.';
        update();
      }
    });
  }

  // ── Nút chụp thủ công ─────────────────────────────────────────────────────
  Future<void> manualCapture() async {
    if (isProcessing) return;
    await _captureAndUpload();
  }

  // ── Core: Chụp ảnh → Base64 → Upload API ─────────────────────────────────
  Future<void> _captureAndUpload() async {
    if (isProcessing || _isCameraDisposed) return;

    _manualButtonTimer?.cancel();
    showManualButton = false;
    _isDetecting = true;

    // 1. Dừng stream, chuyển trạng thái chụp
    await cameraController?.stopImageStream();

    _setState(FaceRegState.capturing);
    instructionText = 'Đang chụp ảnh khuôn mặt...';
    update();

    try {
      // 2. Chụp ảnh
      final XFile photo = await cameraController!.takePicture();
      final File imageFile = File(photo.path);

      _setState(FaceRegState.uploading);
      instructionText = 'Đang đăng ký khuôn mặt...';
      update();

      // 3. Encode base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 4. Gọi API
      final studentApiService = Get.find<StudentApiService>();
      await studentApiService.registerFace(base64Image);

      // 5. Thành công — cập nhật flag local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('face_registered', true);

      _setState(FaceRegState.success);
      instructionText = 'Đăng ký khuôn mặt thành công!';
      update();

      // Chờ 1.5s rồi điều hướng về Home
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.offAllNamed(Routes.bottomNavigationView);
    } on NetworkException catch (e) {
      _handleError(e.message);
    } on ApiException catch (e) {
      // Nếu đã đăng ký rồi (400) → cập nhật flag rồi về home
      if (e.statusCode == 400 &&
          (e.message.contains('đã đăng ký') || e.message.contains('already'))) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('face_registered', true);

        _setState(FaceRegState.success);
        instructionText = 'Khuôn mặt đã được đăng ký trước đó.';
        update();
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.offAllNamed(Routes.bottomNavigationView);
      } else {
        _handleError(e.message);
      }
    } catch (e) {
      _handleError('Đã xảy ra lỗi. Vui lòng thử lại.');
    } finally {
      _isDetecting = false;
    }
  }

  // ── Xử lý lỗi ─────────────────────────────────────────────────────────────
  void _handleError(String message) {
    _setState(FaceRegState.error);
    errorMessage = message;
    instructionText = 'Đăng ký thất bại';
    update();
  }

  // ── Thử lại ───────────────────────────────────────────────────────────────
  Future<void> retryRegistration() async {
    errorMessage = '';
    showManualButton = false;
    faceDetected = false;
    _isCameraDisposed = false;

    _setState(FaceRegState.scanning);
    instructionText = 'Giữ khuôn mặt trong khung hình\nđể đăng kí';
    update();

    try {
      await cameraController?.startImageStream(
        (image) {},
      ); // dummy để test init
      await cameraController?.stopImageStream();
    } catch (_) {}

    _startImageStream();
    _startManualButtonTimer();
  }

  // ── Dọn dẹp camera ────────────────────────────────────────────────────────
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

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _setState(FaceRegState newState) {
    state = newState;
  }

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
