import 'package:flutter/material.dart';

class TermsPoliciesPage extends StatelessWidget {
  const TermsPoliciesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // 1. Đồng bộ nền Scaffold
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C51E6),
        elevation: 0,
        title: const Text(
          "Điều khoản & Chính sách", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // 2. Sử dụng cardColor thay vì Colors.white
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02), 
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(theme, "1. Thu thập dữ liệu sinh trắc học"),
              const SizedBox(height: 8),
              _buildSectionContent(theme, 
                "Hệ thống UniCheck yêu cầu thu thập dữ liệu khuôn mặt (Face ID) của sinh viên để phục vụ duy nhất cho mục đích điểm danh tự động. Dữ liệu này được mã hóa và lưu trữ an toàn trên máy chủ của trường."
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(theme, "2. Trách nhiệm của sinh viên"),
              const SizedBox(height: 8),
              _buildSectionContent(theme, 
                "• Không được sử dụng hình ảnh giả mạo hoặc nhờ người khác điểm danh hộ.\n"
                "• Đảm bảo thông tin tài khoản và mật khẩu được bảo mật.\n"
                "• Theo dõi thường xuyên lịch sử chuyên cần để khiếu nại kịp thời nếu có sai sót."
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(theme, "3. Xử lý vi phạm"),
              const SizedBox(height: 8),
              _buildSectionContent(theme, 
                "Mọi hành vi gian lận trong quá trình điểm danh, nếu bị hệ thống hoặc giảng viên phát hiện, sẽ bị hủy kết quả chuyên cần của môn học đó và xử lý theo quy chế của nhà trường."
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(theme, "4. Cập nhật chính sách"),
              const SizedBox(height: 8),
              _buildSectionContent(theme, 
                "Nhà trường có quyền thay đổi, cập nhật các điều khoản này. Các thay đổi sẽ được thông báo trực tiếp qua ứng dụng."
              ),
              
              const SizedBox(height: 20),
              Divider(color: theme.dividerColor.withOpacity(0.1)),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Cập nhật lần cuối: 28/02/2026",
                  style: TextStyle(
                    fontSize: 12, 
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.5)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper cho tiêu đề mục
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold, 
        fontSize: 16,
        color: theme.colorScheme.onSurface, // Tự động đổi Trắng/Đen
      ),
    );
  }

  // Helper cho nội dung mục
  Widget _buildSectionContent(ThemeData theme, String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14, 
        color: theme.colorScheme.onSurface.withOpacity(0.8), // Giảm độ chói cho text dài
        height: 1.5,
      ),
    );
  }
}