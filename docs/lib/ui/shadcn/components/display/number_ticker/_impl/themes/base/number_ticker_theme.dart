// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../number_ticker.dart';

/// Theme data for [NumberTicker].
class NumberTickerTheme extends ComponentThemeData {
  /// Animation/progress setting used by number ticker transitions.
  final Duration? duration;

  /// Animation/progress setting used by number ticker transitions.
  final Curve? curve;

  /// Style/theme override that customizes `NumberTickerTheme` appearance.
  final TextStyle? style;

  /// Creates `NumberTickerTheme` for configuring or rendering number ticker.
  const NumberTickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.duration,
    this.curve,
    this.style,
  });

  NumberTickerTheme copyWith({
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
    ValueGetter<TextStyle?>? style,
  }) {
    return NumberTickerTheme(
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
      style: style == null ? this.style : style(),
    );
  }

  /// Compares two number ticker values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NumberTickerTheme &&
        other.duration == duration &&
        other.curve == curve &&
        other.style == style;
  }

  /// State flag that toggles specific number ticker behavior.
  @override
  int get hashCode => Object.hash(duration, curve, style);
}
