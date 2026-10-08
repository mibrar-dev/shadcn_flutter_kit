// Registry-owned theme data for the `slider` component: the state-aware
// [SliderStyle] slice, the per-variant [SliderTheme] container and the
// token-derived `sliderDefaults` rows.
//
// User-owned overrides live in `slider_theme.dart`; CLI updates may replace
// this file. The [SliderVariant] enum lives here so the style layer never
// imports the widget layer; `slider.dart` re-exports it.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../primitives/slider/slider_painter.dart'
    show SliderMarksStyle, SliderThumbShape;
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual variants of the slider component.
///
/// Maps to the old presets: `standard` <- `brightness` (bar thumb, pill
/// track), `soft` <- `rangeSoft` (circle thumb, thicker track), `dots` <-
/// `stepsDots` (circle thumb, dot marks), `wave` <- `waveform` (circle
/// thumb, bar marks).
enum SliderVariant {
  /// Default filled pill with a bar thumb.
  standard,

  /// Thicker track with a circle thumb.
  soft,

  /// Circle thumb with per-step dots.
  dots,

  /// Circle thumb with an audio-wave bar overlay.
  wave,
}

/// One variant's styling slice. Every field is nullable: an override leg sets
/// only what it changes and [merge] keeps the lower leg's remaining fields.
class SliderStyle implements Mergeable<SliderStyle> {
  /// Creates a slider style slice.
  const SliderStyle({
    this.track,
    this.fill,
    this.thumb,
    this.thumbBorder,
    this.mark,
    this.trackHeight,
    this.trackRadius,
    this.thumbSize,
    this.thumbShape,
  });

  /// Track (remaining) color.
  final StateValue<ThemedColor>? track;

  /// Fill (active range) color.
  final StateValue<ThemedColor>? fill;

  /// Thumb fill color.
  final StateValue<ThemedColor>? thumb;

  /// Thumb border color (circle thumb).
  final StateValue<ThemedColor>? thumbBorder;

  /// Mark (dot/bar) color for unfilled marks.
  final StateValue<ThemedColor>? mark;

  /// Track height in logical pixels.
  final double? trackHeight;

  /// Track corner radius; clamped to half the track height at paint time.
  final double? trackRadius;

  /// Thumb layout size.
  final Size? thumbSize;

  /// Thumb shape for this variant.
  final SliderThumbShape? thumbShape;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SliderStyle merge(SliderStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return SliderStyle(
      track: track?.merge(fallback.track) ?? fallback.track,
      fill: fill?.merge(fallback.fill) ?? fallback.fill,
      thumb: thumb?.merge(fallback.thumb) ?? fallback.thumb,
      thumbBorder:
          thumbBorder?.merge(fallback.thumbBorder) ?? fallback.thumbBorder,
      mark: mark?.merge(fallback.mark) ?? fallback.mark,
      trackHeight: trackHeight ?? fallback.trackHeight,
      trackRadius: trackRadius ?? fallback.trackRadius,
      thumbSize: thumbSize ?? fallback.thumbSize,
      thumbShape: thumbShape ?? fallback.thumbShape,
    );
  }

