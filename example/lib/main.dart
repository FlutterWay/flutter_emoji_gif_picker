import 'package:flutter/material.dart';
import 'package:flutter_emoji_gif_picker/flutter_emoji_gif_picker.dart';

void main() {
  EmojiGifPickerPanel.setup(
      giphyApiKey: "yourgiphyapikey", mode: Mode.light);
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
                  fromStack: false,
                  controller: controller,
                  icon: Icon(Icons.emoji_emotions),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
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
