// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../tabs.dart';

/// TabPaneTheme defines a reusable type for this registry module.
class TabPaneTheme extends ComponentThemeData {
  /// Border radius for the tab pane container and individual tabs.
  ///
  /// Type: `BorderRadiusGeometry?`. If null, uses the theme's large border radius.
  /// This affects both the main content area and the tab button appearance.
  final BorderRadiusGeometry? borderRadius;

  /// Background color for the tab pane content area and active tabs.
  ///
  /// Type: `Color?`. If null, uses the theme's card color. This provides
  /// the background for both the main content area and highlighted tabs.
  final Color? backgroundColor;

  /// Border styling for the tab pane container.
  ///
  /// Type: `BorderSide?`. If null, uses the theme's default border. This
  /// creates the outline around the entire tab pane component.
  final BorderSide? border;

  /// Height of the tab bar area in logical pixels.
  ///
  /// Type: `double?`. If null, uses 32 logical pixels scaled by theme scaling.
  /// This determines the vertical space allocated for the tab buttons.
  final double? barHeight;

  /// Creates a [TabPaneTheme].
  ///
  /// All parameters are optional and allow customization of tab pane appearance.
  ///
  /// Parameters:
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): Border radius for the tab pane container.
  /// - [backgroundColor] (`Color?`, optional): Background color of the tab pane.
  /// - [border] (`BorderSide?`, optional): Border styling for the tab pane.
  /// - [barHeight] (`double?`, optional): Height of the tab bar area.
  ///
  /// Example:
  /// ```dart
  /// const TabPaneTheme(
  ///   borderRadius: BorderRadius.circular(8),
  ///   backgroundColor: Colors.white,
  ///   border: BorderSide(color: Colors.grey),
  ///   barHeight: 32.0,
  /// )
  /// ```
  const TabPaneTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.barHeight,
  });

  /// Creates a copy with specified fields replaced.
  ///
  /// Parameters:
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry?>?`, optional): new border radius getter
  /// - [backgroundColor] (`ValueGetter<Color?>?`, optional): new background color getter
  /// - [border] (`ValueGetter<BorderSide?>?`, optional): new border getter
  /// - [barHeight] (`ValueGetter<double?>?`, optional): new bar height getter
  ///
  /// Returns: `TabPaneTheme` — new theme with updated values
  TabPaneTheme copyWith({
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<BorderSide?>? border,
    ValueGetter<double?>? barHeight,
  }) {
    return TabPaneTheme(
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      border: border == null ? this.border : border(),
      barHeight: barHeight == null ? this.barHeight : barHeight(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabPaneTheme &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.border == border &&
        other.barHeight == barHeight;
  }

  @override
  int get hashCode =>
      Object.hash(borderRadius, backgroundColor, border, barHeight);
}

/// Data wrapper for tab pane items that extends sortable functionality.
///
/// TabPaneData extends SortableData to provide drag-and-drop reordering
/// capabilities for tab pane items. Each tab item is wrapped in this data
/// structure to enable sorting operations.
///
/// Example:
/// ```dart
/// TabPaneData<String>('tab_content')
/// TabPaneData<TabInfo>(TabInfo(title: 'Tab 1', content: widget))
/// ```
