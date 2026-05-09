// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class AccordionThemeTokens {
  const AccordionThemeTokens({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeIn,
    this.reverseCurve = Curves.easeOut,
    this.padding = 16.0,
    this.iconGap = 18.0,
    this.dividerHeight = 1.0,
    this.dividerColor = const Color(0xFFF5F5F5),
    this.arrowIcon = Icons.keyboard_arrow_up,
    this.arrowIconColor = const Color(0xFF737373),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final double padding;
  final double iconGap;
  final double dividerHeight;
  final Color dividerColor;
  final IconData arrowIcon;
  final Color arrowIconColor;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const accordionThemeTokens = AccordionThemeTokens();
