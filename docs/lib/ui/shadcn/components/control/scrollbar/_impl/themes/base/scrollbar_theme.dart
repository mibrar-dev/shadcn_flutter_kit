// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';

/// Theme configuration for Scrollbar.
class ScrollbarTheme extends ComponentThemeData {
  /// Stores `color` state/configuration for this implementation.
  final Color? color;

  /// Stores `thickness` state/configuration for this implementation.
  final double? thickness;

  /// Stores `radius` state/configuration for this implementation.
  final Radius? radius;

  /// Creates a `ScrollbarTheme` instance.
  const ScrollbarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.thickness,
    this.radius,
  });

  /// Creates a `ScrollbarTheme` instance.
  ScrollbarTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<double?>? thickness,
    ValueGetter<Radius?>? radius,
  }) {
    return ScrollbarTheme(
      color: color == null ? this.color : color(),
      thickness: thickness == null ? this.thickness : thickness(),
      radius: radius == null ? this.radius : radius(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScrollbarTheme &&
        other.color == color &&
        other.thickness == thickness &&
        other.radius == radius;
  }

  @override
  int get hashCode => Object.hash(color, thickness, radius);
}
