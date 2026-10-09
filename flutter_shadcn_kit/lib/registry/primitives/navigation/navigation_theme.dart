// Navigation value types shared by the `navigation_bar` component and the
// navigation item widgets in `primitives/navigation`.
//
// Ported from `components/navigation/navigation_bar/_impl/core/*` and
// `_impl/themes/base/navigation_bar_theme.dart`. The enums and the item style
// slice live here (P4-B22, Q7) because the item widgets are layer-2 machinery;
// the container-level `NavigationBarTheme` stays in the component.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';

/// Which navigation container to render.
enum NavigationContainerType {
  /// Horizontal bar (top/bottom navigation).
  bar,

  /// Vertical compact rail (side navigation).
  rail,

  /// Vertical sidebar with room for labels.
  sidebar,
}

/// When navigation labels are shown.
enum NavigationLabelType {
  /// Never.
  none,

  /// Only on the selected item.
  selected,

  /// Always.
  all,

  /// As a tooltip on hover.
  tooltip,

  /// Only while the container is expanded.
  expanded,
}

/// Label text size.
enum NavigationLabelSize {
  /// 12px.
  small,

  /// 14px.
  large,
}

/// How a label handles text that overflows its row.
enum NavigationOverflow {
  /// Clip.
  clip,

  /// Scroll the text horizontally.
  marquee,

  /// Ellipsis.
  ellipsis,

  /// Let it overflow.
  none,
}

/// Position of a navigation label relative to its icon.
enum NavigationLabelPosition {
  /// Before the icon (left in LTR).
  start,

  /// After the icon (right in LTR).
  end,

  /// Above the icon.
  top,

  /// Below the icon.
  bottom,
}

/// One navigation item state's styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class NavigationItemStyle implements Mergeable<NavigationItemStyle> {
  /// Creates a navigation item style.
  const NavigationItemStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.minHeight,
    this.textStyle,
  });

  /// Per-state fill.
  final StateValue<ThemedColor>? background;

  /// Per-state content/label colour.
  final StateValue<ThemedColor>? foreground;

  /// Per-state border; null draws none.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Row padding; null falls back to the row default.
  final EdgeInsetsGeometry? padding;

  /// Content box minimum height; null falls back to 20 (h-9 with the default
  /// padding). Keeps rows 36 high even while the label is collapsed.
  final double? minHeight;

  /// Label style; its colour is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  NavigationItemStyle merge(NavigationItemStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return NavigationItemStyle(
      background: background?.merge(fallback.background) ?? fallback.background,
      foreground: foreground?.merge(fallback.foreground) ?? fallback.foreground,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      padding: padding ?? fallback.padding,
      minHeight: minHeight ?? fallback.minHeight,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is NavigationItemStyle &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.padding == padding &&
        other.minHeight == minHeight &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(
    background,
    foreground,
    borderColor,
    borderWidth,
    padding,
    minHeight,
    textStyle,
  );
}

/// Token-derived unselected item row.
const NavigationItemStyle navigationItemDefaults = NavigationItemStyle(
  background: StateValue(
    rest: ThemedColor.ref(ColorRef.muted, alpha: 0),
    hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
    pressed: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
    focused: ThemedColor.ref(ColorRef.muted, alpha: 0.4),
  ),
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  minHeight: 20,
  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
);

/// Token-derived selected item row.
const NavigationItemStyle navigationActiveItemDefaults = NavigationItemStyle(
  background: StateValue(
    rest: ThemedColor.ref(ColorRef.secondary),
    hovered: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
    pressed: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
  ),
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.secondaryForeground)),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  minHeight: 20,
  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
);
