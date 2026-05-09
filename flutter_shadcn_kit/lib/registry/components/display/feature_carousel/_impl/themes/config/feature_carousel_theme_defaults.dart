// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class FeatureCarouselThemeDefaults {
  const FeatureCarouselThemeDefaults({
    this.backgroundColor = const Color(0xFF121212),
    this.vignetteInnerColor = const Color(0x00000000),
    this.vignetteOuterColor = const Color(0x8C000000),
    this.cardFillColor = const Color(0xFF141414),
    this.cardBorderColor = const Color(0x8CFFFFFF),
    this.ghostFillColor = const Color(0x66141414),
    this.ghostBorderColor = const Color(0x33FFFFFF),
    this.arrowBackground = const Color(0x0FFFFFFF),
    this.arrowIconColor = const Color(0x8CFFFFFF),
    this.ctaBackground = const Color(0x12FFFFFF),
    this.ctaBorderColor = const Color(0x14FFFFFF),
    this.ctaTextColor = const Color(0xCCFFFFFF),
    this.titleColor = const Color(0x8CFFFFFF),
    this.descriptionColor = const Color(0xA6FFFFFF),
    this.accentColor = const Color(0xFF7EA3FF),
    this.cardWidth = 250.0,
    this.cardHeight = 300.0,
    this.carouselWidth = 420.0,
    this.carouselHeight = 370.0,
    this.arrowSize = 44.0,
    this.arrowRadius = 12.0,
    this.cardRadius = 12.0,
    this.ghostRadius = 12.0,
    this.ctaHeight = 46.0,
    this.ctaMinWidth = 140.0,
    this.ctaHorizontalPadding = 22.0,
    this.titleFontSize = 18.0,
    this.descriptionFontSize = 18.0,
    this.descriptionLineHeight = 1.35,
    this.transitionDuration = const Duration(milliseconds: 260),
    this.transitionCurve = Curves.easeOutCubic,
  });

  final Color backgroundColor;
  final Color vignetteOuterColor;
  final Color vignetteInnerColor;
  final Color cardFillColor;
  final Color cardBorderColor;
  final Color ghostFillColor;
  final Color ghostBorderColor;
  final Color arrowBackground;
  final Color arrowIconColor;
  final Color ctaBackground;
  final Color ctaBorderColor;
  final Color ctaTextColor;
  final Color titleColor;
  final Color descriptionColor;
  final Color accentColor;
  final double cardWidth;
  final double cardHeight;
  final double carouselWidth;
  final double carouselHeight;
  final double arrowSize;
  final double arrowRadius;
  final double cardRadius;
  final double ghostRadius;
  final double ctaHeight;
  final double ctaMinWidth;
  final double ctaHorizontalPadding;
  final double titleFontSize;
  final double descriptionFontSize;
  final double descriptionLineHeight;
  final Duration transitionDuration;
  final Curve transitionCurve;
}
