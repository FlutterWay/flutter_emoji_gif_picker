import '/models/menu_design.dart';
import '/views/picker_menu_desktop.dart';
import '/views/picker_menu_mobile.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:giphy_api_client/giphy_api_client.dart';
import 'package:platform_info/platform_info.dart';

class PickerMenu extends StatelessWidget {
  late MenuColors colors;
  late MenuStyles styles;
  late MenuTexts texts;
  String? giphyApiKey;
  MenuSizes sizes;
  Function()? onBackSpacePressed;
  void Function(Category? category, Emoji emoji)? onEmojiSelected;
  void Function(GiphyGif? gif)? onGifSelected;
  TextEditingController? textEditingController;
  PickerMenu(
      {super.key,
      MenuColors? colors,
      MenuStyles? styles,
      MenuTexts? texts,
      this.onBackSpacePressed,
      this.onEmojiSelected,
      this.onGifSelected,
      this.textEditingController,
      this.giphyApiKey,
      required this.sizes}) {
    this.colors = colors ?? MenuColors();
    this.styles = styles ?? MenuStyles();
    this.texts = texts ?? MenuTexts();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.I.isMobile
        ? PickerMenuMobile(
            colors: colors,
            styles: styles,
            texts: texts,
            onBackSpacePressed: onBackSpacePressed,
            onEmojiSelected: onEmojiSelected,
            onGifSelected: onGifSelected,
            textEditingController: textEditingController,
            giphyApiKey: giphyApiKey,
            sizes: sizes,
          )
        : PickerMenuDesktop(
            colors: colors,
            styles: styles,
            texts: texts,
            onBackSpacePressed: onBackSpacePressed,
            onEmojiSelected: onEmojiSelected,
            onGifSelected: onGifSelected,
            textEditingController: textEditingController,
            giphyApiKey: giphyApiKey,
            sizes: sizes,
          );
  }
}
