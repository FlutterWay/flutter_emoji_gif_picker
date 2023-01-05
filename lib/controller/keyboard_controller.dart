import 'package:get/get.dart';

class KeyboardController extends GetxController {
  bool isOpen = false;
  double height = 0;
  double maxHeight = 0;

  void updateKeyboardStatus({required bool isOpen, required double height}) {
    if (height > maxHeight) {
      maxHeight = height;
    }
    this.height = height;
    this.isOpen = isOpen;
    update();
  }
}
