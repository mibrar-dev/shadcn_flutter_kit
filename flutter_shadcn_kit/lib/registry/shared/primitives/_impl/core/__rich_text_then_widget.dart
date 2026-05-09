// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// _RichTextThenWidget defines a reusable type for this registry module.
class _RichTextThenWidget extends StatelessWidget {
  /// Stores `text` state/configuration for this implementation.
  final RichText text;

  /// Stores `then` state/configuration for this implementation.
  final List<InlineSpan> then;

  const _RichTextThenWidget({required this.text, required this.then});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `span` state/configuration for this implementation.
    final TextSpan span = text.text as TextSpan;
    return RichText(
      text: TextSpan(
        text: span.text,
        style: span.style,
        children: [...(span.children ?? []), ...then],
      ),
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      softWrap: text.softWrap,
      overflow: text.overflow,
      maxLines: text.maxLines,
      textScaler: text.textScaler,
      textWidthBasis: text.textWidthBasis,
      textHeightBehavior: text.textHeightBehavior,
    );
  }
}
