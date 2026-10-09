// Registry-owned theme data for the `card_image` component: the
// [CardImageTheme] container, the chrome-free `cardImageButtonStyle` the
// pressable card runs on, and the token-derived `cardImageDefaults`.
//
// The old `CardImageTheme` held an `AbstractButtonStyle` (`ButtonStyle.fixed`)
// and raw `Color`s. The style is a `ButtonVariantStyle` now and the colours are
// `ThemedColor` rows. User-owned overrides live in `card_image_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button_style.dart';

/// Appearance of the card image component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class CardImageTheme extends ComponentThemeData
    implements Mergeable<CardImageTheme> {
  /// Creates a card image theme.
  const CardImageTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.hoverScale,
    this.normalScale,
    this.imageBackground,
    this.imageBorderColor,
    this.imageRadius,
    this.gap,
  });

  /// Axis of the image/text composition. Defaults to [Axis.vertical].
  final Axis? direction;

  /// Image scale while the card is hovered. Defaults to 1.05.
  final double? hoverScale;

  /// Image scale at rest. Defaults to 1.
  final double? normalScale;

  /// Fill behind the image. Defaults to a fully transparent token.
  final ThemedColor? imageBackground;

  /// Border around the image. Defaults to a fully transparent token.
  final ThemedColor? imageBorderColor;

  /// Corner radius of the image surface. Defaults to the ambient `radiusXl`.
  final BorderRadiusGeometry? imageRadius;

  /// Gap between the image and the text block. Defaults to 12.
  final double? gap;

  /// Returns a copy with the given fields replaced.
  CardImageTheme copyWith({
    ValueGetter<Axis?>? direction,
    ValueGetter<double?>? hoverScale,
    ValueGetter<double?>? normalScale,
    ValueGetter<ThemedColor?>? imageBackground,
    ValueGetter<ThemedColor?>? imageBorderColor,
    ValueGetter<BorderRadiusGeometry?>? imageRadius,
    ValueGetter<double?>? gap,
  }) {
    return CardImageTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      direction: direction == null ? this.direction : direction(),
      hoverScale: hoverScale == null ? this.hoverScale : hoverScale(),
      normalScale: normalScale == null ? this.normalScale : normalScale(),
      imageBackground: imageBackground == null
          ? this.imageBackground
          : imageBackground(),
      imageBorderColor: imageBorderColor == null
          ? this.imageBorderColor
          : imageBorderColor(),
      imageRadius: imageRadius == null ? this.imageRadius : imageRadius(),
      gap: gap == null ? this.gap : gap(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CardImageTheme merge(CardImageTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return CardImageTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      direction: direction ?? fallback.direction,
      hoverScale: hoverScale ?? fallback.hoverScale,
      normalScale: normalScale ?? fallback.normalScale,
      imageBackground: imageBackground ?? fallback.imageBackground,
      imageBorderColor: imageBorderColor ?? fallback.imageBorderColor,
      imageRadius: imageRadius ?? fallback.imageRadius,
      gap: gap ?? fallback.gap,
    );
  }

  /// Colours and the axis step at `t = 0.5`; dimensions are lerped.
  static CardImageTheme lerp(CardImageTheme a, CardImageTheme b, double t) {
    return CardImageTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      direction: t < 0.5 ? a.direction : b.direction,
      hoverScale: lerpDouble(a.hoverScale, b.hoverScale, t),
      normalScale: lerpDouble(a.normalScale, b.normalScale, t),
      imageBackground: t < 0.5 ? a.imageBackground : b.imageBackground,
      imageBorderColor: t < 0.5 ? a.imageBorderColor : b.imageBorderColor,
      imageRadius: t < 0.5 ? a.imageRadius : b.imageRadius,
      gap: lerpDouble(a.gap, b.gap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CardImageTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.direction == direction &&
        other.hoverScale == hoverScale &&
        other.normalScale == normalScale &&
        other.imageBackground == imageBackground &&
        other.imageBorderColor == imageBorderColor &&
        other.imageRadius == imageRadius &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    direction,
    hoverScale,
    normalScale,
    imageBackground,
    imageBorderColor,
    imageRadius,
    gap,
  );
}

/// Default gap between the image and the text block.
const double cardImageDefaultGap = 12;

/// Default image scale while hovered.
const double cardImageDefaultHoverScale = 1.05;

// A fully transparent token (alpha 0 of `muted`) rather than the literal
// `Colors.transparent`: it is still a token, so a themed override can replace
// it, and the old code's `Colors.transparent` default is preserved visually.
const ThemedColor _cardImageTransparent = ThemedColor.ref(
  ColorRef.muted,
  alpha: 0,
);

/// The pressable card runs on a chrome-free button: no fill in any state (the
/// old `ButtonStyle.fixed`), so only the image scale signals hover.
const ButtonVariantStyle cardImageButtonStyle = ButtonVariantStyle(
  background: StateValue(
    rest: _cardImageTransparent,
    hovered: _cardImageTransparent,
    pressed: _cardImageTransparent,
  ),
);

/// Token-derived baseline; `imageRadius` stays null and resolves the ambient
/// `radiusXl` at build time.
const CardImageTheme cardImageDefaults = CardImageTheme(
  direction: Axis.vertical,
  hoverScale: cardImageDefaultHoverScale,
  normalScale: 1,
  imageBackground: _cardImageTransparent,
  imageBorderColor: _cardImageTransparent,
  gap: cardImageDefaultGap,
);
