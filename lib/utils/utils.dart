import 'dart:developer' as l;
import 'dart:io';

import 'package:unicheck_mobile/app/common/app_constant.dart';
import 'package:unicheck_mobile/app/common/colors.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openStoreListing() async {
  InAppReview inAppReview = InAppReview.instance;
  String storeId = '';
  if (Platform.isAndroid) {
    storeId = AppConstants.storeIdAndroid;
  } else if (Platform.isIOS) {
    storeId = AppConstants.storeIdIOS;
  }

  if (await inAppReview.isAvailable()) {
    inAppReview.openStoreListing(
      appStoreId: storeId,
    );
  }
}

openTermsAndConditionsPage() {
  LanucherUrl.lanuncherUrl(AppConstants.term,
      mode: LaunchMode.externalApplication);
}

openPolicy() {
  if (Platform.isIOS) {
    LanucherUrl.lanuncherUrl(AppConstants.policyIOS,
        mode: LaunchMode.externalApplication);
  } else if (Platform.isAndroid) {
    LanucherUrl.lanuncherUrl(AppConstants.policyAndroid,
        mode: LaunchMode.externalApplication);
  }
}

class LanucherUrl {
  static lanuncherUrl(url, {LaunchMode mode = LaunchMode.inAppWebView}) async {
    try {
      if (url != null &&
          !await launchUrl(
            Uri.parse(url),
            mode: mode,
          )) {}
    } catch (ex) {
      l.log(ex.toString());
    }
  }
}

String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
}

Padding buildDivider() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
    child: Divider(
      color: AppColors.grey30,
      height: 0.5,
    ),
  );
}

// Tạo key cho SharedPreferences
String getCacheKey(String licensePlate, String vehicleCode) {
  return 'lookup_${vehicleCode}_$licensePlate';
}
//
// void handleNotificationNavigation(RemoteMessage message) {
//   final String topic = message.data['data']['topic'] ?? "";

//   switch (topic) {
//     case "OPEN-URL":
//       String? url = message.data['data']['url'];
//       if (url.isNotEmpty) {
//         Get.to(WebViewPage(
//           link: url,
//           isNoti: true,
//         ));
//       }
//       break;
//     case "OPEN-SCREEN":
//       String? screenName = message.data['screenName'];
//       if (screenName.isNotEmpty) {
//         Get.toNamed(screenName);
//       }
//       break;
//     default:
//       //log("Unknown topic: $topic");
//   }
// }
