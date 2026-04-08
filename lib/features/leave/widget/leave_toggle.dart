import 'package:flutter/material.dart';

class LeaveToggle extends StatelessWidget {
  final bool isNewRequest;
  final Function(bool) onToggle;

  const LeaveToggle({
    Key? key, 
    required this.isNewRequest, 
    required this.onToggle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // Màu nền toggle thay đổi theo chế độ sáng/tối
        color: isDark 
            ? theme.colorScheme.surfaceVariant.withOpacity(0.3) 
            : const Color(0xFFF3F4F6), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleItem(
            context,
            label: "Gửi đơn mới",
            isActive: isNewRequest,
            onTap: () => onToggle(true),
          ),
          _buildToggleItem(
            context,
            label: "Trạng thái đơn",
            isActive: !isNewRequest,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250), // Hiệu ứng trượt màu mượt mà
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // Màu Primary của UniCheck khi Active
            color: isActive ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive 
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.bold, 
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}