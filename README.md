# flutter_emoji_gif_picker
The same emoji-gif picker as whatsapp. Takes the same size as your keyboard(Mobile).

<img width=1200 src="https://raw.githubusercontent.com/FlutterWay/files/main/slideForEmojiPicker.png"> 


## Features 
- Includes Emoji Icon Widget, Textfield
- Includes Gif menu(via Giphy Api)
- Ready to use Dark/Light Mode
- All keyboard problems solved. Ready to use without worrying about keyboard issues
- Back Button Event working same as whatsapp
- All platforms are supported
- Lightweight
- Loading quickly
- Customizable design
- This package is designed based on whatsapp emoji button
- Search bar for emoji/gif 
- Optionally the menu can resize or not resize the page


<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <table>
                 <tr>
                 	<h2>Mobile</h2>
                    <img src="https://raw.githubusercontent.com/FlutterWay/files/main/emoji_mobile.gif" width="200" />
                  </tr>
                </table>
            </td>   
            <td style="text-align: center">
                <table>
                 <tr>
                 	<h2>Desktop</h2>
                    <img src="https://raw.githubusercontent.com/FlutterWay/files/main/emoji_desktop.gif" width="600" />
                  </tr>
                </table>
            </td>   
        </tr> 
    </table>
</div>

## Getting Started

### Basic Setup
It's ready to use. Just pick your dark/light mode and set your giphyApiKey. Without giphyApiKey, the gif menu won't show.
```dart
EmojiGifPickerPanel.setup(
    giphyApiKey: "yourgiphyapikey", mode: Mode.light);
```

### Custom Setup
```dart
  EmojiGifPickerPanel.setup(
      sizes: MenuSizes(width: 2000, height: 500),
      texts: MenuTexts(
          searchEmojiHintText: "Search Emoji?",
          searchGifHintText: "Search with Giphy"),
      colors: MenuColors(
        backgroundColor: const Color(0xFFf6f5f3),
        searchBarBackgroundColor: Colors.white,
        searchBarBorderColor: const Color(0xFFe6e5e2),
        searchBarEnabledColor: Colors.white,
        searchBarFocusedColor: const Color(0xFF00a884),
        menuSelectedIconColor: const Color(0xFF1d6e5f),
        buttonColor: const Color(0xFF909090),
        iconBackgroundColor: null,
        iconHoveredBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
        indicatorColor: Colors.transparent,
      ),
      styles: MenuStyles(
          menuSelectedTextStyle:
              const TextStyle(fontSize: 20, color: Colors.black),
          menuUnSelectedTextStyle:
              const TextStyle(fontSize: 20, color: Color(0xFF7a7a7a)),
          searchBarHintStyle:
              const TextStyle(fontSize: 12, color: Color(0xFF8d8d8d)),
          searchBarTextStyle:
              const TextStyle(fontSize: 12, color: Colors.black)),
      giphyApiKey: "yourgiphyapikey",
      mode: Mode.light);
```

## Change Your MateralApp builder

```dart
return MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  builder: (context, child) {
    return Stack(
      children: [
        child!,
        EmojiGifMenuStack(),
      ],
    );
  },
  home: const MyHomePage(),
);
```

## Column View or Stack View ???
Changes the size of the application when the keyboard is opened. Do you want Emoji Picker to work the same way? Then wrap your design with EmojiGifMenuLayout and set fromStack:false in your picker icon widget.

```dart
EmojiGifMenuLayout(
  child: YourDesign(),
  )
```
```dart
EmojiGifPickerIcon(
  id: "1",
  onGifSelected: (gif) {},
  fromStack: false,
  controller: controller,
  icon: Icon(Icons.emoji_emotions),
),
```

## Back Button Problem

<img src="https://raw.githubusercontent.com/FlutterWay/files/main/emoji_backbutton.gif"> 

When the back button is pressed while the emoji-gif picker menu is open, the menu should close instead of changing the page. You must wrap your scaffold with WillPopScope to solve this problem

