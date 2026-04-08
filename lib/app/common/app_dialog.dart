// import 'dart:async';
// import 'package:core/utilities/global/app_navigator_key.dart';
// import 'package:core/utilities/global/app_shared.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:vars/app/common/extension.dart';
// import 'package:vars/features/navigate/view/bottom_navitator_view.dart';
// import 'package:vars/features/profile/individual/view/individual_screen.dart';
// import 'package:vars_design/vars_design.dart';

// class AppDialog {
//   AppDialog._();

//   static final instance = AppDialog._();

//   late BuildContext context;

//   void init(BuildContext context) => this.context = context;

//   final isUnquestioningNotification =
//       AppShared.share?.getBool('unquestioningNotification') ?? false;
//   final isUnquestioningLocation =
//       AppShared.share?.getBool('unquestioningLocation') ?? false;

//   Future showNeededUpdateProfileDialog({
//     Function()? onPressedPositivem,
//     Function()? onPressedNegative,
//     Function()? onPressedClose,
//   }) async {
//     final String updateProfile =
//         AppNavigatorKey.navigator.currentContext!.local.msgEnoughInfo;
//     final String updateNow =
//         AppNavigatorKey.navigator.currentContext!.local.updateNow;
//     final String notification =
//         AppNavigatorKey.navigator.currentContext!.local.noti;

//     return varShowDialog(
//         context: AppNavigatorKey.navigator.currentContext!,
//         builder: (_) {
//           return VARDialog(
//             title: notification,
//             msg: updateProfile,
//             positiveButtonName: updateNow,
//             builder: (_) => null,
//             onPressedClose: onPressedClose,
//             onPressedNegative: onPressedNegative,
//             onPressedPositive: onPressedPositivem ??
//                 () {
//                   Navigator.pushNamed(
//                     AppNavigatorKey.navigator.currentContext!,
//                     ProfileIndividualScreen.routeName,
//                   ).then(
//                     (value) => Navigator.popUntil(
//                       AppNavigatorKey.navigator.currentContext!,
//                       ModalRoute.withName(BottomNavigatorView.routeName),
//                     ),
//                   );
//                 },
//           );
//         });
//   }

//   Future showDefaulDialog({required String msg}) {
//     return varShowDialog(
//       context: AppNavigatorKey.navigator.currentContext!,
//       builder: (_) {
//         final String notification =
//             AppNavigatorKey.navigator.currentContext!.local.noti;
//         final String close =
//             AppNavigatorKey.navigator.currentContext!.local.close;

//         return VARDialog(
//           title: notification,
//           msg: msg,
//           positiveButtonName: close,
//           onPressedPositive: () =>
//               Navigator.pop(AppNavigatorKey.navigator.currentContext!),
//           builder: (_) => null,
//         );
//       },
//     );
//   }

