// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in scrollbar widgets
// ═══════════════════════════════════════════════════════════

class ScrollbarThemeDefaults {
  const ScrollbarThemeDefaults({
    this.color = const Color(0xFFE5E5E5),
    this.thickness = 7.0,
    this.radius = const Radius.circular(4.0),
    this.minLength = 48.0,
    this.hoverAnimationDuration = const Duration(milliseconds: 200),
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.interactive = true,
  });

  /// From `ShadcnScrollbarState`: `defaultValue: theme.colorScheme.border`
  final Color color;

  /// From `ShadcnScrollbarState`: `defaultValue: 7.0 * theme.scaling`
  final double thickness;

  /// From `ShadcnScrollbarState`: `defaultValue: Radius.circular(theme.radiusSm)`
  final Radius radius;

  /// From `_kScrollbarMinLength`
  final double minLength;

  /// From `AnimationController(duration: 200ms)`
  final Duration hoverAnimationDuration;

  /// From `_kScrollbarFadeDuration`
  final Duration fadeDuration;

  /// From `_kScrollbarTimeToFade`
  final Duration timeToFade;

  /// From `enableGestures => widget.interactive ?? true`
  final bool interactive;
}
