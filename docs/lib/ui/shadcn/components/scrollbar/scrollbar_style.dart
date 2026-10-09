// Registry-owned theme data for the `scrollbar` component: the flat
// [ScrollbarTheme] container and its token-derived `scrollbarDefaults`.
//
// The widget is a thin styled wrapper around Flutter's `RawScrollbar`, so the
// theme carries exactly the values RawScrollbar paints with. User-owned
// overrides live in `scrollbar_theme.dart`; CLI updates may replace this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../primitives/scroll_metrics.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Default thumb thickness in logical pixels, times the ambient scaling.
const double scrollbarDefaultThickness = 7;

/// Theme container for the scrollbar component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ScrollbarTheme extends ComponentThemeData
    implements Mergeable<ScrollbarTheme> {
  /// Creates a scrollbar theme.
  const ScrollbarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.thickness,
    this.radius,
    this.minThumbLength,
    this.minOverscrollLength,
    this.interactive,
  });

  /// Thumb colour. Default: the `border` token.
  final ThemedColor? color;

  /// Thumb thickness. Default: [scrollbarDefaultThickness] times scaling.
  final double? thickness;

  /// Thumb corner radius. Default: `radiusSm` from the ambient tokens.
  final Radius? radius;

  /// Minimum thumb length. Default: [kMinScrollbarThumbExtent].
  final double? minThumbLength;

  /// Minimum thumb length while dragged past an edge; null follows
  /// [minThumbLength] (Flutter's `RawScrollbar` contract).
  final double? minOverscrollLength;

  /// Whether the thumb responds to drags. Default: true.
  final bool? interactive;

  /// Returns a copy with the given fields replaced.
  ScrollbarTheme copyWith({
    ValueGetter<ThemedColor?>? color,
    ValueGetter<double?>? thickness,
    ValueGetter<Radius?>? radius,
    ValueGetter<double?>? minThumbLength,
    ValueGetter<double?>? minOverscrollLength,
    ValueGetter<bool?>? interactive,
  }) {
    return ScrollbarTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      color: color == null ? this.color : color(),
      thickness: thickness == null ? this.thickness : thickness(),
      radius: radius == null ? this.radius : radius(),
      minThumbLength: minThumbLength == null
          ? this.minThumbLength
          : minThumbLength(),
      minOverscrollLength: minOverscrollLength == null
          ? this.minOverscrollLength
          : minOverscrollLength(),
      interactive: interactive == null ? this.interactive : interactive(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ScrollbarTheme merge(ScrollbarTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ScrollbarTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      color: color ?? fallback.color,
      thickness: thickness ?? fallback.thickness,
      radius: radius ?? fallback.radius,
      minThumbLength: minThumbLength ?? fallback.minThumbLength,
      minOverscrollLength: minOverscrollLength ?? fallback.minOverscrollLength,
      interactive: interactive ?? fallback.interactive,
    );
  }

  /// Colours and the interactive flag step at `t = 0.5`; dimensions are
  /// lerped.
  static ScrollbarTheme lerp(ScrollbarTheme a, ScrollbarTheme b, double t) {
    return ScrollbarTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      color: t < 0.5 ? a.color : b.color,
      thickness: lerpDouble(a.thickness, b.thickness, t),
      radius: Radius.lerp(a.radius, b.radius, t),
      minThumbLength: lerpDouble(a.minThumbLength, b.minThumbLength, t),
      minOverscrollLength: lerpDouble(
        a.minOverscrollLength,
        b.minOverscrollLength,
        t,
      ),
      interactive: t < 0.5 ? a.interactive : b.interactive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ScrollbarTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.color == color &&
        other.thickness == thickness &&
        other.radius == radius &&
        other.minThumbLength == minThumbLength &&
        other.minOverscrollLength == minOverscrollLength &&
        other.interactive == interactive;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    color,
    thickness,
    radius,
    minThumbLength,
    minOverscrollLength,
    interactive,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
const ScrollbarTheme scrollbarDefaults = ScrollbarTheme(
  color: ThemedColor.ref(ColorRef.border),
  minThumbLength: kMinScrollbarThumbExtent,
);
