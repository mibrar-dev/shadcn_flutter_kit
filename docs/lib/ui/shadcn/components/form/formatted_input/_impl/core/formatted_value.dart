// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// Represents a complete formatted value composed of multiple parts.
///
/// A [FormattedValue] holds a list of [FormattedValuePart] instances, where
/// each part represents either static text or editable fields. It provides
/// methods to access value parts (excluding static parts) and retrieve
/// individual parts by index.
///
/// Example:
/// ```dart
/// final value = FormattedValue([
///   FormattedValuePart(DigitPart(), '1'),
///   FormattedValuePart(StaticPart('/'), null),
///   FormattedValuePart(DigitPart(), '2'),
/// ]);
/// print(value.values.length); // 2 (only value parts)
/// ```
class FormattedValue {
  /// The list of parts that make up this formatted value.
  final List<FormattedValuePart> parts;

  /// Creates a [FormattedValue].
  ///
  /// Parameters:
  /// - [parts] (`List<FormattedValuePart>`, default: `const []`): The parts
  ///   composing this value.
  const FormattedValue([this.parts = const []]);

  /// Returns an iterable of only the parts that can hold values.
  ///
  /// This excludes static parts like separators or fixed text.
  Iterable<FormattedValuePart> get values =>
      parts.where((part) => part.part.canHaveValue);

  /// Retrieves the value part at the specified index.
  ///
  /// This indexes only the parts that can hold values (excluding static parts).
  ///
  /// Parameters:
  /// - [index] (`int`, required): The zero-based index into value parts.
  ///
  /// Returns: The [FormattedValuePart] at the index, or null if out of bounds.
  ///
  /// Example:
  /// ```dart
  /// final value = FormattedValue([
  ///   FormattedValuePart(DigitPart(), '1'),
  ///   FormattedValuePart(StaticPart('/'), null),
  ///   FormattedValuePart(DigitPart(), '2'),
  /// ]);
  /// print(value[0]?.value); // '1'
  /// print(value[1]?.value); // '2'
  /// ```
  FormattedValuePart? operator [](int index) {
    int partIndex = 0;
    for (var part in parts) {
      if (part.part.canHaveValue) {
        if (partIndex == index) {
          return part;
        }
        partIndex++;
      }
    }
    return null;
  }

  /// Returns a debug-friendly string representation.
  @override
  String toString() => parts.join();

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormattedValue && listEquals(parts, other.parts);
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => parts.hashCode;
}