//   Future showDialogEvent({
//     required String? animation1,
//     required String animation2,
//     required String code,
//   }) {
//     return varShowDialog(
//       context: AppNavigatorKey.navigator.currentContext!,
//       barrierDismissible: false,
//       builder: (_) {
//         return Dialog(
//           insetPadding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.lg,
//             vertical: 24.0,
//           ),
//           backgroundColor: AppColors.transparent,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Stack(
//                   children: [
//                     _buildLayout1(animation1),
//                     _buildLayout2(animation2),
//                     _buildCode(code),
//                   ],
//                 ),
//                 Center(
//                   child: IconButton(
//                     onPressed: () => Navigator.pop(
//                         AppNavigatorKey.navigator.currentContext!),
//                     icon: Assets.images.icCloseAds.image(
//                       width: 32,
//                       height: 32,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future showDialogConfirmPermissionNotification({
//     required void Function() onConfirm,
//     required void Function() onCancel,
//     required bool isShowCheckBox,
//     required Widget title,
//   }) {
//     var _context = AppNavigatorKey.navigator.currentContext!;
//     return varShowDialog(
//       barrierDismissible: false,
//       context: _context,
//       builder: (_) {
//         StreamController<bool> unquestioningNotification =
//             StreamController<bool>();
//         unquestioningNotification.add(isUnquestioningNotification);
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppSpacing.sm),
//           ),
//           insetPadding: const EdgeInsets.all(30),
//           backgroundColor: AppColors.white,
//           child: StreamBuilder<bool>(
//             stream: unquestioningNotification.stream,
//             builder: (context, snap) {
//               return Container(
//                 padding: const EdgeInsets.all(AppSpacing.lg),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Column(
//                       children: [
//                         title,
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: AppSpacing.lg),
//                           child: VARIconSvg(
//                             assetPath: Assets.icons.icNotificationShake.path,
//                             size: VARIconSize.xxxl,
//                           ),
//                         ),
//                         Text(
//                           _context.local.hintNotiNAVIGATE,
//                           style: UITextStyle.bodyText,
//                         ),
//                         const SizedBox(height: AppSpacing.lg),
//                         DottedBorder(
//                           color: AppColors.primary,
//                           radius: const Radius.circular(10),
//                           dashPattern: const [6, 6],
//                           borderType: BorderType.RRect,
//                           strokeWidth: 1.5,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: AppSpacing.sm,
//                                 horizontal: AppSpacing.lg),
//                             child: Column(
//                               children: [
//                                 benefit(
//                                   Assets.icons.icGiftBoxs.path,
//                                   _context.local.benefit1NAVIGATE,
//                                 ),
//                                 benefit(
//                                   Assets.icons.icHomes.path,
//                                   _context.local.benefit2NAVIGATE,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: AppSpacing.lg),
//                         Visibility(
//                           visible: isShowCheckBox,
//                           child: StreamBuilder<bool>(
//                               stream: unquestioningNotification.stream,
//                               builder: (context, snap) {
//                                 return Row(
//                                   children: [
//                                     VARCheckboxButton(
//                                       value: snap.data ?? false,
//                                       onChanged: (bool value) {
//                                         AppShared.share?.setBool(
//                                             'unquestioningNotification', value);
//                                         unquestioningNotification.sink
//                                             .add(value);
//                                       },
//                                     ),
//                                     const SizedBox(width: AppSpacing.sm),
//                                     Text(
//                                       _context.local.unquestioningNAVIGATE,
//                                       textAlign: TextAlign.center,
//                                       style: UITextStyle.bodyText,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 );
//                               }),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: VARButtonText(
//                             buttonTitle: _context.local.reject,
//                             size: VARButtonSize.l,
//                             style: VARButtonStyle.focus,
//                             onPressed: () {
//                               AppShared.share?.setString(
//                                   'unquestioningNotificationDate',
//                                   DateFormat('yyyy-MM-dd')
//                                       .format(DateTime.now()));
//                               Navigator.pop(_context);
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: AppSpacing.sm),
//                         Expanded(
//                           child: VARButtonText(
//                             buttonTitle: _context.local.next,
//                             size: VARButtonSize.l,
//                             style: (snap.data ?? false)
//                                 ? VARButtonStyle.disable
//                                 : VARButtonStyle.active,
//                             onPressed: (snap.data ?? false)
//                                 ? () {}
//                                 : () {
//                                     onConfirm();
//                                     AppShared.share?.setString(
//                                         'unquestioningNotificationDate',
//                                         DateFormat('yyyy-MM-dd')
//                                             .format(DateTime.now()));
//                                     Navigator.pop(context);
//                                   },
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//         },
//     );
//   }

