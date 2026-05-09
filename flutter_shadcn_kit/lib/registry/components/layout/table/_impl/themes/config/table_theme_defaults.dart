// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../table.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class TableThemeDefaults {
  const TableThemeDefaults({
    this.border,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.cellTheme,
  });

  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final Color backgroundColor;
  final TableCellTheme? cellTheme;
}

class ResizableTableThemeDefaults {
  const ResizableTableThemeDefaults({
    this.tableTheme,
    this.resizerThickness = 4.0,
    this.resizerColor = const Color(0xFF171717),
  });

  final TableTheme? tableTheme;
  final double resizerThickness;
  final Color resizerColor;
}
