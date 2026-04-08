import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.switchValue,
    this.onSwitchChanged,
    this.trailingText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Row(
          children: [
            // Container bọc Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // Ở Dark Mode, dùng màu Primary mờ để tạo hiệu ứng phát sáng nhẹ
                color: theme.colorScheme.primary.withOpacity(isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon, 
                color: theme.colorScheme.primary, // Luôn dùng màu chủ đạo
                size: 20
              ),
            ),
            const SizedBox(width: 16),
            
            // Nội dung Title và Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14, 
                      color: theme.colorScheme.onSurface // Trắng hoặc Đen tự động
                    )
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!, 
                      style: TextStyle(
                        fontSize: 12, 
                        color: theme.colorScheme.onSurface.withOpacity(0.6) // Chữ phụ mờ
                      )
                    ),
                  ]
                ],
              ),
            ),
            
            // Xử lý Switch hoặc Trailing Text
            if (switchValue != null)
              Switch(
                value: switchValue!,
                onChanged: onSwitchChanged,
                activeColor: Colors.white,
                // Màu track khi bật: dùng Primary
                activeTrackColor: theme.colorScheme.primary, 
                inactiveThumbColor: Colors.white,
                // Màu track khi tắt: dùng màu phân cách
                inactiveTrackColor: theme.dividerColor.withOpacity(0.2),
              )
            else if (trailingText != null)
              Row(
                children: [
                  Text(
                    trailingText!, 
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5), 
                      fontSize: 13
                    )
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right, 
                    color: theme.colorScheme.onSurface.withOpacity(0.3), 
                    size: 20
                  ),
                ],
              )
            else
              Icon(
                Icons.chevron_right, 
                color: theme.colorScheme.onSurface.withOpacity(0.3), 
                size: 20
              ),
          ],
        ),
      ),
    );
  }
}