// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme, ThemeData;

import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/style_value.dart';
import '../../../../../components/control/button/button.dart';
import '../../../tab_container/tab_container.dart';
part '../styles/_tab_list_text_style.dart';
part 'tab_list_2.dart';

/// Theme configuration for [TabList] appearance and behavior.
///
/// TabListTheme defines the visual styling for tab list components including
/// border colors, indicator styling, and dimensional properties. All properties
/// are optional and fall back to theme defaults when not specified.
///
/// Example:
/// ```dart
/// ComponentTheme<TabListTheme>(
///   data: TabListTheme(
///     borderColor: Colors.grey,
///     borderWidth: 2.0,
///     indicatorColor: Colors.blue,
///     indicatorHeight: 3.0,
///   ),
///   child: TabList(...),
/// )
/// ```
class TabListTheme extends ComponentThemeData {
  /// Color of the bottom border line separating tabs from content.
  final Color? borderColor;

  /// Width of the bottom border line in logical pixels.
  final double? borderWidth;

  /// Color of the active tab indicator line.
  final Color? indicatorColor;

  /// Height of the active tab indicator line in logical pixels.
  final double? indicatorHeight;

  /// Creates a [TabListTheme].
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
/// highlighted with foreground styling and the indicator line at the bottom.
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

/// Extension helpers used by this registry module.
extension _TabListTextStyles on Widget {
  /// Executes `muted` behavior for this component/composite.
  Widget muted() {
    return _TabListTextStyle(
      child: this,
      styleBuilder: (theme) =>
          /// Creates a `TextStyle` instance.
          TextStyle(color: theme.colorScheme.mutedForeground),
    );
  }

  /// Executes `foreground` behavior for this component/composite.
  Widget foreground() {
    return _TabListTextStyle(
      child: this,
      styleBuilder: (theme) => TextStyle(color: theme.colorScheme.foreground),
    );
  }
}
