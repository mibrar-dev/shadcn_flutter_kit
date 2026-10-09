// The `text_area` component: [TextArea], a multi-line [Input].
//
// Ported from `components/form/text_area/**` (312 LOC across three files,
// two of them a `part` pair). The old widget subclassed `TextField` to
// override `expands`, `maxLines` and `minLines` through `widget.copyWith`, then
// stacked a drag-resize handle on top. See README.md ("Fixed bugs").

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/form_core/form_core.dart';
import '../../primitives/input_features/input_features.dart';
import '../input/input.dart';

export '../input/input_style.dart'
    show InputSurface, InputTheme, resolveInputSurface;

/// A multi-line text input.
///
/// A thin, opinionated [Input]: three lines tall, vertically centred content,
/// and a multiline keyboard. Everything else — controller, validation, form
/// participation, features, the focus ring, the theme legs — is `Input`'s.
///
/// ```dart
/// TextArea(hintText: 'Type your message here...', minLines: 3);
/// ```
///
/// The old drag-resize handle is gone: resizing a field is a layout decision
/// (`minLines`/`maxLines`/`expands`) that a rebuild already expresses, and the
/// handle could not work in the direction the box was not laid out in.
class TextArea extends StatelessWidget {
  /// Creates a multi-line text input.
  const TextArea({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.undoController,
    this.statesController,
    this.hintText,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.sentences,
    this.style,
    this.keyboardType,
    this.minLines = textAreaMinLines,
    this.maxLines = textAreaMaxLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.padding,
    this.decoration,
    this.border,
    this.borderRadius,
    this.filled,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.cursorColor,
    this.scrollPadding = const EdgeInsets.all(20),
    this.features = const <InputFeature>[],
    this.validator,
    this.autovalidateMode = FormValidationMode.changed,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.theme,
  }) : assert(
         minLines == null || maxLines == null || maxLines >= minLines,
         'maxLines must be >= minLines',
       );

  /// Lines shown when neither is given.
  static const int textAreaMinLines = 3;

  /// Cap of the auto-grown field; null lets it grow with the content.
  static const int? textAreaMaxLines = null;

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;
  final WidgetStatesController? statesController;
  final String? hintText;
  final Widget? placeholder;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextInputType? keyboardType;

  /// Smallest height, in lines; defaults to [textAreaMinLines].
  final int? minLines;

  /// Largest height, in lines; defaults to [textAreaMaxLines].
  final int? maxLines;

  /// Whether the field fills its parent instead of growing.
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final bool? filled;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final Color? cursorColor;
  final EdgeInsets scrollPadding;
  final List<InputFeature> features;
  final String? Function(String? value)? validator;
  final FormValidationMode autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  /// Widget-leg [InputTheme] override.
  final InputTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      undoController: undoController,
      statesController: statesController,
      hintText: hintText,
      placeholder: placeholder,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      style: style,
      // A textarea has no `Enter` to press: the keyboard offers a return key
      // instead of a submit action.
      keyboardType: keyboardType ?? TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      padding: padding,
      decoration: decoration,
      border: border,
      borderRadius: borderRadius,
      filled: filled,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      cursorColor: cursorColor,
      scrollPadding: scrollPadding,
      features: features,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      theme: theme,
    );
  }
}
