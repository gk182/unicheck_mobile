import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/core/api/api_client.dart';
import 'package:unicheck_mobile/core/api/api_endpoints.dart';
import 'package:unicheck_mobile/features/auth/models/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      
      final authData = AuthResponseModel.fromJson(response.data);
      
      // Tự động lưu token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authData.token);
      await prefs.setBool('login', true);
      
      return authData;
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.setBool('login', false);
  }
}
