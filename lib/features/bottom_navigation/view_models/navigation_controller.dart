import 'package:get/get.dart';

// Controller để quản lý trạng thái bottom navigation
class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
