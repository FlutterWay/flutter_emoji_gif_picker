import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_emoji_gif_picker/flutter_emoji_gif_picker.dart';

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
            const EmojiGifMenuStack(),
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
    return PopScope(
        canPop: EmojiGifPickerPanel.onWillPop(),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: EmojiGifMenuLayout(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                EmojiGifPickerIcon(
                  id: "1",
                  onGifSelected: (gif) {},
                  fromStack: false,
                  controller: controller,
                  viewEmoji: true,
                  viewGif: true,
                  icon: const Icon(Icons.emoji_emotions),
                ),
                EmojiGifPickerBuilder(
                  id: "1",
                  builder: ((isMenuOpened) {
                    return const SizedBox();
                  }),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: EmojiGifTextField(
                      id: "1",
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    )),
              ]),
            )));
  }
}
