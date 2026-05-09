// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';

/// Theme overrides for the FileUpload dropzone surface.
class FileUploadDropzoneTheme extends ComponentThemeData {
  const FileUploadDropzoneTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.icon,
  });

  /// Background color for the dropzone container.
  final Color? backgroundColor;

  /// Border radius for the dropzone container.
  final BorderRadiusGeometry? borderRadius;

  /// Internal padding for the dropzone content.
  final EdgeInsetsGeometry? padding;

  /// Minimum height for the dropzone surface.
  final double? minHeight;

  /// Optional icon widget used in the default dropzone content.
  final Widget? icon;
}
