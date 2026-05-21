// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in hover widgets
// ═══════════════════════════════════════════════════════════

class HoverThemeDefaults {
  const HoverThemeDefaults({
    this.debounceDuration = const Duration(milliseconds: 100),
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.waitDuration = const Duration(milliseconds: 500),
    this.minDuration = const Duration(milliseconds: 0),
    this.showDuration = const Duration(milliseconds: 200),
  });

  /// From `HoverActivityState`: `defaultValue: Duration(milliseconds: 100)`
  final Duration debounceDuration;

  /// From hover states: `defaultValue: HitTestBehavior.deferToChild`
  final HitTestBehavior hitTestBehavior;

  /// From `HoverState`: `defaultValue: Duration(milliseconds: 500)`
  final Duration waitDuration;

  /// From `HoverState`: `defaultValue: Duration(milliseconds: 0)`
  final Duration minDuration;

  /// From `HoverState`: `defaultValue: Duration(milliseconds: 200)`
  final Duration showDuration;
}
