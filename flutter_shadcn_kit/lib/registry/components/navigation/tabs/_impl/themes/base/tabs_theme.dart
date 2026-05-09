// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../tabs.dart';

/// TabsTheme defines a reusable type for this registry module.
class TabsTheme extends ComponentThemeData {
  /// Padding around the entire tabs container.
  ///
  /// Defines the outer spacing for the tabs widget. If `null`,
  /// uses the theme's default container padding.
  final EdgeInsetsGeometry? containerPadding;

  /// Padding inside individual tab headers.
  ///
  /// Defines the spacing within each tab button. If `null`,
  /// uses the theme's default tab padding.
  final EdgeInsetsGeometry? tabPadding;

  /// Background color for the tabs container.
  ///
  /// Applied to the tabs bar background. If `null`,
  /// uses the theme's default background color.
  final Color? backgroundColor;

  /// Corner radius for the tabs container.
  ///
  /// Defines rounded corners for the tabs widget. If `null`,
  /// uses the theme's default border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Creates a tabs theme.
  ///
  /// All parameters are optional and default to theme values when `null`.
  const TabsTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.containerPadding,
    this.tabPadding,
    this.backgroundColor,
    this.borderRadius,
  });

  /// Creates a copy of this theme with optionally replaced values.
  ///
  /// Uses [ValueGetter] functions to allow nullable value replacement.
  /// Properties not provided retain their current values.
  ///
  /// Parameters:
  /// - [containerPadding]: Optional getter for new container padding
  /// - [tabPadding]: Optional getter for new tab padding
  /// - [backgroundColor]: Optional getter for new background color
  /// - [borderRadius]: Optional getter for new border radius
  ///
  /// Returns a new [TabsTheme] with updated values.
  TabsTheme copyWith({
    ValueGetter<EdgeInsetsGeometry?>? containerPadding,
    ValueGetter<EdgeInsetsGeometry?>? tabPadding,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return TabsTheme(
      containerPadding: containerPadding == null
          ? this.containerPadding
          : containerPadding(),
      tabPadding: tabPadding == null ? this.tabPadding : tabPadding(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabsTheme &&
        other.containerPadding == containerPadding &&
        other.tabPadding == tabPadding &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      Object.hash(containerPadding, tabPadding, backgroundColor, borderRadius);
}

/// A tabbed interface widget for organizing content into switchable panels.
///
/// [Tabs] provides a clean and intuitive way to organize related content into
/// separate panels that users can switch between by tapping tab headers. It manages
/// the selection state and provides visual feedback for the active tab while
/// handling the display of corresponding content.
///
/// Key features:
/// - Tab-based content organization with header and panel areas
/// - Active tab highlighting with smooth transitions
/// - Customizable tab styling through theming
/// - Gesture-based tab switching with tap support
/// - Flexible content management through TabChild system
/// - Integration with the shadcn_flutter design system
/// - Responsive layout adaptation
/// - Keyboard navigation support
///
/// The widget works with [TabChild] elements that define both the tab header
/// and the associated content panel. Each tab can contain any widget content,
/// from simple text to complex layouts.
///
/// Tab organization:
/// - Headers: Displayed in a horizontal row for tab selection
/// - Content: The active tab's content is shown in the main area
/// - Selection: Visual indication of the currently active tab
/// - Transitions: Smooth animations between tab switches
///
/// Example:
/// ```dart
/// Tabs(
///   index: currentTabIndex,
///   onChanged: (index) => setState(() => currentTabIndex = index),
///   children: [
///     TabChild(
///       tab: Text('Overview'),
///       child: Center(child: Text('Overview content')),
///     ),
///     TabChild(
///       tab: Text('Details'),
///       child: Center(child: Text('Details content')),
///     ),
///     TabChild(
///       tab: Text('Settings'),
///       child: Center(child: Text('Settings content')),
///     ),
///   ],
/// );
/// ```
