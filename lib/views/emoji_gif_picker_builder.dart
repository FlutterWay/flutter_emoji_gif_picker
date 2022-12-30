import 'package:flutter/material.dart';

import '../flutter_emoji_gif_picker.dart';
import '/controller/menu_state_controller.dart';
import 'package:get/get.dart';

class EmojiGifPickerBuilder extends StatelessWidget {
  /// EmojiGifPickerBuilder returns true if the connected emoji gif picker menu is opened.

  final Widget Function(bool isMenuOpened) builder;
  final String id;
  const EmojiGifPickerBuilder(
      {super.key, required this.builder, required this.id});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuStateController>(builder: ((controller) {
      return builder(EmojiGifPickerPanel.isMenuOpened(id));
    }));
  }
}
