import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:unicheck_mobile/features/face_scan/views/face_scan_page.dart';

/// Controller cho màn hình quét QR code.
/// Sau khi quét được, navigate sang FaceScanPage truyền qrToken.
class QrScanController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool isFlashOn = false;
  bool isProcessing = false;

  void toggleFlash() {
    cameraController.toggleTorch();
    isFlashOn = !isFlashOn;
    update();
  }

  /// Callback khi MobileScanner phát hiện barcode.
  /// Validate token không rỗng rồi navigate sang FaceScanPage.
  void onDetect(BarcodeCapture capture) {
    if (isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String rawValue = barcodes.first.rawValue ?? '';
    if (rawValue.isEmpty) return;

    isProcessing = true;
    update();

    debugPrint('[QrScan] qrToken = $rawValue');
    cameraController.stop();

    // Navigate sang FaceScanPage, bỏ qua màn QR trong stack
    Get.off(
      () => FaceScanPage(qrCodeData: rawValue),
      transition: Transition.fadeIn,
    );
  }

  void switchCamera() {
    cameraController.switchCamera();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
