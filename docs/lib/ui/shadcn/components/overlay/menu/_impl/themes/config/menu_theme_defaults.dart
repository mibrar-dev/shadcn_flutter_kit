// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class MenuThemeDefaults {
  const MenuThemeDefaults({
    this.itemPadding = EdgeInsets.zero,
    this.subMenuOffset = const Offset(8.0, -5.0),
  });

  final EdgeInsets itemPadding;
  final Offset subMenuOffset;
}

class MenuPopupThemeDefaults {
  const MenuPopupThemeDefaults({
    this.surfaceOpacity,
    this.surfaceBlur,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
  });

  final double? surfaceOpacity;
  final double? surfaceBlur;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
}

class MenubarThemeDefaults {
  const MenubarThemeDefaults({
    this.border = true,
    this.subMenuOffset = const Offset(-4.0, 8.0),
    this.padding,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
  });

  final bool border;
  final Offset subMenuOffset;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
}
