// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror ProgressThemeDefaults
// ═══════════════════════════════════════════════════════════

class ProgressThemeTokens {
  const ProgressThemeTokens({
    this.color,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.minHeight = 8.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final double minHeight;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const progressThemeTokens = ProgressThemeTokens();
