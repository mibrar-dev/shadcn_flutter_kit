// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// A part that represents an editable input field section.
///
/// [EditablePart] defines a user-editable portion of a formatted input,
/// such as a date component, time segment, or numeric field. Each editable
/// part can have a fixed length, input formatters, and optional obscuring.
///
/// Example:
/// ```dart
/// EditablePart(
///   length: 2,
///   width: 40.0,
///   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
///   placeholder: Text('MM'),
/// )
/// ```
class EditablePart extends InputPart {
  /// The maximum length of text this part can hold.
  final int length;

  /// Whether to obscure the text (e.g., for passwords).
  final bool obscureText;

  /// Input formatters to apply to this part.
  final List<TextInputFormatter> inputFormatters;

  /// The width of this input part.
  final double width;

  /// Optional placeholder widget to display when empty.
  final Widget? placeholder;

  /// Creates an [EditablePart] with the specified configuration.
  const EditablePart({
    required this.length,
    this.obscureText = false,
    this.inputFormatters = const [],
    this.placeholder,
    required this.width,
  });

  /// Field storing `partKey` for this form implementation.
  @override
  Object? get partKey => null;

  /// Current value stored for `canHaveValue`.
  @override
  bool get canHaveValue => true;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, FormattedInputData data) {
    return _EditablePartWidget(
      data: data,
      length: length,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      placeholder: placeholder,
      width: width,
    );
  }

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return 'EditablePart{length: $length, obscureText: $obscureText, inputFormatters: $inputFormatters, width: $width, placeholder: $placeholder}';
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditablePart &&
        other.length == length &&
        other.obscureText == obscureText &&
        listEquals(other.inputFormatters, inputFormatters) &&
        other.width == width &&
        other.placeholder == placeholder;
  }

  @override
  int get hashCode => Object.hash(
    length,
    obscureText,
    Object.hashAll(inputFormatters),
    width,
    placeholder,
  );
}
