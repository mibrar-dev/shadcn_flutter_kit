// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuItem defines a reusable type for this registry module.
abstract class MenuItem extends Widget {
  /// Creates a menu item.
  const MenuItem({super.key});

  /// Whether this menu item has a leading widget (icon, checkbox indicator, etc.).
  bool get hasLeading;

  /// Optional popover controller for submenu functionality.
  PopoverController? get popoverController;
}

/// Radio button group container for menu items.
///
/// Groups multiple [MenuRadio] items together with shared selection state.
/// Only one radio button in the group can be selected at a time.
///
/// Example:
/// ```dart
/// MenuRadioGroup<String>(
///   value: selectedOption,
///   onChanged: (context, value) => setState(() => selectedOption = value),
///   children: [
///     MenuRadio(value: 'option1', child: Text('Option 1')),
///     MenuRadio(value: 'option2', child: Text('Option 2')),
///   ],
/// )
/// ```
