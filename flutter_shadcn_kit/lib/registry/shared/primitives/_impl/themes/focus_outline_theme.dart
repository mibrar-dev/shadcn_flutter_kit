// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../focus_outline.dart';

/// FocusOutlineTheme defines a reusable type for this registry module.
class FocusOutlineTheme extends ComponentThemeData {
  /// Stores `align` state/configuration for this implementation.
  final double? align;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Stores `border` state/configuration for this implementation.
  final Border? border;

  /// Creates a `FocusOutlineTheme` instance.
  const FocusOutlineTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.align,
    this.border,
    this.borderRadius,
  });

  /// Creates a `FocusOutlineTheme` instance.
  FocusOutlineTheme copyWith({
    ValueGetter<Border?>? border,
    ValueGetter<double?>? align,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return FocusOutlineTheme(
      align: align == null ? this.align : align(),
      border: border == null ? this.border : border(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FocusOutlineTheme &&
        other.align == align &&
        other.border == border &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(border, align, borderRadius);
}
