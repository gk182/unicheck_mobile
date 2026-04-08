import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicheck_mobile/app/common/routes.dart';
import 'package:unicheck_mobile/core/api/api_exceptions.dart';
import 'package:unicheck_mobile/core/widgets/app_dialog.dart';
import 'package:unicheck_mobile/services/api/auth_api_service.dart';
import 'package:unicheck_mobile/services/api/student_api_service.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  final LoginModel _loginData = LoginModel();

  // States
  bool _isObscure = true;
  bool get isObscure => _isObscure;

  bool get rememberMe => _loginData.rememberMe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _isObscure = !_isObscure;
    update();
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      _loginData.rememberMe = value;
      update();
    }
  }

  void onStudentIdChanged(String value) {
    _loginData.studentId = value;
  }

  void onPasswordChanged(String value) {
    _loginData.password = value;
  }

  Future<void> login() async {
    if (_loginData.studentId.isEmpty || _loginData.password.isEmpty) {
      AppDialog.show(
        title: 'Thông báo',
        message: 'Vui lòng nhập đầy đủ Mã số sinh viên và Mật khẩu.',
        type: DialogType.warning,
      );
      return;
    }

    _isLoading = true;
    update();

    try {
      final authApiService = Get.find<AuthApiService>();
      final studentApiService = Get.find<StudentApiService>();

      // Bước 1: Đăng nhập — lấy token
      final authData = await authApiService.login(
        _loginData.studentId,
        _loginData.password,
      );

      // Bước 2: Lưu fullName vào SharedPreferences để dùng ở các màn hình sau
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('full_name', authData.fullName);
      await prefs.setString('user_id', authData.userId);

      // Bước 3: Gọi API lấy profile để kiểm tra isFaceRegistered từ server (KHÔNG dùng local flag)
      final student = await studentApiService.getMyProfile();

      // Lưu face_registered để SplashPage biết khi cold start
      await prefs.setBool('face_registered', student.isFaceRegistered);

      // Bước 4: Điều hướng theo trạng thái đăng ký khuôn mặt
      if (!student.isFaceRegistered) {
        Get.offAllNamed(Routes.faceRegistrationPage);
      } else {
        Get.offAllNamed(Routes.bottomNavigationView);
      }
    } on NetworkException catch (e) {
      AppDialog.show(
        title: 'Lỗi kết nối',
        message: e.message,
        type: DialogType.error,
      );
    } on ApiException catch (e) {
      // Hiển thị đúng message lỗi từ server (VD: "Tên đăng nhập hoặc mật khẩu không đúng.")
      AppDialog.show(
        title: 'Đăng nhập thất bại',
        message: e.message,
        type: DialogType.error,
      );
    } on DioException catch (_) {
      AppDialog.show(
        title: 'Đăng nhập thất bại',
        message: 'Tài khoản hoặc mật khẩu không chính xác.',
        type: DialogType.error,
      );
    } catch (_) {
      AppDialog.show(
        title: 'Lỗi',
        message: 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.',
        type: DialogType.error,
      );
    } finally {
      _isLoading = false;
      update();
    }
  }
}
