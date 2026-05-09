// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in drawer widgets
// ═══════════════════════════════════════════════════════════

class DrawerThemeDefaults {
  const DrawerThemeDefaults({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor = const Color.fromRGBO(0, 0, 0, 0.8),
    this.showDragHandle = true,
    this.dragHandleSize = const Size(6.0, 100.0),
  });

  /// From drawer theme/api: fallback to `theme.surfaceOpacity`.
  final double? surfaceOpacity;

  /// From drawer theme/api: fallback to `theme.surfaceBlur`.
  final double? surfaceBlur;

  /// From drawer wrappers: fallback to `Colors.black.scaleAlpha(0.8)`.
  final Color barrierColor;

  /// From drawer API: `theme?.showDragHandle ?? true`
  final bool showDragHandle;

  /// From drawer wrappers: fallback drag-handle size for edge drawers.
  final Size dragHandleSize;
}