//   Future showDialogAskAgainPermissionNotification({
//     required void Function() onConfirm,
//     required void Function() onCancel,
//     required bool isShowCheckBox,
//     required Widget title,
//   }) {
//     var _context = AppNavigatorKey.navigator.currentContext!;
//     return varShowDialog(
//       barrierDismissible: false,
//       context: _context,
//       builder: (_) {
//         StreamController<bool> unquestioningNotification =
//             StreamController<bool>();
//         unquestioningNotification.add(isUnquestioningLocation);
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppSpacing.sm),
//           ),
//           insetPadding: const EdgeInsets.all(30),
//           backgroundColor: AppColors.white,
//           child: StreamBuilder<bool>(
//             stream: unquestioningNotification.stream,
//             builder: (context, snap) {
//               return Container(
//                 padding: const EdgeInsets.all(AppSpacing.lg),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Column(
//                       children: [
//                         title,
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: AppSpacing.lg),
//                           child: VARIconSvg(
//                             assetPath: Assets.icons.icMapPlan.path,
//                             size: VARIconSize.xxxl,
//                           ),
//                         ),
//                         Text(
//                           _context.local.hintLocationNAVIGATE,
//                           style: UITextStyle.bodyText,
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: AppSpacing.lg),
//                         DottedBorder(
//                           color: AppColors.primary,
//                           radius: const Radius.circular(10),
//                           dashPattern: const [6, 6],
//                           borderType: BorderType.RRect,
//                           strokeWidth: 1.5,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: AppSpacing.sm,
//                                 horizontal: AppSpacing.lg),
//                             child: Column(
//                               children: [
//                                 benefit(
//                                   Assets.icons.icHomes.path,
//                                   _context.local.benefitLocation1NAVIGATE,
//                                 ),
//                                 benefit(
//                                   Assets.icons.icMapPlan.path,
//                                   _context.local.benefitLocation2NAVIGATE,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: AppSpacing.lg),
//                         Visibility(
//                           visible: isShowCheckBox,
//                           child: Row(
//                             children: [
//                               VARCheckboxButton(
//                                 value: snap.data ?? false,
//                                 onChanged: (bool value) {
//                                   AppShared.share
//                                       ?.setBool('unquestioningLocation', value);
//                                   unquestioningNotification.sink.add(value);
//                                 },
//                               ),
//                               const SizedBox(width: AppSpacing.sm),
//                               Text(
//                                 _context.local.unquestioningNAVIGATE,
//                                 textAlign: TextAlign.center,
//                                 style: UITextStyle.bodyText,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: VARButtonText(
//                             buttonTitle: _context.local.reject,
//                             size: VARButtonSize.l,
//                             style: VARButtonStyle.focus,
//                             onPressed: () {
//                               AppShared.share?.setString(
//                                   'unquestioningNotificationDate',
//                                   DateFormat('yyyy-MM-dd')
//                                       .format(DateTime.now()));
//                               Navigator.pop(_context);
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: AppSpacing.sm),
//                         Expanded(
//                           child: VARButtonText(
//                             buttonTitle: _context.local.next,
//                             size: VARButtonSize.l,
//                             style: (snap.data ?? false)
//                                 ? VARButtonStyle.disable
//                                 : VARButtonStyle.active,
//                             onPressed: (snap.data ?? false)
//                                 ? () {}
//                                 : () {
//                                     onConfirm();
//                                     AppShared.share?.setString(
//                                         'unquestioningNotificationDate',
//                                         DateFormat('yyyy-MM-dd')
//                                             .format(DateTime.now()));
//                                     Navigator.pop(_context);
//                                   },
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Future showDialogConfirmPermissionLocation({
//     required void Function() onConfirm,
//     required void Function() onCancel,
//     required bool isShowCheckBox,
//     required Widget title,
//   }) {
//     var _context = AppNavigatorKey.navigator.currentContext!;
//     return varShowDialog(
//       barrierDismissible: false,
//       context: _context,
//       builder: (_) {
//         StreamController<bool> unquestioningNotification =
//             StreamController<bool>();
//         unquestioningNotification.add(isUnquestioningLocation);
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppSpacing.sm),
//           ),
//           insetPadding: const EdgeInsets.all(30),
//           backgroundColor: AppColors.white,
//           child: StreamBuilder<bool>(
//               stream: unquestioningNotification.stream,
//               builder: (context, snap) {
//                 return Container(
//                   padding: const EdgeInsets.all(AppSpacing.lg),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           title,
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: AppSpacing.lg),
//                             child: VARIconSvg(
//                               assetPath: Assets.icons.icMapPlan.path,
//                               size: VARIconSize.xxxl,
//                             ),
//                           ),
//                           Text(
//                             _context.local.hintLocationNAVIGATE,
//                             style: UITextStyle.bodyText,
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: AppSpacing.lg),
//                           DottedBorder(
//                             color: AppColors.primary,
//                             radius: const Radius.circular(10),
//                             dashPattern: const [6, 6],
//                             borderType: BorderType.RRect,
//                             strokeWidth: 1.5,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: AppSpacing.sm,
//                                   horizontal: AppSpacing.lg),
//                               child: Column(
//                                 children: [
//                                   benefit(
//                                     Assets.icons.icHomes.path,
//                                     _context.local.benefitLocation1NAVIGATE,
//                                   ),
//                                   benefit(
//                                     Assets.icons.icMapPlan.path,
//                                     _context.local.benefitLocation2NAVIGATE,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: AppSpacing.lg),
//                           Visibility(
//                             visible: isShowCheckBox,
//                             child: GestureDetector(
//                               onTap: () {
//                                 AppShared.share?.setBool(
//                                     'unquestioningLocation',
//                                     snap.data ?? false);
//                                 unquestioningNotification.sink
//                                     .add(snap.data ?? false);
//                               },
//                               child: Row(
//                                 children: [
//                                   VARCheckboxButton(
//                                     value: snap.data ?? false,
//                                     onChanged: (bool value) {
//                                       AppShared.share?.setBool(
//                                           'unquestioningLocation', value);
//                                       unquestioningNotification.sink.add(value);
//                                     },
//                                   ),
//                                   const SizedBox(width: AppSpacing.sm),
//                                   Text(
//                                     _context.local.unquestioningNAVIGATE,
//                                     textAlign: TextAlign.center,
//                                     style: UITextStyle.bodyText,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(height: AppSpacing.lg),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: VARButtonText(
//                               buttonTitle: _context.local.reject,
//                               size: VARButtonSize.l,
//                               style: VARButtonStyle.focus,
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: AppSpacing.sm),
//                           Expanded(
//                             child: VARButtonText(
//                               buttonTitle: _context.local.next,
//                               size: VARButtonSize.l,
//                               style: (snap.data ?? false)
//                                   ? VARButtonStyle.disable
//                                   : VARButtonStyle.active,
//                               onPressed: (snap.data ?? false)
//                                   ? () {}
//                                   : () {
//                                       onConfirm();
//                                       Navigator.pop(_context);
//                                     },
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               }),
//         );
//       },
//     );
//   }

