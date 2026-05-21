// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Mixin providing select popup interaction methods.
///
/// Allows widgets to check selection state and update selections.
mixin SelectPopupHandle {
  /// Checks if the given value is currently selected.
  bool isSelected(Object? value);

  /// Updates the selection state for the given value.
  void selectItem(Object? value, bool selected);

  /// Whether any items are currently selected.
  bool get hasSelection;

  /// Retrieves the nearest SelectPopupHandle from the widget tree.
  static SelectPopupHandle of(BuildContext context) {
    return Data.of<SelectPopupHandle>(context);
  }
}
