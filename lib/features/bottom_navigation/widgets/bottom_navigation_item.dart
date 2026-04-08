// import 'package:green_vibe/app/common/colors.dart';
// import 'package:green_vibe/features/bottom_navigation/view_models/navigation_controller.dart';
// import 'package:green_vibe/utils/image_util.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BottomNavigationItem extends StatelessWidget {
//   final navigationController = Get.find<NavigationController>();
//   BottomNavigationItem({
//     super.key,
//     required this.index,
//     required this.icon,
//     required this.label,
//   });

//   final int index;
//   final String icon;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(onTap: () {
//       navigationController.changePage(index);
//     }, child: Obx(() {
//       return Padding(
//         padding: const EdgeInsets.only(top: 12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ImageUtils.imageSvgAsset(
//                 name: icon,
//                 height: 24,
//                 width: 24,
//                 color: navigationController.selectedIndex.value == index
//                     ? AppColors.primary2
//                     : AppColors.grey29),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: navigationController.selectedIndex.value == index
//                       ? AppColors.primary2
//                       : AppColors.grey29),
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 4),
//               width: 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: navigationController.selectedIndex.value == index
//                     ? AppColors.primary2
//                     : Colors.transparent,
//               ),
//             ),
//           ],
//         ),
//       );
//     }));
//   }
// }
