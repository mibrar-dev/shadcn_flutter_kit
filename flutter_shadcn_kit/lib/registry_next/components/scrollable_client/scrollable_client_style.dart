// Registry-owned theme data for the `scrollable_client` component: the flat
// [ScrollableClientTheme] container and its `scrollableClientDefaults`.
//
// The theme carries the behaviour flags the old widget read from
// `ComponentTheme` only. User-owned overrides live in
// `scrollable_client_theme.dart`; CLI updates may replace this file.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme container for the scrollable client component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ScrollableClientTheme extends ComponentThemeData
    implements Mergeable<ScrollableClientTheme> {
  /// Creates a scrollable client theme.
  const ScrollableClientTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.diagonalDragBehavior,
    this.dragStartBehavior,
    this.keyboardDismissBehavior,
    this.clipBehavior,
    this.hitTestBehavior,
    this.overscroll,
  });

  /// How diagonal drags pick an axis. Default: none.
  final DiagonalDragBehavior? diagonalDragBehavior;

  /// When drag gestures start. Default: start.
  final DragStartBehavior? dragStartBehavior;

  /// Keyboard dismissal on drag. Default: manual.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// Viewport clipping. Default: hardEdge.
  final Clip? clipBehavior;

  /// Hit-test behaviour of the scrollable. Default: opaque.
  final HitTestBehavior? hitTestBehavior;

  /// Whether offsets may move past the content edges. Default: false.
  final bool? overscroll;

  /// Returns a copy with the given fields replaced.
  ScrollableClientTheme copyWith({
    ValueGetter<DiagonalDragBehavior?>? diagonalDragBehavior,
    ValueGetter<DragStartBehavior?>? dragStartBehavior,
    ValueGetter<ScrollViewKeyboardDismissBehavior?>? keyboardDismissBehavior,
    ValueGetter<Clip?>? clipBehavior,
    ValueGetter<HitTestBehavior?>? hitTestBehavior,
    ValueGetter<bool?>? overscroll,
  }) {
    return ScrollableClientTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      diagonalDragBehavior: diagonalDragBehavior == null
          ? this.diagonalDragBehavior
          : diagonalDragBehavior(),
      dragStartBehavior: dragStartBehavior == null
          ? this.dragStartBehavior
          : dragStartBehavior(),
      keyboardDismissBehavior: keyboardDismissBehavior == null
          ? this.keyboardDismissBehavior
          : keyboardDismissBehavior(),
      clipBehavior: clipBehavior == null ? this.clipBehavior : clipBehavior(),
      hitTestBehavior: hitTestBehavior == null
          ? this.hitTestBehavior
          : hitTestBehavior(),
      overscroll: overscroll == null ? this.overscroll : overscroll(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ScrollableClientTheme merge(ScrollableClientTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ScrollableClientTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      diagonalDragBehavior:
          diagonalDragBehavior ?? fallback.diagonalDragBehavior,
      dragStartBehavior: dragStartBehavior ?? fallback.dragStartBehavior,
      keyboardDismissBehavior:
          keyboardDismissBehavior ?? fallback.keyboardDismissBehavior,
      clipBehavior: clipBehavior ?? fallback.clipBehavior,
      hitTestBehavior: hitTestBehavior ?? fallback.hitTestBehavior,
      overscroll: overscroll ?? fallback.overscroll,
    );
  }

  /// Enums and flags step at `t = 0.5`.
  static ScrollableClientTheme lerp(
    ScrollableClientTheme a,
    ScrollableClientTheme b,
    double t,
  ) {
    return ScrollableClientTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      diagonalDragBehavior: t < 0.5
          ? a.diagonalDragBehavior
          : b.diagonalDragBehavior,
      dragStartBehavior: t < 0.5 ? a.dragStartBehavior : b.dragStartBehavior,
      keyboardDismissBehavior: t < 0.5
          ? a.keyboardDismissBehavior
          : b.keyboardDismissBehavior,
      clipBehavior: t < 0.5 ? a.clipBehavior : b.clipBehavior,
      hitTestBehavior: t < 0.5 ? a.hitTestBehavior : b.hitTestBehavior,
      overscroll: t < 0.5 ? a.overscroll : b.overscroll,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ScrollableClientTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.diagonalDragBehavior == diagonalDragBehavior &&
        other.dragStartBehavior == dragStartBehavior &&
        other.keyboardDismissBehavior == keyboardDismissBehavior &&
        other.clipBehavior == clipBehavior &&
        other.hitTestBehavior == hitTestBehavior &&
        other.overscroll == overscroll;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    diagonalDragBehavior,
    dragStartBehavior,
    keyboardDismissBehavior,
    clipBehavior,
    hitTestBehavior,
    overscroll,
  );
}

/// Baseline values; unset override fields fall through here.
const ScrollableClientTheme scrollableClientDefaults = ScrollableClientTheme(
  diagonalDragBehavior: DiagonalDragBehavior.none,
  dragStartBehavior: DragStartBehavior.start,
  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
  clipBehavior: Clip.hardEdge,
  hitTestBehavior: HitTestBehavior.opaque,
  overscroll: false,
);