//   Future showDialogAskAgainPermissionLocation({
//     required void Function() onConfirm,
//     required void Function() onCancel,
//     required bool isShowCheckBox,
//     required Widget title,
//   }) {
//     var _context = AppNavigatorKey.navigator.currentContext!;
//     return varShowDialog(
//       barrierDismissible: false,
//       context: _context,
//       builder: (_) {
//         StreamController<bool> unquestioningNotification =
//             StreamController<bool>();
//         unquestioningNotification.add(isUnquestioningLocation);
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppSpacing.sm),
//           ),
//           insetPadding: const EdgeInsets.all(30),
//           backgroundColor: AppColors.white,
//           child: StreamBuilder<bool>(
//               stream: unquestioningNotification.stream,
//               builder: (context, snap) {
//                 return Container(
//                   padding: const EdgeInsets.all(AppSpacing.lg),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           title,
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: AppSpacing.lg),
//                             child: VARIconSvg(
//                               assetPath: Assets.icons.icMapPlan.path,
//                               size: VARIconSize.xxxl,
//                             ),
//                           ),
//                           Text(
//                             _context.local.hintLocationNAVIGATE,
//                             style: UITextStyle.bodyText,
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: AppSpacing.lg),
//                           DottedBorder(
//                             color: AppColors.primary,
//                             radius: const Radius.circular(10),
//                             dashPattern: const [6, 6],
//                             borderType: BorderType.RRect,
//                             strokeWidth: 1.5,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: AppSpacing.sm,
//                                   horizontal: AppSpacing.lg),
//                               child: Column(
//                                 children: [
//                                   benefit(
//                                     Assets.icons.icHomes.path,
//                                     _context.local.benefitLocation1NAVIGATE,
//                                   ),
//                                   benefit(
//                                     Assets.icons.icMapPlan.path,
//                                     _context.local.benefitLocation2NAVIGATE,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: AppSpacing.lg),
//                           Visibility(
//                             visible: isShowCheckBox,
//                             child: GestureDetector(
//                               onTap: () {
//                                 AppShared.share?.setBool(
//                                     'unquestioningLocation',
//                                     !(snap.data ?? false));
//                                 unquestioningNotification.sink
//                                     .add(!(snap.data ?? false));
//                               },
//                               child: Row(
//                                 children: [
//                                   VARCheckboxButton(
//                                     value: snap.data ?? false,
//                                     onChanged: (bool value) {
//                                       AppShared.share?.setBool(
//                                           'unquestioningLocation', value);
//                                       unquestioningNotification.sink.add(value);
//                                     },
//                                   ),
//                                   const SizedBox(width: AppSpacing.sm),
//                                   Text(
//                                     _context.local.unquestioningNAVIGATE,
//                                     textAlign: TextAlign.center,
//                                     style: UITextStyle.bodyText,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(height: AppSpacing.lg),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: VARButtonText(
//                               buttonTitle: _context.local.reject,
//                               size: VARButtonSize.l,
//                               style: VARButtonStyle.focus,
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: AppSpacing.sm),
//                           Expanded(
//                             child: VARButtonText(
//                               buttonTitle: _context.local.next,
//                               size: VARButtonSize.l,
//                               style: (snap.data ?? false)
//                                   ? VARButtonStyle.disable
//                                   : VARButtonStyle.active,
//                               onPressed: (snap.data ?? false)
//                                   ? () {}
//                                   : () {
//                                       onConfirm();
//                                       Navigator.pop(_context);
//                                     },
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               }),
//         );
//       },
//     );
//   }

