// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in focus outline widgets
// ═══════════════════════════════════════════════════════════

class FocusOutlineThemeDefaults {
  const FocusOutlineThemeDefaults({
    this.align = 3.0,
    this.borderRadius,
    this.border = const Border.fromBorderSide(
      BorderSide(color: Color(0x80A1A1A1), width: 3.0),
    ),
    this.shape = BoxShape.rectangle,
  });

  /// From `FocusOutline`: `defaultValue: 3.0`
  final double align;

  /// From `FocusOutline`: `defaultValue: null`
  final BorderRadiusGeometry? borderRadius;

  /// From `FocusOutline`: `defaultValue: Border.all(color: visibleRingColor, width: 3.0)`
  final Border border;

  /// From `FocusOutline`: `shape ?? BoxShape.rectangle`
  final BoxShape shape;
}
