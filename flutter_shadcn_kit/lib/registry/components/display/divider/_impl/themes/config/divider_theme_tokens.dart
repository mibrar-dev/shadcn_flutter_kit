// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/utils/axis.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class DividerThemeTokens {
  final Color color;
  final double? height;
  final double thickness;
  final double indent;
  final double endIndent;
  final EdgeInsetsGeometry padding;
  final AxisAlignmentGeometry childAlignment;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;

  const DividerThemeTokens({
    this.color = const Color(0xFFE5E5E5),
    this.height,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.childAlignment = AxisAlignment.center,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });
}

const dividerThemeTokens = DividerThemeTokens();
