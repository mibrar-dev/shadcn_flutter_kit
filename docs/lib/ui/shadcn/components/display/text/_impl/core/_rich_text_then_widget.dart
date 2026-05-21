// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// Internal helper class used by the text component implementation.
class _RichTextThenWidget extends StatelessWidget {
  /// Data consumed by `_RichTextThenWidget` to render text content.
  final RichText text;

  /// Input parameter used by `_RichTextThenWidget` during rendering and behavior handling.
  final List<InlineSpan> then;

  const _RichTextThenWidget({required this.text, required this.then});

  /// Builds the widget tree for text.
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      locale: text.locale,
      softWrap: text.softWrap,
      overflow: text.overflow,
      textWidthBasis: text.textWidthBasis,
      textHeightBehavior: text.textHeightBehavior,
      maxLines: text.maxLines,
      strutStyle: text.strutStyle,
      selectionColor: text.selectionColor,
      selectionRegistrar: text.selectionRegistrar,
      textScaler: text.textScaler,
      text: TextSpan(children: [text.text, ...then]),
    );
  }
}
