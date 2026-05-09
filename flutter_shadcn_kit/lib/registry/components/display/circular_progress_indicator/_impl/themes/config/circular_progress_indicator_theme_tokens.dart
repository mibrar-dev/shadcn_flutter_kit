// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror CircularProgressIndicatorThemeDefaults
// ═══════════════════════════════════════════════════════════

class CircularProgressIndicatorThemeTokens {
  const CircularProgressIndicatorThemeTokens({
    this.color = const Color(0xFF171717),
    this.backgroundColor = const Color(0x33171717),
    this.size = 16.0,
    this.strokeWidth = 1.3333333333333333,
    this.duration = const Duration(milliseconds: 150),
    this.animated = true,
    this.onSurface = false,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color color;
  final Color backgroundColor;
  final double size;
  final double strokeWidth;
  final Duration duration;
  final bool animated;
  final bool onSurface;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const circularProgressIndicatorThemeTokens =
    CircularProgressIndicatorThemeTokens();
