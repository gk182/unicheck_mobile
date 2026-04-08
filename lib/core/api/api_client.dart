import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicheck_mobile/app/common/routes.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';

class ApiClient extends GetxService {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          log('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('<-- ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          log('<-- ERROR ${e.response?.statusCode} ${e.requestOptions.path} - ${e.message}');
          
          // Xử lý chung khi token hết hạn — KHÔNG áp dụng cho endpoint login
          // vì login trả 401 khi sai mật khẩu (đây là lỗi nghiệp vụ, không phải hết hạn)
          if (e.response?.statusCode == 401 &&
              e.requestOptions.path != ApiEndpoints.login) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
            await prefs.setBool('login', false);
            
            // Xóa session và ném về màn hình đăng nhập
            Get.offAllNamed(Routes.loginPage);
            
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: UnauthorizedException('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'),
                response: e.response,
              ),
            );
          }
          
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Phương thức helper để xử lý lỗi nhất quán
  Exception handleError(DioException e) {
    if (e.error is UnauthorizedException) {
      return e.error as Exception;
    }
    
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.receiveTimeout || 
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException('Kết nối máy chủ hết hạn. Kiểm tra mạng hoặc thử lại.');
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException('Không thể kết nối đến máy chủ. Kiểm tra mạng của bạn.');
    }
    
    if (e.response != null) {
      final data = e.response?.data;
      String message = 'Đã có lỗi xảy ra.';
      String? code;
      
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'].toString();
        code = data['code']?.toString();
      }
      return ApiException(
        message,
        statusCode: e.response?.statusCode,
        data: data,
        code: code,
      );
    }
    
    return ApiException('Lỗi không xác định: ${e.message}');
  }
}
