// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/utils/axis.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class DividerThemeDefaults {
  /// Widget fallback: theme.colorScheme.border
  final Color color;
  final double? height;

  /// Widget fallback: 1
  final double thickness;

  /// Widget fallback: 0
  final double indent;

  /// Widget fallback: 0
  final double endIndent;
  final EdgeInsetsGeometry padding;

  /// Widget fallback: AxisAlignment.center
  final AxisAlignmentGeometry childAlignment;

  const DividerThemeDefaults({
    this.color = const Color(0xFFE5E5E5),
    this.height,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.childAlignment = AxisAlignment.center,
  });
}
