import 'dart:convert';
import 'dart:developer';

import 'package:unicheck_mobile/services/shared_preferences_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConfigTextController extends GetxController {
  RxString appNameLookupPage = ''.obs;
  RxString contentLookupPage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadConfigFromJson();
  }

  loadConfigFromJson() async {
    try {
      String? savedConfigText = await SharedPreferencesService.getConfigText();
      List<dynamic> data;

      if (savedConfigText != null && savedConfigText.isNotEmpty) {
        log("USE CONFIG TEXT FROM SERVER");
        data = json.decode(savedConfigText);
      } else {
        log("USE CONFIG TEXT FROM RESOURCE");
        final String response =
            await rootBundle.loadString('assets/datas/text.json');
        data = json.decode(response);
      }

      final lookupTextConfig = data.firstWhere(
          (element) => element['page'] == 'lookup_page',
          orElse: () => null);
      if (lookupTextConfig != null) {
        final List<dynamic> positions = lookupTextConfig['position'] ?? [];
        for (var position in positions) {
          final name = position['name'];
          final content = position['content'];
          //final enable = position['enable'];

          switch (name) {
            case 'NameApp':
              appNameLookupPage.value = content;
              break;
            case 'Content':
              contentLookupPage.value = content;
              break;
          }
        }
      }
    } catch (e) {
      log('Error loading config: $e');
    }
  }
}
