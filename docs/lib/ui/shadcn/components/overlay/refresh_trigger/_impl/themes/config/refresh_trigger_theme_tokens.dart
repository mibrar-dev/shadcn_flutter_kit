// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../refresh_trigger.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror RefreshTriggerThemeDefaults
// ═══════════════════════════════════════════════════════════

class RefreshTriggerThemeTokens {
  const RefreshTriggerThemeTokens({
    this.minExtent = 75.0,
    this.maxExtent = 150.0,
    this.indicatorBuilder = RefreshTrigger.defaultIndicatorBuilder,
    this.curve = Curves.easeOutSine,
    this.completeDuration = const Duration(milliseconds: 500),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double minExtent;
  final double maxExtent;
  final RefreshIndicatorBuilder indicatorBuilder;
  final Curve curve;
  final Duration completeDuration;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const refreshTriggerThemeTokens = RefreshTriggerThemeTokens();
