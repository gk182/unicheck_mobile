class AppConstants {
  static final AppConstants _appConstant = AppConstants._internal();
  //LINK STORE APP
  static const String shareIOS =
      '';
  static const String shareAndroid =
      '';

  static const String shareApp = "";

  //TERM AND POLICY
  static const String term =
      "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/";
  static const String policyIOS = 'https://azmemo.resdii.com/privacy-ios';
  static const String policyAndroid =
      'https://azmemo.resdii.com/privacy-android';

  //STORE ID
  static String storeIdAndroid = "";
  static String storeIdIOS = "";

  //CLIENT ID OAUTH 2.0
  static String clientIdAndroid =
      "";
  static String clientIdIOS =
      "";

  //API DRIVE
  static String apiAndroid = "";
  static String apiIOS = "";


  static String appIdProd = "";
  static String serverURLProd = "";
  static String clientKeyProd =
      "";

  factory AppConstants() {
    return _appConstant;
  }

  AppConstants._internal();
}