//   Widget benefit(String icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
//       child: Row(
//         children: [
//           VARIconSvg(
//             assetPath: icon,
//             size: VARIconSize.xxxl,
//           ),
//           const SizedBox(width: AppSpacing.sm),
//           Expanded(
//             child: Text(
//               text,
//               style: UITextStyle.bodyText,
//               maxLines: 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLayout1(String? animationCheckInLight) {
//     return FutureBuilder(
//       future: Future.delayed(const Duration(seconds: 1)),
//       builder: (_, __) {
//         return AnimatedOpacity(
//           opacity: __.connectionState == ConnectionState.done ? 1 : 0,
//           duration: const Duration(milliseconds: 300),
//           child: !animationCheckInLight.isNullOrEmpty
//               ? Transform.translate(
//                   offset: const Offset(0, -60),
//                   child: Lottie.network(
//                     animationCheckInLight!,
//                     fit: BoxFit.contain,
//                     repeat: true,
//                     width: double.infinity,
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         );
//       },
//     );
//   }

//   Widget _buildLayout2(String animationCheckIn) {
//     return Lottie.network(
//       animationCheckIn,
//       fit: BoxFit.contain,
//       repeat: false,
//       width: double.infinity,
//       errorBuilder: (_, __, ___) {
//         return Lottie.network(
//           'https://static.vars.vn/media/json/events/anim-welcome-checkin-v7.json',
//           fit: BoxFit.contain,
//           repeat: false,
//           width: double.infinity,
//         );
//       },
//     );
//   }

//   Widget _buildCode(String s) {
//     return Positioned(
//       bottom:
//           MediaQuery.sizeOf(AppNavigatorKey.navigator.currentContext!).width *
//               0.18,
//       left: 30,
//       right: 30,
//       child: Center(child: _textAnimation(s)),
//     );
//   }

//   Widget _textAnimation(String code) {
//     return FutureBuilder(
//       future: Future.delayed(const Duration(seconds: 1)),
//       builder: (_, __) {
//         return AnimatedOpacity(
//           opacity: __.connectionState == ConnectionState.done ? 1 : 0,
//           duration: const Duration(milliseconds: 300),
//           child: Text(
//             code,
//             style: const TextStyle(
//               fontWeight: AppFontWeight.bold,
//               fontFamily: FontFamily.nunito,
//               decoration: TextDecoration.none,
//               fontSize: 28,
//               height: 1.22,
//               color: AppColors.neutral,
//               letterSpacing: 20,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
