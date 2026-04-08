import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/app/controller/theme_controller.dart';
import 'package:unicheck_mobile/app/typical/enums/app_theme.dart';
import 'package:unicheck_mobile/features/profile/controllers/profile_controller.dart';
import 'package:unicheck_mobile/features/profile/views/about_page.dart';
import 'package:unicheck_mobile/features/profile/views/terms_policies_page.dart';
import 'package:unicheck_mobile/features/profile/views/user_manual_page.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_row.dart';
import '../widgets/setting_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Chưa cập nhật';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          final student = controller.studentInfo;
          final settings = controller.settings;
          final isLoading = controller.isLoading.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  name: student?.fullName ?? '',
                  studentId: student?.studentId ?? '',
                  isLoading: isLoading,
                ),

                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Thẻ Thông tin sinh viên ---
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  theme.brightness == Brightness.light
                                      ? 0.05
                                      : 0.2,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Thông tin sinh viên",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (isLoading) ...[
                                _buildSkeletonRow(),
                                _buildSkeletonRow(),
                                _buildSkeletonRow(),
                                _buildSkeletonRow(),
                                _buildSkeletonRow(),
                                _buildSkeletonRow(isLast: true),
                              ] else if (student != null) ...[
                                InfoRow(
                                  label: "Họ và tên",
                                  value: student.fullName,
                                ),
                                InfoRow(
                                  label: "Mã số sinh viên",
                                  value: student.studentId,
                                ),
                                InfoRow(
                                  label: "Lớp sinh hoạt",
                                  value: student.classCode,
                                ),
                                InfoRow(
                                  label: "Ngày sinh",
                                  value: _formatDate(student.dateOfBirth),
                                ),
                                InfoRow(label: "Khoa", value: student.faculty),
                                InfoRow(label: "Ngành", value: student.major),
                                InfoRow(label: "Email", value: student.email),

                                // Face badge
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Khuôn mặt",
                                        style: TextStyle(
                                          color: theme
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.6),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              student.isFaceRegistered
                                                  ? Colors.green.withOpacity(
                                                    0.15,
                                                  )
                                                  : Colors.red.withOpacity(
                                                    0.15,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                student.isFaceRegistered
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              student.isFaceRegistered
                                                  ? Icons.check_circle
                                                  : Icons.warning_amber_rounded,
                                              size: 14,
                                              color:
                                                  student.isFaceRegistered
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              student.isFaceRegistered
                                                  ? "Đã đăng ký"
                                                  : "Chưa đăng ký",
                                              style: TextStyle(
                                                color:
                                                    student.isFaceRegistered
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("Không có dữ liệu sinh viên"),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- Khối Cài đặt ---
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  theme.brightness == Brightness.light
                                      ? 0.05
                                      : 0.2,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                  bottom: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.settings_outlined,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Cài đặt",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SettingItem(
                                icon: Icons.key_outlined,
                                title: "Đổi mật khẩu",
                                onTap: () {},
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),
                              SettingItem(
                                icon: Icons.notifications_none,
                                title: "Thông báo",
                                subtitle: "Nhận thông báo khi có lớp học",
                                switchValue: settings.notificationsEnabled,
                                onSwitchChanged: controller.toggleNotifications,
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),
                              SettingItem(
                                icon: Icons.volume_up_outlined,
                                title: "Âm thanh thông báo",
                                subtitle: "Phát âm thanh khi có thông báo",
                                switchValue: settings.soundEnabled,
                                onSwitchChanged: controller.toggleSound,
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),

                              _buildThemeSettingItem(context),

                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),
                              SettingItem(
                                icon: Icons.language,
                                title: "Ngôn ngữ",
                                trailingText: settings.language,
                                onTap: () {},
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),
                              SettingItem(
                                icon: Icons.menu_book_rounded,
                                title: "Hướng dẫn sử dụng",
                                onTap:
                                    () => Get.to(() => const UserManualPage()),
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),
                              SettingItem(
                                icon: Icons.info_outline,
                                title: "Về UniCheck",
                                onTap: () => Get.to(() => const AboutPage()),
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 16,
                                color: theme.dividerColor,
                              ),
                              SettingItem(
                                icon: Icons.description_outlined,
                                title: "Điều khoản & Chính sách",
                                onTap:
                                    () =>
                                        Get.to(() => const TermsPoliciesPage()),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- Nút Đăng xuất ---
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: controller.logout,
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text(
                              "Đăng xuất",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                color: Color(0xFFFECACA),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor:
                                  theme.brightness == Brightness.light
                                      ? const Color(0xFFFEF2F2)
                                      : Colors.transparent,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- Footer ---
                        const Center(
                          child: Text(
                            "UniCheck v1.0.0",
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            "© 2026 Hệ thống điểm danh sinh viên",
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonRow({bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.grey.withOpacity(0.1)),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeSettingItem(BuildContext context) {
    if (!Get.isRegistered<ThemeController>()) {
      return const SizedBox.shrink();
    }

    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      String currentThemeText = "Hệ thống";
      if (themeController.appTheme.value == AppTheme.light)
        currentThemeText = "Sáng";
      if (themeController.appTheme.value == AppTheme.dark)
        currentThemeText = "Tối";

      return SettingItem(
        icon: Icons.dark_mode_outlined,
        title: "Giao diện",
        trailingText: currentThemeText,
        onTap: () {
          Get.bottomSheet(
            _buildThemeSelector(context, themeController),
            backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          );
        },
      );
    });
  }

  Widget _buildThemeSelector(BuildContext context, ThemeController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chọn giao diện",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _themeRadioOption(
            context,
            controller,
            "Sáng",
            AppTheme.light,
            Icons.light_mode,
          ),
          _themeRadioOption(
            context,
            controller,
            "Tối",
            AppTheme.dark,
            Icons.dark_mode,
          ),
          _themeRadioOption(
            context,
            controller,
            "Theo hệ thống",
            AppTheme.system,
            Icons.settings_system_daydream,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _themeRadioOption(
    BuildContext context,
    ThemeController controller,
    String title,
    AppTheme value,
    IconData icon,
  ) {
    return Obx(() {
      final isSelected = controller.appTheme.value == value;
      final primaryColor = Theme.of(context).colorScheme.primary;

      return ListTile(
        leading: Icon(icon, color: isSelected ? primaryColor : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing:
            isSelected ? Icon(Icons.check_circle, color: primaryColor) : null,
        onTap: () {
          controller.changeTheme(value);
          Get.back();
        },
      );
    });
  }
}
