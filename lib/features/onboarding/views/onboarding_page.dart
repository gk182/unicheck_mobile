import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicheck_mobile/app/common/routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Chào mừng đến với\nUniCheck",
      "description": "Hệ thống điểm danh thông minh qua nhận diện khuôn mặt và định vị GPS dành cho sinh viên.",
      "icon": Icons.school_rounded,
      "color": const Color(0xFF1C51E6),
    },
    {
      "title": "Điểm danh\nnhanh chóng",
      "description": "Chỉ mất vài giây để điểm danh thành công bằng công nghệ Face AI và xác thực vị trí an toàn.",
      "icon": Icons.face_retouching_natural_rounded,
      "color": const Color(0xFF10B981), // Emerald
    },
    {
      "title": "Theo dõi\ntiến trình học",
      "description": "Dễ dàng tra cứu lịch sử điểm danh, xem báo cáo vắng mặt và gửi đơn xin nghỉ trực tuyến.",
      "icon": Icons.insert_chart_rounded,
      "color": const Color(0xFFF59E0B), // Amber
    },
  ];

  void _onNext() async {
    if (_currentPage == _onboardingData.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _onSkip() async {
    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarded", true);
    Get.offAllNamed(Routes.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorations
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            top: -100.h,
            right: _currentPage == 0 ? -50.w : -150.w,
            left: _currentPage == 2 ? -50.w : null,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _onboardingData[_currentPage]["color"].withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header (Skip button)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AnimatedOpacity(
                      opacity: _currentPage == _onboardingData.length - 1 ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: TextButton(
                        onPressed: _currentPage == _onboardingData.length - 1 ? null : _onSkip,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9CA3AF),
                        ),
                        child: Text(
                          'Bỏ qua',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Graphic
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              width: 250.w,
                              height: 250.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: data["color"].withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: data["color"].withOpacity(0.05),
                                    blurRadius: 40,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 150.w,
                                    height: 150.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      data["icon"],
                                      size: 70.w,
                                      color: data["color"],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 60.h),
                            
                            // Title
                            Text(
                              data["title"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF111827),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            
                            // Description
                            Text(
                              data["description"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFF6B7280),
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Footer (Indicators & Button)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Smooth Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 8.h,
                            width: _currentPage == index ? 24.w : 8.w,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? _onboardingData[_currentPage]["color"]
                                  : const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // Full width Next Button
                      GestureDetector(
                        onTap: _onNext,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: _onboardingData[_currentPage]["color"],
                            borderRadius: BorderRadius.circular(28.h),
                            boxShadow: [
                              BoxShadow(
                                color: _onboardingData[_currentPage]["color"].withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _currentPage == _onboardingData.length - 1
                                    ? "Bắt đầu trải nghiệm"
                                    : "Tiếp tục",
                                key: ValueKey(_currentPage == _onboardingData.length - 1),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
