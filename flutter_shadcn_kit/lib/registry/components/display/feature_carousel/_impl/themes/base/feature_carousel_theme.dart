// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

/// Core class used by the feature carousel component.
class FeatureCarouselThemeData {
  /// Color value used by feature carousel painting or state styling.
  final Color backgroundColor;

  /// Color value used by feature carousel painting or state styling.
  final Color vignetteOuterColor;

  /// Color value used by feature carousel painting or state styling.
  final Color vignetteInnerColor;

  /// Color value used by feature carousel painting or state styling.
  final Color cardFillColor;

  /// Color value used by feature carousel painting or state styling.
  final Color cardBorderColor;

  /// Color value used by feature carousel painting or state styling.
  final Color ghostFillColor;

  /// Color value used by feature carousel painting or state styling.
  final Color ghostBorderColor;

  /// Input parameter used by `FeatureCarouselThemeData` during rendering and behavior handling.
  final Color arrowBackground;

  /// Color value used by feature carousel painting or state styling.
  final Color arrowIconColor;

  /// Input parameter used by `FeatureCarouselThemeData` during rendering and behavior handling.
  final Color ctaBackground;

  /// Color value used by feature carousel painting or state styling.
  final Color ctaBorderColor;

  /// Color value used by feature carousel painting or state styling.
  final Color ctaTextColor;

  /// Color value used by feature carousel painting or state styling.
  final Color titleColor;

  /// Color value used by feature carousel painting or state styling.
  final Color descriptionColor;

  /// Color value used by feature carousel painting or state styling.
  final Color accentColor;

  /// Layout/size setting that affects feature carousel rendering.
  final double cardWidth;

  /// Layout/size setting that affects feature carousel rendering.
  final double cardHeight;

  /// Layout/size setting that affects feature carousel rendering.
  final double carouselWidth;

  /// Layout/size setting that affects feature carousel rendering.
  final double carouselHeight;

  /// Layout/size setting that affects feature carousel rendering.
  final double arrowSize;

  /// Layout/size setting that affects feature carousel rendering.
  final double arrowRadius;

  /// Layout/size setting that affects feature carousel rendering.
  final double cardRadius;

  /// Layout/size setting that affects feature carousel rendering.
  final double ghostRadius;

  /// Layout/size setting that affects feature carousel rendering.
  final double ctaHeight;

  /// Layout/size setting that affects feature carousel rendering.
  final double ctaMinWidth;

  /// Layout/size setting that affects feature carousel rendering.
  final double ctaHorizontalPadding;

  /// Layout/size setting that affects feature carousel rendering.
  final double titleFontSize;

  /// Layout/size setting that affects feature carousel rendering.
  final double descriptionFontSize;

  /// Layout/size setting that affects feature carousel rendering.
  final double descriptionLineHeight;

  /// Animation/progress setting used by feature carousel transitions.
  final Duration transitionDuration;

  /// Animation/progress setting used by feature carousel transitions.
  final Curve transitionCurve;

  /// Creates `FeatureCarouselThemeData` for configuring or rendering feature carousel.
  const FeatureCarouselThemeData({
    required this.backgroundColor,
    required this.vignetteInnerColor,
    required this.vignetteOuterColor,
    required this.cardFillColor,
    required this.cardBorderColor,
    required this.ghostFillColor,
    required this.ghostBorderColor,
    required this.arrowBackground,
    required this.arrowIconColor,
    required this.ctaBackground,
    required this.ctaBorderColor,
    required this.ctaTextColor,
    required this.titleColor,
    required this.descriptionColor,
    required this.accentColor,
    required this.cardWidth,
    required this.cardHeight,
    required this.carouselWidth,
    required this.carouselHeight,
    required this.arrowSize,
    required this.arrowRadius,
    required this.cardRadius,
    required this.ghostRadius,
    required this.ctaHeight,
    required this.ctaMinWidth,
    required this.ctaHorizontalPadding,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.descriptionLineHeight,
    required this.transitionDuration,
    required this.transitionCurve,
  });

