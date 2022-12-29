import '/models/menu_design.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:giphy_api_client/giphy_api_client.dart';
import 'package:platform_info/platform_info.dart';

import '../models/menu.dart';

class PickerMenuDesktop extends StatefulWidget {
  late MenuColors colors;
  late MenuStyles styles;
  late MenuTexts texts;
  String? giphyApiKey;
  MenuSizes sizes;
  Function()? onBackSpacePressed;
  void Function(Category? category, Emoji emoji)? onEmojiSelected;
  void Function(GiphyGif? gif)? onGifSelected;
  TextEditingController? textEditingController;
  PickerMenuDesktop(
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
  State<PickerMenuDesktop> createState() => _PickerMenuState();
}

class _PickerMenuState extends State<PickerMenuDesktop> {
  MenuType menu = MenuType.emoji;
  TextEditingController searchController = TextEditingController();
  GiphyClient? client;
  GiphyCollection? gifs;
  List<Emoji> filterEmojiEntities = [];
  @override
  void initState() {
    super.initState();
    myfocus.requestFocus();
  }

  @override
  void dispose() {
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
          decoration: BoxDecoration(
              color: widget.colors.backgroundColor,
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        menu = MenuType.emoji;
                        setState(() {});
                      },
                      child: Text(
                        "Emoji",
                        style: menu == MenuType.emoji
                            ? widget.styles.menuSelectedTextStyle
                            : widget.styles.menuUnSelectedTextStyle,
                      )),
                  if (widget.giphyApiKey != null)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            menu = MenuType.gif;
                            setupGiphy();
                          });
                        },
                        child: Text(
                          "GIF",
                          style: menu == MenuType.gif
                              ? widget.styles.menuSelectedTextStyle
                              : widget.styles.menuUnSelectedTextStyle,
                        ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.colors.searchBarBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: widget.colors.searchBarBorderColor)),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    focusNode: myfocus,
                    style: widget.styles.searchBarTextStyle,
                    scrollPadding: EdgeInsets.zero,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: menu == MenuType.emoji
                          ? widget.texts.searchEmojiHintText!
                          : widget.texts.searchGifHintText!,
                      hintStyle: widget.styles.searchBarHintStyle,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.colors.searchBarEnabledColor),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.colors.searchBarFocusedColor),
                          borderRadius: BorderRadius.circular(5)),
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
                          : Icon(
                              Icons.search,
                              size: widget.sizes.iconSize,
                              color: widget.colors.buttonColor,
                            ),
                    ),
                    onChanged: (text) {
                      if (menu == MenuType.emoji) {
                        searchEmoji(text);
                      } else {
                        searchGif(text);
                      }
                    },
                  ),
                ),
              ),
              if (Platform.I.isDesktop)
                const SizedBox(
                  height: 10,
                ),
              Expanded(
                child: menu == MenuType.emoji || widget.giphyApiKey == null
                    ? emojiPicker()
                    : gifPicker(),
              ),
            ],
          )),
    );
  }

  FocusNode myfocus = FocusNode();

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
                itemCount: filterEmojiEntities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
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
        emojiSizeMax: 32 *
            (Platform.I.isIOS
                ? 1.30
                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
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
          ? EdgeInsets.only(top: 4, left: 2, right: 2)
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
