// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
