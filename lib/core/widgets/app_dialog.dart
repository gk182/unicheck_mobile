import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DialogType { success, error, warning, info }

class AppDialog {
  static void show({
    required String title,
    required String message,
    DialogType type = DialogType.info,
    String confirmText = 'Đóng',
    VoidCallback? onConfirm,
  }) {
    IconData icon;
    Color iconColor;

    switch (type) {
      case DialogType.success:
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case DialogType.error:
        icon = Icons.error_outline;
        iconColor = Colors.red;
        break;
      case DialogType.warning:
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.orange;
        break;
      case DialogType.info:
        icon = Icons.info_outline;
        iconColor = Colors.blue;
        break;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Icon(
                icon,
                size: 64,
                color: iconColor,
              ),
              const SizedBox(height: 16.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Đóng dialog
                      if (onConfirm != null) {
                        onConfirm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C51E6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
