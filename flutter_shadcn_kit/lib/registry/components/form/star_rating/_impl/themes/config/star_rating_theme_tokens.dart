// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror StarRatingThemeDefaults
// ═══════════════════════════════════════════════════════════

class StarRatingThemeTokens {
  const StarRatingThemeTokens({
    this.activeColor = const Color(0xFF171717),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.starSize = 24.0,
    this.starSpacing = 5.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color activeColor;
  final Color backgroundColor;
  final double starSize;
  final double starSpacing;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const starRatingThemeTokens = StarRatingThemeTokens();
