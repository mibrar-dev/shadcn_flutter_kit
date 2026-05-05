part of '../../../card.dart';

/// Theme data for customizing [Card] and [SurfaceCard] widget appearance.
class CardTheme extends ComponentThemeData {
  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Whether the card is filled.
  final bool? filled;

  /// The fill color when [filled] is true.
  final Color? fillColor;

  /// Border radius of the card.
  final BorderRadiusGeometry? borderRadius;

  /// Border color of the card.
  final Color? borderColor;

  /// Border width of the card.
  final double? borderWidth;

  /// Clip behavior of the card.
  final Clip? clipBehavior;

  /// Box shadow of the card.
  final List<BoxShadow>? boxShadow;

  /// Surface opacity for blurred background.
  final double? surfaceOpacity;

  /// Surface blur for blurred background.
  final double? surfaceBlur;

  /// Animation duration for transitions.
  final Duration? duration;

  /// Creates a [CardTheme].
  const CardTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.padding,
    this.filled,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.clipBehavior,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
  });

  /// Creates a copy of this theme with the given values replaced.
  CardTheme copyWith({
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<bool?>? filled,
    ValueGetter<Color?>? fillColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<Color?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<Clip?>? clipBehavior,
    ValueGetter<List<BoxShadow>?>? boxShadow,
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<Duration?>? duration,
  }) {
    return CardTheme(
      padding: padding == null ? this.padding : padding(),
      filled: filled == null ? this.filled : filled(),
      fillColor: fillColor == null ? this.fillColor : fillColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      clipBehavior: clipBehavior == null ? this.clipBehavior : clipBehavior(),
      boxShadow: boxShadow == null ? this.boxShadow : boxShadow(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      duration: duration == null ? this.duration : duration(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardTheme &&
        other.padding == padding &&
        other.filled == filled &&
        other.fillColor == fillColor &&
        other.borderRadius == borderRadius &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.clipBehavior == clipBehavior &&
        other.boxShadow == boxShadow &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(
    padding,
    filled,
    fillColor,
    borderRadius,
    borderColor,
    borderWidth,
    clipBehavior,
    boxShadow,
    surfaceOpacity,
    surfaceBlur,
    duration,
  );
}
