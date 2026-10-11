// Registry-owned theme data for the `button` component: the state-aware
// [ButtonVariantStyle] slice, the per-variant [ButtonTheme] container and the
// token-derived `buttonDefaults` rows.
//
// User-owned overrides live in `button_theme.dart`; CLI updates may replace
// this file. The `ButtonVariant`/`ButtonSize` enums live here (not in
// `button.dart`) so the style layer never imports the widget layer;
// `button.dart` re-exports them.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual variants of the button component.
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  link,
  text,
  destructive,
}

/// Fixed button sizes. Global density scales the size table's padding.
enum ButtonSize { xs, sm, md, lg, icon }

/// Fallback text style before the size table narrows the font size.
const TextStyle buttonDefaultTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

/// One variant's state-aware styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining states/fields.
class ButtonVariantStyle implements Mergeable<ButtonVariantStyle> {
  /// Creates a variant style slice.
  const ButtonVariantStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.decoration,
    this.padding,
    this.textStyle,
  });

  /// Per-state fill of the button surface.
  final StateValue<ThemedColor>? background;

  /// Per-state label/icon color.
  final StateValue<ThemedColor>? foreground;

  /// Per-state border color; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Per-state [TextDecoration] (link underline); null draws none.
  final StateValue<TextDecoration>? decoration;

  /// Padding override; null falls back to the size table.
  final EdgeInsetsGeometry? padding;

  /// Text style override; its color is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ButtonVariantStyle merge(ButtonVariantStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return ButtonVariantStyle(
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
  static ButtonVariantStyle lerp(
    ButtonVariantStyle a,
    ButtonVariantStyle b,
    double t,
  ) {
    return ButtonVariantStyle(
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
    return other is ButtonVariantStyle &&
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

/// Per-variant theme container for the button component.
///
/// A leg may set only the variants/fields it cares about; [merge] lets the
/// receiver win per field. [forVariant] is an exhaustive switch over
/// [ButtonVariant].
class ButtonTheme extends ComponentThemeData implements Mergeable<ButtonTheme> {
  /// Creates a button theme with one nullable slice per variant.
  const ButtonTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.primary,
    this.secondary,
    this.outline,
    this.ghost,
    this.link,
    this.text,
    this.destructive,
  });

  /// Style for [ButtonVariant.primary].
  final ButtonVariantStyle? primary;

  /// Style for [ButtonVariant.secondary].
  final ButtonVariantStyle? secondary;

  /// Style for [ButtonVariant.outline].
  final ButtonVariantStyle? outline;

  /// Style for [ButtonVariant.ghost].
  final ButtonVariantStyle? ghost;

  /// Style for [ButtonVariant.link].
  final ButtonVariantStyle? link;

  /// Style for [ButtonVariant.text].
  final ButtonVariantStyle? text;

  /// Style for [ButtonVariant.destructive].
  final ButtonVariantStyle? destructive;

  /// The slice for [variant], or null when this leg leaves it unset.
  ButtonVariantStyle? forVariant(ButtonVariant variant) {
    return switch (variant) {
      ButtonVariant.primary => primary,
      ButtonVariant.secondary => secondary,
      ButtonVariant.outline => outline,
      ButtonVariant.ghost => ghost,
      ButtonVariant.link => link,
      ButtonVariant.text => text,
      ButtonVariant.destructive => destructive,
    };
  }

  /// Returns a copy with the given variant rows replaced.
  ButtonTheme copyWith({
    ValueGetter<ButtonVariantStyle?>? primary,
    ValueGetter<ButtonVariantStyle?>? secondary,
    ValueGetter<ButtonVariantStyle?>? outline,
    ValueGetter<ButtonVariantStyle?>? ghost,
    ValueGetter<ButtonVariantStyle?>? link,
    ValueGetter<ButtonVariantStyle?>? text,
    ValueGetter<ButtonVariantStyle?>? destructive,
  }) {
    return ButtonTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      primary: primary == null ? this.primary : primary(),
      secondary: secondary == null ? this.secondary : secondary(),
      outline: outline == null ? this.outline : outline(),
      ghost: ghost == null ? this.ghost : ghost(),
      link: link == null ? this.link : link(),
      text: text == null ? this.text : text(),
      destructive: destructive == null ? this.destructive : destructive(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ButtonTheme merge(ButtonTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ButtonTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      primary: primary?.merge(fallback.primary) ?? fallback.primary,
      secondary: secondary?.merge(fallback.secondary) ?? fallback.secondary,
      outline: outline?.merge(fallback.outline) ?? fallback.outline,
      ghost: ghost?.merge(fallback.ghost) ?? fallback.ghost,
      link: link?.merge(fallback.link) ?? fallback.link,
      text: text?.merge(fallback.text) ?? fallback.text,
      destructive:
          destructive?.merge(fallback.destructive) ?? fallback.destructive,
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static ButtonTheme lerp(ButtonTheme a, ButtonTheme b, double t) {
    ButtonVariantStyle? row(ButtonVariantStyle? x, ButtonVariantStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return ButtonVariantStyle.lerp(x, y, t);
    }

    return ButtonTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      primary: row(a.primary, b.primary),
      secondary: row(a.secondary, b.secondary),
      outline: row(a.outline, b.outline),
      ghost: row(a.ghost, b.ghost),
      link: row(a.link, b.link),
      text: row(a.text, b.text),
      destructive: row(a.destructive, b.destructive),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ButtonTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.outline == outline &&
        other.ghost == ghost &&
        other.link == link &&
        other.text == text &&
        other.destructive == destructive;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    primary,
    secondary,
    outline,
    ghost,
    link,
    text,
    destructive,
  );
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// Disabled states are intentionally absent: every `StateValue` falls back to
// its `rest` entry, and `Button` dims the whole control to 50% opacity when
// disabled (shadcn `disabled:opacity-50`). Pressed duplicates hovered because
// `StateValue.resolve` never falls back from one state to another.
// ---------------------------------------------------------------------------

const _primaryBg = StateValue(
  rest: ThemedColor.ref(ColorRef.primary),
  hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
);
const _primaryRow = ButtonVariantStyle(
  background: _primaryBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.primaryForeground)),
);

const _secondaryBg = StateValue(
  rest: ThemedColor.ref(ColorRef.secondary),
  hovered: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
  pressed: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
);
const _secondaryRow = ButtonVariantStyle(
  background: _secondaryBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.secondaryForeground)),
);

