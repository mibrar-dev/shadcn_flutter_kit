// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/icons/radix_icons.dart';
import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/primitives/icon_extensions.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/util.dart';
import '../../layout/basic/basic.dart';
import '../../control/button/button.dart';
import '../../layout/outlined_container/outlined_container.dart';
import '../../overlay/popover/popover.dart';
import '../../display/text/text.dart';
part '_impl/state/navigation_menu_state.dart';
part '_impl/core/navigation_menu_2.dart';
part '_impl/core/navigation_menu_content_list.dart';
part '_impl/core/navigation_menu_content.dart';
part '_impl/state/navigation_menu_item_state.dart';
part '_impl/core/navigation_menu_item.dart';

/// Theme configuration for [NavigationMenu] components.
///
/// Defines visual properties for navigation menu popovers including
/// surface appearance, positioning, and spacing. This theme controls
/// how navigation menu content is displayed when triggered.
///
/// The theme can be applied through [ComponentTheme] or passed directly
/// to individual [NavigationMenu] widgets for customization.
class NavigationMenuTheme extends ComponentThemeData {
  /// Opacity of the popover surface.
  final double? surfaceOpacity;

  /// Blur amount of the popover surface.
  final double? surfaceBlur;

  /// Margin applied to the popover.
  final EdgeInsetsGeometry? margin;

  /// Offset for the popover relative to the trigger.
  final Offset? offset;

  /// Creates a [NavigationMenuTheme] with the specified appearance properties.
  ///
  /// All parameters are optional and will fall back to default values
  /// when not provided. This allows for partial customization while
  /// maintaining consistent defaults.
  ///
  /// Parameters:
  /// - [surfaceOpacity] (double?, optional): Opacity level for popover background
  /// - [surfaceBlur] (double?, optional): Blur effect intensity for popover
  /// - [margin] (EdgeInsetsGeometry?, optional): Space around the popover
  /// - [offset] (Offset?, optional): Position offset relative to trigger
  ///
  /// Example:
  /// ```dart
  /// NavigationMenuTheme(
  ///   surfaceOpacity: 0.9,
  ///   surfaceBlur: 8.0,
  ///   margin: EdgeInsets.all(16.0),
  ///   offset: Offset(0, 8),
  /// )
  /// ```
  const NavigationMenuTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.margin,
    this.offset,
  });

  /// Returns a copy of this theme with the given fields replaced.
  NavigationMenuTheme copyWith({
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<EdgeInsetsGeometry?>? margin,
    ValueGetter<Offset?>? offset,
  }) {
    return NavigationMenuTheme(
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      margin: margin == null ? this.margin : margin(),
      offset: offset == null ? this.offset : offset(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationMenuTheme &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.margin == margin &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(surfaceOpacity, surfaceBlur, margin, offset);
}

/// An individual menu item within a [NavigationMenu].
///
/// Represents a single interactive element in a navigation menu structure.
/// Each item can function as either a standalone action button or a trigger
/// for displaying additional content in a popover. When content is provided,
/// the item shows a chevron indicator and triggers the popover on interaction.
///
/// The item automatically integrates with its parent [NavigationMenu] to
/// manage popover state, hover interactions, and visual feedback. Items
/// with content become active when hovered or clicked, displaying their
/// associated content in the navigation menu's popover.
///
/// Example:
/// ```dart
/// NavigationMenuItem(
///   onPressed: () => print('Item pressed'),
///   content: NavigationMenuContent(
///     title: Text('Products'),
///     content: Text('Browse our product catalog'),
///   ),
///   child: Text('Products'),
/// )
/// ```

/// State class for [NavigationMenuItem] widget.
///
/// Manages the lifecycle and interaction of a single navigation menu item.

/// A content item displayed within a navigation menu popover.
///
/// Provides a structured layout for navigation menu content with support
/// for titles, descriptions, leading/trailing widgets, and interactive behavior.
/// This widget is designed to be used within [NavigationMenuItem] content
/// to create rich, informative menu options.
///
/// The content displays as a button with optional leading icon, title text,
/// descriptive content, and trailing elements. When pressed, it can trigger
/// custom actions while maintaining the navigation menu's visual consistency.
///
/// Example:
/// ```dart
/// NavigationMenuContent(
///   leading: Icon(Icons.dashboard),
///   title: Text('Dashboard'),
///   content: Text('View project analytics and metrics'),
///   onPressed: () => Navigator.pushNamed(context, '/dashboard'),
/// )
/// ```

/// A grid layout container for organizing navigation menu content items.
///
/// Provides flexible grid-based layout for multiple [NavigationMenuContent]
/// items within a navigation menu popover. The layout arranges items in
/// columns and rows with customizable spacing and supports responsive
/// organization of navigation options.
///
/// The grid layout adapts to the number of items and specified column count,
/// creating a structured presentation for complex navigation menus with
/// multiple categories or sections of content.
///
/// Example:
/// ```dart
/// NavigationMenuContentList(
///   crossAxisCount: 2,
///   spacing: 16.0,
///   runSpacing: 12.0,
///   children: [
///     NavigationMenuContent(title: Text('Dashboard'), onPressed: _openDashboard),
///     NavigationMenuContent(title: Text('Analytics'), onPressed: _openAnalytics),
///     NavigationMenuContent(title: Text('Settings'), onPressed: _openSettings),
///   ],
/// )
/// ```

/// A horizontal navigation menu with dropdown content support.
///
/// Provides a sophisticated navigation component that displays menu items
/// in a horizontal layout with support for dropdown content. When menu items
/// have associated content, hovering or clicking reveals a popover with
/// additional navigation options or information.
///
/// The navigation menu manages popover state, hover interactions, and smooth
/// transitions between different content sections. It supports both simple
/// action items and complex content-rich dropdown menus with animated
/// transitions and responsive behavior.
///
/// The menu uses a popover overlay to display content, which automatically
/// positions itself relative to the trigger and handles edge cases for
/// viewport constraints and user interactions.
///
/// Example:
/// ```dart
/// NavigationMenu(
///   surfaceOpacity: 0.95,
///   surfaceBlur: 8.0,
///   children: [
///     NavigationMenuItem(
///       child: Text('Products'),
///       content: NavigationMenuContentList(
///         children: [
///           NavigationMenuContent(title: Text('Web Apps')),
///           NavigationMenuContent(title: Text('Mobile Apps')),
///         ],
///       ),
///     ),
///     NavigationMenuItem(
///       child: Text('About'),
///       onPressed: () => Navigator.pushNamed(context, '/about'),
///     ),
///   ],
/// )
/// ```

/// State class for [NavigationMenu] managing menu interactions and timing.
///
/// Handles hover debouncing, popover control, active menu item tracking,
/// and content builder management for navigation menu items.
