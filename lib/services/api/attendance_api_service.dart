import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/core/api/api_client.dart';
import 'package:unicheck_mobile/core/api/api_endpoints.dart';
import 'package:unicheck_mobile/features/face_scan/models/check_in_response_model.dart';
import 'package:unicheck_mobile/features/history/models/attendance_history_model.dart';
import 'package:unicheck_mobile/features/history/models/attendance_stats_model.dart';

class AttendanceApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<AttendanceHistoryModel>> getHistory() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.attendanceHistory);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => AttendanceHistoryModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  Future<AttendanceStatsModel> getStatistics() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.attendanceStats);
      return AttendanceStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }

  /// Gọi POST /api/attendance/check-in với đầy đủ 4 params.
  /// Trả về [CheckInResponseModel] chứa status, faceConfidence, distanceMeter.
  /// Ném [ApiException] với message từ server khi có lỗi 400.
  Future<CheckInResponseModel> checkIn({
    required String qrToken,
    required String faceImageBase64,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.checkIn,
        data: {
          'qrToken': qrToken,
          'faceImageBase64': faceImageBase64,
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      return CheckInResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    }
  }
}

