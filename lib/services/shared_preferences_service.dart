import 'dart:convert';

import 'package:unicheck_mobile/app/common/app_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Các key cho SharedPreferences
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _authStateKey = 'auth_state';
  static const String _sessionTokenKey = 'session_token';

  // Các key cho tiến trình người dùng
  static const String _lastScreenKey = 'last_screen';
  static const String _lastActivityKey = 'last_activity';
  static const String _appSettingsKey = 'app_settings';
  static const String _userPreferencesKey = 'user_preferences';

  static const String _configAdsKey = "configAds";
  static const String _configTextKey = "configText";


  static const String _themeKey = "theme_key";

  static const _languageKey = 'app_language';

  static const String _cityNameKey = 'city_name';
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Lưu ID người dùng
  static Future<bool> setUserId(String userId) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(_userIdKey, userId);
  }

  // Lấy ID người dùng
  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_userIdKey);
  }

  // Lưu email người dùng
  static Future<bool> setUserEmail(String? email) async {
    final SharedPreferences prefs = await _prefs;
    if (email == null) return await prefs.remove(_userEmailKey);
    return await prefs.setString(_userEmailKey, email);
  }

  // Lấy email người dùng
  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_userEmailKey);
  }

  // Lưu tên người dùng
  static Future<bool> setUserName(String? name) async {
    final SharedPreferences prefs = await _prefs;
    if (name == null) return await prefs.remove(_userNameKey);
    return await prefs.setString(_userNameKey, name);
  }

  // Lấy tên người dùng
  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_userNameKey);
  }

  // Lưu trạng thái xác thực
  static Future<bool> setAuthState(AuthState state) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(_authStateKey, state.toString());
  }

  // Lấy trạng thái xác thực
  static Future<AuthState> getAuthState() async {
    final SharedPreferences prefs = await _prefs;
    final stateStr = prefs.getString(_authStateKey);
    if (stateStr == null) return AuthState.guest;

    return AuthState.values.firstWhere(
      (e) => e.toString() == stateStr,
      orElse: () => AuthState.guest,
    );
  }

  // Lưu token phiên
  static Future<bool> setSessionToken(String? token) async {
    final SharedPreferences prefs = await _prefs;
    if (token == null) return await prefs.remove(_sessionTokenKey);
    return await prefs.setString(_sessionTokenKey, token);
  }

  // Lấy token phiên
  static Future<String?> getSessionToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_sessionTokenKey);
  }

  // ----- USER PROGRESS METHODS -----

  static Future<bool> setLastScreen(String screenName) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(_lastScreenKey, screenName);
  }

  static Future<String> getLastScreen() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_lastScreenKey) ?? 'home';
  }

  // Lưu hoạt động cuối cùng của người dùng (JSON string)
  static Future<bool> setLastActivity(String activityJson) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(_lastActivityKey, activityJson);
  }

  // Lấy hoạt động cuối cùng của người dùng
  static Future<String?> getLastActivity() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_lastActivityKey);
  }

  // Lưu thiết lập ứng dụng (JSON string)
  static Future<bool> setAppSettings(String settingsJson) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(_appSettingsKey, settingsJson);
  }

  // Lấy thiết lập ứng dụng
  static Future<String?> getAppSettings() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_appSettingsKey);
  }

  // Lưu tùy chọn của người dùng (JSON string)
  static Future<bool> setUserPreferences(String preferencesJson) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(_userPreferencesKey, preferencesJson);
  }

  // Lấy tùy chọn của người dùng
  static Future<String?> getUserPreferences() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_userPreferencesKey);
  }

  // Xóa toàn bộ dữ liệu xác thực
  static Future<void> clearAuthData() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_sessionTokenKey);
    // Không xóa authState để biết phương thức đăng nhập trước đó
  }

  // Xóa toàn bộ dữ liệu
  static Future<bool> clearAllData() async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.clear();
  }

  // ----------- CONFIG ADS --------------
  static Future<void> setConfigAds(String configAds) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_configAdsKey, configAds);
  }

  static Future<String?> getConfigAds() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_configAdsKey);
  }

  static Future<void> setConfigText(String configText) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_configTextKey, configText);
  }

  static Future<String?> getConfigText() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_configTextKey);
  }

  // ---------- THEME ------------

  static Future<void> setTheme(String theme) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_themeKey, theme);
  }

  static Future<String?> getTheme() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_themeKey);
  }

  // ---------- LANGUAGE ------------
  static Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, langCode);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  // ---------- LOCATION ------------
  static Future<void> saveLocation({required String city, required double lat, required double long}) async {
    final prefs = await _prefs;
    await prefs.setString(_cityNameKey, city);
    await prefs.setDouble(_latitudeKey, lat);
    await prefs.setDouble(_longitudeKey, long);
  }

  static Future<Map<String, dynamic>?> getSavedLocation() async {
    final prefs = await _prefs;
    final city = prefs.getString(_cityNameKey);
    final lat = prefs.getDouble(_latitudeKey);
    final long = prefs.getDouble(_longitudeKey);

    if (city != null && lat != null && long != null) {
      return {
        'city': city,
        'lat': lat,
        'long': long,
      };
    }
    return null;
  }
}
