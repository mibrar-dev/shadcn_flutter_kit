part of '../../focus_outline.dart';

class FocusOutlineTheme extends ComponentThemeData {
  final double? align;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;

  const FocusOutlineTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.align,
    this.border,
    this.borderRadius,
  });

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
