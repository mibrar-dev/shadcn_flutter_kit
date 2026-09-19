// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';

/// Theme configuration for [IconContainer] widget styling.
///
/// Defines background color, icon color, padding, and border radius for
/// icon containers. Applied globally through [ComponentTheme] or per-instance
/// via the `theme` parameter.
class IconContainerTheme extends ComponentThemeData {
  /// Background color for the icon container.
  final Color? backgroundColor;

  /// Color for the icon inside the container.
  final Color? iconColor;

  /// Padding inside the icon container.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the icon container.
  final BorderRadius? borderRadius;

  /// Creates an [IconContainerTheme].
  ///
  /// Parameters:
  /// - [backgroundColor] (`Color?`, optional): Container background color.
  /// - [iconColor] (`Color?`, optional): Icon color.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): Container padding.
  /// - [borderRadius] (`BorderRadius?`, optional): Container border radius.
  const IconContainerTheme({
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.borderRadius,
  });

  /// Returns a copy of this theme with the given fields replaced.
  IconContainerTheme copyWith({
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<Color?>? iconColor,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderRadius?>? borderRadius,
  }) {
    return IconContainerTheme(
      backgroundColor: backgroundColor != null
          ? backgroundColor()
          : this.backgroundColor,
      iconColor: iconColor != null ? iconColor() : this.iconColor,
      padding: padding != null ? padding() : this.padding,
      borderRadius: borderRadius != null ? borderRadius() : this.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IconContainerTheme &&
        other.backgroundColor == backgroundColor &&
        other.iconColor == iconColor &&
        other.padding == padding &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode {
    return Object.hash(backgroundColor, iconColor, padding, borderRadius);
  }
}
