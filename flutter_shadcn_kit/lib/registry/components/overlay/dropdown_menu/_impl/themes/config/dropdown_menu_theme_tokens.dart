// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror DropdownMenuThemeDefaults
// ═══════════════════════════════════════════════════════════

class DropdownMenuThemeTokens {
  const DropdownMenuThemeTokens({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.minWidth = 192.0,
    this.subMenuOffset = const Offset(8.0, -4.0),
    this.direction = Axis.vertical,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double? surfaceOpacity;
  final double? surfaceBlur;
  final double minWidth;
  final Offset subMenuOffset;
  final Axis direction;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const dropdownMenuThemeTokens = DropdownMenuThemeTokens();
