// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in file picker widgets
// ═══════════════════════════════════════════════════════════

class FileUploadDropzoneThemeDefaults {
  const FileUploadDropzoneThemeDefaults({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.minHeight = 220.0,
    this.icon,
  });

  /// From file upload surfaces: fallback to widget/theme/default surface color behavior.
  final Color? backgroundColor;

  /// From file upload surfaces: fallback to widget/theme/default border radius behavior.
  final BorderRadiusGeometry? borderRadius;

  /// From file upload surfaces: fallback to widget/theme/default padding behavior.
  final EdgeInsetsGeometry? padding;

  /// From `_buildDragDropSurface`: `dropzoneTheme?.minHeight ?? 220 * scaling`
  final double minHeight;

  /// From upload content builder: theme value is nullable and widget supplies
  /// its own fallback icon when this is null.
  final Widget? icon;
}
