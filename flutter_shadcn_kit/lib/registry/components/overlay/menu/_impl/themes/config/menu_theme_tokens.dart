// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class MenuThemeTokens {
  const MenuThemeTokens({
    this.itemPadding = EdgeInsets.zero,
    this.subMenuOffset = const Offset(8.0, -5.0),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final EdgeInsets itemPadding;
  final Offset subMenuOffset;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const menuThemeTokens = MenuThemeTokens();

class MenuPopupThemeTokens {
  const MenuPopupThemeTokens({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double? surfaceOpacity;
  final double? surfaceBlur;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const menuPopupThemeTokens = MenuPopupThemeTokens();

class MenubarThemeTokens {
  const MenubarThemeTokens({
    this.border = true,
    this.subMenuOffset = const Offset(-4.0, 8.0),
    this.padding,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final bool border;
  final Offset subMenuOffset;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const menubarThemeTokens = MenubarThemeTokens();
