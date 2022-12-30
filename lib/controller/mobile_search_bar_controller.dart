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
    viewMobileSearchBar = true;
    update();
  }
}
