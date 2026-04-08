class LoginModel {
  String studentId;
  String password;
  bool rememberMe;

  LoginModel({
    this.studentId = '',
    this.password = '',
    this.rememberMe = false,
  });
}