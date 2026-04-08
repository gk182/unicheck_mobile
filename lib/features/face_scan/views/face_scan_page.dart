import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/features/face_scan/models/check_in_response_model.dart';
import 'package:unicheck_mobile/features/face_scan/view_models/face_scan_controller.dart';
import '../widgets/face_overlay.dart';
import '../widgets/face_scanner_animation.dart';

/// Màn hình quét khuôn mặt để điểm danh.
/// Nhận [qrCodeData] từ QrScanPage → tạo FaceScanController với qrToken đó.
class FaceScanPage extends StatelessWidget {
  final String qrCodeData;
  const FaceScanPage({Key? key, required this.qrCodeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return GetBuilder<FaceScanController>(
      init: FaceScanController(qrToken: qrCodeData),
      builder: (controller) {
        double scale = 1.0;
        if (controller.cameraController != null &&
            controller.cameraController!.value.isInitialized) {
          final cameraRatio =
              controller.cameraController!.value.aspectRatio;
          scale = 1 / (cameraRatio * deviceRatio);
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // ── 1. Camera preview ─────────────────────────────────────────
              if (controller.cameraController != null &&
                  controller.cameraController!.value.isInitialized)
                Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: CameraPreview(controller.cameraController!),
                )
              else
                Container(color: Colors.black),

              // ── 2. Dark overlay ───────────────────────────────────────────
              const FaceOverlay(),

              // ── 3. Centre icon: Scanning / Success / Error ────────────────
              Center(child: _buildCentreWidget(controller)),

              // ── 4. UI controls & info ─────────────────────────────────────
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                    ),

                    // Bottom: GPS badge + instruction + spinner + manual button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          // GPS badge
                          if (!controller.isError && !controller.isSuccess)
                            _buildGpsBadge(controller),

                          const SizedBox(height: 20),

                          // Instruction text
                          Text(
                            controller.instructionText,
                            style: TextStyle(
                              color: controller.isError
                                  ? const Color(0xFFEF4444)
                                  : controller.isSuccess
                                      ? const Color(0xFF10B981)
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Loading spinner
                          if (controller.isProcessing)
                            const CircularProgressIndicator(
                                color: Color(0xFF1C51E6)),

                          // Kết quả chi tiết nếu thành công
                          if (controller.isSuccess &&
                              controller.checkInResult != null)
                            _buildSuccessDetail(controller.checkInResult!),

                          // Nút chụp thủ công
                          if (controller.showManualButton)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: ElevatedButton.icon(
                                onPressed: controller.manualCapture,
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Chụp thủ công',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)),
                                ),
                              ),
                            ),

                          // Nút Thử lại khi lỗi
                          if (controller.isError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => Get.back(),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.white24,
                                        foregroundColor:
                                            Colors.white),
                                    child:
                                        const Text('Hủy bỏ'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed:
                                        controller.resetAndTryAgain,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1C51E6),
                                        foregroundColor:
                                            Colors.white),
                                    child: const Text('Thử lại'),
                                  ),
                                ],
                              ),
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

  // ── Widget ở giữa: Animation / Thành công / Lỗi ──────────────────────────
  Widget _buildCentreWidget(FaceScanController controller) {
    if (controller.isError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 90),
          if (controller.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.errorMessage,
                  style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    }

    if (controller.isSuccess) {
      return const Icon(Icons.check_circle,
          color: Color(0xFF10B981), size: 100);
    }

    // Đang quét hoặc khởi tạo → hiển thị scanner animation
    return const FaceScannerAnimation();
  }

  // ── GPS Badge ─────────────────────────────────────────────────────────────
  Widget _buildGpsBadge(FaceScanController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: controller.isLocationValid
            ? Colors.black.withOpacity(0.6)
            : Colors.orange.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: controller.isLocationValid ? Colors.white38 : Colors.orange,
        ),
      ),
      child: Text(
        controller.locationText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── Kết quả check-in chi tiết sau khi thành công ──────────────────────────
  Widget _buildSuccessDetail(CheckInResponseModel result) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            // Trạng thái PRESENT / LATE
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: result.isLate
                    ? Colors.orange.withOpacity(0.2)
                    : const Color(0xFF10B981).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: result.isLate
                      ? Colors.orange
                      : const Color(0xFF10B981),
                ),
              ),
              child: Text(
                result.isLate ? '⏰ Trễ giờ' : '✅ Đúng giờ',
                style: TextStyle(
                  color:
                      result.isLate ? Colors.orange : const Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Thông số kỹ thuật
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statChip(
                  icon: Icons.face_retouching_natural,
                  label: 'Nhận dạng',
                  value: result.confidencePercent,
                  color: const Color(0xFF1C51E6),
                ),
                _statChip(
                  icon: Icons.location_on,
                  label: 'Khoảng cách',
                  value: result.distanceLabel,
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(label,
            style:
                const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
  }
}