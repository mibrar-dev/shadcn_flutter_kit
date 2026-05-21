// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// Represents a part of a formatted value with its associated input part and value.
///
/// A [FormattedValuePart] pairs an [InputPart] definition with an optional
/// string value, used to represent user input or parsed data within a
/// formatted input field.
///
/// Example:
/// ```dart
/// final part = FormattedValuePart(DigitPart(), '5');
/// final updated = part.withValue('7');
/// ```
class FormattedValuePart {
  /// The input part definition that this value belongs to.
  final InputPart part;

  /// The actual string value for this part, or null if not set.
  final String? value;

  /// Creates a [FormattedValuePart].
  ///
  /// Parameters:
  /// - [part] (`InputPart`, required): The input part definition.
  /// - [value] (`String?`, optional): The value for this part.
  const FormattedValuePart(this.part, [this.value]);

  /// Creates a copy of this part with a new value.
  ///
  /// Parameters:
  /// - [value] (`String`, required): The new value to associate with this part.
  ///
  /// Returns: A new [FormattedValuePart] with the updated value.
  ///
  /// Example:
  /// ```dart
  /// final original = FormattedValuePart(DigitPart(), '1');
  /// final updated = original.withValue('2');
  /// ```
  FormattedValuePart withValue(String value) {
    return FormattedValuePart(part, value);
  }

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return 'FormattedValuePart{part: $part, value: $value}';
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormattedValuePart &&
        part == other.part &&
        value == other.value;
  }

  @override
  int get hashCode => Object.hash(part, value);
}
