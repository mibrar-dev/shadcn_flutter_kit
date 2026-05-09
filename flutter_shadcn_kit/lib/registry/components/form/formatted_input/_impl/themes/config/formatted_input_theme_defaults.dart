// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in formatted input widgets
// ═══════════════════════════════════════════════════════════

class FormattedInputThemeDefaults {
  const FormattedInputThemeDefaults({
    this.height = 34.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0),
  });

  /// From `_FormattedInputState`: `compTheme?.height ?? kTextFieldHeight`
  final double height;

  /// From `_FormattedInputState`: `EdgeInsets.symmetric(horizontal: ... * 0.75)`
  final EdgeInsetsGeometry padding;
}
