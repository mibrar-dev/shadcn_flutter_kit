// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in modal backdrop widgets
// ═══════════════════════════════════════════════════════════

class ModalBackdropThemeDefaults {
  const ModalBackdropThemeDefaults({
    this.borderRadius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
    this.barrierColor = const Color.fromRGBO(0, 0, 0, 0.8),
    this.modal = true,
    this.surfaceClip = true,
  });

  /// From `ModalBackdrop`: `defaultValue: BorderRadius.zero`
  final BorderRadiusGeometry borderRadius;

  /// From `ModalBackdrop`: `defaultValue: EdgeInsets.zero`
  final EdgeInsetsGeometry padding;

  /// From `ModalBackdrop`: `defaultValue: Color.fromRGBO(0, 0, 0, 0.8)`
  final Color barrierColor;

  /// From `ModalBackdrop`: `defaultValue: true`
  final bool modal;

  /// From `ModalBackdrop`: `defaultValue: true`
  final bool surfaceClip;
}
