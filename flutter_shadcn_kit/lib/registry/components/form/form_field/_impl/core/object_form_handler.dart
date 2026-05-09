// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form_field.dart';

/// Abstract interface for controlling an object form field's state.
///
/// [ObjectFormHandler] provides methods to interact with an object form field,
/// including getting/setting values and controlling the editor visibility.
abstract class ObjectFormHandler<T> {
  /// Gets the current value.
  T? get value;

  /// Sets the current value.
  set value(T? value);

  /// Opens the editor with an optional initial value.
  void prompt([T? value]);

  /// Closes the editor.
  Future<void> close();

  /// Finds the [ObjectFormHandler] in the widget tree.
  static ObjectFormHandler<T> of<T>(BuildContext context) {
    return Data.of<ObjectFormHandler<T>>(context);
  }

  /// Finds the [ObjectFormHandler] in the widget tree (alternative method).
  static ObjectFormHandler<T> find<T>(BuildContext context) {
    return Data.find<ObjectFormHandler<T>>(context);
  }
}
