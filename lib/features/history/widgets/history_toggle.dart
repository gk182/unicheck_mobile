import 'package:flutter/material.dart';

class HistoryToggle extends StatelessWidget {
  final bool isListView;
  final Function(bool) onToggle;

  const HistoryToggle({Key? key, required this.isListView, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // Nền của thanh toggle: Xám nhạt ở Light, Xám đen ở Dark
        color: isDark ? theme.colorScheme.surfaceVariant.withOpacity(0.3) : const Color(0xFFF3F4F6), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleButton(
            context,
            label: "Danh sách",
            icon: Icons.list_alt_rounded,
            isActive: isListView,
            onTap: () => onToggle(true),
          ),
          _buildToggleButton(
            context,
            label: "Lịch",
            icon: Icons.calendar_today_rounded,
            isActive: !isListView,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Thêm hiệu ứng chuyển mượt
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            // Sử dụng màu Primary khi active để làm nổi bật thương hiệu
            color: isActive ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive 
              ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                size: 16, 
                color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.5)
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}