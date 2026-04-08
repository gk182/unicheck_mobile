import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:unicheck_mobile/features/qr_scan/view_models/qr_controller.dart';
import 'package:unicheck_mobile/features/qr_scan/widgets/qr_animated_line.dart';
import 'package:unicheck_mobile/features/qr_scan/widgets/qr_overlay.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrScanController>(
      init: QrScanController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // 1. Camera view
              MobileScanner(
                controller: controller.cameraController,
                onDetect: controller.onDetect,
              ),

              // 2. Dark overlay với khung giữa
              const QrOverlay(),

              // 3. Khung QR scan box
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Stack(
                    children: [QrAnimatedLine()],
                  ),
                ),
              ),

              // 4. UI controls
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top bar: close | flash | switch camera
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 28),
                            onPressed: () => Get.back(),
                          ),
                          IconButton(
                            icon: Icon(
                              controller.isFlashOn
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: controller.toggleFlash,
                          ),
                          IconButton(
                            icon: const Icon(Icons.cameraswitch,
                                color: Colors.white, size: 28),
                            onPressed: controller.switchCamera,
                          ),
                        ],
                      ),
                    ),

                    // Hướng dẫn + trạng thái xử lý
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Column(
                        children: [
                          if (controller.isProcessing)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          Text(
                            controller.isProcessing
                                ? 'Đang xử lý...'
                                : 'Di chuyển camera đến mã QR của lớp học',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}