enum WalletEnum {
  main,
  promotion,
  employee,
  none,
}

extension WalletExtentions on WalletEnum {}

WalletEnum walletFromCode(String code) {
  switch (code) {
    case "1":
      return WalletEnum.main;
    case "2":
      return WalletEnum.promotion;
    case "3":
      return WalletEnum.employee;
    default:
      return WalletEnum.none;
  }
}
