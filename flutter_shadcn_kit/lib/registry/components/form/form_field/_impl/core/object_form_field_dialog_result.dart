// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form_field.dart';

/// Holds the result value from an object form field dialog.
///
/// Used to pass the selected or edited value back from a dialog prompt.
///
/// Example:
/// ```dart
/// final result = ObjectFormFieldDialogResult<DateTime>(DateTime.now());
/// Navigator.of(context).pop(result);
/// ```
class ObjectFormFieldDialogResult<T> {
  /// The value selected or edited by the user.
  final T? value;

  /// Creates an [ObjectFormFieldDialogResult].
  ///
  /// Parameters:
  /// - [value] (`T?`, required): The result value.
  ObjectFormFieldDialogResult(this.value);
}
