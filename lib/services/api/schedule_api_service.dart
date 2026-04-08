import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/core/api/api_client.dart';
import 'package:unicheck_mobile/core/api/api_endpoints.dart';
import 'package:unicheck_mobile/features/home_page/models/schedule_model.dart';

class ScheduleApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<ScheduleModel>> getSchedules() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.schedules);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => ScheduleModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }
}
