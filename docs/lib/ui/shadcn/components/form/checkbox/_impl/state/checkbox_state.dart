// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../checkbox.dart';

/// Represents the possible states of a checkbox widget.
///
/// Supports the standard checked/unchecked binary states as well as an
/// indeterminate state commonly used to represent partial selection in
/// hierarchical or grouped checkbox scenarios.
///
/// The enum implements [Comparable] to provide consistent ordering:
/// checked < unchecked < indeterminate (based on declaration order).
enum CheckboxState implements Comparable<CheckboxState> {
  /// The checkbox is selected/checked state.
  ///
  /// Visually represented with a checkmark icon inside the checkbox square.
  /// Indicates the associated option or value is selected/enabled.
  checked,

  /// The checkbox is unselected/unchecked state.
  ///
  /// Visually represented as an empty checkbox square with border.
  /// Indicates the associated option or value is not selected/disabled.
  unchecked,

  /// The checkbox is in a partially selected/indeterminate state.
  ///
  /// Visually represented with a small square inside the checkbox.
  /// Typically used in hierarchical structures to indicate some but not
  /// all child items are selected, or when the state is unknown/mixed.
  indeterminate;

  /// Compares checkbox states based on their declaration order.
  ///
  /// Returns negative if this state comes before [other], zero if equal,
  /// positive if this state comes after [other] in the enum declaration.
  @override
  int compareTo(CheckboxState other) {
    return index.compareTo(other.index);
  }
}
