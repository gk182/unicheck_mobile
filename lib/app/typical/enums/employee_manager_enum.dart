enum EmployeeManagerEnum {
  /// Đang hoạt động
  accepted,

  /// Chờ xác nhân
  waitingAccept,

  /// Từ chối
  nonAccept,

  /// Khoá tài khoản
  lockAccount,

  /// Ngưng hoạt động
  inactive,

  none,
}

EmployeeManagerEnum employeeManagerEnumFromString(String code) {
  switch (code) {
    case '1':
      return EmployeeManagerEnum.accepted;
    case '2':
      return EmployeeManagerEnum.waitingAccept;
    case '3':
      return EmployeeManagerEnum.nonAccept;
    case '4':
      return EmployeeManagerEnum.lockAccount;
    case '5':
      return EmployeeManagerEnum.inactive;
    default:
      return EmployeeManagerEnum.none;
  }
}

extension EmployeeManagerEnumMapper on EmployeeManagerEnum {
  int toCode() {
    switch (this) {
      case EmployeeManagerEnum.accepted:
        return 1;
      case EmployeeManagerEnum.waitingAccept:
        return 2;
      case EmployeeManagerEnum.nonAccept:
        return 3;
      case EmployeeManagerEnum.lockAccount:
        return 4;
      case EmployeeManagerEnum.inactive:
        return 5;
      case EmployeeManagerEnum.none:
        return 0;
    }
  }

  // String? getMessage() {
  //   switch (this) {
  //     case EmployeeManagerEnum.accepted:
  //       return AppNavigatorKey.navigator.currentContext!.local.unlockSuccessEMLOYEE;
  //     case EmployeeManagerEnum.lockAccount:
  //       return AppNavigatorKey.navigator.currentContext!.local.lockSuccessEMLOYEE;
  //     case EmployeeManagerEnum.inactive:
  //       return AppNavigatorKey.navigator.currentContext!.local.inactiveSuccessEMLOYEE;
  //     case EmployeeManagerEnum.waitingAccept:
  //     case EmployeeManagerEnum.nonAccept:
  //     case EmployeeManagerEnum.none:
  //     default:
  //       return null;
  //   }
  // }
}
