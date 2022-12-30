import '/controller/mobile_search_bar_controller.dart';
import '/models/menu_design.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_api_client/giphy_api_client.dart';
import 'package:platform_info/platform_info.dart';

import '../models/menu.dart';

class PickerMenuMobile extends StatefulWidget {
  final MenuColors colors;
  final MenuStyles styles;
  final MenuTexts texts;
  final String? giphyApiKey;
  final MenuSizes sizes;
  final Function()? onBackSpacePressed;
  final void Function(Category? category, Emoji emoji)? onEmojiSelected;
  final void Function(GiphyGif? gif)? onGifSelected;
  final TextEditingController? textEditingController;
  PickerMenuMobile(
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
  State<PickerMenuMobile> createState() => _PickerMenuState();
}

class _PickerMenuState extends State<PickerMenuMobile> {
  MenuType menu = MenuType.emoji;
  TextEditingController searchController = TextEditingController();
  GiphyClient? client;
  GiphyCollection? gifs;
  late MobileSearchBarController mobileSearchBarController;
  List<Emoji> filterEmojiEntities = [];
  @override
  void initState() {
    MobileSearchBarController searchBarController =
        Get.put(MobileSearchBarController());
    searchBarController.viewMobileSearchBar = false;
    mobileSearchBarController = Get.find<MobileSearchBarController>();
    super.initState();
    myfocus.requestFocus();
  }

  @override
  void dispose() {
    Get.find<MobileSearchBarController>().viewMobileSearchBar = false;
    super.dispose();
  }

  Future<void> setupGiphy() async {
    client = GiphyClient(apiKey: widget.giphyApiKey!);
    searchGif(searchController.text);
  }

  Future<void> searchGif(String search) async {
    gifs =
        search != "" ? await client!.search(search) : await client!.trending();
    setState(() {});
  }

