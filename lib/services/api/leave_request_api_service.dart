import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:unicheck_mobile/core/api/api_client.dart';
import 'package:unicheck_mobile/core/api/api_endpoints.dart';
import 'package:unicheck_mobile/features/home_page/models/schedule_model.dart';
import 'package:unicheck_mobile/features/leave/models/leave_request_model.dart';

class LeaveRequestApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<LeaveRequestModel>> getLeaveRequests() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.leaveRequests);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => LeaveRequestModel.fromJson(e))
            .toList();
      }
      return [];
    } on dio.DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  Future<List<ScheduleModel>> getEligibleSchedules() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.leaveEligibleSchedules);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => ScheduleModel.fromJson(e))
            .toList();
      }
      return [];
    } on dio.DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  Future<Map<String, dynamic>> uploadAttachment(File file) async {
    try {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.leaveAttachments,
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return response.data as Map<String, dynamic>;
    } on dio.DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  Future<Map<String, dynamic>> submitLeaveRequest({
    required int scheduleId,
    required String reason,
    String? attachmentUrl,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.leaveRequests,
        data: {
          'scheduleId': scheduleId,
          'reason': reason,
          if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        },
      );
      return response.data as Map<String, dynamic>;
    } on dio.DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }
}
