// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// A part that displays static, non-editable text.
class StaticPart extends InputPart {
  /// The static text to display.
  final String text;

  /// Creates a [StaticPart] with the specified static text.
  ///
  /// Parameters:
  /// - [text] (`String`, required): The immutable text content to display.
  ///
  /// Example:
  /// ```dart
  /// const StaticPart('/')
  /// ```
  const StaticPart(this.text);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, FormattedInputData data) {
    return _StaticPartWidget(text: text);
  }

  /// Field storing `partKey` for this form implementation.
  @override
  String get partKey => text;

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return 'StaticPart{text: $text}';
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaticPart && other.text == text;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => text.hashCode;
}
