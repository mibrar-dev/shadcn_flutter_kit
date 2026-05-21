// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../stage_container.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror StageContainerThemeDefaults
// ═══════════════════════════════════════════════════════════

class StageContainerThemeTokens {
  const StageContainerThemeTokens({
    this.breakpoint = StageBreakpoint.defaultBreakpoints,
    this.padding = const EdgeInsets.symmetric(horizontal: 72.0),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final StageBreakpoint breakpoint;
  final EdgeInsets padding;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const stageContainerThemeTokens = StageContainerThemeTokens();
