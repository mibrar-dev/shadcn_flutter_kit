// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in context menu widgets
// ═══════════════════════════════════════════════════════════

class ContextMenuThemeDefaults {
  const ContextMenuThemeDefaults({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.direction = Axis.vertical,
    this.popupAnimationDuration = const Duration(milliseconds: 100),
    this.maxWidth = 192.0,
  });

  /// From `MenuPopup`: `defaultValue: theme.surfaceOpacity`
  final double? surfaceOpacity;

  /// From `MenuPopup`: `defaultValue: theme.surfaceBlur`
  final double? surfaceBlur;

  /// From `ContextMenuPopup`: `direction = Axis.vertical`
  final Axis direction;

  /// From `ContextMenuPopup`: `AnimatedValueBuilder duration = 100ms`
  final Duration popupAnimationDuration;

  /// From `ContextMenuPopup`: `LimitedBox(maxWidth: 192 * scaling)`
  final double maxWidth;
}
