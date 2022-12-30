import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

class KeyboardProvider extends StatelessWidget {
  final Widget? child;
  const KeyboardProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyboardSizeProvider(
      child: child ?? const SizedBox(),
    );
  }
}
