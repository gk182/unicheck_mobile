import 'package:flutter/material.dart';

class UserManualPage extends StatelessWidget {
  const UserManualPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Dùng scaffoldBackgroundColor để tự động đổi màu nền xám nhạt/đen
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Giữ màu xanh thương hiệu cho AppBar hoặc dùng theme.appBarTheme
        backgroundColor: const Color(0xFF1C51E6),
        elevation: 0,
        title: const Text(
          "Hướng dẫn sử dụng", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildManualItem(
            context,
            icon: Icons.face_retouching_natural,
            title: "1. Đăng ký khuôn mặt (Face ID)",
            content: "Lần đầu đăng nhập, hệ thống sẽ yêu cầu bạn quét khuôn mặt ở nhiều góc độ để làm dữ liệu nhận diện. Vui lòng thực hiện ở nơi đủ ánh sáng, không đeo kính râm hay khẩu trang.",
          ),
          const SizedBox(height: 12),
          _buildManualItem(
            context,
            icon: Icons.how_to_reg,
            title: "2. Cách điểm danh",
            content: "Tại màn hình Trang chủ, khi có lớp học đang diễn ra, nút 'ĐIỂM DANH NGAY' sẽ sáng lên. Bấm vào nút này và đưa điện thoại lên ngang mặt để hệ thống tự động xác thực.",
          ),
          const SizedBox(height: 12),
          _buildManualItem(
            context,
            icon: Icons.history,
            title: "3. Xem lịch sử chuyên cần",
            content: "Chuyển sang tab 'Lịch sử' để xem chi tiết các buổi có mặt, vắng mặt hoặc đi muộn. Bạn có thể xem dạng danh sách hoặc dạng lịch tháng.",
          ),
          const SizedBox(height: 12),
          _buildManualItem(
            context,
            icon: Icons.edit_document,
            title: "4. Xin nghỉ phép",
            content: "Vào tab 'Nghỉ phép', chọn 'Gửi đơn mới', điền đầy đủ thông tin môn học, ngày nghỉ, lý do và đính kèm minh chứng (nếu có). Theo dõi tiến độ duyệt ở phần 'Trạng thái đơn'.",
          ),
        ],
      ),
    );
  }

  Widget _buildManualItem(BuildContext context, {
    required IconData icon, 
    required String title, 
    required String content
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: theme.cardColor, // Tự động đổi Trắng/Xám đen
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.light ? 0.03 : 0.2), 
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Theme(
        // Triệt tiêu đường kẻ chia của ExpansionTile và áp dụng màu Theme
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          title: Text(
            title, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 15,
              color: theme.colorScheme.onSurface,
            )
          ),
          // Màu icon mũi tên khi mở rộng
          iconColor: theme.colorScheme.primary,
          collapsedIconColor: theme.hintColor,
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            Text(
              content, 
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7), 
                fontSize: 14, 
                height: 1.5
              )
            ),
          ],
        ),
      ),
    );
  }
}