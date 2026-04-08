import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Đồng bộ màu nền hệ thống
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C51E6),
        elevation: 0,
        title: const Text(
          "Về UniCheck", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Logo App Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.cardColor, // Đổi sang màu Card để nổi bật trên nền Scaffold
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.1), 
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Icon(
                Icons.menu_book_rounded, 
                color: theme.colorScheme.primary, // Dùng màu xanh thương hiệu
                size: 60
              ),
            ),
            const SizedBox(height: 32),
            // Tên App
            Text(
              "UniCheck", 
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: theme.colorScheme.primary,
                letterSpacing: 1.2
              )
            ),
            const SizedBox(height: 8),
            // Phiên bản
            Text(
              "Phiên bản 1.0.0", 
              style: TextStyle(
                fontSize: 14, 
                color: theme.colorScheme.onSurface.withOpacity(0.5)
              )
            ),
            const SizedBox(height: 48),
            // Thẻ giới thiệu nội dung
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), 
                    blurRadius: 15,
                    offset: const Offset(0, 5)
                  )
                ],
              ),
              child: Text(
                "Hệ thống điểm danh thông minh dành cho sinh viên, hỗ trợ nhận diện khuôn mặt và quản lý chuyên cần tiện lợi, nhanh chóng.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15, 
                  color: theme.colorScheme.onSurface.withOpacity(0.8), 
                  height: 1.6
                ),
              ),
            ),
            const Spacer(flex: 3),
            // Bản quyền Footer
            Text(
              "© 2026 Hệ thống điểm danh sinh viên", 
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4), 
                fontSize: 12
              )
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}