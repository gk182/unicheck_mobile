import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/services/shared_preferences_service.dart';

import 'en_US.dart';
import 'vi_VN.dart';

class LocalizationService extends Translations {
  // Default locale
  static final locale = Locale('vi', 'VN');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'en',
    'vi',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('vi', 'VN')
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': en, 'vi_VN': vi};

  // Gets locale from language, and updates the locale
  Future<void> changeLocale(String lang) async {
    final locale = _getLocaleFromLanguage(lang);
    await SharedPreferencesService.setLanguage(lang);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    try {
      for (int i = 0; i < langs.length; i++) {
        if (lang == langs[i]) return locales[i];
      }
    } catch (error) {
      return locales[0];
    }
    return locales[0];
  }
}
