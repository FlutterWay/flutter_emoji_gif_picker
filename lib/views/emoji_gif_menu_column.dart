import '/controller/menu_state_controller.dart';
import '/views/picker_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_info/platform_info.dart';

import '../models/menu_design.dart';

class EmojiGifMenuColumn extends StatelessWidget {

  bool isKeyboardOpened = false;
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
              textEditingController:
                  controller.currentMenu!.textEditingController,
              styles: controller.menuStyles,
              texts: controller.menuTexts,
              giphyApiKey: controller.giphyApiKey)
          : SizedBox();
    });
  }

  MenuSizes setSizes(MenuStateController controller) {
    MenuSizes sizes;
    if (Platform.I.isMobile && controller.isKeyboardOpened) {
      sizes = MenuSizes(width: controller.menuSizes.width, height: 150);
    } else {
      sizes = controller.menuSizes;
    }
    return sizes;
  }
}
