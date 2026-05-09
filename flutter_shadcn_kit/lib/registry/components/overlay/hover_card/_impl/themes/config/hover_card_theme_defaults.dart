// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class HoverCardThemeDefaults {
  const HoverCardThemeDefaults({
    this.debounce = const Duration(milliseconds: 500),
    this.wait = const Duration(milliseconds: 500),
    this.popoverAlignment = Alignment.topCenter,
    this.anchorAlignment = Alignment.bottomCenter,
    this.popoverOffset = const Offset(0.0, 8.0),
    this.behavior = HitTestBehavior.deferToChild,
  });

  final Duration debounce;
  final Duration wait;
  final AlignmentGeometry popoverAlignment;
  final AlignmentGeometry anchorAlignment;
  final Offset popoverOffset;
  final HitTestBehavior behavior;
}
