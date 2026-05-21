// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in circular progress indicator widgets
// ═══════════════════════════════════════════════════════════

class CircularProgressIndicatorThemeDefaults {
  const CircularProgressIndicatorThemeDefaults({
    this.color = const Color(0xFF171717),
    this.backgroundColor = const Color(0x33171717),
    this.size = 16.0,
    this.strokeWidth = 1.3333333333333333,
    this.duration = const Duration(milliseconds: 150),
    this.animated = true,
    this.onSurface = false,
  });

  /// From `CircularProgressIndicator`: default primary color when `onSurface` is false.
  final Color color;

  /// From `CircularProgressIndicator`: `effectiveColor.scaleAlpha(0.2)`
  final Color backgroundColor;

  /// From `CircularProgressIndicator`: `(iconTheme.size ?? 24 * scaling) - 8 * scaling`
  final double size;

  /// From `CircularProgressIndicator`: `effectiveSize / 12`
  final double strokeWidth;

  /// From constructor default: `kDefaultDuration`
  final Duration duration;

  /// From constructor default: `animated = true`
  final bool animated;

  /// From constructor default: `onSurface = false`
  final bool onSurface;
}
