import '../controller/keyboard_controller.dart';
import '/controller/menu_state_controller.dart';
import '/views/picker_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_info/platform_info.dart';
import '../models/menu_design.dart';

class EmojiGifMenuColumn extends StatelessWidget {
  /// EmojiGifMenuColumn will be openning at bottom of EmojiGifMenuLayout

  final bool isKeyboardOpened = false;

  const EmojiGifMenuColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuStateController>(builder: (controller) {
      return controller.isOpened && controller.currentMenu!.fromStack == false
          ? PickerMenu(
              sizes: setSizes(controller),
              onBackSpacePressed: controller.currentMenu!.onBackSpacePressed,
              onEmojiSelected: controller.currentMenu!.onEmojiSelected,
              onGifSelected: controller.currentMenu!.onGifSelected,
              colors: controller.menuColors,
              viewEmoji: controller.currentMenu!.viewEmoji,
              viewGif: controller.currentMenu!.viewGif,
              textEditingController:
                  controller.currentMenu!.textEditingController,
              styles: controller.menuStyles,
              texts: controller.menuTexts,
              giphyApiKey: controller.giphyApiKey)
          : const SizedBox();
    });
  }

  MenuSizes setSizes(MenuStateController controller) {
    var keyboardController = Get.find<KeyboardController>();
    MenuSizes sizes;
    if (Platform.I.isMobile && keyboardController.isOpen) {
      sizes = MenuSizes(width: controller.menuSizes.width, height: 150);
    } else {
      sizes = controller.menuSizes;
    }
    return sizes;
  }
}
