// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror FormattedInputThemeDefaults
// ═══════════════════════════════════════════════════════════

class FormattedInputThemeTokens {
  const FormattedInputThemeTokens({
    this.height = 34.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const formattedInputThemeTokens = FormattedInputThemeTokens();
