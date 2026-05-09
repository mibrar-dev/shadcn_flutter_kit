// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror AlertThemeDefaults
// ═══════════════════════════════════════════════════════════

class AlertThemeTokens {
  const AlertThemeTokens({
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE5E5E5),
    this.destructive = false,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final bool destructive;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const alertThemeTokens = AlertThemeTokens();
