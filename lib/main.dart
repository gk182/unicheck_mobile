import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/app/common/routes.dart';
import 'package:unicheck_mobile/app/common/theme/theme.dart';
import 'package:unicheck_mobile/app/controller/theme_controller.dart';
import 'package:unicheck_mobile/features/auth/views/login_page.dart';
import 'package:unicheck_mobile/features/bottom_navigation/view/bottom_navigation_view.dart';
import 'package:unicheck_mobile/features/bottom_navigation/view_models/navigation_controller.dart';
import 'package:unicheck_mobile/features/home_page/views/home_page.dart';
import 'package:unicheck_mobile/features/leave/views/leave_page.dart';
import 'package:unicheck_mobile/features/profile/views/profile_page.dart';
import 'package:unicheck_mobile/features/profile/widgets/profile_header.dart';
import 'package:unicheck_mobile/features/qr_scan/views/qr_scan_page.dart';
import 'package:unicheck_mobile/features/splash/views/splash_page.dart';
import 'package:unicheck_mobile/features/onboarding/views/onboarding_page.dart';
import 'package:unicheck_mobile/features/auth/views/face_registration_page.dart';
import 'package:unicheck_mobile/core/bindings/initial_binding.dart';
import 'package:unicheck_mobile/languages/localization_service.dart';
import 'package:unicheck_mobile/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String? savedLang = await SharedPreferencesService.getLanguage();
  final Locale? startLocale = savedLang != null ? Locale(savedLang) : null;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(NavigationController());
  final themeController = Get.put(ThemeController());
  await themeController.loadTheme();
  runApp(MainApp(initialLocale: startLocale));
}

class MainApp extends StatefulWidget {
  final Locale? initialLocale;
  const MainApp({super.key, this.initialLocale});
  
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
  
}
class _MyAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Uni Check',
          // ========================= Theme =========================
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          // ========================= Localization =========================
          translations: LocalizationService(),
          locale: widget.initialLocale ?? LocalizationService.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          // ========================= Bindings =========================
          initialBinding: InitialBinding(),
          // ========================= Routing =========================
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          home: SplashPage(),
          getPages: [
            GetPage(name: Routes.onboardingPage, page: () => OnboardingPage(),),
            GetPage(name: Routes.faceRegistrationPage, page: () => FaceRegistrationPage(),),
            GetPage(
              name: Routes.bottomNavigationView,
              page: () => BottomNavigationView(),
            ),
            GetPage(name: Routes.loginPage, page: () => LoginPage(),),
            GetPage(name: Routes.home, page: () => HomePage()),
            GetPage(name: Routes.profilePage, page: () => ProfilePage()),
            GetPage(name: Routes.leavepage, page: () => LeavePage()),
            GetPage(name: Routes.qrscanpage, page: () => QrScanPage(),transition: Transition.cupertino,),
          ],
        );
      },
    );
  }
}
