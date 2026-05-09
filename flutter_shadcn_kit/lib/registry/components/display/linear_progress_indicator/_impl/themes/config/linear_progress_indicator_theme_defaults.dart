// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class LinearProgressIndicatorThemeDefaults {
  final Color color;
  final Color backgroundColor;
  final double minHeight;
  final BorderRadiusGeometry borderRadius;
  final bool showSparks;
  final bool disableAnimation;

  const LinearProgressIndicatorThemeDefaults({
    this.color = const Color(0xFF171717),
    this.backgroundColor = const Color(0x33171717),
    this.minHeight = 2.0,
    this.borderRadius = BorderRadius.zero,
    this.showSparks = false,
    this.disableAnimation = false,
  });
}
