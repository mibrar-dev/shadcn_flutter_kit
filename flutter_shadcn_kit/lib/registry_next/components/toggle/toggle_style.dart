// Registry-owned theme data for the `toggle` component: the state-aware
// [ToggleStyle] slice, the on/off [ToggleTheme] container and the
// token-derived `toggleDefaults` rows.
//
// Toggle is installable on its own, so the slice is defined here instead of
// importing the button component's style classes (components never import
// each other). User-owned overrides live in `toggle_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One toggle state's styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining states/fields.
class ToggleStyle implements Mergeable<ToggleStyle> {
  /// Creates a toggle style slice.
  const ToggleStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.decoration,
    this.padding,
    this.textStyle,
  });

  /// Per-state fill of the toggle surface.
  final StateValue<ThemedColor>? background;

  /// Per-state label/icon color.
  final StateValue<ThemedColor>? foreground;

  /// Per-state border color; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Per-state [TextDecoration].
  final StateValue<TextDecoration>? decoration;

  /// Padding override; null falls back to the toggle default padding.
  final EdgeInsetsGeometry? padding;

  /// Text style override; its color is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ToggleStyle merge(ToggleStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return ToggleStyle(
      background: background?.merge(fallback.background) ?? fallback.background,
      foreground: foreground?.merge(fallback.foreground) ?? fallback.foreground,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      decoration: decoration?.merge(fallback.decoration) ?? fallback.decoration,
      padding: padding ?? fallback.padding,
      // TextStyle.merge lets the argument win; merge fallback over this style
      // so the receiver's fields stay.
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
    );
  }

  /// State scales are stepped at t < 0.5; dimensions are lerped.
  static ToggleStyle lerp(ToggleStyle a, ToggleStyle b, double t) {
    return ToggleStyle(
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      decoration: t < 0.5 ? a.decoration : b.decoration,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ToggleStyle &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.decoration == decoration &&
        other.padding == padding &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(
    background,
    foreground,
    borderColor,
    borderWidth,
    decoration,
    padding,
    textStyle,
  );
}

/// On/off theme container for the toggle component.
class ToggleTheme extends ComponentThemeData implements Mergeable<ToggleTheme> {
  /// Creates a toggle theme with one nullable slice per value.
  const ToggleTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.on,
    this.off,
  });

  /// Style while the toggle is on.
  final ToggleStyle? on;

  /// Style while the toggle is off.
  final ToggleStyle? off;

  /// The slice for the current value, or null when this leg leaves it unset.
  ToggleStyle? forValue(bool value) => value ? on : off;

  /// Returns a copy with the given fields replaced.
  ToggleTheme copyWith({
    ValueGetter<ToggleStyle?>? on,
    ValueGetter<ToggleStyle?>? off,
  }) {
    return ToggleTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      on: on == null ? this.on : on(),
      off: off == null ? this.off : off(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ToggleTheme merge(ToggleTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ToggleTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      on: on?.merge(fallback.on) ?? fallback.on,
      off: off?.merge(fallback.off) ?? fallback.off,
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static ToggleTheme lerp(ToggleTheme a, ToggleTheme b, double t) {
    ToggleStyle? row(ToggleStyle? x, ToggleStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return ToggleStyle.lerp(x, y, t);
    }

    return ToggleTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      on: row(a.on, b.on),
      off: row(a.off, b.off),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ToggleTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.on == on &&
        other.off == off;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, on, off);
}

/// Default toggle padding before any override.
const EdgeInsetsGeometry toggleDefaultPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
);

/// Default toggle text style before any override.
const TextStyle toggleDefaultTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// On = the button primary row, off = the button ghost row (design §1.6).
// Disabled states are intentionally absent: `StateValue` falls back to `rest`
// and `Toggle` dims the whole control to 50% opacity when disabled.
// ---------------------------------------------------------------------------

const _onBg = StateValue(
  rest: ThemedColor.ref(ColorRef.primary),
  hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
);
const _onRow = ToggleStyle(
  background: _onBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.primaryForeground)),
  padding: toggleDefaultPadding,
  textStyle: toggleDefaultTextStyle,
);

const _offBg = StateValue(
  rest: ThemedColor.ref(ColorRef.muted, alpha: 0),
  hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
  pressed: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
);
const _offRow = ToggleStyle(
  background: _offBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  padding: toggleDefaultPadding,
  textStyle: toggleDefaultTextStyle,
);

/// Token-derived baseline rows; every unset override field falls through here.
const ToggleTheme toggleDefaults = ToggleTheme(on: _onRow, off: _offRow);
