// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:country_flags/country_flags.dart';
import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class PhoneInputThemeDefaults {
  const PhoneInputThemeDefaults({
    this.padding = const EdgeInsets.only(
      top: 8.0,
      left: 8.0,
      bottom: 8.0,
      right: 4.0,
    ),
    this.borderRadius,
    this.popupConstraints = const BoxConstraints(
      maxWidth: 250.0,
      maxHeight: 300.0,
    ),
    this.maxWidth = 200.0,
    this.flagHeight = 18.0,
    this.flagWidth = 24.0,
    this.flagGap = 8.0,
    this.countryGap = 16.0,
    this.flagShape = const RoundedRectangle(4.0),
  });

  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints popupConstraints;
  final double maxWidth;
  final double flagHeight;
  final double flagWidth;
  final double flagGap;
  final double countryGap;
  final Shape flagShape;
}
