import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ActiveClassCard extends StatelessWidget {
  final ScheduleModel? session;
  final VoidCallback onCheckInTap;
  final bool isCheckedIn;
  final String checkInTime;

  const ActiveClassCard({
    Key? key,
    required this.session,
    required this.onCheckInTap,
    this.isCheckedIn = false,
    this.checkInTime = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Hôm nay bạn không có lớp học nào nữa.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    
    final startTimeStr = '${session!.startTime.hour.toString().padLeft(2, '0')}:${session!.startTime.minute.toString().padLeft(2, '0')}';
    final endTimeStr = '${session!.endTime.hour.toString().padLeft(2, '0')}:${session!.endTime.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Tự động Đen/Trắng theo Theme
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // Đổ bóng đậm hơn một chút ở Dark mode để thẻ nổi lên
            color: Colors.black.withOpacity(isLight ? 0.05 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge "Đang diễn ra"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  // Dùng màu xanh lá với độ mờ 15% để hợp với cả Sáng và Tối
                  color: const Color(0xFF4CAF50).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                    SizedBox(width: 4),
                    Text(
                      "Môn học sắp tới / Đang diễn ra",
                      style: TextStyle(
                        color: Color(0xFF4CAF50), // Màu xanh lá giữ nguyên
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Giờ học
              Row(
                children: [
                   const SizedBox(width: 4),
                   // Optional icon/space
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Icon(
                Icons.access_time, 
                size: 14, 
                color: theme.colorScheme.onSurface.withOpacity(0.5)
              ),
              const SizedBox(width: 4),
              Text(
                "$startTimeStr - $endTimeStr",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tên môn học
          Text(
            session!.courseName,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface, // Chữ chính
            ),
          ),
          const SizedBox(height: 8),
          
          // Vị trí phòng
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: theme.colorScheme.primary, // Đổi theo Primary Color
              ),
              const SizedBox(width: 8),
              Text(
                session!.roomName,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8), // Chữ phụ
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Nút bấm chính
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: isCheckedIn ? null : onCheckInTap,
              icon: Icon(
                isCheckedIn ? Icons.check_circle : Icons.qr_code_scanner,
                color: theme.colorScheme.onPrimary, // Thường là màu trắng
              ),
              label: Text(
                isCheckedIn ? "ĐÃ ĐIỂM DANH - $checkInTime" : "ĐIỂM DANH NGAY",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary, // Thường là màu trắng
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCheckedIn
                    ? const Color(0xFF10B981) // Nếu thành công thì dùng màu Xanh lá
                    : theme.colorScheme.primary, // Nếu chưa thì dùng Primary Blue
                disabledBackgroundColor: const Color(0xFF10B981).withOpacity(0.9),
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: isCheckedIn ? 0 : 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}