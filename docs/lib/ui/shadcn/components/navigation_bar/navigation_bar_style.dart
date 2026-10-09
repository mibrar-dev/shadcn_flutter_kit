// Registry-owned theme data for the `navigation_bar` component: the
// [NavigationBarTheme] container and the token-derived [navigationBarDefaults].
//
// The item slice (`NavigationItemStyle`), its defaults and the shared enums
// live in `primitives/navigation/navigation_theme.dart` (P4-B22, Q7); this
// file re-exports them so one import brings the whole component theme.
// User-owned overrides live in `navigation_bar_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../primitives/navigation/navigation_theme.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

export '../../primitives/navigation/navigation_theme.dart';

/// Container-level theme for the navigation bar family.
class NavigationBarTheme extends ComponentThemeData
    implements Mergeable<NavigationBarTheme> {
  /// Creates a navigation bar theme.
  const NavigationBarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.alignment,
    this.direction,
    this.spacing,
    this.labelType,
    this.labelPosition,
    this.labelSize,
    this.padding,
    this.itemStyle,
    this.activeItemStyle,
  });

  /// Container fill; null resolves the `background` token for bar/rail and
  /// draws nothing for sidebars.
  final ThemedColor? backgroundColor;

  /// Main-axis distribution of the bar.
  final MainAxisAlignment? alignment;

  /// Layout direction; null resolves from the container type.
  final Axis? direction;

  /// Space between items.
  final double? spacing;

  /// When labels are shown.
  final NavigationLabelType? labelType;

  /// Where labels sit relative to icons.
  final NavigationLabelPosition? labelPosition;

  /// Label text size.
  final NavigationLabelSize? labelSize;

  /// Container padding; null resolves 12x8.
  final EdgeInsetsGeometry? padding;

  /// Style of an unselected item.
  final NavigationItemStyle? itemStyle;

  /// Style of the selected item.
  final NavigationItemStyle? activeItemStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  NavigationBarTheme merge(NavigationBarTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return NavigationBarTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
      alignment: alignment ?? fallback.alignment,
      direction: direction ?? fallback.direction,
      spacing: spacing ?? fallback.spacing,
      labelType: labelType ?? fallback.labelType,
      labelPosition: labelPosition ?? fallback.labelPosition,
      labelSize: labelSize ?? fallback.labelSize,
      padding: padding ?? fallback.padding,
      itemStyle: itemStyle?.merge(fallback.itemStyle) ?? fallback.itemStyle,
      activeItemStyle:
          activeItemStyle?.merge(fallback.activeItemStyle) ??
          fallback.activeItemStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is NavigationBarTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.backgroundColor == backgroundColor &&
        other.alignment == alignment &&
        other.direction == direction &&
        other.spacing == spacing &&
        other.labelType == labelType &&
        other.labelPosition == labelPosition &&
        other.labelSize == labelSize &&
        other.padding == padding &&
        other.itemStyle == itemStyle &&
        other.activeItemStyle == activeItemStyle;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    Object.hash(themeDensity, themeSpacing, themeShadows),
    backgroundColor,
    alignment,
    direction,
    spacing,
    labelType,
    labelPosition,
    labelSize,
    padding,
    itemStyle,
    activeItemStyle,
  ]);
}

/// Token-derived baseline values; unset override fields fall through here.
const NavigationBarTheme navigationBarDefaults = NavigationBarTheme(
  spacing: 8,
  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  labelPosition: NavigationLabelPosition.bottom,
  labelSize: NavigationLabelSize.small,
  itemStyle: navigationItemDefaults,
  activeItemStyle: navigationActiveItemDefaults,
);
