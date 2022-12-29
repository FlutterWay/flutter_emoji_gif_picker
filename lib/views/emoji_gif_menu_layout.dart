import '/controller/menu_state_controller.dart';
import '/views/emoji_gif_menu_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiGifMenuLayout extends StatelessWidget {
  Widget child;
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
        EmojiGifMenuColumn()
      ],
    );
  }
}
