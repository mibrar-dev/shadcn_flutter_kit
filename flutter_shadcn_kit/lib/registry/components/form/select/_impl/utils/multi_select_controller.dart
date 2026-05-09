// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Controller for managing [ControlledMultiSelect] state programmatically.
///
/// Extends [SelectController] to provide reactive state management for multi-selection
/// components. Manages a collection of selected items with methods for adding,
/// removing, and bulk operations.
///
/// Example:
/// ```dart
/// final controller = MultiSelectController<String>(['apple', 'banana']);
///
/// // Listen to changes
/// controller.addListener(() {
///   print('Selection changed to: ${controller.value}');
/// });
///
/// // Update selection
/// controller.value = ['apple', 'cherry'];
/// ```
class MultiSelectController<T> extends SelectController<Iterable<T>> {
  /// Creates a [MultiSelectController] with an optional initial selection.
  ///
  /// The [value] parameter sets the initial selected items collection.
  /// Can be null or empty to start with no selections.
  ///
  /// Parameters:
  /// - [value] (`Iterable<T>?`, optional): Initial selected items
  MultiSelectController([super.value]);
}
