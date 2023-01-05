import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileSearchBarController extends GetxController {
  bool viewMobileSearchBar = false;
  FocusNode? myfocus;
  void close() {
    viewMobileSearchBar = false;
    update();
  }

  void open(FocusNode myfocus) {
    this.myfocus = myfocus;
    myfocus.requestFocus();
    viewMobileSearchBar = true;
    update();
  }

  static bool checkFocus() {
    if (GetInstance().isRegistered<MobileSearchBarController>() &&
        Get.find<MobileSearchBarController>().myfocus != null &&
        Get.find<MobileSearchBarController>().myfocus!.hasFocus) {
      return true;
    } else {
      return false;
    }
  }
}
