// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../navigation_bar.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class NavigationBarThemeDefaults {
  const NavigationBarThemeDefaults({
    this.backgroundColor,
    this.alignment = NavigationBarAlignment.center,
    this.direction = Axis.horizontal,
    this.spacing = 8.0,
    this.labelType = NavigationLabelType.none,
    this.labelPosition = NavigationLabelPosition.bottom,
    this.labelSize = NavigationLabelSize.small,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
  });

  final Color? backgroundColor;
  final NavigationBarAlignment alignment;
  final Axis direction;
  final double spacing;
  final NavigationLabelType labelType;
  final NavigationLabelPosition labelPosition;
  final NavigationLabelSize labelSize;
  final EdgeInsetsGeometry padding;
}
