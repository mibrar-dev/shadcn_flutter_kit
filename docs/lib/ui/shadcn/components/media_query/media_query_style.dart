// Registry-owned theme data for the `media_query` component: the
// [MediaQueryVisibilityTheme] container and `mediaQueryVisibilityDefaults`.
//
// User-owned overrides live in `media_query_theme.dart`; CLI updates may
// replace this file. The widget resolves the four legs through
// `resolveComponentStyle` from `theme/theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Viewport bounds shared by every [MediaQueryVisibility] in a subtree.
///
/// Only breakpoint numbers live here; nothing about this theme is a token, so
/// the defaults are deliberately empty and the widget arguments stay the
/// primary way to set them.
class MediaQueryVisibilityTheme extends ComponentThemeData
    implements Mergeable<MediaQueryVisibilityTheme> {
  /// Creates a visibility theme.
  const MediaQueryVisibilityTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.minWidth,
    this.maxWidth,
  });

  /// Narrowest viewport width (inclusive) that shows the main child.
  final double? minWidth;

  /// Widest viewport width (inclusive) that shows the main child.
  final double? maxWidth;

  /// Returns a copy with the given fields replaced.
  ///
  /// The density/spacing/shadow fields are carried over, which the old
  /// `MediaQueryVisibilityTheme.copyWith` did not do.
  MediaQueryVisibilityTheme copyWith({
    ValueGetter<double?>? minWidth,
    ValueGetter<double?>? maxWidth,
  }) {
    return MediaQueryVisibilityTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      minWidth: minWidth == null ? this.minWidth : minWidth(),
      maxWidth: maxWidth == null ? this.maxWidth : maxWidth(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  MediaQueryVisibilityTheme merge(MediaQueryVisibilityTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return MediaQueryVisibilityTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      minWidth: minWidth ?? fallback.minWidth,
      maxWidth: maxWidth ?? fallback.maxWidth,
    );
  }

  /// Discrete fields step at t < 0.5.
  static MediaQueryVisibilityTheme lerp(
    MediaQueryVisibilityTheme a,
    MediaQueryVisibilityTheme b,
    double t,
  ) {
    return MediaQueryVisibilityTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      minWidth: t < 0.5 ? a.minWidth : b.minWidth,
      maxWidth: t < 0.5 ? a.maxWidth : b.maxWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MediaQueryVisibilityTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, minWidth, maxWidth);
}

/// No breakpoints by default: a `MediaQueryVisibility` with no widget
/// arguments always shows its child.
const MediaQueryVisibilityTheme mediaQueryVisibilityDefaults =
    MediaQueryVisibilityTheme();
