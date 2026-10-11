// Registry-owned theme data for the `text_animate` component: the
// [TextAnimateTheme] container, `textAnimateDefaults`, the typewriter and
// cursor values, and the four-leg resolution helpers.
//
// User-owned overrides live in `text_animate_theme.dart`; CLI updates may
// replace this file. The animation styles themselves live in the shared
// `primitives/streaming_text/` engine (one data class with const named
// constructors), so both streaming widgets and the user-owned file share
// them.

import 'package:flutter/widgets.dart';

import '../../primitives/streaming_text/streaming_text.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

export '../../primitives/streaming_text/streaming_text.dart'
    show TextAnimateEffect, TextAnimateEffectKind;

/// Fired once when the latest text revision has fully settled.
typedef TextAnimateSettled = void Function(String text);

/// Typewriter reveal of newly arrived units.
class TextAnimateTypewriter {
  const TextAnimateTypewriter({this.enabled = true, this.charsPerSecond = 48});

  /// Progressive reveal on/off; off shows the whole tail at once.
  final bool enabled;

  /// Reveal speed for newly appended units.
  final double charsPerSecond;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextAnimateTypewriter &&
        other.enabled == enabled &&
        other.charsPerSecond == charsPerSecond;
  }

  @override
  int get hashCode => Object.hash(enabled, charsPerSecond);
}

/// Cursor shown while streaming.
class TextAnimateCursor {
  const TextAnimateCursor.none()
    : enabled = false,
      blink = false,
      character = '',
      blinkPeriod = Duration.zero,
      showWhenSettled = false,
      style = null;

  const TextAnimateCursor.blink({
    this.character = '|',
    this.blinkPeriod = const Duration(milliseconds: 650),
    this.showWhenSettled = true,
    this.style,
  }) : enabled = true,
       blink = true;

  const TextAnimateCursor.solid({
    this.character = '|',
    this.showWhenSettled = true,
    this.style,
  }) : enabled = true,
       blink = false,
       blinkPeriod = Duration.zero;

  final bool enabled;
  final bool blink;
  final String character;
  final Duration blinkPeriod;
  final TextStyle? style;
  final bool showWhenSettled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextAnimateCursor &&
        other.enabled == enabled &&
        other.blink == blink &&
        other.character == character &&
        other.blinkPeriod == blinkPeriod &&
        other.showWhenSettled == showWhenSettled &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(
    enabled,
    blink,
    character,
    blinkPeriod,
    showWhenSettled,
    style,
  );
}

/// Theme of the animated text.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class TextAnimateTheme extends ComponentThemeData
    implements Mergeable<TextAnimateTheme> {
  const TextAnimateTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.style,
    this.typewriter,
    this.effect,
    this.cursor,
  });

  /// Base text style, merged over the ambient `DefaultTextStyle`.
  final TextStyle? style;

  /// Reveal pacing; null falls back to an enabled 48-units/s typewriter.
  final TextAnimateTypewriter? typewriter;

  /// Animation of newly revealed units; null falls back to no animation.
  final TextAnimateEffect? effect;

  /// Cursor; null falls back to hidden.
  final TextAnimateCursor? cursor;

  TextAnimateTheme copyWith({
    ValueGetter<TextStyle?>? style,
    ValueGetter<TextAnimateTypewriter?>? typewriter,
    ValueGetter<TextAnimateEffect?>? effect,
    ValueGetter<TextAnimateCursor?>? cursor,
  }) {
    return TextAnimateTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      style: style == null ? this.style : style(),
      typewriter: typewriter == null ? this.typewriter : typewriter(),
      effect: effect == null ? this.effect : effect(),
      cursor: cursor == null ? this.cursor : cursor(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  TextAnimateTheme merge(TextAnimateTheme? fallback) {
    if (fallback == null) return this;
    return TextAnimateTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      style: style ?? fallback.style,
      typewriter: typewriter ?? fallback.typewriter,
      effect: effect ?? fallback.effect,
      cursor: cursor ?? fallback.cursor,
    );
  }

  /// Styles lerp; pacing, effects and cursors step at `t = 0.5`.
  static TextAnimateTheme lerp(
    TextAnimateTheme a,
    TextAnimateTheme b,
    double t,
  ) {
    return TextAnimateTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      style: TextStyle.lerp(a.style, b.style, t),
      typewriter: t < 0.5 ? a.typewriter : b.typewriter,
      effect: t < 0.5 ? a.effect : b.effect,
      cursor: t < 0.5 ? a.cursor : b.cursor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextAnimateTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.style == style &&
        other.typewriter == typewriter &&
        other.effect == effect &&
        other.cursor == cursor;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    style,
    typewriter,
    effect,
    cursor,
  );
}

/// Baseline: inherit the ambient style, reveal at 48 units/s with no
/// per-unit animation and no cursor.
const TextAnimateTheme textAnimateDefaults = TextAnimateTheme(
  style: TextStyle(),
  typewriter: TextAnimateTypewriter(),
  effect: TextAnimateEffect.none(),
  cursor: TextAnimateCursor.none(),
);

/// Resolved per-build values: the four theme legs plus widget-leg overrides
/// merged per field (widget arg > scoped > app > defaults).
({
  TextStyle base,
  TextAnimateTypewriter typewriter,
  TextAnimateEffect effect,
  TextAnimateCursor cursor,
})
resolveTextAnimateParts(
  BuildContext context, {
  TextAnimateTheme? widgetTheme,
  TextStyle? style,
  TextAnimateTypewriter? typewriter,
  TextAnimateEffect? effect,
  TextAnimateCursor? cursor,
}) {
  final TextAnimateTheme theme =
      resolveComponentStyle<TextAnimateTheme, TextAnimateTheme>(
        context,
        widget: widgetTheme,
        select: (t) => t,
        defaults: textAnimateDefaults,
      );
  return (
    base: DefaultTextStyle.of(context).style.merge(theme.style).merge(style),
    typewriter: typewriter ?? theme.typewriter ?? const TextAnimateTypewriter(),
    effect: effect ?? theme.effect ?? const TextAnimateEffect.none(),
    cursor: cursor ?? theme.cursor ?? const TextAnimateCursor.none(),
  );
}

/// Whether the cursor shows: hidden when disabled or settled-away, solid
/// under reduced motion, otherwise blinking on its phase.
bool textAnimateCursorVisible({
  required TextAnimateCursor cursor,
  required bool settled,
  required bool reduced,
  required Duration now,
}) {
  if (!cursor.enabled) return false;
  if (settled && !cursor.showWhenSettled) return false;
  if (!cursor.blink || reduced) return true;
  return streamingCursorBlinkOn(now: now, blinkPeriod: cursor.blinkPeriod);
}