  /// Factory constructor that derives a `FeatureCarouselThemeData.defaults` configuration for feature carousel.
  factory FeatureCarouselThemeData.defaults() {
    return const FeatureCarouselThemeData(
      backgroundColor: Color(0xFF121212),
      vignetteInnerColor: Color(0x00000000),
      vignetteOuterColor: Color(0x8C000000),
      cardFillColor: Color(0xFF141414),
      cardBorderColor: Color(0x8CFFFFFF),
      ghostFillColor: Color(0x66141414),
      ghostBorderColor: Color(0x33FFFFFF),
      arrowBackground: Color(0x0FFFFFFF),
      arrowIconColor: Color(0x8CFFFFFF),
      ctaBackground: Color(0x12FFFFFF),
      ctaBorderColor: Color(0x14FFFFFF),
      ctaTextColor: Color(0xCCFFFFFF),
      titleColor: Color(0x8CFFFFFF),
      descriptionColor: Color(0xA6FFFFFF),
      accentColor: Color(0xFF7EA3FF),
      cardWidth: 250,
      cardHeight: 300,
      carouselWidth: 420,
      carouselHeight: 370,
      arrowSize: 44,
      arrowRadius: 12,
      cardRadius: 12,
      ghostRadius: 12,
      ctaHeight: 46,
      ctaMinWidth: 140,
      ctaHorizontalPadding: 22,
      titleFontSize: 18,
      descriptionFontSize: 18,
      descriptionLineHeight: 1.35,
      transitionDuration: Duration(milliseconds: 260),
      transitionCurve: Curves.easeOutCubic,
    );
  }

  FeatureCarouselThemeData copyWith({
    Color? backgroundColor,
    Color? vignetteInnerColor,
    Color? vignetteOuterColor,
    Color? cardFillColor,
    Color? cardBorderColor,
    Color? ghostFillColor,
    Color? ghostBorderColor,
    Color? arrowBackground,
    Color? arrowIconColor,
    Color? ctaBackground,
    Color? ctaBorderColor,
    Color? ctaTextColor,
    Color? titleColor,
    Color? descriptionColor,
    Color? accentColor,
    double? cardWidth,
    double? cardHeight,
    double? carouselWidth,
    double? carouselHeight,
    double? arrowSize,
    double? arrowRadius,
    double? cardRadius,
    double? ghostRadius,
    double? ctaHeight,
    double? ctaMinWidth,
    double? ctaHorizontalPadding,
    double? titleFontSize,
    double? descriptionFontSize,
    double? descriptionLineHeight,
    Duration? transitionDuration,
    Curve? transitionCurve,
  }) {
    return FeatureCarouselThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      vignetteInnerColor: vignetteInnerColor ?? this.vignetteInnerColor,
      vignetteOuterColor: vignetteOuterColor ?? this.vignetteOuterColor,
      cardFillColor: cardFillColor ?? this.cardFillColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      ghostFillColor: ghostFillColor ?? this.ghostFillColor,
      ghostBorderColor: ghostBorderColor ?? this.ghostBorderColor,
      arrowBackground: arrowBackground ?? this.arrowBackground,
      arrowIconColor: arrowIconColor ?? this.arrowIconColor,
      ctaBackground: ctaBackground ?? this.ctaBackground,
      ctaBorderColor: ctaBorderColor ?? this.ctaBorderColor,
      ctaTextColor: ctaTextColor ?? this.ctaTextColor,
      titleColor: titleColor ?? this.titleColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      accentColor: accentColor ?? this.accentColor,
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      carouselWidth: carouselWidth ?? this.carouselWidth,
      carouselHeight: carouselHeight ?? this.carouselHeight,
      arrowSize: arrowSize ?? this.arrowSize,
      arrowRadius: arrowRadius ?? this.arrowRadius,
      cardRadius: cardRadius ?? this.cardRadius,
      ghostRadius: ghostRadius ?? this.ghostRadius,
      ctaHeight: ctaHeight ?? this.ctaHeight,
      ctaMinWidth: ctaMinWidth ?? this.ctaMinWidth,
      ctaHorizontalPadding: ctaHorizontalPadding ?? this.ctaHorizontalPadding,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      descriptionFontSize: descriptionFontSize ?? this.descriptionFontSize,
      descriptionLineHeight:
          descriptionLineHeight ?? this.descriptionLineHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
    );
  }
}