```dart
return WillPopScope(
        onWillPop: (() async {
          return EmojiGifPickerPanel.onWillPop();
        }),
        child: Scaffold(
```

## EmojiGifPickerIcon & EmojiGifTextfield

You have to use these widgets to show picker menu.
You should give an id to your picker widgets. This way you can use these widgets in multiple places on the same page.
Don't forget to give your TextEditingController in EmojiGifPickerIcon.

### Icon
```dart
EmojiGifPickerIcon(
    id: "1",
    onGifSelected: (gif) {},
    controller: controller,
    icon: Icon(Icons.emoji_emotions),
  )
```

### TextField
```dart
EmojiGifTextField(
     id: "1",
   )
```

### Full View Example
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    EmojiGifPickerIcon(
      id: "2",
      onGifSelected: (gif) {},
      controller: controller2,
      icon: Icon(Icons.emoji_emotions),
    ),
    SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: EmojiGifTextField(
          id: "2",
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(30)),
          ),
        )),
  ],
```

## Ready to use Example 

```dart
import 'package:flutter/material.dart';
import 'package:emoji_gif_picker_menu/emoji_gif_picker_menu.dart';

void main() {
  EmojiGifPickerPanel.setup(
      giphyApiKey: "kPBosXOgMBPUQQLSlKXQbKFn7EU2sh6p", mode: Mode.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            EmojiGifMenuStack(),
          ],
        );
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (() async {
          return EmojiGifPickerPanel.onWillPop();
        }),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: EmojiGifMenuLayout(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                EmojiGifPickerIcon(
                  id: "1",
                  onGifSelected: (gif) {},
                  controller: controller,
                  icon: Icon(Icons.emoji_emotions),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: EmojiGifTextField(
                      id: "1",
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    )),
              ]),
            )));
  }
}
```

## Customizable

<p align="center">
<img src="https://raw.githubusercontent.com/FlutterWay/files/main/light.JPG"> 
<img src="https://raw.githubusercontent.com/FlutterWay/files/main/dark.JPG"> 
</p>

There is a panel called EmojiGifPickerPanel to edit the design. 
You can customize the features below
- Position
```dart
EmojiGifPickerPanel.setPosition(MenuPosition(bottom: 0));
```
- Size
```dart
EmojiGifPickerPanel.setSizes(MenuSizes(width: 2000, height: 500));
```
- Texts
```dart
EmojiGifPickerPanel.setTexts(MenuTexts(
      searchEmojiHintText: "Search Emoji?",
      searchGifHintText: "Search with Giphy"));
```
- Colors
```dart
  EmojiGifPickerPanel.setColors(MenuColors(
    backgroundColor: const Color(0xFFf6f5f3),
    searchBarBackgroundColor: Colors.white,
    searchBarBorderColor: const Color(0xFFe6e5e2),
    searchBarEnabledColor: Colors.white,
    searchBarFocusedColor: const Color(0xFF00a884),
    menuSelectedIconColor: const Color(0xFF1d6e5f),
    buttonColor: const Color(0xFF909090),
    iconBackgroundColor: null,
    iconHoveredBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
    indicatorColor: Colors.transparent,
  ));
```
- Text Styles
```dart
  EmojiGifPickerPanel.setStyles(MenuStyles(
      menuSelectedTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
      menuUnSelectedTextStyle:
          const TextStyle(fontSize: 20, color: Color(0xFF7a7a7a)),
      searchBarHintStyle:
          const TextStyle(fontSize: 12, color: Color(0xFF8d8d8d)),
      searchBarTextStyle: const TextStyle(fontSize: 12, color: Colors.black)));
```

## Thanks to
- The [emoji_picker_flutter](https://pub.dev/packages/emoji_picker_flutter) package
- The [flutter_keyboard_size](https://pub.dev/packages/flutter_keyboard_size) package
- The [giphy_api_client](https://pub.dev/packages/giphy_api_client) package
- The [get](https://pub.dev/packages/get) package
- The [platform_info](https://pub.dev/packages/platform_info) package