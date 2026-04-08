import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Khai báo theme để dùng chung
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LABEL: Dùng màu chữ chính kèm độ mờ (Opacity)
              Text(
                label,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6), 
                  fontSize: 13,
                ),
              ),
              // VALUE: Dùng màu chữ chính đậm nét
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  fontSize: 13, 
                  color: theme.colorScheme.onSurface, // Tự động Trắng hoặc Đen
                ),
              ),
            ],
          ),
        ),
        // 2. DIVIDER: Dùng dividerColor hệ thống hoặc onSurface với độ mờ rất thấp
        if (showDivider)
          Divider(
            height: 1, 
            thickness: 1, 
            color: theme.dividerColor.withOpacity(0.08), // Tự thích ứng theo môi trường sáng/tối
          ),
      ],
    );
  }
}