// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../dot_indicator.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class DotIndicatorThemeDefaults {
  final double spacing;
  final EdgeInsetsGeometry padding;
  final DotBuilder? dotBuilder;
  final double size;
  final double borderRadius;
  final Color activeColor;
  final Color? inactiveColor;
  final Color inactiveBorderColor;
  final double inactiveBorderWidth;

  const DotIndicatorThemeDefaults({
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.dotBuilder,
    this.size = 12.0,
    this.borderRadius = 6.0,
    this.activeColor = const Color(0xFF171717),
    this.inactiveColor,
    this.inactiveBorderColor = const Color(0xFFF5F5F5),
    this.inactiveBorderWidth = 2.0,
  });
}
