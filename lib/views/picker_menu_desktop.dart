import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';

import '../giphy/client.dart';
import '../giphy/models/collection.dart';
import '../giphy/models/gif.dart';
import '../models/menu.dart';
import '/models/menu_design.dart';

class PickerMenuDesktop extends StatefulWidget {
  final MenuColors colors;
  final MenuStyles styles;
  final MenuTexts texts;
  final String? giphyApiKey;
  final MenuSizes sizes;
  final Function()? onBackSpacePressed;
  final void Function(Category? category, Emoji emoji)? onEmojiSelected;
  final void Function(GiphyGif? gif)? onGifSelected;
  final TextEditingController? textEditingController;
  final bool viewEmoji, viewGif;
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
      required this.viewEmoji,
      required this.viewGif,
      required this.sizes})
      : colors = colors ?? MenuColors(),
        styles = styles ?? MenuStyles(),
        texts = texts ?? MenuTexts();

  @override
  State<PickerMenuDesktop> createState() {
    return _PickerMenuState();
  }
}

class _PickerMenuState extends State<PickerMenuDesktop> {
  MenuType menu = MenuType.emoji;
  TextEditingController searchController = TextEditingController();
  GiphyClient? client;
  List<Emoji> filterEmojiEntities = [];
  var gifScrollController = ScrollController();
  List<GiphyGif> left = [];
  List<GiphyGif> right = [];
  double leftH = 0, rightH = 0;
  String search = "";
  int offset = 0;
  int limit = 30;
  @override
  void initState() {
    super.initState();
    if (!widget.viewEmoji && widget.viewGif) {
      menu = MenuType.gif;
      setupGiphy();
    }
    if (widget.viewGif) {
      gifScrollController.addListener(() {
        if (gifScrollController.position.pixels >
            gifScrollController.position.maxScrollExtent * 0.8) {
          addGif();
        }
      });
    }
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
    left = [];
    right = [];
    this.search = search;
    leftH = 0;
    rightH = 0;
    offset = limit;
    GiphyCollection gifs = search != ""
        ? await client!.search(search, limit: limit)
        : await client!.trending(limit: limit);
    updateGifs(gifs);
    setState(() {});
  }

  bool adding = false;
  Future<void> addGif() async {
    if (!adding) {
      adding = true;
      GiphyCollection gifs = search != ""
          ? await client!.search(search, limit: limit, offset: offset)
          : await client!.trending(limit: limit, offset: offset);
      updateGifs(gifs);
      offset += limit;
      adding = false;
      setState(() {});
    }
  }

  void updateGifs(GiphyCollection? gifs) {
    if (gifs != null && gifs.data != null) {
      for (var gif in gifs.data!) {
        if (gif != null &&
            gif.images != null &&
            gif.images!.previewGif != null &&
            gif.images!.previewGif!.url != null) {
          double aspectRatio = int.parse(gif.images!.preview!.width!) /
              int.parse(gif.images!.preview!.height!);
          if (leftH == rightH || rightH > leftH) {
            left.add(gif);
            leftH += widget.sizes.width / 2 * aspectRatio;
          } else {
            right.add(gif);
            rightH += widget.sizes.width / 2 * aspectRatio;
          }
        }
      }
    }
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
              if (widget.viewEmoji && widget.viewGif)
                Row(
                  children: [
                    if (widget.viewEmoji)
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
                    if (widget.giphyApiKey != null && widget.viewGif)
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
                    : viewGifs(widget.sizes.width - 20),
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
        recentsLimit: 28,
        noRecents: widget.texts.noRecents ??
            const Text(
              "No Recents",
              style: TextStyle(fontSize: 20, color: Colors.grey),
              textAlign: TextAlign.center,
            ), // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }

  GiphyGif? hoveredGif;
  Widget viewGifs(double width) {
    return ListView(
      controller: gifScrollController,
      padding: EdgeInsets.zero,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var gifs in [left, right])
              SizedBox(
                width: width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var gif in gifs)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onHover: (value) {
                            if (value) {
                              setState(() {
                                hoveredGif = gif;
                              });
                            } else {
                              setState(() {
                                hoveredGif = null;
                              });
                            }
                          },
                          onPressed: () {
                            if (widget.onGifSelected != null) {
                              widget.onGifSelected!(gif);
                            }
                          },
                          child: Container(
                            width: width / 2,
                            decoration: BoxDecoration(
                                border: gif == hoveredGif
                                    ? Border.all(
                                        width: 3, color: Colors.greenAccent)
                                    : null),
                            child: Image.network(
                              width: width / 2,
                              gif.images!.previewGif!.url!,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}
