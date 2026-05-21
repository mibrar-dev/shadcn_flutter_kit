// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Implements `_buildCharacterWidgetSpan` behavior for text animate.
InlineSpan _buildCharacterWidgetSpan({required Widget child}) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: child,
  );
}

InlineSpan _buildCursorSpan({
  required StreamingCursor cursor,
  required TextStyle baseStyle,
}) {
  return TextSpan(text: cursor.character, style: baseStyle.merge(cursor.style));
}

Widget _spanToWidget({
  required InlineSpan span,
  required String fallbackChar,
  required TextStyle baseStyle,
}) {
  if (span is WidgetSpan) {
    return span.child;
  }
  if (span is TextSpan) {
    final plainText = span.toPlainText();
    return Text(
      plainText.isEmpty ? fallbackChar : plainText,
      style: baseStyle.merge(span.style),
    );
  }
  return RichText(
    text: TextSpan(style: baseStyle, children: [span]),
  );
}
