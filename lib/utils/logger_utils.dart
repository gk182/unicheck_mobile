import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerUtils {
  static var logger = Logger();

  static Future<void> logDebug(dynamic data) async {
    if (kDebugMode) {
      logger.d(data);
    }
  }

  static Future<void> logInfo(dynamic data) async {
    if (kDebugMode) {
      logger.i(data);
    }
  }

  static Future<void> logError(dynamic data) async {
    if (kDebugMode) {
      logger.e(data);
    }
  }

  static final LoggerUtils _appConstant = LoggerUtils._internal();

  factory LoggerUtils() {
    return _appConstant;
  }
  LoggerUtils._internal();
}
