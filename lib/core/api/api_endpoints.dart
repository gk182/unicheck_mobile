class ApiEndpoints {
  // Base URLs
  // static const String baseUrlDev =
  //     'http://10.0.2.2:5094'; // Dành cho Android Emulator
  static const String baseUrlDev =
      'http://192.168.1.214:5094'; // Dành cho Android Emulator
  static const String baseUrlProd = 'https://your-production-url.com';

  // Chọn Base URL hiện tại
  static const String baseUrl = baseUrlDev;

  // -- Auth --
  static const String login = '/api/auth/login';

  // -- Students --
  static const String myProfile = '/api/students/me';
  static const String registerFace = '/api/students/register-face';

  // -- Schedules --
  static const String schedules = '/api/schedules';

  // -- Attendances --
  static const String attendanceHistory = '/api/attendances/history';
  static const String attendanceStats = '/api/attendances/statistics';
  static const String checkIn = '/api/attendance/check-in';

  // -- Leave Requests --
  static const String leaveRequests = '/api/leave-requests';
  static const String leaveEligibleSchedules = '/api/leave-requests/eligible-schedules';
  static const String leaveAttachments = '/api/leave-requests/attachments';
}
