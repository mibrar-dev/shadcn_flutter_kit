// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart'
    hide Theme, ThemeData, TextField, ButtonStyle, Tooltip;
import 'package:gap/gap.dart';

import '../../control/button/button.dart';
import '../../layout/hidden/hidden.dart';
import '../../layout/overflow_marquee/overflow_marquee.dart';
import '../../overlay/tooltip/tooltip.dart';
import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/primitives/outlined_container.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/platform_utils.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/util.dart';
part '_impl/core/navigation_widget.dart';
part '_impl/core/_navigation_label_background_painter.dart';
part '_impl/utils/_navigation_label_delegate.dart';
part '_impl/core/_navigation_child_overflow_handle.dart';
part '_impl/themes/base/navigation_bar_theme.dart';
part '_impl/core/navigation_label.dart';
part '_impl/core/navigation_padding.dart';
part '_impl/core/_navigation_labeled.dart';
part '_impl/state/_navigation_button_state.dart';
part '_impl/core/navigation_bar_item.dart';
part '_impl/core/abstract_navigation_button.dart';
part '_impl/state/_abstract_navigation_button_state.dart';
part '_impl/core/navigation_button.dart';
part '_impl/state/_navigation_item_state.dart';
part '_impl/core/navigation_item.dart';
part '_impl/core/navigation_divider.dart';
part '_impl/core/navigation_gap.dart';
part '_impl/core/navigation_control_data.dart';
part '_impl/core/navigation_child_control_data.dart';
part '_impl/state/_navigation_sidebar_state.dart';
part '_impl/core/navigation_sidebar.dart';
part '_impl/state/_navigation_rail_state.dart';
part '_impl/core/navigation_rail.dart';
part '_impl/state/_navigation_bar_state.dart';
part '_impl/core/navigation_bar_2.dart';

/// Enumeration defining alignment options for navigation bar items.
///
/// This enum provides various alignment strategies for positioning navigation
/// items within the available space, corresponding to Flutter's MainAxisAlignment
/// options but specifically tailored for navigation contexts.
enum NavigationBarAlignment {
  /// Align items to the start of the navigation bar.
  start(MainAxisAlignment.start),

  /// Center items within the navigation bar.
  center(MainAxisAlignment.center),

  /// Align items to the end of the navigation bar.
  end(MainAxisAlignment.end),

  /// Distribute items with space between them.
  spaceBetween(MainAxisAlignment.spaceBetween),

  /// Distribute items with space around them.
  spaceAround(MainAxisAlignment.spaceAround),

  /// Distribute items with equal space between and around them.
  spaceEvenly(MainAxisAlignment.spaceEvenly);

  /// The corresponding MainAxisAlignment value.
  final MainAxisAlignment mainAxisAlignment;

  /// Creates a NavigationBarAlignment with the associated MainAxisAlignment.
  const NavigationBarAlignment(this.mainAxisAlignment);
}

/// NavigationRailAlignment enumerates fixed values used by this implementation.
enum NavigationRailAlignment {
  /// Align items to the start (top) of the rail.
  start,

  /// Center items within the rail.
  center,

  /// Align items to the end (bottom) of the rail.
  end,
}

/// Enumeration defining the type of navigation container.
enum NavigationContainerType {
  /// Vertical rail navigation, typically positioned at the side.
  rail,

  /// Horizontal bar navigation, typically positioned at the top or bottom.
  bar,

  /// Expandable sidebar navigation with more space for content.
  sidebar,
}

/// A flexible navigation container widget for organizing navigation items.
///
/// [NavigationBar] provides a comprehensive navigation solution that can be configured
/// for various layouts including horizontal bars, vertical rails, and expandable sidebars.
/// It manages navigation item presentation, selection states, and provides extensive
/// customization options for different navigation patterns.
///
/// Key features:
/// - Flexible layout orientation (horizontal/vertical)
/// - Multiple alignment strategies for item positioning
/// - Configurable label presentation and positioning
/// - Selection state management with callbacks
/// - Surface effects for glassmorphism styling
/// - Responsive behavior with expansion options
/// - Theme integration for consistent styling
/// - Support for gaps, dividers, and custom widgets
///
/// Navigation layout modes:
/// - Bar mode: Horizontal layout for top/bottom navigation
/// - Rail mode: Vertical compact layout for side navigation
/// - Sidebar mode: Expanded vertical layout with more content space
///
/// Item organization features:
/// - Automatic selection state management
/// - Customizable spacing between items
/// - Support for navigation gaps and dividers
/// - Flexible item alignment options
/// - Label display controls (always, never, selected)
///
/// The widget supports various navigation patterns:
/// - Tab-style navigation with selection highlighting
/// - Menu-style navigation with hover states
/// - Hierarchical navigation with grouping
/// - Responsive navigation that adapts to screen size
///
/// Example:
/// ```dart
/// NavigationBar(
///   index: selectedIndex,
///   onSelected: (index) => setState(() => selectedIndex = index),
///   children: [
///     NavigationItem(
///       icon: Icon(Icons.home),
///       label: Text('Home'),
///       onPressed: () => _navigateToHome(),
///     ),
///     NavigationItem(
///       icon: Icon(Icons.search),
///       label: Text('Search'),
///       onPressed: () => _navigateToSearch(),
///     ),
///     NavigationDivider(),
///     NavigationItem(
///       icon: Icon(Icons.settings),
///       label: Text('Settings'),
///       onPressed: () => _navigateToSettings(),
///     ),
///   ],
/// );
/// ```
/// A flexible navigation container widget.
///
/// Provides a customizable navigation bar that can be configured for various
/// layouts including horizontal bars, vertical rails, and expandable sidebars.
/// Manages navigation item presentation and selection states.
///
/// Example:
/// ```dart
/// NavigationBar(
///   index: selectedIndex,
///   onSelected: (index) => setState(() => selectedIndex = index),
///   children: [
///     NavigationButton(child: Text('Home')),
///     NavigationButton(child: Text('Settings')),
///   ],
/// )
/// ```

