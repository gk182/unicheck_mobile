import 'package:get/get.dart';
import 'package:unicheck_mobile/core/api/api_client.dart';
import 'package:unicheck_mobile/services/api/attendance_api_service.dart';
import 'package:unicheck_mobile/services/api/auth_api_service.dart';
import 'package:unicheck_mobile/services/api/leave_request_api_service.dart';
import 'package:unicheck_mobile/services/api/schedule_api_service.dart';
import 'package:unicheck_mobile/services/api/student_api_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Khởi tạo ApiClient (sẽ được inject vào các Service khác)
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Khởi tạo các API Services
    Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);
    Get.lazyPut<StudentApiService>(() => StudentApiService(), fenix: true);
    Get.lazyPut<ScheduleApiService>(() => ScheduleApiService(), fenix: true);
    Get.lazyPut<AttendanceApiService>(() => AttendanceApiService(), fenix: true);
    Get.lazyPut<LeaveRequestApiService>(() => LeaveRequestApiService(), fenix: true);
  }
}
