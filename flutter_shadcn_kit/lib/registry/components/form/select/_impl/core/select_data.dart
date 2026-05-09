// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Data class holding select dropdown state and configuration.
///
/// Contains selection state, callbacks, and display options for select popups.
class SelectData {
  /// Whether to automatically close the popup after selection.
  final bool? autoClose;

  /// Predicate to check if a value is currently selected.
  final Predicate<Object?> isSelected;

  /// Callback invoked when selection changes.
  final SelectValueChanged<Object?> onChanged;

  /// Whether any items are currently selected.
  final bool hasSelection;

  /// Whether the select is enabled for interaction.
  final bool enabled;

  /// Creates select data.
  const SelectData({
    required this.autoClose,
    required this.isSelected,
    required this.onChanged,
    required this.hasSelection,
    required this.enabled,
  });

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelectData) return false;
    return other.isSelected == isSelected &&
        other.onChanged == onChanged &&
        other.hasSelection == hasSelection &&
        other.autoClose == autoClose &&
        other.enabled == enabled;
  }

  @override
  int get hashCode =>
      Object.hash(isSelected, onChanged, autoClose, hasSelection, enabled);
}
