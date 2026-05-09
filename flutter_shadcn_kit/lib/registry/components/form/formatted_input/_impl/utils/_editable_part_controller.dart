// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// _EditablePartController coordinates state and interactions for this form component.
class _EditablePartController extends TextEditingController {
  /// Field storing `maxLength` for this form implementation.
  final int maxLength;

  /// Flag indicating whether `hasPlaceholder` is enabled/active.
  final bool hasPlaceholder;

  /// Constructs `_EditablePartController` with the provided parameters.
  _EditablePartController({
    required this.maxLength,
    required this.hasPlaceholder,
    super.text,
  });

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final theme = Theme.of(context);
    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );
    final bool composingRegionOutOfRange =
        !value.isComposingRangeValid || !withComposing;

    if (composingRegionOutOfRange) {
      var text = this.text;
      if (text.isEmpty && hasPlaceholder) {
        return const TextSpan();
      }
      var padding = '_' * max(0, maxLength - text.length);
      return TextSpan(
        children: [
          TextSpan(style: style, text: text),
          TextSpan(
            style: style?.copyWith(color: theme.colorScheme.mutedForeground),
            text: padding,
          ),
        ],
      );
    }

    final TextStyle composingStyle =
        style?.merge(const TextStyle(decoration: TextDecoration.underline)) ??
        const TextStyle(decoration: TextDecoration.underline);
    var textBefore = value.composing.textBefore(value.text);
    var textInside = value.composing.textInside(value.text);
    var textAfter = value.composing.textAfter(value.text);
    int totalTextLength =
        textBefore.length + textInside.length + textAfter.length;
    if (totalTextLength == 0 && hasPlaceholder) {
      return const TextSpan();
    }
    var padding = '_' * max(0, maxLength - totalTextLength);
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: textBefore),
        TextSpan(style: composingStyle, text: textInside),
        TextSpan(text: textAfter),
        TextSpan(
          style: style?.copyWith(color: theme.colorScheme.mutedForeground),
          text: padding,
        ),
      ],
    );
  }
}
