// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../focus_outline.dart';

/// Theme configuration for focus outlines.
class FocusOutlineTheme extends ComponentThemeData {
  /// Offset applied when drawing the outline.
  final double? align;

  /// Border radius for rounded outlines.
  final BorderRadiusGeometry? borderRadius;

  /// Border style used by the outline.
  final Border? border;

  /// Creates a theme for [FocusOutline].
  const FocusOutlineTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.align,
    this.borderRadius,
    this.border,
  });

  /// Copies this theme with selected overrides.
  FocusOutlineTheme copyWith({
    ValueGetter<double?>? align,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<Border?>? border,
  }) {
    return FocusOutlineTheme(
      align: align == null ? this.align : align(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      border: border == null ? this.border : border(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is FocusOutlineTheme &&
        other.align == align &&
        other.borderRadius == borderRadius &&
        other.border == border;
  }

  @override
  int get hashCode => Object.hash(align, borderRadius, border);
}
