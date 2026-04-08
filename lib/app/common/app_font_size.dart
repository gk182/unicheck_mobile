import 'package:flutter/material.dart';

class FontSize {
  // Font size rất nhỏ
  static const double xs = 12.0;

  // Font size nhỏ
  static const double sm = 14.0;

  // Font size trung bình
  static const double md = 16.0;

  // Font size lớn
  static const double lg = 18.0;

  // Font size rất lớn
  static const double xl = 24.0;

  // Font size cực lớn
  static const double xxl = 28.0;

  // Font size siêu lớn
  static const double xxxl = 45.0;
}

// Extension để dễ dàng sử dụng trong Text widget
extension FontSizeExtension on TextStyle {
  TextStyle get xs => copyWith(fontSize: FontSize.xs);
  TextStyle get sm => copyWith(fontSize: FontSize.sm);
  TextStyle get md => copyWith(fontSize: FontSize.md);
  TextStyle get lg => copyWith(fontSize: FontSize.lg);
  TextStyle get xl => copyWith(fontSize: FontSize.xl);
  TextStyle get xxl => copyWith(fontSize: FontSize.xxl);
  TextStyle get xxxl => copyWith(fontSize: FontSize.xxxl);
}
