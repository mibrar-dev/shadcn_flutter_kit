// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror HoverThemeDefaults
// ═══════════════════════════════════════════════════════════

class HoverThemeTokens {
  const HoverThemeTokens({
    this.debounceDuration = const Duration(milliseconds: 100),
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.waitDuration = const Duration(milliseconds: 500),
    this.minDuration = const Duration(milliseconds: 0),
    this.showDuration = const Duration(milliseconds: 200),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Duration debounceDuration;
  final HitTestBehavior hitTestBehavior;
  final Duration waitDuration;
  final Duration minDuration;
  final Duration showDuration;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const hoverThemeTokens = HoverThemeTokens();
