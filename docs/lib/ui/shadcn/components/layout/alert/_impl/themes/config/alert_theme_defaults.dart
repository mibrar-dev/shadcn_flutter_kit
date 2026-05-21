// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in alert widgets
// ═══════════════════════════════════════════════════════════

class AlertThemeDefaults {
  const AlertThemeDefaults({
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE5E5E5),
    this.destructive = false,
  });

  /// From `Alert`: `EdgeInsets.symmetric(horizontal: 16 * scaling, vertical: 12 * scaling)`
  final EdgeInsetsGeometry padding;

  /// From `Alert`: `defaultValue: theme.colorScheme.card`
  final Color backgroundColor;

  /// From `Alert`: `defaultValue: theme.colorScheme.border`
  final Color borderColor;

  /// From `Alert`: `destructive = false`
  final bool destructive;
}
