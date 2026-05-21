// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../dropdown_menu.dart';

/// DropdownMenuTheme defines a reusable type for this registry module.
class DropdownMenuTheme extends ComponentThemeData {
  /// Surface opacity for the popup container.
  final double? surfaceOpacity;

  /// Surface blur for the popup container.
  final double? surfaceBlur;

  /// Creates a [DropdownMenuTheme].
  const DropdownMenuTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.surfaceOpacity,
    this.surfaceBlur,
  });

  /// Returns a copy of this theme with the given fields replaced.
  DropdownMenuTheme copyWith({
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
  }) {
    return DropdownMenuTheme(
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownMenuTheme &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur;
  }

  @override
  int get hashCode => Object.hash(surfaceOpacity, surfaceBlur);
}

/// A dropdown menu widget that displays a list of menu items in a popup.
///
/// Provides a styled dropdown menu with vertical layout, automatic sizing,
/// and theme integration. Wraps menu items in a [MenuPopup] container with
/// appropriate padding and spacing for dropdown contexts.
///
/// Features:
/// - **Vertical Layout**: Displays menu items in a column
/// - **Auto-sizing**: Minimum width constraint of 192px
/// - **Surface Effects**: Configurable backdrop blur and opacity
/// - **Nested Menus**: Supports sub-menus with proper offset
/// - **Sheet Adaptation**: Adjusts padding for sheet overlay contexts
/// - **Auto-dismiss**: Closes when items are selected
///
/// Typically used with [showDropdown] function or as part of dropdown
/// button implementations. Menu items are provided as [MenuItem] widgets.
///
/// Example:
/// ```dart
/// DropdownMenu(
///   children: [
///     MenuItem(
///       title: Text('New File'),
///       leading: Icon(Icons.add),
///       onTap: () => createFile(),
///     ),
///     MenuItem(
///       title: Text('Open'),
///       trailing: Text('Ctrl+O'),
///       onTap: () => openFile(),
///     ),
///     MenuItem.divider(),
///     MenuItem(
///       title: Text('Exit'),
///       onTap: () => exit(),
///     ),
///   ],
/// )
/// ```
///
/// See also:
/// - [MenuItem] for individual menu items
/// - [MenuPopup] for the popup container
/// - [showDropdown] for displaying dropdowns programmatically
