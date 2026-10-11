// Registry-owned theme data for the `hover_card` component: the
// [HoverCardTheme] behaviour container and token-derived `hoverCardDefaults`.
//
// User-owned overrides live in `hover_card_theme.dart`; CLI updates may
// replace this file. The card surface paints from global tokens
// (popover/border/radius); only timing and placement are theme rows.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Timing and placement contract of a hover card.
class HoverCardTheme extends ComponentThemeData
    implements Mergeable<HoverCardTheme> {
  /// Creates a hover card theme.
  const HoverCardTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.debounce,
    this.wait,
    this.popoverAlignment,
    this.anchorAlignment,
    this.popoverOffset,
    this.behavior,
  });

  /// Hide delay after the pointer leaves; null resolves 500 ms.
  final Duration? debounce;

  /// Show delay after the pointer enters; null resolves 500 ms.
  final Duration? wait;

  /// Card placement; null resolves top-center.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor edge; null resolves bottom-center.
  final AlignmentGeometry? anchorAlignment;

  /// Gap between anchor and card; null resolves Offset(0, 8).
  final Offset? popoverOffset;

  /// Hit-test behaviour of the anchor; null resolves deferToChild.
  final HitTestBehavior? behavior;

  /// Returns a copy with the given fields replaced.
  HoverCardTheme copyWith({
    ValueGetter<Duration?>? debounce,
    ValueGetter<Duration?>? wait,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? anchorAlignment,
    ValueGetter<Offset?>? popoverOffset,
    ValueGetter<HitTestBehavior?>? behavior,
  }) => HoverCardTheme(
    themeDensity: themeDensity,
    themeSpacing: themeSpacing,
    themeShadows: themeShadows,
    debounce: debounce == null ? this.debounce : debounce(),
    wait: wait == null ? this.wait : wait(),
    popoverAlignment: popoverAlignment == null
        ? this.popoverAlignment
        : popoverAlignment(),
    anchorAlignment: anchorAlignment == null
        ? this.anchorAlignment
        : anchorAlignment(),
    popoverOffset: popoverOffset == null ? this.popoverOffset : popoverOffset(),
    behavior: behavior == null ? this.behavior : behavior(),
  );

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  HoverCardTheme merge(HoverCardTheme? fallback) {
    if (fallback == null) return this;
    return HoverCardTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      debounce: debounce ?? fallback.debounce,
      wait: wait ?? fallback.wait,
      popoverAlignment: popoverAlignment ?? fallback.popoverAlignment,
      anchorAlignment: anchorAlignment ?? fallback.anchorAlignment,
      popoverOffset: popoverOffset ?? fallback.popoverOffset,
      behavior: behavior ?? fallback.behavior,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HoverCardTheme &&
          other.debounce == debounce &&
          other.wait == wait &&
          other.popoverAlignment == popoverAlignment &&
          other.anchorAlignment == anchorAlignment &&
          other.popoverOffset == popoverOffset &&
          other.behavior == behavior &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    debounce,
    wait,
    popoverAlignment,
    anchorAlignment,
    popoverOffset,
    behavior,
  );
}

/// Baseline behaviour; every unset override field falls through here.
const HoverCardTheme hoverCardDefaults = HoverCardTheme(
  debounce: Duration(milliseconds: 500),
  wait: Duration(milliseconds: 500),
  popoverAlignment: Alignment.topCenter,
  anchorAlignment: Alignment.bottomCenter,
  popoverOffset: Offset(0, 8),
  behavior: HitTestBehavior.deferToChild,
);
