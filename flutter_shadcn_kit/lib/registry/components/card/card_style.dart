// Registry-owned theme data for the `card` component: the [CardTheme]
// container and its token-derived `cardDefaults`.
//
// shadcn card: `bg-card text-card-foreground flex flex-col rounded-xl border
// py-6`. Glass (`surfaceOpacity` / `surfaceBlur`) is not a token, so it is gone
// from the new API; a card that needs a blurred surface belongs to the
// `outlined_container` / `popover` components. User-owned overrides live in
// `card_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Surface, border, padding and shadow of the card component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class CardTheme extends ComponentThemeData implements Mergeable<CardTheme> {
  /// Creates a card theme.
  const CardTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.shadows,
  });

  /// Fill of the card surface. Default: the `card` token.
  final ThemedColor? background;

  /// Text colour inherited by the card content. Default: the
  /// `cardForeground` token.
  final ThemedColor? foreground;

  /// Border colour; null draws no border. Default: the `border` token.
  final ThemedColor? borderColor;

  /// Border width; `0` hides the border. Default: `1`.
  final double? borderWidth;

  /// Corner radius; null resolves the ambient `radiusXl` at build.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves the 24 default at build.
  final EdgeInsetsGeometry? padding;

  /// Drop shadows of the card; null resolves the ambient `shadowSm` at build,
  /// `const []` removes them.
  final List<BoxShadow>? shadows;

  /// Returns a copy with the given fields replaced.
  CardTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<List<BoxShadow>?>? shadows,
  }) {
    return CardTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      shadows: shadows == null ? this.shadows : shadows(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CardTheme merge(CardTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return CardTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      shadows: shadows ?? fallback.shadows,
    );
  }

  /// Colours step at `t = 0.5`; geometry and shadows are lerped.
  static CardTheme lerp(CardTheme a, CardTheme b, double t) {
    return CardTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      shadows:
          BoxShadow.lerpList(a.shadows, b.shadows, t) ??
          (t < 0.5 ? a.shadows : b.shadows),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CardTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        Object.hashAll(other.shadows ?? const <BoxShadow>[]) ==
            Object.hashAll(shadows ?? const <BoxShadow>[]);
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    Object.hashAll(shadows ?? const <BoxShadow>[]),
  );
}

/// Default card padding: shadcn `py-6` plus the horizontal gutter.
const EdgeInsetsGeometry cardDefaultPadding = EdgeInsets.all(24);

/// Token-derived baseline values; unset override fields fall through here.
///
/// `borderRadius` and `shadows` stay null because their real defaults come
/// from the ambient token scale (`radiusXl`, `shadowSm`) and are resolved at
/// build time instead of being frozen into this const.
const CardTheme cardDefaults = CardTheme(
  background: ThemedColor.ref(ColorRef.card),
  foreground: ThemedColor.ref(ColorRef.cardForeground),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: cardDefaultPadding,
);
