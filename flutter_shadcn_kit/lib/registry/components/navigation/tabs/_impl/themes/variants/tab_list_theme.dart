// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../tabs.dart';

/// TabListTheme defines a reusable type for this registry module.
class TabListTheme extends ComponentThemeData {
  /// Color of the bottom border line separating tabs from content.
  ///
  /// Type: `Color?`. If null, uses the theme's border color. This creates
  /// visual separation between the tab bar and the content area.
  final Color? borderColor;

  /// Width of the bottom border line in logical pixels.
  ///
  /// Type: `double?`. If null, uses 1 logical pixel scaled by theme scaling.
  /// The border provides structure and visual hierarchy to the tab interface.
  final double? borderWidth;

  /// Color of the active tab indicator line.
  ///
  /// Type: `Color?`. If null, uses the theme's primary color. The indicator
  /// clearly shows which tab is currently active.
  final Color? indicatorColor;

  /// Height of the active tab indicator line in logical pixels.
  ///
  /// Type: `double?`. If null, uses 2 logical pixels scaled by theme scaling.
  /// The indicator appears at the bottom of the active tab.
  final double? indicatorHeight;

  /// Creates a [TabListTheme].
  ///
  /// All parameters are optional and allow customization of tab list appearance.
  ///
  /// Parameters:
  /// - [borderColor] (`Color?`, optional): Color of the tab list border.
  /// - [borderWidth] (`double?`, optional): Width of the tab list border.
  /// - [indicatorColor] (`Color?`, optional): Color of the active tab indicator.
  /// - [indicatorHeight] (`double?`, optional): Height of the active tab indicator.
  ///
  /// Example:
  /// ```dart
  /// const TabListTheme(
  ///   borderColor: Colors.grey,
  ///   borderWidth: 1.0,
  ///   indicatorColor: Colors.blue,
  ///   indicatorHeight: 2.0,
  /// )
  /// ```
  const TabListTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.borderColor,
    this.borderWidth,
    this.indicatorColor,
    this.indicatorHeight,
  });

  /// Creates a copy with specified fields replaced.
  ///
  /// Parameters:
  /// - [borderColor] (`ValueGetter<Color?>?`, optional): new border color getter
  /// - [borderWidth] (`ValueGetter<double?>?`, optional): new border width getter
  /// - [indicatorColor] (`ValueGetter<Color?>?`, optional): new indicator color getter
  /// - [indicatorHeight] (`ValueGetter<double?>?`, optional): new indicator height getter
  ///
  /// Returns: `TabListTheme` — new theme with updated values
  TabListTheme copyWith({
    ValueGetter<Color?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<Color?>? indicatorColor,
    ValueGetter<double?>? indicatorHeight,
  }) {
    return TabListTheme(
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      indicatorColor: indicatorColor == null
          ? this.indicatorColor
          : indicatorColor(),
      indicatorHeight: indicatorHeight == null
          ? this.indicatorHeight
          : indicatorHeight(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabListTheme &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.indicatorColor == indicatorColor &&
        other.indicatorHeight == indicatorHeight;
  }

  @override
  int get hashCode =>
      Object.hash(borderColor, borderWidth, indicatorColor, indicatorHeight);
}

/// A horizontal tab list widget for selecting between multiple tab content areas.
///
/// TabList provides a classic tab interface with a horizontal row of tab buttons
/// and an active tab indicator. It handles tab selection state and provides visual
/// feedback for the currently active tab through styling and an indicator line.
///
/// The widget automatically manages the appearance of tab buttons, applying
/// appropriate styling for active and inactive states. The active tab is
/// highlighted with foreground styling and an indicator line at the bottom.
///
/// Features:
/// - Horizontal row of selectable tab buttons
/// - Visual active tab indicator with customizable styling
/// - Automatic tab button state management (active/inactive)
/// - Theme-aware styling with customizable colors and dimensions
/// - Integration with TabContainer for coordinated tab management
///
/// The TabList works as part of a complete tab system, typically used with
/// corresponding content areas that show/hide based on the selected tab.
///
/// Example:
/// ```dart
/// TabList(
///   index: currentTabIndex,
///   onChanged: (index) => setState(() => currentTabIndex = index),
///   children: [
///     TabChild(child: Text('Tab 1')),
///     TabChild(child: Text('Tab 2')),
///     TabChild(child: Text('Tab 3')),
///   ],
/// )
/// ```
