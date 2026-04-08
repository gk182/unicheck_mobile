import 'package:flutter/material.dart';
import 'package:unicheck_mobile/app/common/colors.dart';

@immutable
class BottomNavTheme extends ThemeExtension<BottomNavTheme> {
  final Color background;
  final Color activeIcon;
  final Color inactiveIcon;
  final Color indicator;

  const BottomNavTheme({
    required this.background,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.indicator,
  });

  @override
  BottomNavTheme copyWith({
    Color? background,
    Color? activeIcon,
    Color? inactiveIcon,
    Color? indicator,
  }) {
    return BottomNavTheme(
      background: background ?? this.background,
      activeIcon: activeIcon ?? this.activeIcon,
      inactiveIcon: inactiveIcon ?? this.inactiveIcon,
      indicator: indicator ?? this.indicator,
    );
  }

  @override
  BottomNavTheme lerp(ThemeExtension<BottomNavTheme>? other, double t) {
    if (other is! BottomNavTheme) return this;
    return BottomNavTheme(
      background: Color.lerp(background, other.background, t)!,
      activeIcon: Color.lerp(activeIcon, other.activeIcon, t)!,
      inactiveIcon: Color.lerp(inactiveIcon, other.inactiveIcon, t)!,
      indicator: Color.lerp(indicator, other.indicator, t)!,
    );
  }
}