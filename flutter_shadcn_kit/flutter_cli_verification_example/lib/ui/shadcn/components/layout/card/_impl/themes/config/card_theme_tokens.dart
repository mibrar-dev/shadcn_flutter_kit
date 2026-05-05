import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class CardThemeTokens {
  const CardThemeTokens({
    this.padding = const EdgeInsets.all(16.0),
    this.filled = false,
    this.fillColor = const Color(0xFFE5E5E5),
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.clipBehavior = Clip.none,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final EdgeInsetsGeometry padding;
  final bool filled;
  final Color fillColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Clip clipBehavior;
  final List<BoxShadow>? boxShadow;
  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Duration? duration;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const cardThemeTokens = CardThemeTokens();