/// Executes `_startPadding` behavior for this component/composite.
double _startPadding(EdgeInsets padding, Axis direction) {
  if (direction == Axis.vertical) {
    return padding.top;
  }
  return padding.left;
}

/// Executes `_endPadding` behavior for this component/composite.
double _endPadding(EdgeInsets padding, Axis direction) {
  if (direction == Axis.vertical) {
    return padding.bottom;
  }
  return padding.right;
}

/// A mixin for navigation containers that provides child wrapping functionality.
///
/// This mixin is used to enhance navigation containers with the ability to wrap
/// navigation items with necessary control data. It tracks item positions and
/// manages selectable state for proper navigation behavior.
mixin NavigationContainerMixin {
  /// Wraps navigation bar items with control data for selection tracking.
  ///
  /// Takes a list of [NavigationBarItem] children and wraps each with
  /// [NavigationChildControlData] that tracks the item's index and selection state.
  /// Only selectable items receive a selection index, while non-selectable items
  /// have a null selection index.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): Build context for inherited data.
  /// - [children] (`List<NavigationBarItem>`, required): Navigation items to wrap.
  ///
  /// Returns: `List<Widget>` — wrapped navigation items with control data.
  ///
  /// Example:
  /// ```dart
  /// final wrappedItems = wrapChildren(
  ///   context,
  ///   [
  ///     NavigationBarItem(icon: Icon(Icons.home), selectable: true),
  ///     NavigationBarItem(icon: Icon(Icons.settings), selectable: true),
  ///   ],
  /// );
  /// ```
  List<Widget> wrapChildren(
    BuildContext context,
    List<NavigationBarItem> children,
  ) {
    int index = 0;
    List<Widget> newChildren = List.of(children);
    for (var i = 0; i < children.length; i++) {
      if (children[i].selectable) {
        newChildren[i] = Data.inherit(
          data: NavigationChildControlData(index: index, actualIndex: i),
          child: children[i],
        );
        index++;
      } else {
        newChildren[i] = Data.inherit(
          data: NavigationChildControlData(index: null, actualIndex: i),
          child: children[i],
        );
      }
    }
    return newChildren;
  }
}

/// A vertical or horizontal navigation rail component for sidebar navigation.
///
/// Provides a compact navigation interface typically used in sidebar layouts
/// or as a secondary navigation element. The rail displays navigation items
/// in a linear arrangement with configurable alignment, spacing, and label
/// presentation. Items can show icons, labels, or both based on configuration.
///
/// The rail supports both vertical and horizontal orientations, making it
/// suitable for various layout contexts including left/right sidebars,
/// top/bottom navigation bars, or embedded navigation within content areas.
/// Label presentation can be customized to show always, on selection, or never.
///
/// Integrates with the navigation theming system and supports background
/// customization, surface effects, and responsive sizing based on content
/// and constraints.
///
/// Example:
/// ```dart
/// NavigationRail(
///   direction: Axis.vertical,
///   alignment: NavigationRailAlignment.start,
///   labelType: NavigationLabelType.all,
///   index: selectedIndex,
///   onSelected: (index) => setState(() => selectedIndex = index),
///   children: [
///     NavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
///     NavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
///     NavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
///   ],
/// )
/// ```

