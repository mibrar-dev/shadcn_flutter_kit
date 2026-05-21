// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in progress widgets
// ═══════════════════════════════════════════════════════════

class ProgressThemeDefaults {
  const ProgressThemeDefaults({
    this.color,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.minHeight = 8.0,
  });

  /// From `Progress`: `defaultValue: null`
  final Color? color;

  /// From `Progress`: `defaultValue: null`
  final Color? backgroundColor;

  /// From `Progress`: `defaultValue: theme.borderRadiusSm`
  final BorderRadiusGeometry borderRadius;

  /// From `Progress`: `defaultValue: 8.0 * theme.scaling`
  final double minHeight;
}
