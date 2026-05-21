// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror ScrollbarThemeDefaults
// ═══════════════════════════════════════════════════════════

class ScrollbarThemeTokens {
  const ScrollbarThemeTokens({
    this.color = const Color(0xFFE5E5E5),
    this.thickness = 7.0,
    this.radius = const Radius.circular(4.0),
    this.minLength = 48.0,
    this.hoverAnimationDuration = const Duration(milliseconds: 200),
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.interactive = true,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color color;
  final double thickness;
  final Radius radius;
  final double minLength;
  final Duration hoverAnimationDuration;
  final Duration fadeDuration;
  final Duration timeToFade;
  final bool interactive;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const scrollbarThemeTokens = ScrollbarThemeTokens();
