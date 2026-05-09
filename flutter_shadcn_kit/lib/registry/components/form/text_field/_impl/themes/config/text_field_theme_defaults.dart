// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in text field widgets
// ═══════════════════════════════════════════════════════════

class TextFieldThemeDefaults {
  const TextFieldThemeDefaults({
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.filled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.border = const Border.fromBorderSide(
      BorderSide(
        color: Color(0xFFE5E5E5),
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
    ),
  });

  /// From `TextFieldState`: fallback to `BorderRadius.circular(theme.radiusMd)`
  final BorderRadiusGeometry borderRadius;

  /// From `TextFieldState`: `(widget.filled ?? compTheme?.filled ?? false)`
  final bool filled;

  /// From `TextFieldState`: density-based symmetric fallback padding.
  final EdgeInsetsGeometry padding;

  /// From `TextFieldState`: `Border.all(color: theme.colorScheme.border, strokeAlign: center)`
  final Border border;
}
