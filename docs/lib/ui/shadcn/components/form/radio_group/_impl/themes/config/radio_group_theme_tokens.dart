// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class RadioCardThemeTokens {
  const RadioCardThemeTokens({
    this.enabledCursor = SystemMouseCursors.click,
    this.disabledCursor = SystemMouseCursors.forbidden,
    this.hoverColor = const Color(0xFFF5F5F5),
    this.color = const Color(0xFFFFFFFF),
    this.borderWidth = 1.0,
    this.selectedBorderWidth = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.padding = const EdgeInsets.all(16.0),
    this.borderColor = const Color(0xFFF5F5F5),
    this.selectedBorderColor = const Color(0xFF171717),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;
  final Color hoverColor;
  final Color color;
  final double borderWidth;
  final double selectedBorderWidth;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color selectedBorderColor;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const radioCardThemeTokens = RadioCardThemeTokens();

class RadioThemeTokens {
  const RadioThemeTokens({
    this.activeColor = const Color(0xFF171717),
    this.borderColor = const Color(0xFFE5E5E5),
    this.backgroundColor = const Color(0x4DE5E5E5),
    this.size = 16.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color activeColor;
  final Color borderColor;
  final Color backgroundColor;
  final double size;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const radioThemeTokens = RadioThemeTokens();
