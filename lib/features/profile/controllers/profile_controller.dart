import 'package:get/get.dart';
import 'package:unicheck_mobile/features/profile/models/profile_model.dart';
import 'package:unicheck_mobile/features/profile/models/student_model.dart';
import 'package:unicheck_mobile/services/api/student_api_service.dart';
import 'package:unicheck_mobile/services/api/auth_api_service.dart';
import 'package:unicheck_mobile/core/widgets/app_dialog.dart';
import 'package:unicheck_mobile/app/common/routes.dart';

class ProfileController extends GetxController {
  final StudentApiService _studentApiService = Get.find<StudentApiService>();
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  
  StudentModel? studentInfo;
  var isLoading = true.obs;
  
  final AppSettings settings = AppSettings();

  @override
  void onInit() {
    super.onInit();
    fetchMyProfile();
  }

  Future<void> fetchMyProfile() async {
    isLoading.value = true;
    update();
    try {
      studentInfo = await _studentApiService.getMyProfile();
    } catch (e) {
      AppDialog.show(
        type: DialogType.error,
        title: "Lỗi dữ liệu",
        message: "Không thể lấy thông tin sinh viên hiện tại.",
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void toggleNotifications(bool value) {
    settings.notificationsEnabled = value;
    update();
  }

  void toggleSound(bool value) {
    settings.soundEnabled = value;
    update();
  }

  void toggleDarkMode(bool value) {
    settings.darkModeEnabled = value;
    update();
  }

  void logout() async {
    // Gọi màn hình loading nếu cần
    await _authApiService.logout();
    Get.offAllNamed(Routes.loginPage);
  }
}
