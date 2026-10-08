// Registry-owned theme data for the `badge` component: the state-aware
// [BadgeStyle] slice, the per-variant [BadgeTheme] container and the
// token-derived `badgeDefaults` rows.
//
// Variants are data (one enum + one exhaustive switch), so the four old
// per-variant wrapper classes collapse into `Badge(variant: ...)`. User-owned
// overrides live in `badge_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual variants of the badge component (shadcn `default | secondary |
/// destructive | outline`).
enum BadgeVariant { primary, secondary, outline, destructive }

/// Fallback text style before the [BadgeTheme.textStyle] row narrows it.
///
/// shadcn `text-xs`: 12px on a 16px (`1rem`) line, i.e. height 4/3, so the
/// badge measures 16 + py-0.5 (4) = 20 borderless, 22 with the 1px border
/// (shadcn `h` ≈ 22 border-box).
const TextStyle badgeDefaultTextStyle = TextStyle(fontSize: 12, height: 4 / 3);

/// One variant's state-aware styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining states/fields. Unlike the old
/// `Styleable<BadgeTheme>` bags, a leg no longer replaces a whole property:
/// `StateValue.merge` fills the states it leaves unset, so an override that
/// only sets `hovered` keeps the default `rest` colour.
class BadgeStyle implements Mergeable<BadgeStyle> {
  /// Creates a badge style slice.
  const BadgeStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.textStyle,
    this.iconSize,
  });

  /// Per-state fill of the badge surface.
  final StateValue<ThemedColor>? background;

  /// Per-state label/icon color.
  final StateValue<ThemedColor>? foreground;

  /// Per-state border color; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Padding override; null falls back to the size table.
  final EdgeInsetsGeometry? padding;

  /// Text style override; its color is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// Icon size override; null resolves 12 logical pixels at build.
  final double? iconSize;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  BadgeStyle merge(BadgeStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return BadgeStyle(
      background: background?.merge(fallback.background) ?? fallback.background,
      foreground: foreground?.merge(fallback.foreground) ?? fallback.foreground,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      padding: padding ?? fallback.padding,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      iconSize: iconSize ?? fallback.iconSize,
    );
  }

  /// State scales are stepped at t < 0.5; dimensions are lerped.
  static BadgeStyle lerp(BadgeStyle a, BadgeStyle b, double t) {
    return BadgeStyle(
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      iconSize: lerpDouble(a.iconSize, b.iconSize, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BadgeStyle &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.iconSize == iconSize;
  }

  @override
  int get hashCode => Object.hash(
    background,
    foreground,
    borderColor,
    borderWidth,
    padding,
    textStyle,
    iconSize,
  );
}

/// Per-variant theme container for the badge component.
class BadgeTheme extends ComponentThemeData implements Mergeable<BadgeTheme> {
  /// Creates a badge theme with one nullable slice per variant.
  const BadgeTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.primary,
    this.secondary,
    this.outline,
    this.destructive,
    this.textStyle,
  });

  /// Style for [BadgeVariant.primary].
  final BadgeStyle? primary;

  /// Style for [BadgeVariant.secondary].
  final BadgeStyle? secondary;

  /// Style for [BadgeVariant.outline].
  final BadgeStyle? outline;

  /// Style for [BadgeVariant.destructive].
  final BadgeStyle? destructive;

  /// Text style shared by every variant; a variant row wins over it.
  final TextStyle? textStyle;

  /// The slice for [variant], or null when this leg leaves it unset.
  BadgeStyle? forVariant(BadgeVariant variant) {
    return switch (variant) {
      BadgeVariant.primary => primary,
      BadgeVariant.secondary => secondary,
      BadgeVariant.outline => outline,
      BadgeVariant.destructive => destructive,
    };
  }

  /// Returns a copy with the given fields replaced.
  BadgeTheme copyWith({
    ValueGetter<BadgeStyle?>? primary,
    ValueGetter<BadgeStyle?>? secondary,
    ValueGetter<BadgeStyle?>? outline,
    ValueGetter<BadgeStyle?>? destructive,
    ValueGetter<TextStyle?>? textStyle,
  }) {
    return BadgeTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      primary: primary == null ? this.primary : primary(),
      secondary: secondary == null ? this.secondary : secondary(),
      outline: outline == null ? this.outline : outline(),
      destructive: destructive == null ? this.destructive : destructive(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  BadgeTheme merge(BadgeTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return BadgeTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      primary: primary?.merge(fallback.primary) ?? fallback.primary,
      secondary: secondary?.merge(fallback.secondary) ?? fallback.secondary,
      outline: outline?.merge(fallback.outline) ?? fallback.outline,
      destructive:
          destructive?.merge(fallback.destructive) ?? fallback.destructive,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static BadgeTheme lerp(BadgeTheme a, BadgeTheme b, double t) {
    BadgeStyle? row(BadgeStyle? x, BadgeStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return BadgeStyle.lerp(x, y, t);
    }

    return BadgeTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      primary: row(a.primary, b.primary),
      secondary: row(a.secondary, b.secondary),
      outline: row(a.outline, b.outline),
      destructive: row(a.destructive, b.destructive),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BadgeTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.outline == outline &&
        other.destructive == destructive &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    primary,
    secondary,
    outline,
    destructive,
    textStyle,
  );
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// shadcn badge: `rounded-md border px-2 py-0.5 text-xs font-medium w-fit`. The
// border is transparent unless a variant paints one. Disabled states are
// intentionally absent: `StateValue` falls back to `rest` and `Badge` dims the
// whole control to 50% opacity. Pressed duplicates hovered because
// `StateValue.resolve` never falls back from one state to another.
// ---------------------------------------------------------------------------

/// Default badge padding: shadcn `px-2 py-0.5`, density-scaled.
const EdgeInsetsGeometry badgeDefaultPadding = EdgeInsets.symmetric(
  horizontal: 8,
  vertical: 2,
);

const _badgePrimaryBg = StateValue(
  rest: ThemedColor.ref(ColorRef.primary),
  hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
);
const _badgePrimaryRow = BadgeStyle(
  background: _badgePrimaryBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.primaryForeground)),
  padding: badgeDefaultPadding,
  textStyle: badgeDefaultTextStyle,
);

const _badgeSecondaryBg = StateValue(
  rest: ThemedColor.ref(ColorRef.secondary),
  hovered: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
  pressed: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
);
const _badgeSecondaryRow = BadgeStyle(
  background: _badgeSecondaryBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.secondaryForeground)),
  padding: badgeDefaultPadding,
  textStyle: badgeDefaultTextStyle,
);

const _badgeOutlineRow = BadgeStyle(
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  borderColor: StateValue(rest: ThemedColor.ref(ColorRef.border)),
  borderWidth: 1,
  padding: badgeDefaultPadding,
  textStyle: badgeDefaultTextStyle,
);

const _badgeDestructiveBg = StateValue(
  rest: ThemedColor.ref(ColorRef.destructive),
  hovered: ThemedColor.ref(ColorRef.destructive, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.destructive, alpha: 0.9),
);
const _badgeDestructiveRow = BadgeStyle(
  background: _badgeDestructiveBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.destructiveForeground)),
  padding: badgeDefaultPadding,
  textStyle: badgeDefaultTextStyle,
);

/// Token-derived baseline rows; every unset override field falls through here.
const BadgeTheme badgeDefaults = BadgeTheme(
  primary: _badgePrimaryRow,
  secondary: _badgeSecondaryRow,
  outline: _badgeOutlineRow,
  destructive: _badgeDestructiveRow,
  textStyle: badgeDefaultTextStyle,
);
