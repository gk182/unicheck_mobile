import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/features/home_page/view_models/home_controller.dart';
import 'package:unicheck_mobile/features/home_page/widget/active_class_card.dart';
import 'package:unicheck_mobile/features/home_page/widget/attendance_stats_card.dart';
import 'package:unicheck_mobile/features/home_page/widget/daily_schedule_list.dart';
import 'package:unicheck_mobile/features/home_page/widget/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: controller.fetchHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  HomeHeader(
                    userName: controller.userName.value,
                    notifCount: controller.unreadNotifications.value,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 130, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ActiveClassCard(
                          session: controller.currentClass,
                          onCheckInTap: controller.checkIn,
                          isCheckedIn: controller.isCheckedIn, 
                          checkInTime: controller.checkInTime
                        ),
                        const SizedBox(height: 20),

                        AttendanceStatsCard(stats: controller.stats),
                        const SizedBox(height: 24),

                        DailyScheduleList(
                          schedule: controller.dailySchedule,
                          currentClass: controller.currentClass,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
