// Registry-owned theme data for the `image` component: the [ImageTheme]
// container and the token-derived `imageDefaults`.
//
// User-owned overrides live in `image_theme.dart`; CLI updates may replace this
// file. The widget resolves the four legs through
// `resolveComponentStyle<ImageTheme, ImageTheme>` from `theme/theme.dart`.

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One image box's visual contract.
///
/// Every field is nullable, so an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. `borderRadius` resolves at
/// build because its default follows the theme's radius token.
class ImageTheme extends ComponentThemeData implements Mergeable<ImageTheme> {
  /// Creates an image theme.
  const ImageTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderRadius,
    this.duration,
  });

  /// Fill painted behind the image; also the default placeholder.
  final ThemedColor? background;

  /// Corner radius of the box; null resolves `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Fade-in duration of the decoded picture; null resolves 150 ms.
  final Duration? duration;

  /// Returns a copy with the given fields replaced.
  ImageTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<Duration?>? duration,
  }) {
    return ImageTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      duration: duration == null ? this.duration : duration(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ImageTheme merge(ImageTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ImageTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderRadius: borderRadius ?? fallback.borderRadius,
      duration: duration ?? fallback.duration,
    );
  }

  /// Discrete fields step at t < 0.5, matching the other component themes.
  static ImageTheme lerp(ImageTheme a, ImageTheme b, double t) {
    return ImageTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      duration: t < 0.5 ? a.duration : b.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ImageTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderRadius == borderRadius &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    borderRadius,
    duration,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `borderRadius` is left null so it resolves from the ambient radius token
/// rather than freezing a value here.
const ImageTheme imageDefaults = ImageTheme(
  background: ThemedColor.ref(ColorRef.muted),
  duration: kDefaultDuration,
);
