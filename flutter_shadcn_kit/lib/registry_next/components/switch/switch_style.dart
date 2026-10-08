// Registry-owned theme data for the `switch` component: the on/off
// [SwitchStyle] slice, the [SwitchTheme] container and the token-derived
// `switchDefaults` rows.
//
// shadcn switch: a `h-[1.15rem] w-8 rounded-full` track (`bg-input` off,
// `bg-primary` on) with a `size-4 rounded-full bg-background` thumb that
// slides across. User-owned overrides live in `switch_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Default switch track size: shadcn `h-[1.15rem] w-8` = 18.4 x 32.
const Size switchDefaultTrackSize = Size(32, 18.4);

/// Default thumb size: shadcn `size-4`.
const double switchDefaultThumbSize = 16;

/// Duration of the track colour and thumb travel.
const Duration switchDefaultDuration = Duration(milliseconds: 100);

/// Fallback label text style before [SwitchTheme.labelStyle] narrows it.
const TextStyle switchDefaultLabelStyle = TextStyle(fontSize: 14);

/// One switch value's styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class SwitchStyle implements Mergeable<SwitchStyle> {
  /// Creates a switch style slice.
  const SwitchStyle({
    this.trackColor,
    this.thumbColor,
    this.borderColor,
    this.borderWidth,
    this.trackSize,
    this.thumbSize,
    this.travel,
    this.gap,
    this.labelStyle,
  });

  /// Per-state fill of the track.
  final StateValue<ThemedColor>? trackColor;

  /// Per-state fill of the thumb.
  final StateValue<ThemedColor>? thumbColor;

  /// Per-state border colour of the track; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Track size; null resolves [switchDefaultTrackSize].
  final Size? trackSize;

  /// Thumb side length; null resolves [switchDefaultThumbSize].
  final double? thumbSize;

  /// Thumb travel between the off and on positions; null derives it from the
  /// track and thumb sizes at build (track width - thumb - 2, the shadcn
  /// `translate-x-[calc(100%-2px)]` slack, minus any border).
  final double? travel;

  /// Space between the switch and [Switch.label]; null resolves 8.
  final double? gap;

  /// Label text style; its colour falls back to the `foreground` token.
  final TextStyle? labelStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SwitchStyle merge(SwitchStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return SwitchStyle(
      trackColor: trackColor?.merge(fallback.trackColor) ?? fallback.trackColor,
      thumbColor: thumbColor?.merge(fallback.thumbColor) ?? fallback.thumbColor,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      trackSize: trackSize ?? fallback.trackSize,
      thumbSize: thumbSize ?? fallback.thumbSize,
      travel: travel ?? fallback.travel,
      gap: gap ?? fallback.gap,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
    );
  }

  /// State scales are stepped at t < 0.5; dimensions are lerped.
  static SwitchStyle lerp(SwitchStyle a, SwitchStyle b, double t) {
    return SwitchStyle(
      trackColor: t < 0.5 ? a.trackColor : b.trackColor,
      thumbColor: t < 0.5 ? a.thumbColor : b.thumbColor,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      trackSize: Size.lerp(a.trackSize, b.trackSize, t),
      thumbSize: lerpDouble(a.thumbSize, b.thumbSize, t),
      travel: lerpDouble(a.travel, b.travel, t),
      gap: lerpDouble(a.gap, b.gap, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SwitchStyle &&
        other.trackColor == trackColor &&
        other.thumbColor == thumbColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.trackSize == trackSize &&
        other.thumbSize == thumbSize &&
        other.travel == travel &&
        other.gap == gap &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode => Object.hash(
    trackColor,
    thumbColor,
    borderColor,
    borderWidth,
    trackSize,
    thumbSize,
    travel,
    gap,
    labelStyle,
  );
}

/// On/off theme container for the switch component.
class SwitchTheme extends ComponentThemeData implements Mergeable<SwitchTheme> {
  /// Creates a switch theme with one nullable slice per value.
  const SwitchTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.on,
    this.off,
    this.labelStyle,
  });

  /// Style while the switch is on.
  final SwitchStyle? on;

  /// Style while the switch is off.
  final SwitchStyle? off;

  /// Label text style shared by both values; a value row wins over it.
  final TextStyle? labelStyle;

  /// The slice for the current value, or null when this leg leaves it unset.
  SwitchStyle? forValue(bool value) => value ? on : off;

  /// Returns a copy with the given fields replaced.
  SwitchTheme copyWith({
    ValueGetter<SwitchStyle?>? on,
    ValueGetter<SwitchStyle?>? off,
    ValueGetter<TextStyle?>? labelStyle,
  }) {
    return SwitchTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      on: on == null ? this.on : on(),
      off: off == null ? this.off : off(),
      labelStyle: labelStyle == null ? this.labelStyle : labelStyle(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SwitchTheme merge(SwitchTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SwitchTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      on: on?.merge(fallback.on) ?? fallback.on,
      off: off?.merge(fallback.off) ?? fallback.off,
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static SwitchTheme lerp(SwitchTheme a, SwitchTheme b, double t) {
    SwitchStyle? row(SwitchStyle? x, SwitchStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return SwitchStyle.lerp(x, y, t);
    }

    return SwitchTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      on: row(a.on, b.on),
      off: row(a.off, b.off),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SwitchTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.on == on &&
        other.off == off &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    on,
    off,
    labelStyle,
  );
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// Disabled states are intentionally absent: `StateValue` falls back to `rest`
// and `Switch` dims the whole control to 50% opacity. The old table painted
// `muted` / `mutedForeground` instead, so a disabled switch lost its colour
// identity; the rest rows + one opacity keep it readable.
// ---------------------------------------------------------------------------

const _switchOnTrack = StateValue(
  rest: ThemedColor.ref(ColorRef.primary),
  hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
);
const _switchOnRow = SwitchStyle(
  trackColor: _switchOnTrack,
  thumbColor: StateValue(rest: ThemedColor.ref(ColorRef.background)),
  trackSize: switchDefaultTrackSize,
  thumbSize: switchDefaultThumbSize,
  gap: 8,
  labelStyle: switchDefaultLabelStyle,
);

const _switchOffTrack = StateValue(
  rest: ThemedColor.ref(ColorRef.input),
  hovered: ThemedColor.ref(ColorRef.input, alpha: 0.8),
  pressed: ThemedColor.ref(ColorRef.input, alpha: 0.8),
);
const _switchOffRow = SwitchStyle(
  trackColor: _switchOffTrack,
  thumbColor: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  trackSize: switchDefaultTrackSize,
  thumbSize: switchDefaultThumbSize,
  gap: 8,
  labelStyle: switchDefaultLabelStyle,
);

/// Token-derived baseline rows; every unset override field falls through here.
const SwitchTheme switchDefaults = SwitchTheme(
  on: _switchOnRow,
  off: _switchOffRow,
  labelStyle: switchDefaultLabelStyle,
);
