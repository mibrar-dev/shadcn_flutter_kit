// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../radio_group.dart';

/// Data class holding radio group state information.
///
/// Contains the selected item and enabled state for a radio group.
class RadioGroupData<T> {
  /// The currently selected item value.
  final T? selectedItem;

  /// Whether the radio group is enabled.
  final bool enabled;

  /// Creates radio group data.
  RadioGroupData(this.selectedItem, this.enabled);

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioGroupData<T> &&
        other.selectedItem == selectedItem &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(selectedItem, enabled);
}
