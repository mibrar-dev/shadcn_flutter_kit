// The value model of a segmented field: the parts (separators + editable
// segments) and the values they carry.
//
// Split out of `segmented_editing.dart` so both files stay under the 400-line
// rule; `formatted_input` is the component that renders this model.

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'segmented_editing.dart';

/// One part of a segmented value: a separator or an editable segment.
///
/// ```dart
/// const SegmentPart.separator('(');
/// const SegmentPart.editable(length: 3, width: 28, placeholder: Text('MM'));
/// ```
class SegmentPart {
  /// Creates a separator part.
  const SegmentPart.separator(this.separator)
    : length = 0,
      width = 0,
      obscureText = false,
      placeholder = null,
      inputFormatters = const <TextInputFormatter>[],
      value = '';

  /// Creates an editable segment.
  const SegmentPart.editable({
    this.value = '',
    required this.length,
    required this.width,
    this.obscureText = false,
    this.placeholder,
    this.inputFormatters = const <TextInputFormatter>[],
  }) : separator = null;

  /// The separator text; null when this part is an editable segment.
  final String? separator;

  /// Maximum length of an editable segment.
  final int length;

  /// Width of an editable segment.
  final double width;

  /// Whether the segment paints dots.
  final bool obscureText;

  /// Placeholder widget of an editable segment.
  final Widget? placeholder;

  /// Formatters of an editable segment.
  final List<TextInputFormatter> inputFormatters;

  /// The current text of an editable segment.
  final String value;

  /// Whether this part holds a value.
  bool get holdsValue => separator == null;

  /// The segment definition of an editable part.
  TextSegment get segment => TextSegment(
    length: length,
    obscureText: obscureText,
    placeholder: placeholder,
    inputFormatters: inputFormatters,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SegmentPart &&
        other.separator == separator &&
        other.length == length &&
        other.width == width &&
        other.obscureText == obscureText &&
        other.placeholder == placeholder &&
        other.inputFormatters == inputFormatters &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(
    separator,
    length,
    width,
    obscureText,
    placeholder,
    inputFormatters,
    value,
  );

  @override
  String toString() => 'SegmentPart($value)';
}

/// The value of a segmented field: its parts plus the value of each editable
/// segment.
class SegmentedValue {
  /// Creates a value from [parts].
  const SegmentedValue([this.parts = const <SegmentPart>[]]);

  /// The parts, in display order.
  final List<SegmentPart> parts;

  /// The editable parts only, in order.
  Iterable<SegmentPart> get values =>
      parts.where((SegmentPart part) => part.holdsValue);

  /// The whole field's text (separators included).
  String get text => parts
      .map(
        (SegmentPart part) =>
            part.holdsValue ? part.value : part.separator ?? '',
      )
      .join();

  /// Returns a copy with the editable part at [index] set to [value].
  SegmentedValue withValue(int index, String value) {
    final List<SegmentPart> next = List<SegmentPart>.of(parts);
    int i = 0;
    for (int part = 0; part < next.length; part++) {
      if (!next[part].holdsValue) {
        continue;
      }
      if (i == index) {
        final SegmentPart old = next[part];
        next[part] = SegmentPart.editable(
          value: value,
          length: old.length,
          width: old.width,
          obscureText: old.obscureText,
          placeholder: old.placeholder,
          inputFormatters: old.inputFormatters,
        );
        break;
      }
      i++;
    }
    return SegmentedValue(next);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SegmentedValue && listEquals(other.parts, parts);
  }

  /// Whether [parts] describes the same field as this value: same parts in the
  /// same order with the same lengths and widths. Values are ignored, so a
  /// value swap never rebuilds the field's segment controllers.
  bool hasShape(List<SegmentPart> parts) {
    if (parts.length != this.parts.length) {
      return false;
    }
    for (int i = 0; i < parts.length; i++) {
      final SegmentPart a = parts[i];
      final SegmentPart b = this.parts[i];
      if (a.holdsValue != b.holdsValue) {
        return false;
      }
      if (a.holdsValue) {
        if (a.length != b.length ||
            a.width != b.width ||
            a.obscureText != b.obscureText ||
            a.placeholder != b.placeholder ||
            !listEquals(a.inputFormatters, b.inputFormatters)) {
          return false;
        }
      } else if (a.separator != b.separator) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => parts.length;

  @override
  String toString() => 'SegmentedValue(${parts.length} parts, $text)';
}
