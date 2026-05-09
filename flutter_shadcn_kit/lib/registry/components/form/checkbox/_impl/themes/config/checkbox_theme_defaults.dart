// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in checkbox widget state
// ═══════════════════════════════════════════════════════════

class CheckboxThemeDefaults {
  const CheckboxThemeDefaults({
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
  });

  /// From widget default: `theme.colorScheme.input.scaleAlpha(0.3)`
  final Color backgroundColor;

  /// From widget default: `theme.colorScheme.primary`
  final Color activeColor;

  /// From widget default: `theme.colorScheme.border`
  final Color borderColor;

  /// From widget default: `16 * theme.scaling`
  final double size;

  /// From widget default: `8 * theme.scaling`
  final double gap;

  /// From widget default: `BorderRadius.circular(theme.radiusSm)`
  final BorderRadiusGeometry borderRadius;

  /// From widget default: `tristate = false`
  final bool tristate;

  /// From widget border default: `width: (_focusing ? 2 : 1) * scaling`
  final double borderWidth;

  /// From widget border default: `width: (_focusing ? 2 : 1) * scaling`
  final double focusedBorderWidth;

  /// From checked indicator default: `width: scaling * 9`
  final double checkedIndicatorWidth;

  /// From checked indicator default: `height: scaling * 6.5`
  final double checkedIndicatorHeight;

  /// From check painter default: `strokeWidth: scaling * 1`
  final double checkedIndicatorStrokeWidth;

  /// From indeterminate indicator default: `scaling * 8`
  final double indeterminateIndicatorSize;

  /// From indeterminate indicator default: `BorderRadius.circular(theme.radiusXs)`
  final double indeterminateIndicatorRadius;

  /// From indicator container default: `Duration(milliseconds: 100)`
  final Duration boxAnimationDuration;

  /// From check animation default: `Duration(milliseconds: 300)`
  final Duration checkmarkAnimationDuration;

  /// From check animation delay default: `Duration(milliseconds: 175)`
  final Duration checkmarkAnimationDelay;

  /// From clickable default when enabled: `SystemMouseCursors.click`
  final MouseCursor enabledMouseCursor;

  /// From clickable default when disabled: `SystemMouseCursors.forbidden`
  final MouseCursor disabledMouseCursor;
}
