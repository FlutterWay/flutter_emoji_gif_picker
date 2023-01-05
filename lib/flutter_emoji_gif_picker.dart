library flutter_emoji_gif_picker;

export 'views/emoji_gif_menu_stack.dart';
export 'views/emoji_gif_picker_icon.dart';
export 'views/emoji_gif_picker_builder.dart';
export 'views/picker_menu.dart';
export 'models/menu_design.dart';
export 'views/emoji_gif_menu_layout.dart';
export 'views/keyboard_provider.dart';
export 'views/emoji_gif_textfield.dart';
export 'models/layout_mode.dart';
import 'package:flutter_emoji_gif_picker/controller/keyboard_controller.dart';

import '/models/menu_design.dart';
import 'package:get/get.dart';
import 'controller/menu_state_controller.dart';
import 'package:platform_info/platform_info.dart';

enum Mode { dark, light }

class EmojiGifPickerPanel {
  /// You dont need to customize your emoji gif picker.
  /// But you can customize almost everything in it.
  ///
  /// Don't forget to put onWillPop to your Scaffold's onWillPop
  ///
  /// You can close, open menu or get status of menu.

  static void setup({
    MenuSizes? sizes,
    MenuTexts? texts,
    MenuColors? colors,
    MenuStyles? styles,
    String? giphyApiKey,
    Mode mode = Mode.dark,
  }) {
    Get.put(KeyboardController());
    MenuStateController controller = Get.put(MenuStateController());
    if (sizes != null) {
      controller.menuSizes = sizes;
    } else {
      if (Platform.I.isMobile) {
        controller.menuSizes = MenuSizes(width: 2000, height: 300);
      } else {
        controller.menuSizes = MenuSizes(width: 460, height: 400);
      }
    }
    if (texts != null) {
      controller.menuTexts = texts;
    }
    if (colors != null) {
      controller.menuColors = colors;
    } else {
      if (mode == Mode.dark) {
        controller.menuColors = MenuColors.dark();
      } else {
        controller.menuColors = MenuColors.light();
      }
    }
    if (styles != null) {
      controller.menuStyles = styles;
    } else {
      if (mode == Mode.dark) {
        controller.menuStyles = MenuStyles.dark();
      } else {
        controller.menuStyles = MenuStyles.light();
      }
    }
    if (giphyApiKey != null) {
      controller.giphyApiKey = giphyApiKey;
    }
  }

  static bool onWillPop() {
    return Get.find<MenuStateController>().onWillPop();
  }

  static setPosition(MenuPosition position) {
    Get.find<MenuStateController>().menuPosition = position;
  }

  static MenuPosition get position =>
      Get.find<MenuStateController>().menuPosition;

  static setSizes(MenuSizes sizes) {
    Get.find<MenuStateController>().menuSizes = sizes;
  }

  static MenuSizes get sizes => Get.find<MenuStateController>().menuSizes;

  static setTexts(MenuTexts texts) {
    Get.find<MenuStateController>().menuTexts = texts;
  }

  static MenuTexts get texts => Get.find<MenuStateController>().menuTexts;

  static setColors(MenuColors colors) {
    Get.find<MenuStateController>().menuColors = colors;
  }

  static MenuColors get colors => Get.find<MenuStateController>().menuColors;

  static setStyles(MenuStyles styles) {
    Get.find<MenuStateController>().menuStyles = styles;
  }

  static MenuStyles get styles => Get.find<MenuStateController>().menuStyles;

  static set setGiphyApiKey(String giphyApiKey) {
    Get.find<MenuStateController>().giphyApiKey = giphyApiKey;
  }

  static String? get giphyApiKey => Get.find<MenuStateController>().giphyApiKey;

  static void open(
      {MenuPosition? position, bool? openFromStack, required String id}) {
    openFromStack ??= Platform.I.isMobile ? false : true;
    var controller = Get.find<MenuStateController>();
    if (Platform.I.isMobile) {
      controller.menuPosition = MenuPosition(bottom: 0);
    } else if (position != null) {
      controller.menuPosition = position;
    }
    controller.open(openFromStack: openFromStack, id: id);
  }

  static void close() {
    Get.find<MenuStateController>().close();
  }

  static bool get isOpened {
    return Get.find<MenuStateController>().isOpened;
  }

  static bool isMenuOpened(String id) {
    return Get.find<MenuStateController>().isMenuOpened(id);
  }

  static void setMenuProperties(MenuProperties menuProperties) {
    Get.find<MenuStateController>().setMenuProperties(menuProperties);
  }

  static MenuProperties getMenuProperties(String id) {
    return Get.find<MenuStateController>().getMenuProperties(id);
  }

  static MenuProperties? get currentMenu =>
      Get.find<MenuStateController>().currentMenu;

  static String? get currentMenuId {
    return Get.find<MenuStateController>().isOpened
        ? Get.find<MenuStateController>().currentMenu!.id
        : null;
  }
}
