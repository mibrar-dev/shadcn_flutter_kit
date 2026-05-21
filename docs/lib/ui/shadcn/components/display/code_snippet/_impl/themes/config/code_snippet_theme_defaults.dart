// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in code snippet widgets
// ═══════════════════════════════════════════════════════════

class CodeSnippetThemeDefaults {
  const CodeSnippetThemeDefaults({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE5E5E5),
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.padding = const EdgeInsets.only(
      left: 16.0,
      right: 56.0,
      top: 16.0,
      bottom: 16.0,
    ),
  });

  /// From `CodeSnippetState`: `defaultValue: theme.colorScheme.card`
  final Color backgroundColor;

  /// From `CodeSnippetState`: `defaultValue: theme.colorScheme.border`
  final Color borderColor;

  /// From `CodeSnippetState`: `defaultValue: theme.scaling`
  final double borderWidth;

  /// From `CodeSnippetState`: `defaultValue: BorderRadius.circular(theme.radiusLg)`
  final BorderRadiusGeometry borderRadius;

  /// From `CodeSnippetState`: density-based `EdgeInsets.only(...)`
  final EdgeInsetsGeometry padding;
}
