// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart' hide Theme, ThemeData;

import '../../../shared/primitives/fade_scroll.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/geometry_extensions.dart';
import '../../../shared/utils/util.dart';
import '../../layout/outlined_container/outlined_container.dart';
import '../../layout/sortable/sortable.dart';
import '../tab_container/tab_container.dart';
part '_impl/core/_clip_rect_with_adjustment.dart';
part '_impl/core/_tab_item_painter.dart';
part '_impl/state/tab_pane_state.dart';
part '_impl/core/_tab_ghost_data.dart';
part '_impl/core/tab_pane_2.dart';
part '_impl/core/tab_pane_data.dart';

/// Theme configuration for [TabPane] appearance and layout.
///
/// TabPaneTheme defines the visual styling for tab pane components including
/// borders, background colors, dimensions, and corner rounding. All properties
/// are optional and fall back to theme defaults when not specified.
///
/// Example:
/// ```dart
/// ComponentTheme<TabPaneTheme>(
///   data: TabPaneTheme(
///     borderRadius: BorderRadius.circular(12),
///     backgroundColor: Colors.white,
///     border: BorderSide(color: Colors.grey),
///     barHeight: 40.0,
///   ),
///   child: TabPane(...),
/// )
/// ```
class TabPaneTheme extends ComponentThemeData {
  /// Border radius for the tab pane container and individual tabs.
  final BorderRadiusGeometry? borderRadius;

  /// Background color for the tab pane content area and active tabs.
  final Color? backgroundColor;

  /// Border styling for the tab pane container.
  final BorderSide? border;

  /// Height of the tab bar area in logical pixels.
  final double? barHeight;

  /// Creates a [TabPaneTheme].
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

/// Builder function for creating tab child widgets from tab pane data.
///
/// Takes the build context, tab data, and index to create a TabChild widget
/// that represents the visual appearance of each tab button.
///
/// Parameters:
/// - [context] (BuildContext): Build context for theme access
/// - [item] (`TabPaneData<T>`): The data for this specific tab
/// - [index] (int): Zero-based index of this tab in the list
///
/// Returns: A [TabChild] widget for the tab button
typedef TabPaneItemBuilder<T> =
    TabChild Function(BuildContext context, TabPaneData<T> item, int index);

/// A comprehensive tab pane widget with sortable tabs and integrated content display.
///
/// TabPane provides a complete tab interface that combines a sortable tab bar with
/// a content display area. It supports drag-and-drop reordering of tabs, scrollable
/// tab overflow, and customizable leading/trailing elements in the tab bar.
///
/// The widget manages both the tab selection state and the tab ordering, providing
/// callbacks for both focus changes and sort operations. The tab bar is horizontally
/// scrollable when tabs exceed the available width, with fade effects at the edges.
///
/// Features:
/// - Drag-and-drop sortable tabs with visual feedback
/// - Horizontal scrolling with edge fade effects for tab overflow
/// - Integrated content area with customizable styling
/// - Leading and trailing widget support in the tab bar
/// - Custom tab rendering through builder patterns
/// - Comprehensive theming and styling options
/// - Automatic focus management during sorting operations
///
/// The content area is styled as a card-like container that appears above the
/// tab bar, creating a cohesive tabbed interface suitable for complex applications.
///
/// Example:
/// ```dart
/// TabPane<String>(
///   items: [
///     TabPaneData('tab1'),
///     TabPaneData('tab2'),
///     TabPaneData('tab3'),
///   ],
///   focused: currentTab,
///   onFocused: (index) => setState(() => currentTab = index),
///   onSort: (newOrder) => setState(() => tabOrder = newOrder),
///   itemBuilder: (context, item, index) => TabChild(
///     child: Text(item.data),
///   ),
///   child: IndexedStack(
///     index: currentTab,
///     children: tabContent,
///   ),
/// )
/// ```

/// State class for [TabPane] widget.
///
/// Manages the scrolling and rendering of tab pane content.
