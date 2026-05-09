// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror DrawerThemeDefaults
// ═══════════════════════════════════════════════════════════

class DrawerThemeTokens {
  const DrawerThemeTokens({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor = const Color.fromRGBO(0, 0, 0, 0.8),
    this.showDragHandle = true,
    this.dragHandleSize = const Size(6.0, 100.0),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Color barrierColor;
  final bool showDragHandle;
  final Size dragHandleSize;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const drawerThemeTokens = DrawerThemeTokens();
