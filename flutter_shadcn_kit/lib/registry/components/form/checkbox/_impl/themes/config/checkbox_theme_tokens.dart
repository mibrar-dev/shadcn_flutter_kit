// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror CheckboxThemeDefaults
// ═══════════════════════════════════════════════════════════

class CheckboxThemeTokens {
  const CheckboxThemeTokens({
    this.backgroundColor = const Color(0x4DE5E5E5),
    this.activeColor = const Color(0xFF171717),
    this.borderColor = const Color(0xFFE5E5E5),
    this.size = 16.0,
    this.gap = 8.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.tristate = false,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    this.checkedIndicatorWidth = 9.0,
    this.checkedIndicatorHeight = 6.5,
    this.checkedIndicatorStrokeWidth = 1.0,
    this.indeterminateIndicatorSize = 8.0,
    this.indeterminateIndicatorRadius = 2.0,
    this.boxAnimationDuration = const Duration(milliseconds: 100),
    this.checkmarkAnimationDuration = const Duration(milliseconds: 300),
    this.checkmarkAnimationDelay = const Duration(milliseconds: 175),
    this.enabledMouseCursor = SystemMouseCursors.click,
    this.disabledMouseCursor = SystemMouseCursors.forbidden,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color backgroundColor;
  final Color activeColor;
  final Color borderColor;
  final double size;
  final double gap;
  final BorderRadiusGeometry borderRadius;
  final bool tristate;
  final double borderWidth;
  final double focusedBorderWidth;
  final double checkedIndicatorWidth;
  final double checkedIndicatorHeight;
  final double checkedIndicatorStrokeWidth;
  final double indeterminateIndicatorSize;
  final double indeterminateIndicatorRadius;
  final Duration boxAnimationDuration;
  final Duration checkmarkAnimationDuration;
  final Duration checkmarkAnimationDelay;
  final MouseCursor enabledMouseCursor;
  final MouseCursor disabledMouseCursor;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const checkboxThemeTokens = CheckboxThemeTokens();
