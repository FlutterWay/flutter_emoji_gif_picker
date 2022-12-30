import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';

class MenuColors {
  late Color backgroundColor,
      searchBarBackgroundColor,
      searchBarBorderColor,
      searchBarEnabledColor,
      searchBarFocusedColor,
      iconHoveredBackgroundColor,
      buttonColor,
      menuSelectedIconColor,
      indicatorColor;
  Color? iconBackgroundColor;
  MenuColors({
    Color? backgroundColor,
    Color? searchBarBackgroundColor,
    Color? searchBarBorderColor,
    Color? searchBarEnabledColor,
    Color? searchBarFocusedColor,
    Color? buttonColor,
    Color? iconHoveredBackgroundColor,
    Color? menuSelectedIconColor,
    Color? indicatorColor,
    this.iconBackgroundColor,
  }) {
    this.backgroundColor = backgroundColor ?? const Color(0xFFf6f5f3);
    this.searchBarBackgroundColor = searchBarBackgroundColor ?? Colors.white;
    this.searchBarBorderColor = searchBarBorderColor ?? const Color(0xFFe6e5e2);
    this.searchBarEnabledColor = searchBarEnabledColor ?? this.backgroundColor;
    this.searchBarFocusedColor =
        searchBarFocusedColor ?? const Color(0xFF00a884);
    this.buttonColor = buttonColor ?? const Color(0xFF909090);
    this.iconHoveredBackgroundColor =
        iconHoveredBackgroundColor ?? const Color.fromARGB(255, 224, 224, 224);
    this.menuSelectedIconColor =
        menuSelectedIconColor ?? const Color(0xFF1d6e5f);
    this.indicatorColor = indicatorColor ?? Colors.transparent;
  }
  MenuColors.dark() {
    if (Platform.I.isDesktop) {
      backgroundColor = const Color(0xFF262626);
      searchBarBackgroundColor = const Color(0xFF202020);
      searchBarBorderColor = const Color(0xFF343434);
      searchBarEnabledColor = backgroundColor;
      searchBarFocusedColor = const Color(0xFF00a884);
      buttonColor = const Color(0xFF7d7d7d);
      iconHoveredBackgroundColor = const Color.fromARGB(255, 75, 75, 75);
      menuSelectedIconColor = const Color(0xFF037e69);
      indicatorColor = Colors.transparent;
    } else {
      backgroundColor = const Color(0xFF121b22);
      searchBarBackgroundColor = const Color(0xFF1f2c34);
      searchBarBorderColor = Colors.transparent;
      searchBarEnabledColor = Colors.transparent;
      searchBarFocusedColor = Colors.transparent;
      buttonColor = const Color(0xFF627885);
      iconHoveredBackgroundColor = Colors.transparent;
      menuSelectedIconColor = Colors.white;
      indicatorColor = const Color(0xFF037e69);
    }
  }
  MenuColors.light() {
    if (Platform.I.isDesktop) {
      backgroundColor = const Color(0xFFf6f5f3);
      searchBarBackgroundColor = Colors.white;
      searchBarBorderColor = const Color(0xFFe6e5e2);
      searchBarEnabledColor = backgroundColor;
      searchBarFocusedColor = const Color(0xFF00a884);
      buttonColor = const Color(0xFF909090);
      iconHoveredBackgroundColor = const Color.fromARGB(255, 224, 224, 224);
      menuSelectedIconColor = const Color.fromARGB(255, 42, 219, 187);
      indicatorColor = Colors.transparent;
    } else {
      backgroundColor = const Color(0xFFe9edf0);
      searchBarBackgroundColor = const Color(0xFFf7f8fa);
      searchBarBorderColor = Colors.transparent;
      searchBarEnabledColor = Colors.transparent;
      searchBarFocusedColor = Colors.transparent;
      buttonColor = const Color(0xFF758288);
      iconHoveredBackgroundColor = Colors.transparent;
      menuSelectedIconColor = Colors.black;
      indicatorColor = const Color(0xFF037e69);
    }
  }
}

class MenuStyles {
  late TextStyle menuSelectedTextStyle,
      menuUnSelectedTextStyle,
      searchBarTextStyle,
      searchBarHintStyle;
  MenuStyles(
      {TextStyle? menuSelectedTextStyle,
      TextStyle? menuUnSelectedTextStyle,
      TextStyle? searchBarHintStyle,
      TextStyle? searchBarTextStyle}) {
    this.menuSelectedTextStyle = menuSelectedTextStyle ??
        const TextStyle(fontSize: 20, color: Colors.black);
    this.menuUnSelectedTextStyle = menuUnSelectedTextStyle ??
        const TextStyle(fontSize: 20, color: Color(0xFF7a7a7a));
    this.searchBarHintStyle = searchBarHintStyle ??
        const TextStyle(fontSize: 12, color: Color(0xFF8d8d8d));
    this.searchBarTextStyle = searchBarTextStyle ??
        const TextStyle(fontSize: 12, color: Colors.black);
  }
  MenuStyles.dark() {
    menuSelectedTextStyle = const TextStyle(fontSize: 20, color: Colors.white);
    menuUnSelectedTextStyle =
        const TextStyle(fontSize: 20, color: Color(0xFF9d9f9e));
    searchBarHintStyle =
        const TextStyle(fontSize: 12, color: Color(0xFF848484));
    searchBarTextStyle = const TextStyle(fontSize: 12, color: Colors.white);
  }
  MenuStyles.light() {
    menuSelectedTextStyle = const TextStyle(fontSize: 20, color: Colors.black);
    menuUnSelectedTextStyle =
        const TextStyle(fontSize: 20, color: Color(0xFF7a7a7a));
    searchBarHintStyle =
        const TextStyle(fontSize: 12, color: Color(0xFF8d8d8d));
    searchBarTextStyle = const TextStyle(fontSize: 12, color: Colors.black);
  }
}

class MenuSizes {
  double width, height;
  double? tempWidth, tempHeight;
  late double iconSize;
  MenuSizes({required this.width, required this.height, double? iconSize}) {
    this.iconSize = iconSize ?? 20;
  }
}

class MenuPosition {
  double? top, bottom, left, right;
  MenuPosition({this.top, this.bottom, this.left, this.right});
}

class MenuTexts {
  String? searchGifHintText, searchEmojiHintText;
  MenuTexts({String? searchEmojiHintText, String? searchGifHintText}) {
    this.searchEmojiHintText = searchEmojiHintText ?? "Search Emoji";
    this.searchGifHintText = searchGifHintText ?? "Search with Giphy";
  }
}