  Future<void> searchEmoji(String search) async {
    filterEmojiEntities =
        await EmojiPickerUtils().searchEmoji(search, defaultEmojiSet);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: widget.sizes.tempWidth ?? widget.sizes.width,
          height: widget.sizes.tempHeight ?? widget.sizes.height,
          color: widget.colors.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: menu == MenuType.emoji || widget.giphyApiKey == null
                    ? emojiPicker()
                    : gifPicker(),
              ),
              Container(
                width: widget.sizes.width,
                height: widget.sizes.iconSize * 2.3,
                color: widget.colors.searchBarBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GetBuilder<MobileSearchBarController>(builder: (_) {
                  return viewMobileSearchBar();
                }),
              )
            ],
          )),
    );
  }

  FocusNode myfocus = FocusNode();
  Widget viewMobileSearchBar() {
    return !mobileSearchBarController.viewMobileSearchBar
        ? Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: () {
                    mobileSearchBarController.open(myfocus);
                  },
                  child: Icon(
                    Icons.search,
                    size: widget.sizes.iconSize,
                    color: widget.colors.buttonColor,
                  )),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      menu = MenuType.emoji;
                    });
                  },
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    size: widget.sizes.iconSize,
                    color: menu == MenuType.emoji
                        ? widget.colors.indicatorColor
                        : widget.colors.buttonColor,
                  )),
              if (widget.giphyApiKey != null)
                TextButton(
                    onPressed: () {
                      setState(() {
                        menu = MenuType.gif;
                        setupGiphy();
                      });
                    },
                    child: Icon(
                      Icons.gif_box_outlined,
                      size: widget.sizes.iconSize,
                      color: menu == MenuType.gif
                          ? widget.colors.indicatorColor
                          : widget.colors.buttonColor,
                    )),
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    if (widget.textEditingController != null) {
                      Runes strRunes = widget.textEditingController!.text.runes;
                      widget.textEditingController!.text = String.fromCharCodes(
                          strRunes, 0, strRunes.length - 1);
                      widget.textEditingController!.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset:
                                  widget.textEditingController!.text.length));
                    }
                    if (widget.onBackSpacePressed != null) {
                      widget.onBackSpacePressed!();
                    }
                  },
                  child: Icon(
                    Icons.backspace,
                    size: widget.sizes.iconSize,
                    color: widget.colors.buttonColor,
                  )),
            ),
          ])
        : Row(children: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                mobileSearchBarController.close();
              },
              child: Icon(Icons.arrow_back,
                  color: widget.colors.buttonColor,
                  size: widget.sizes.iconSize),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: widget.colors.searchBarBackgroundColor,
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: searchController,
                  style: widget.styles.searchBarTextStyle,
                  focusNode: myfocus,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: menu == MenuType.emoji
                          ? widget.texts.searchEmojiHintText!
                          : widget.texts.searchGifHintText!,
                      hintStyle: widget.styles.searchBarHintStyle,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: widget.colors.searchBarBackgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: widget.colors.searchBarBackgroundColor),
                      ),
                      suffixIcon: searchController.text != ""
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                if (menu == MenuType.emoji) {
                                  searchEmoji(searchController.text);
                                } else {
                                  searchGif(searchController.text);
                                }
                              },
                              icon: Icon(
                                Icons.close,
                                size: widget.sizes.iconSize,
                                color: widget.colors.buttonColor,
                              ))
                          : null),
                  onChanged: (text) {
                    if (menu == MenuType.emoji) {
                      searchEmoji(text);
                    } else {
                      searchGif(text);
                    }
                  },
                ),
              ),
            )
          ]);
  }

  Widget emojiPicker() {
    return EmojiPicker(
      textEditingController: widget.textEditingController,
      onEmojiSelected: (var category, var emoji) {
        if (widget.onEmojiSelected != null) {
          widget.onEmojiSelected!(category, emoji);
        }
      },
      customWidget: searchController.text == ""
          ? null
          : (config, state) {
              return GridView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: filterEmojiEntities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Platform.I.isDesktop ? 5 : 2,
                    mainAxisSpacing: Platform.I.isDesktop ? 5 : 2),
                itemBuilder: (context, index) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      if (widget.onEmojiSelected != null) {
                        widget.onEmojiSelected!(
                            null, filterEmojiEntities[index]);
                      }
                      if (widget.textEditingController != null) {
                        widget.textEditingController!.text +=
                            filterEmojiEntities[index].emoji;
                        widget.textEditingController!.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                    widget.textEditingController!.text.length));
                      }
                    },
                    child: Text(
                      filterEmojiEntities[index].emoji,
                      style: TextStyle(
                          fontSize: 32 * (Platform.I.isIOS ? 1.30 : 1.0)),
                    ),
                  );
                },
              );
            },
      config: Config(
        columns: 7,
        emojiSizeMax: 32 * (Platform.I.isIOS ? 1.30 : 1.0),
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: widget.colors.backgroundColor,
        indicatorColor: widget.colors.indicatorColor,
        iconColor: Colors.grey,
        iconColorSelected: widget.colors.menuSelectedIconColor,
        backspaceColor: widget.colors.backgroundColor,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        showRecentsTab: true,
        recentsLimit: 28,
        noRecents: Text(
          'No Recents',
          style: widget.styles.menuUnSelectedTextStyle,
          textAlign: TextAlign.center,
        ), // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }

  Widget gifPicker() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: Platform.I.isMobile
          ? const EdgeInsets.only(top: 4, left: 2, right: 2)
          : null,
      child: gifs == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: gifs!.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: Platform.I.isDesktop ? 5 : 2,
                  mainAxisSpacing: Platform.I.isDesktop ? 5 : 2),
              itemBuilder: (context, index) {
                return TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    if (widget.onGifSelected != null) {
                      widget.onGifSelected!(gifs!.data![index]);
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      gifs!.data![index]!.images!.previewGif!.url!,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
