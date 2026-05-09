// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class SwitchThemeDefaults {
  const SwitchThemeDefaults({
    this.activeColor = const Color(0xFF171717),
    this.inactiveColor = const Color(0xFFE5E5E5),
    this.activeThumbColor = const Color(0xFFFFFFFF),
    this.inactiveThumbColor = const Color(0xFF0A0A0A),
    this.gap = 8.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
  });

  final Color activeColor;
  final Color inactiveColor;
  final Color activeThumbColor;
  final Color inactiveThumbColor;
  final double gap;
  final BorderRadiusGeometry borderRadius;
}
