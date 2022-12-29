import '/controller/menu_state_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:platform_info/platform_info.dart';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'emoji_gif_picker_builder.dart';

class EmojiGifTextField extends StatelessWidget {
  EmojiGifTextField({
    super.key,
    required this.id,
    this.decoration = const InputDecoration(),
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    ToolbarOptions? toolbarOptions,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
  })  : assert(textAlign != null),
        assert(autofocus != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(obscureText != null),
        assert(autocorrect != null),
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(enableSuggestions != null),
        assert(scrollPadding != null),
        assert(dragStartBehavior != null),
        assert(selectionHeightStyle != null),
        assert(selectionWidthStyle != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
          !identical(textInputAction, TextInputAction.newline) ||
              maxLines == 1 ||
              !identical(keyboardType, TextInputType.text),
          'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.',
        ),
        assert(clipBehavior != null),
        assert(enableIMEPersonalizedLearning != null),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline);

  final String id;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  ToolbarOptions? toolbarOptions;
  static const int noMaxLength = -1;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  bool get selectionEnabled => enableInteractiveSelection!;
  final GestureTapCallback? onTap;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;

  @override
  Widget build(BuildContext context) {
    return EmojiGifPickerBuilder(
        id: id,
        builder: (isMenuOpened) {
          bool readOnly = Platform.I.isMobile ? isMenuOpened : false;
          bool? showCursor = isMenuOpened ? true : null;
          TextEditingController? controller =
              Get.find<MenuStateController>().isValidMenu(id)
                  ? Get.find<MenuStateController>()
                      .getMenuProperties(id)
                      .textEditingController
                  : null;
          FocusNode? focusNode = Get.find<MenuStateController>().isValidMenu(id)
              ? Get.find<MenuStateController>().getMenuProperties(id).focusNode
              : null;
          enableInteractiveSelection =
              enableInteractiveSelection ?? (!readOnly || !obscureText);
          toolbarOptions = toolbarOptions ??
              (obscureText
                  ? (readOnly
                      // No point in even offering "Select All" in a read-only obscured
                      // field.
                      ? const ToolbarOptions()
                      // Writable, but obscured.
                      : const ToolbarOptions(
                          selectAll: true,
                          paste: true,
                        ))
                  : (readOnly
                      // Read-only, not obscured.
                      ? const ToolbarOptions(
                          selectAll: true,
                          copy: true,
                        )
                      // Writable, not obscured.
                      : const ToolbarOptions(
                          copy: true,
                          cut: true,
                          selectAll: true,
                          paste: true,
                        )));
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: decoration,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            textDirection: textDirection,
            autofocus: autofocus,
            obscuringCharacter: obscuringCharacter,
            obscureText: obscureText,
            autocorrect: autocorrect,
            smartDashesType: smartDashesType,
            smartQuotesType: smartQuotesType,
            enableSuggestions: enableSuggestions,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            readOnly: readOnly,
            toolbarOptions: toolbarOptions,
            showCursor: showCursor,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            onAppPrivateCommand: onAppPrivateCommand,
            inputFormatters: inputFormatters,
            enabled: enabled,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorColor: cursorColor,
            selectionHeightStyle: selectionHeightStyle,
            selectionWidthStyle: selectionWidthStyle,
            keyboardAppearance: keyboardAppearance,
            scrollPadding: scrollPadding,
            enableInteractiveSelection: enableInteractiveSelection,
            selectionControls: selectionControls,
            dragStartBehavior: dragStartBehavior,
            onTap: onTap,
            mouseCursor: mouseCursor,
            buildCounter: buildCounter,
            scrollPhysics: scrollPhysics,
            scrollController: scrollController,
            autofillHints: autofillHints,
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scribbleEnabled: scribbleEnabled,
            enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          );
        });
  }
}
