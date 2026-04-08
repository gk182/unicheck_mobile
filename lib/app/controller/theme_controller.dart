import 'dart:developer';

import 'package:get/get.dart';
import 'package:unicheck_mobile/app/typical/enums/app_theme.dart';
import 'package:unicheck_mobile/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {

  /// Business theme
  Rx<AppTheme> appTheme = AppTheme.system.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  ThemeMode get themeMode {
    switch (appTheme.value) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }

  /// Đổi theme
  void changeTheme(AppTheme theme) {
    appTheme.value = theme;
    Get.changeThemeMode(themeMode);
    saveTheme(theme);
  }

  /// Lưu thêm vào local
  Future<void> saveTheme(AppTheme theme) async {
    log('Saving theme: ${theme.name}');
    await SharedPreferencesService.setTheme(theme.name);
  }

  /// Load theme từ local
  Future<void> loadTheme() async {
    final saved = await SharedPreferencesService.getTheme();
    if (saved != null) {
      appTheme.value = AppTheme.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppTheme.system,
      );
    }
    Get.changeThemeMode(themeMode);
    log('Loaded theme: ${appTheme.value.name}');
  }
}