/// A full-width navigation sidebar component for comprehensive navigation.
///
/// Provides an expanded navigation interface designed for sidebar layouts
/// with full-width items and extensive labeling support. Unlike [NavigationRail],
/// the sidebar is optimized for detailed navigation with prominent labels,
/// descriptions, and expanded interactive areas.
///
/// The sidebar always displays labels and typically occupies a dedicated
/// sidebar area in layouts. Items are arranged vertically with generous
/// spacing and padding to create a comfortable navigation experience.
/// Supports badges, icons, and detailed labeling for complex navigation hierarchies.
///
/// Integrates with responsive layout systems and can be combined with
/// collapsible containers or drawer systems for adaptive navigation
/// experiences across different screen sizes and device types.
///
/// Example:
/// ```dart
/// NavigationSidebar(
///   backgroundColor: Colors.grey.shade50,
///   labelType: NavigationLabelType.all,
///   index: currentPageIndex,
///   onSelected: (index) => _navigateToPage(index),
///   children: [
///     NavigationBarItem(
///       icon: Icon(Icons.dashboard),
///       label: 'Dashboard',
///       badge: Badge(child: Text('New')),
///     ),
///     NavigationBarItem(
///       icon: Icon(Icons.analytics),
///       label: 'Analytics',
///     ),
///     NavigationBarItem(
///       icon: Icon(Icons.settings),
///       label: 'Settings',
///     ),
///   ],
/// )
/// ```

/// Determines when labels are shown in navigation items.
enum NavigationLabelType {
  /// No labels displayed.
  none,

  /// Labels shown only for selected items.
  selected,

  /// Labels always shown for all items.
  all,

  /// Labels shown as tooltips on hover.
  tooltip,

  /// Labels shown when navigation is expanded.
  expanded,
}

/// Position of navigation item labels relative to icons.
enum NavigationLabelPosition {
  /// Label before icon (left in LTR, right in RTL)
  start,

  /// Label after icon (right in LTR, left in RTL)
  end,

  /// Label above icon
  top,

  /// Label below icon
  bottom,
}

/// Size variant for navigation item labels.
enum NavigationLabelSize {
  /// Compact label text
  small,

  /// Larger label text
  large,
}

/// Data class tracking navigation child position and selection state.
///
/// Associates a navigation item with its logical index (for selection)
/// and actual index (for layout position).

/// Data class containing navigation control configuration and state.
///
/// Manages layout, styling, and interaction settings for navigation
/// containers and their children. Used internally to coordinate
/// behavior across navigation items.

/// Spacing gap between navigation items.
///
/// Creates empty space in navigation bars or sidebars. Automatically
/// uses appropriate gap type based on container (Gap for boxes, SliverGap for slivers).

/// Visual divider between navigation items.
///
/// Renders a horizontal or vertical line separator in navigation bars.
/// Automatically adapts direction based on navigation orientation.

/// Selectable navigation item with selection state management.
///
/// Represents a clickable navigation item that can be selected. Supports
/// custom styling for selected/unselected states, labels, and icons.
///
/// Example:
/// ```dart
/// NavigationItem(
///   index: 0,
///   label: Text('Home'),
///   child: Icon(Icons.home),
///   selected: selectedIndex == 0,
///   onChanged: (selected) => setState(() => selectedIndex = 0),
/// )
/// ```

/// Non-selectable navigation button for actions.
///
/// Similar to [NavigationItem] but without selection state. Used for
/// action buttons in navigation (e.g., settings, logout) that trigger
/// callbacks rather than changing navigation state.
///
/// Example:
/// ```dart
/// NavigationButton(
///   label: Text('Settings'),
///   child: Icon(Icons.settings),
///   onPressed: () => _openSettings(),
/// )
/// ```

/// Internal widget that applies spacing between navigation items.
///
/// Automatically calculates and applies appropriate padding based on
/// navigation direction, item position, and parent spacing configuration.
/// Used internally by navigation components.

/// Overflow behavior for navigation item labels.
enum NavigationOverflow {
  /// Clip text that exceeds bounds
  clip,

  /// Scroll text horizontally when too long
  marquee,

  /// Show ellipsis (...) for overflow
  ellipsis,

  /// No overflow handling
  none,
}

/// Non-interactive label widget for navigation sections.
///
/// Displays text headers or section labels within navigation bars or sidebars.
/// Supports different overflow behaviors and can be configured as floating or
/// pinned when used in sidebars.
///
/// Example:
/// ```dart
/// NavigationLabel(
///   child: Text('Main Menu').semiBold(),
///   padding: EdgeInsets.all(8),
/// )
/// ```

/// Builder function for navigation widgets with selection state.
///
/// Parameters:
/// - [context] (BuildContext): Build context
/// - [selected] (bool): Whether this item is currently selected
///
/// Returns a widget that adapts to selection state.
typedef NavigationWidgetBuilder =
    Widget Function(BuildContext context, bool selected);

/// Custom widget wrapper for navigation items.
///
/// Allows inserting custom widgets into navigation containers with optional
/// selection tracking. Can be used with a static child or a builder that
/// responds to selection state.
///
/// Example:
/// ```dart
/// // Static widget
/// NavigationWidget(
///   index: 0,
///   child: CustomNavigationItem(),
/// )
///
/// // Builder with selection state
/// NavigationWidget.builder(
///   index: 1,
///   builder: (context, selected) => CustomItem(
///     highlighted: selected,
///   ),
/// )
/// ```
