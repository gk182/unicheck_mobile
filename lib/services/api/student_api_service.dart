import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/core/api/api_client.dart';
import 'package:unicheck_mobile/core/api/api_endpoints.dart';
import 'package:unicheck_mobile/features/profile/models/student_model.dart';

class StudentApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<StudentModel> getMyProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.myProfile);
      return StudentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  Future<bool> registerFace(String base64Image) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.registerFace,
        data: {'faceImageBase64': base64Image},
      );
      // Giả sử server trả về 200/201 là thành công
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }
}
