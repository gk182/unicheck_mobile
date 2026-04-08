import 'package:unicheck_mobile/app/common/theme/bottom_nav_theme.dart';
import 'package:unicheck_mobile/features/auth/views/login_page.dart';
import 'package:unicheck_mobile/features/bottom_navigation/view_models/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/features/history/views/history_page.dart';
import 'package:unicheck_mobile/features/home_page/view_models/home_controller.dart';
import 'package:unicheck_mobile/features/home_page/views/home_page.dart';
import 'package:unicheck_mobile/features/leave/views/leave_page.dart';
import 'package:unicheck_mobile/features/profile/views/profile_page.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  final navigationController = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
    // Đăng ký HomeController 1 lần duy nhất và giữ nó sống trong suốt phiên
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController(), permanent: false);
    }
  }

  final screens = [
    const HomePage(),
    const HistoryPage(),
    const LeavePage(),
    const ProfilePage(),
  ];

  final List<String> labels = ["Trang chủ", "Lịch sử", "Nghỉ phép", "Cá nhân"];

  final List<IconData> activeIcons = [
    Icons.home_rounded,
    Icons.access_time_filled,
    Icons.description,
    Icons.person,
  ];

  final List<IconData> inactiveIcons = [
    Icons.home_outlined,
    Icons.access_time,
    Icons.description_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    // Lấy toàn bộ biến Theme từ context
    final theme = Theme.of(context);
    final bottomNavTheme = theme.extension<BottomNavTheme>()!;

    // Khởi tạo các màu động dựa trên Theme
    final bgColor = bottomNavTheme.background ?? theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface; // Màu nền của "viên thuốc"
    final activeColor = theme.colorScheme.primary; // Màu chủ đạo của app
    final inactiveColor =
        theme.unselectedWidgetColor; // Màu icon khi không được chọn
    final shadowColor = theme.shadowColor;

    return Scaffold(
      backgroundColor: bgColor,
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(
          () => IndexedStack(
            index: navigationController.selectedIndex.value,
            children: screens,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Gradient giờ sẽ mờ dần dựa trên màu nền của Theme
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgColor.withValues(alpha: 0.0),
              activeColor.withValues(alpha: 0.3),
            ],
            stops: const [0, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: surfaceColor, // Nền viên thuốc đổi theo chế độ Sáng/Tối
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() {
                final currentIndex = navigationController.selectedIndex.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    final isActive = currentIndex == index;

                    return GestureDetector(
                      onTap: () => navigationController.changePage(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        padding: EdgeInsets.symmetric(
                          horizontal: isActive ? 16 : 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? activeColor.withOpacity(
                                    0.15,
                                  ) // Nền highlight bằng 15% màu primary
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isActive
                                  ? activeIcons[index]
                                  : inactiveIcons[index],
                              color: isActive ? activeColor : inactiveColor,
                              size: 24,
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn,
                              child: SizedBox(
                                width: isActive ? null : 0,
                                child: ClipRect(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 6),
                                      Text(
                                        labels[index],
                                        style: TextStyle(
                                          color: activeColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
