// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class HiddenThemeTokens {
  final Axis direction;
  final Duration duration;
  final Curve curve;
  final bool reverse;
  final bool keepCrossAxisSize;
  final bool keepMainAxisSize;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;

  const HiddenThemeTokens({
    this.direction = Axis.horizontal,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.reverse = false,
    this.keepCrossAxisSize = false,
    this.keepMainAxisSize = false,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });
}

const hiddenThemeTokens = HiddenThemeTokens();
