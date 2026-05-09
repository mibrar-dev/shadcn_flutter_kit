// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in star rating widgets
// ═══════════════════════════════════════════════════════════

class StarRatingThemeDefaults {
  const StarRatingThemeDefaults({
    this.activeColor = const Color(0xFF171717),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.starSize = 24.0,
    this.starSpacing = 5.0,
  });

  /// From `StarRatingState`: enabled fallback to `theme.colorScheme.primary`
  final Color activeColor;

  /// From `StarRatingState`: `defaultValue: theme.colorScheme.muted`
  final Color backgroundColor;

  /// From `StarRatingState`: `defaultValue: 24.0 * scaling`
  final double starSize;

  /// From `StarRatingState`: `defaultValue: 5.0 * scaling`
  final double starSpacing;
}