const _outlineBg = StateValue(
  rest: ThemedColor.ref(ColorRef.input, alpha: 0.3),
  hovered: ThemedColor.ref(ColorRef.input, alpha: 0.5),
  pressed: ThemedColor.ref(ColorRef.input, alpha: 0.5),
);
const _outlineRow = ButtonVariantStyle(
  background: _outlineBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  borderColor: StateValue(rest: ThemedColor.ref(ColorRef.input)),
  borderWidth: 1,
);

const _ghostBg = StateValue(
  rest: ThemedColor.ref(ColorRef.muted, alpha: 0),
  hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
  pressed: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
);
const _ghostRow = ButtonVariantStyle(
  background: _ghostBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
);

const _linkRow = ButtonVariantStyle(
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  decoration: StateValue(
    hovered: TextDecoration.underline,
    pressed: TextDecoration.underline,
  ),
  // shadcn link is a plain anchor (ml-auto): no horizontal padding, so an
  // end-aligned link's text meets the field's right edge.
  padding: EdgeInsets.zero,
);

const _textRow = ButtonVariantStyle(
  foreground: StateValue(
    rest: ThemedColor.ref(ColorRef.mutedForeground),
    hovered: ThemedColor.ref(ColorRef.primary),
    pressed: ThemedColor.ref(ColorRef.primary),
  ),
  // Same plain-anchor shape as link: no horizontal padding.
  padding: EdgeInsets.zero,
);

const _destructiveBg = StateValue(
  rest: ThemedColor.ref(ColorRef.destructive),
  hovered: ThemedColor.ref(ColorRef.destructive, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.destructive, alpha: 0.9),
);
const _destructiveRow = ButtonVariantStyle(
  background: _destructiveBg,
  foreground: StateValue(rest: ThemedColor.ref(ColorRef.destructiveForeground)),
);

/// Token-derived baseline rows; every unset override field falls through here.
const ButtonTheme buttonDefaults = ButtonTheme(
  primary: _primaryRow,
  secondary: _secondaryRow,
  outline: _outlineRow,
  ghost: _ghostRow,
  link: _linkRow,
  text: _textRow,
  destructive: _destructiveRow,
);
