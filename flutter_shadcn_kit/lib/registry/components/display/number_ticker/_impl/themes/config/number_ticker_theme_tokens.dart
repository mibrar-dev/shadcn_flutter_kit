// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror NumberTickerThemeDefaults
// ═══════════════════════════════════════════════════════════

class NumberTickerThemeTokens {
  const NumberTickerThemeTokens({
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.style,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Duration duration;
  final Curve curve;
  final TextStyle? style;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const numberTickerThemeTokens = NumberTickerThemeTokens();
