// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class HoverCardThemeTokens {
  const HoverCardThemeTokens({
    this.debounce = const Duration(milliseconds: 500),
    this.wait = const Duration(milliseconds: 500),
    this.popoverAlignment = Alignment.topCenter,
    this.anchorAlignment = Alignment.bottomCenter,
    this.popoverOffset = const Offset(0.0, 8.0),
    this.behavior = HitTestBehavior.deferToChild,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Duration debounce;
  final Duration wait;
  final AlignmentGeometry popoverAlignment;
  final AlignmentGeometry anchorAlignment;
  final Offset popoverOffset;
  final HitTestBehavior behavior;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const hoverCardThemeTokens = HoverCardThemeTokens();
