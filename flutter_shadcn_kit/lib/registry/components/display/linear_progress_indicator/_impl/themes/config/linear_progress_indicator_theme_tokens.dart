// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class LinearProgressIndicatorThemeTokens {
  final Color color;
  final Color backgroundColor;
  final double minHeight;
  final BorderRadiusGeometry borderRadius;
  final bool showSparks;
  final bool disableAnimation;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;

  const LinearProgressIndicatorThemeTokens({
    this.color = const Color(0xFF171717),
    this.backgroundColor = const Color(0x33171717),
    this.minHeight = 2.0,
    this.borderRadius = BorderRadius.zero,
    this.showSparks = false,
    this.disableAnimation = false,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });
}

const linearProgressIndicatorThemeTokens = LinearProgressIndicatorThemeTokens();
