import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class CardThemeDefaults {
  const CardThemeDefaults({
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
}