  /// State scales are stepped at t < 0.5; dimensions are lerped.
  static SliderStyle lerp(SliderStyle a, SliderStyle b, double t) {
    return SliderStyle(
      track: t < 0.5 ? a.track : b.track,
      fill: t < 0.5 ? a.fill : b.fill,
      thumb: t < 0.5 ? a.thumb : b.thumb,
      thumbBorder: t < 0.5 ? a.thumbBorder : b.thumbBorder,
      mark: t < 0.5 ? a.mark : b.mark,
      trackHeight: lerpDouble(a.trackHeight, b.trackHeight, t),
      trackRadius: lerpDouble(a.trackRadius, b.trackRadius, t),
      thumbSize: Size.lerp(a.thumbSize, b.thumbSize, t),
      thumbShape: t < 0.5 ? a.thumbShape : b.thumbShape,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SliderStyle &&
        other.track == track &&
        other.fill == fill &&
        other.thumb == thumb &&
        other.thumbBorder == thumbBorder &&
        other.mark == mark &&
        other.trackHeight == trackHeight &&
        other.trackRadius == trackRadius &&
        other.thumbSize == thumbSize &&
        other.thumbShape == thumbShape;
  }

  @override
  int get hashCode => Object.hash(
    track,
    fill,
    thumb,
    thumbBorder,
    mark,
    trackHeight,
    trackRadius,
    thumbSize,
    thumbShape,
  );
}

/// Marks overlay for a [variant]; the variants-are-data table.
SliderMarksStyle marksStyleForVariant(SliderVariant variant) {
  return switch (variant) {
    SliderVariant.standard || SliderVariant.soft => SliderMarksStyle.none,
    SliderVariant.dots => SliderMarksStyle.dots,
    SliderVariant.wave => SliderMarksStyle.wave,
  };
}

/// Per-variant theme container for the slider component.
class SliderTheme extends ComponentThemeData implements Mergeable<SliderTheme> {
  /// Creates a slider theme with one nullable slice per variant.
  const SliderTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.standard,
    this.soft,
    this.dots,
    this.wave,
  });

  /// Style for [SliderVariant.standard].
  final SliderStyle? standard;

  /// Style for [SliderVariant.soft].
  final SliderStyle? soft;

  /// Style for [SliderVariant.dots].
  final SliderStyle? dots;

  /// Style for [SliderVariant.wave].
  final SliderStyle? wave;

  /// The slice for [variant], or null when this leg leaves it unset.
  SliderStyle? forVariant(SliderVariant variant) {
    return switch (variant) {
      SliderVariant.standard => standard,
      SliderVariant.soft => soft,
      SliderVariant.dots => dots,
      SliderVariant.wave => wave,
    };
  }

  /// Returns a copy with the given variant rows replaced.
  SliderTheme copyWith({
    ValueGetter<SliderStyle?>? standard,
    ValueGetter<SliderStyle?>? soft,
    ValueGetter<SliderStyle?>? dots,
    ValueGetter<SliderStyle?>? wave,
  }) {
    return SliderTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      standard: standard == null ? this.standard : standard(),
      soft: soft == null ? this.soft : soft(),
      dots: dots == null ? this.dots : dots(),
      wave: wave == null ? this.wave : wave(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SliderTheme merge(SliderTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SliderTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      standard: standard?.merge(fallback.standard) ?? fallback.standard,
      soft: soft?.merge(fallback.soft) ?? fallback.soft,
      dots: dots?.merge(fallback.dots) ?? fallback.dots,
      wave: wave?.merge(fallback.wave) ?? fallback.wave,
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static SliderTheme lerp(SliderTheme a, SliderTheme b, double t) {
    SliderStyle? row(SliderStyle? x, SliderStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return SliderStyle.lerp(x, y, t);
    }

    return SliderTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      standard: row(a.standard, b.standard),
      soft: row(a.soft, b.soft),
      dots: row(a.dots, b.dots),
      wave: row(a.wave, b.wave),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SliderTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.standard == standard &&
        other.soft == soft &&
        other.dots == dots &&
        other.wave == wave;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    standard,
    soft,
    dots,
    wave,
  );
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// Disabled states are intentionally absent: every `StateValue` falls back to
// its `rest` entry, and `Slider` dims the whole control to 50% opacity when
// disabled (shadcn `disabled:opacity-50`).
// ---------------------------------------------------------------------------

const _standardRow = SliderStyle(
  track: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
  fill: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  thumb: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  mark: StateValue(rest: ThemedColor.ref(ColorRef.mutedForeground)),
  trackHeight: 6,
  thumbSize: Size(20, 20),
  thumbShape: SliderThumbShape.bar,
);

const _softRow = SliderStyle(
  track: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
  fill: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  thumb: StateValue(rest: ThemedColor.ref(ColorRef.background)),
  thumbBorder: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  mark: StateValue(rest: ThemedColor.ref(ColorRef.mutedForeground)),
  trackHeight: 8,
  thumbSize: Size(18, 18),
  thumbShape: SliderThumbShape.circle,
);

const _dotsRow = SliderStyle(
  track: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
  fill: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  thumb: StateValue(rest: ThemedColor.ref(ColorRef.background)),
  thumbBorder: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  mark: StateValue(rest: ThemedColor.ref(ColorRef.mutedForeground)),
  trackHeight: 4,
  thumbSize: Size(16, 16),
  thumbShape: SliderThumbShape.circle,
);

const _waveRow = SliderStyle(
  track: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
  fill: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  thumb: StateValue(rest: ThemedColor.ref(ColorRef.background)),
  thumbBorder: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  mark: StateValue(rest: ThemedColor.ref(ColorRef.mutedForeground)),
  trackHeight: 4,
  thumbSize: Size(16, 16),
  thumbShape: SliderThumbShape.circle,
);

/// Token-derived baseline rows; every unset override field falls through here.
const SliderTheme sliderDefaults = SliderTheme(
  standard: _standardRow,
  soft: _softRow,
  dots: _dotsRow,
  wave: _waveRow,
);
