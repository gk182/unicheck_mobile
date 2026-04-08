import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicheck_mobile/app/common/routes.dart';
import 'package:unicheck_mobile/features/home_page/models/schedule_model.dart';
import 'package:unicheck_mobile/features/history/models/attendance_stats_model.dart';
import 'package:unicheck_mobile/services/api/schedule_api_service.dart';
import 'package:unicheck_mobile/services/api/attendance_api_service.dart';

class HomeController extends GetxController {
  final ScheduleApiService _scheduleApi = Get.find<ScheduleApiService>();
  final AttendanceApiService _attendanceApi = Get.find<AttendanceApiService>();

  RxBool isLoading = true.obs;
  RxString userName = "".obs;
  RxInt unreadNotifications = 0.obs;

  bool isCheckedIn = false;
  String checkInTime = "";
  String? lastCheckInStatus; // "PRESENT" | "LATE"

  List<ScheduleModel> dailySchedule = [];
  AttendanceStatsModel? stats;
  ScheduleModel? currentClass;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  /// Được gọi từ FaceScanController sau khi điểm danh thành công.
  /// Cập nhật trực tiếp state mà không cần navigate lại.
  void onCheckInSuccess({required String status}) {
    isCheckedIn = true;
    lastCheckInStatus = status;
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    checkInTime = '${hour == 0 ? 12 : hour}:$minute $ampm';
    debugPrint('[HomeController] Check-in success: status=$status, time=$checkInTime');
    fetchHomeData(); // Refresh stats
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    update();

    try {
      final prefs = await SharedPreferences.getInstance();
      userName.value = prefs.getString('full_name') ?? "Sinh Viên";

      final futures = await Future.wait([
        _scheduleApi.getSchedules(),
        _attendanceApi.getStatistics(),
      ]);

      final allSchedules = futures[0] as List<ScheduleModel>;
      stats = futures[1] as AttendanceStatsModel;

      final now = DateTime.now();

      // Filter today's schedule
      dailySchedule =
          allSchedules.where((s) {
            return s.date.year == now.year &&
                s.date.month == now.month &&
                s.date.day == now.day;
          }).toList();

      dailySchedule.sort((a, b) {
        final aTime = a.startTime.hour * 60 + a.startTime.minute;
        final bTime = b.startTime.hour * 60 + b.startTime.minute;
        return aTime.compareTo(bTime);
      });

      _determineCurrentClass(now);
    } catch (e) {
      print("Error fetching home data: ${e.toString()}");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _determineCurrentClass(DateTime now) {
    if (dailySchedule.isEmpty) {
      currentClass = null;
      return;
    }

    final nowMinutes = now.hour * 60 + now.minute;

    for (var schedule in dailySchedule) {
      final startMin = schedule.startTime.hour * 60 + schedule.startTime.minute;
      final endMin = schedule.endTime.hour * 60 + schedule.endTime.minute;

      if (nowMinutes >= (startMin - 15) && nowMinutes <= endMin) {
        currentClass = schedule;
        return;
      }
    }

    // Nearest future class
    final nextClasses =
        dailySchedule.where((s) {
          final startMin = s.startTime.hour * 60 + s.startTime.minute;
          return startMin > nowMinutes;
        }).toList();

    if (nextClasses.isNotEmpty) {
      currentClass = nextClasses.first;
    } else {
      currentClass = null;
    }
  }

  void checkIn() {
    Get.toNamed(Routes.qrscanpage);
  }
}
