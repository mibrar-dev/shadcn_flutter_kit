// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror TooltipThemeDefaults
// ═══════════════════════════════════════════════════════════

class TooltipThemeTokens {
  const TooltipThemeTokens({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    this.backgroundColor = const Color(0xFF171717),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double? surfaceOpacity;
  final double? surfaceBlur;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const tooltipThemeTokens = TooltipThemeTokens();
