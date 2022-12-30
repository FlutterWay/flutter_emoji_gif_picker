import '/models/menu_design.dart';
import '/views/picker_menu_desktop.dart';
import '/views/picker_menu_mobile.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:giphy_api_client/giphy_api_client.dart';
import 'package:platform_info/platform_info.dart';

class PickerMenu extends StatelessWidget {
  /// This is your Emoji Gif Picker that will be shown

  final MenuColors colors;
  final MenuStyles styles;
  final MenuTexts texts;
  final String? giphyApiKey;
  final MenuSizes sizes;
  final Function()? onBackSpacePressed;
  final void Function(Category? category, Emoji emoji)? onEmojiSelected;
  final void Function(GiphyGif? gif)? onGifSelected;
  final TextEditingController? textEditingController;
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
      required this.sizes})
      : colors = colors ?? MenuColors(),
        styles = styles ?? MenuStyles(),
        texts = texts ?? MenuTexts();

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
