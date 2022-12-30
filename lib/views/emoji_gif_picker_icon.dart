import 'dart:math';
import '../flutter_emoji_gif_picker.dart';
import '/controller/menu_state_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_api_client/giphy_api_client.dart';
import 'package:platform_info/platform_info.dart';

class EmojiGifPickerIcon extends StatefulWidget {
  /// If is there any textfield that should be worked with this icon, you must give it's TextEditingController and id as a parameter
  /// Give same id with your EmojiTextField
  final Function()? onBackSpacePressed;
  final void Function(Category? category, Emoji emoji)? onEmojiSelected;
  final void Function(GiphyGif? gif)? onGifSelected;
  final Icon icon;
  final String id;
  final TextEditingController? controller;
  final Widget keyboardIcon;
  final Color hoveredBackgroundColor;
  final Color? backgroundColor;
  final bool fromStack;
  EmojiGifPickerIcon(
      {super.key,
      this.onBackSpacePressed,
      this.onEmojiSelected,
      this.onGifSelected,
      Widget? keyboardIcon,
      required this.id,
      this.controller,
      bool? fromStack,
      required this.icon,
      Color? hoveredBackgroundColor,
      Color? backgroundColor})
      : fromStack = fromStack ?? (Platform.I.isMobile ? false : true),
        hoveredBackgroundColor = hoveredBackgroundColor ??
            Get.find<MenuStateController>()
                .menuColors
                .iconHoveredBackgroundColor,
        backgroundColor = backgroundColor ??
            Get.find<MenuStateController>().menuColors.iconBackgroundColor,
        keyboardIcon = keyboardIcon ??
            Icon(
              Icons.keyboard,
              size: icon.size,
              color: icon.color,
            );

  @override
  State<EmojiGifPickerIcon> createState() => _EmojiGifPickerIconState();
}

class _EmojiGifPickerIconState extends State<EmojiGifPickerIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuStateController>(builder: (controller) {
      return TextButton(
          onPressed: () {
            if (Platform.I.isDesktop) {
              setPosition(context);
            } else {
              Get.find<MenuStateController>().menuSizes.width =
                  MediaQuery.of(context).size.width;
            }
            if (EmojiGifPickerPanel.isMenuOpened(widget.id)) {
              EmojiGifPickerPanel.close();
            } else {
              setMenuItems();
              EmojiGifPickerPanel.open(
                  openFromStack: widget.fromStack, id: widget.id);
            }
          },
          onHover: (value) {
            setState(() {
              isHovered = value;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: isHovered || EmojiGifPickerPanel.isMenuOpened(widget.id)
                    ? widget.hoveredBackgroundColor
                    : widget.backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Platform.I.isMobile &&
                      EmojiGifPickerPanel.isMenuOpened(widget.id)
                  ? widget.keyboardIcon
                  : widget.icon,
            ),
          ));
    });
  }

  void setMenuItems() {
    Get.find<MenuStateController>().setMenuProperties(MenuProperties(
        id: widget.id,
        textEditingController: widget.controller,
        onBackSpacePressed: widget.onBackSpacePressed,
        onEmojiSelected: widget.onEmojiSelected,
        onGifSelected: widget.onGifSelected,
        fromStack: widget.fromStack));
  }

  void setPosition(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      var translation = renderBox.getTransformTo(null).getTranslation();
      final offset = Offset(translation.x, translation.y - 5);
      double menuWidth = EmojiGifPickerPanel.sizes.width;
      double menuHeight = EmojiGifPickerPanel.sizes.height;
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      if (menuWidth > screenWidth - 20) {
        menuWidth = screenWidth - 20;
        EmojiGifPickerPanel.sizes.tempWidth = menuWidth;
      } else {
        EmojiGifPickerPanel.sizes.tempWidth = null;
      }
      if (menuHeight > screenHeight - 20) {
        menuHeight = screenHeight - 20;
        EmojiGifPickerPanel.sizes.tempHeight = menuWidth;
      } else {
        EmojiGifPickerPanel.sizes.tempHeight = null;
      }
      double x1 = offset.dx - (menuWidth / 2);
      double x2 = offset.dx + (menuWidth / 2);
      if (x1 < 0) {
        x2 += (-x1) + 5;
        x1 = 5;
      }
      if (x2 > screenWidth) {
        double fark = x2 - screenWidth;
        x2 = screenWidth - 10;
        x1 -= (fark + 10);
      }
      double y2 = offset.dy;
      double y1 = offset.dy - (menuHeight);
      if (y1 < 0) {
        y2 += (-y1) + 5;
        y1 = 5;
      }
      if (y2 > screenHeight) {
        double fark = y2 - screenHeight;
        y2 = screenHeight - 10;
        y1 -= (fark + 10);
      }
      EmojiGifPickerPanel.setPosition(MenuPosition(left: x1, top: y1));
    }
  }
}

String getRandId() {
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const length = 20;
  final buffer = StringBuffer();
  final random = Random.secure();

  for (int i = 0; i < length; i++) {
    buffer.write(alphabet[random.nextInt(length)]);
  }
  return buffer.toString();
}
