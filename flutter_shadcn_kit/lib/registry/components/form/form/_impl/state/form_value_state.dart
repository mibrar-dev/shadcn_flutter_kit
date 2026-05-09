// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Holds the current value and validator for a form field.
///
/// Immutable snapshot of a form field's state used internally by form controllers
/// to track field values and their associated validation rules.
class FormValueState<T> {
  /// The current field value.
  final T? value;

  /// The validator function for this field.
  final Validator<T>? validator;

  /// Creates a [FormValueState].
  ///
  /// Parameters:
  /// - [value] (`T?`, optional): Current field value.
  /// - [validator] (`Validator<T>?`, optional): Validation function.
  FormValueState({this.value, this.validator});

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return 'FormValueState($value, $validator)';
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is FormValueState &&
        other.value == value &&
        other.validator == validator;
  }

  @override
  int get hashCode => Object.hash(value, validator);
}
