import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/app/common/routes.dart';
import 'package:unicheck_mobile/features/face_scan/widgets/face_overlay.dart';
import 'package:unicheck_mobile/features/face_scan/widgets/face_scanner_animation.dart';
import '../controllers/face_registration_controller.dart';

class FaceRegistrationPage extends StatefulWidget {
  const FaceRegistrationPage({Key? key}) : super(key: key);

  @override
  State<FaceRegistrationPage> createState() => _FaceRegistrationPageState();
}

class _FaceRegistrationPageState extends State<FaceRegistrationPage> {
  @override
  void initState() {
    super.initState();
    // Đăng ký controller vào GetX DI - GetBuilder sẽ tự tìm qua Get.find()
    Get.put(FaceRegistrationController());
  }

  @override
  void dispose() {
    // onClose() của controller tự dọn camera + faceDetector
    Get.delete<FaceRegistrationController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<FaceRegistrationController>(
        builder: (controller) {
          // ── Màn hình Success ───────────────────────────────────────────
          if (controller.isSuccess) {
            return _buildSuccessScreen();
          }

          // ── Màn hình Error ─────────────────────────────────────────────
          if (controller.isError) {
            return _buildErrorScreen(controller);
          }

          // ── Màn hình Camera (Initializing / Scanning / Processing) ─────
          return _buildCameraScreen(controller, size, deviceRatio);
        },
      ),
    );
  }

  // ── Camera Screen ────────────────────────────────────────────────────────
  Widget _buildCameraScreen(
    FaceRegistrationController controller,
    Size size,
    double deviceRatio,
  ) {
    double scale = 1.0;
    if (controller.cameraController != null &&
        controller.cameraController!.value.isInitialized) {
      final cameraRatio = controller.cameraController!.value.aspectRatio;
      scale = 1 / (cameraRatio * deviceRatio);
    }

    return Stack(
      children: [
        // 1. Camera preview (full screen)
        if (controller.cameraController != null &&
            controller.cameraController!.value.isInitialized)
          Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: CameraPreview(controller.cameraController!),
          )
        else
          Container(color: Colors.black87),

        // 2. Lớp phủ oval (dùng lại FaceOverlay từ face_scan)
        const FaceOverlay(),

        // 3. Animation oval border (pulsing)
        if (!controller.isProcessing)
          Center(
            child:
                controller.faceDetected
                    ? _buildDetectedBorder()
                    : const FaceScannerAnimation(),
          ),

        // 4. Loading khi đang xử lý
        if (controller.isProcessing)
          Center(child: _buildProcessingIndicator(controller)),

        // 5. Top bar
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildTopBar(), _buildBottomInfo(controller)],
          ),
        ),
      ],
    );
  }

  // ── Top bar với title và progress hint ───────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Nút back về Login (chỉ cho phép nếu chưa bắt đầu xử lý)
          Material(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Get.offAllNamed(Routes.loginPage);
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đăng ký khuôn mặt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Thực hiện 1 lần duy nhất',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),

          // Badge "Bước 1/1"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1C51E6).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Bước 1/1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom info (GPS-like badge + instruction + manual button) ────────────
  Widget _buildBottomInfo(FaceRegistrationController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge trạng thái nhận diện
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  controller.faceDetected
                      ? Colors.green.withOpacity(0.8)
                      : Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    controller.faceDetected
                        ? Colors.greenAccent
                        : Colors.white30,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.faceDetected
                      ? Icons.face_retouching_natural
                      : Icons.face_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  controller.faceDetected
                      ? '✓ Đã nhận diện khuôn mặt'
                      : '⟳ Đang tìm kiếm khuôn mặt...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Text hướng dẫn chính
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.instructionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Loading spinner khi đang xử lý
          if (controller.isProcessing)
            const CircularProgressIndicator(color: Color(0xFF1C51E6)),

          // Nút chụp thủ công (sau 12 giây)
          if (controller.showManualButton && !controller.isProcessing)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton.icon(
                onPressed: controller.manualCapture,
                icon: const Icon(Icons.camera_alt, size: 18),
                label: const Text(
                  'Chụp thủ công',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Border xanh khi đã detect được mặt ────────────────────────────────────
  Widget _buildDetectedBorder() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, _) {
        return Container(
          width: 280,
          height: 380,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.elliptical(280, 380)),
            border: Border.all(
              color: Colors.greenAccent.withOpacity(value),
              width: 3.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(value * 0.4),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Indicator khi đang upload ─────────────────────────────────────────────
  Widget _buildProcessingIndicator(FaceRegistrationController controller) {
    return Container(
      width: 280,
      height: 380,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(280, 380)),
        border: Border.all(color: const Color(0xFF1C51E6), width: 3),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              controller.state == FaceRegState.capturing
                  ? 'Đang chụp ảnh...'
                  : 'Đang đăng ký...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Success Screen ────────────────────────────────────────────────────────
  Widget _buildSuccessScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder:
                  (context, value, child) =>
                      Transform.scale(scale: value, child: child),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 100,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đăng ký thành công!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Khuôn mặt của bạn đã được lưu.\nĐang chuyển đến trang chủ...',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Error Screen ──────────────────────────────────────────────────────────
  Widget _buildErrorScreen(FaceRegistrationController controller) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 80),
            const SizedBox(height: 20),
            const Text(
              'Đăng ký thất bại',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                controller.errorMessage,
                style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Get.offAllNamed(Routes.loginPage),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Về đăng nhập'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: controller.retryRegistration,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text(
                    'Thử lại',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C51E6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
