// Registry-owned theme data for the `number_ticker` component.
//
// User-owned overrides live in `number_ticker_theme.dart`; CLI updates may
// replace this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme of the animated number ticker.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget).
class NumberTickerTheme extends ComponentThemeData
    implements Mergeable<NumberTickerTheme> {
  /// Creates a number ticker theme.
  const NumberTickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.duration,
    this.curve,
    this.style,
  });

  /// Animation duration. Default: 500ms.
  final Duration? duration;

  /// Animation curve. Default: `Curves.easeInOut`.
  final Curve? curve;

  /// Text style; null inherits the ambient style.
  final TextStyle? style;

  /// Returns a copy with the given fields replaced.
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

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  NumberTickerTheme merge(NumberTickerTheme? fallback) {
    if (fallback == null) return this;
    return NumberTickerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      duration: duration ?? fallback.duration,
      curve: curve ?? fallback.curve,
      style: style ?? fallback.style,
    );
  }

  /// Steps at `t = 0.5`, except the duration which interpolates.
  static NumberTickerTheme lerp(
    NumberTickerTheme a,
    NumberTickerTheme b,
    double t,
  ) {
    Duration? span(Duration? x, Duration? y) {
      if (x == null) return y;
      if (y == null) return x;
      return Duration(
        microseconds:
            (x.inMicroseconds + (y.inMicroseconds - x.inMicroseconds) * t)
                .round(),
      );
    }

    return NumberTickerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      duration: span(a.duration, b.duration),
      curve: t < 0.5 ? a.curve : b.curve,
      style: TextStyle.lerp(a.style, b.style, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NumberTickerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.duration == duration &&
        other.curve == curve &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    duration,
    curve,
    style,
  );
}

/// Built-in number ticker defaults.
const NumberTickerTheme numberTickerDefaults = NumberTickerTheme(
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
);
