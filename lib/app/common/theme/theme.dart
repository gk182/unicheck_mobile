import 'package:flutter/material.dart';
import 'package:unicheck_mobile/app/common/colors.dart';
import 'package:unicheck_mobile/app/common/theme/bottom_nav_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: UniCheckLightColors.background50,
  cardColor: UniCheckLightColors.surface,
  dividerColor: UniCheckLightColors.divider,
  colorScheme: const ColorScheme.light(
    primary: UniCheckLightColors.primary500,
    secondary: UniCheckLightColors.secondary500,
    surface: UniCheckLightColors.surface,
    onSurface: UniCheckLightColors.text900,
    error: UniCheckLightColors.error,
  ),
  extensions: const [
    BottomNavTheme(
      background: UniCheckLightColors.surface, // Background của bottom nav thường là trắng
      activeIcon: UniCheckLightColors.primary500,
      inactiveIcon: UniCheckLightColors.text400,
      indicator: UniCheckLightColors.primary50,
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: UniCheckDarkColors.background100,
  cardColor: UniCheckDarkColors.surface,
  dividerColor: UniCheckDarkColors.divider,
  colorScheme: const ColorScheme.dark(
    primary: UniCheckDarkColors.primary500,
    secondary: UniCheckDarkColors.secondary500,
    surface: UniCheckDarkColors.surface,
    onSurface: UniCheckDarkColors.text900,
    error: UniCheckDarkColors.error,
  ),
  extensions: const [
    BottomNavTheme(
      background: UniCheckDarkColors.surface,
      activeIcon: UniCheckDarkColors.primary500,
      inactiveIcon: UniCheckDarkColors.text400,
      indicator: UniCheckDarkColors.primary50,
    ),
  ],
);