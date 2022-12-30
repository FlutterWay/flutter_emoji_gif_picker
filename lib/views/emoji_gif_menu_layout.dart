import '/controller/menu_state_controller.dart';
import '/views/emoji_gif_menu_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiGifMenuLayout extends StatelessWidget {
  /// EmojiGifMenuLayout puts your design inside a Column
  ///
  /// If you change your emoji icon widget's fromStack parameter as false and put your design into this, your design will be resized like the keyboard does

  final Widget child;
  EmojiGifMenuLayout({super.key, required this.child}) {
    Get.put(MenuStateController());
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: child,
        ),
        const EmojiGifMenuColumn()
      ],
    );
  }
}
