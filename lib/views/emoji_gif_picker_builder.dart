import '../flutter_emoji_gif_picker.dart';
import '/controller/menu_state_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class EmojiGifPickerBuilder extends StatelessWidget {
  Widget Function(bool isMenuOpened) builder;
  String id;
  EmojiGifPickerBuilder({super.key, required this.builder, required this.id});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuStateController>(builder: ((controller) {
      return builder(EmojiGifPickerPanel.isMenuOpened(id));
    }));
  }
}
