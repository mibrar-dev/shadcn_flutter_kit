// Registry-owned side of the `feature_carousel` component: the
// [FeatureCarouselAnimationStyle] enum, the [FeatureCarouselItem] model, the
// [FeatureCarouselController], the [FeatureCarouselTheme] container, the
// token-derived `featureCarouselDefaults`, the pure transition-style table and
// the two card painters.
//
// The painters live here (public, because Dart privacy is per-library) so both
// files stay under 400 lines — the same call `carousel_style.dart` makes for
// its controller. User-owned overrides live in `feature_carousel_theme.dart`;
// the reusable transform machinery lives in `primitives/animation.dart`.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../primitives/animation.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// The animation applied while the carousel changes item.
enum FeatureCarouselAnimationStyle {
  crossfadeScale,
  slideFade,
  blurFade,
  rotateParallax,
  liftFade,
  slideUpFade,
  slideDownFade,
  rotateFade,
  zoomFade,
}

/// Builds a custom item icon from the resolved [accentColor].
typedef FeatureCarouselIconBuilder =
    Widget Function(BuildContext context, Color accentColor, double size);

/// One item of a `FeatureCarousel`.
class FeatureCarouselItem {
  /// Creates a carousel item.
  const FeatureCarouselItem({
    this.title,
    this.description,
    this.icon,
    this.iconBuilder,
    this.accentColor,
  });

  final String? title;

  final String? description;

  final IconData? icon;

  final FeatureCarouselIconBuilder? iconBuilder;

  final ThemedColor? accentColor;
}

/// Runtime configuration of a `FeatureCarousel`.
///
/// A controller is optional: a carousel creates and disposes its own when none
/// is given. The old `update()`, `cycleAnimationStyles`, `next`/`previous` and
/// `primaryActionLabel` setter are gone (clean break).
class FeatureCarouselController extends ChangeNotifier {
  /// Creates a carousel controller.
  FeatureCarouselController({
    int initialIndex = 0,
    this.showCta = true,
    this.showNavArrows = true,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.animationStyle = FeatureCarouselAnimationStyle.slideFade,
    this.enableKeyboardNavigation = true,
    this.enableSwipe = true,
    this.primaryActionLabel = 'Add to chat',
    this.onPrimaryAction,
    this.onIndexChanged,
  }) : _index = initialIndex;

  int _index;

  bool showCta;

  bool showNavArrows;

  bool autoPlay;

  Duration autoPlayInterval;

  FeatureCarouselAnimationStyle animationStyle;

  bool enableKeyboardNavigation;

  bool enableSwipe;

  /// Label of the call-to-action control (English fallback: no ARB key).
  final String primaryActionLabel;

  void Function(FeatureCarouselItem item, int index)? onPrimaryAction;

  void Function(int index)? onIndexChanged;

  int get index => _index;

  set index(int value) {
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
    onIndexChanged?.call(_index);
  }
}

/// Appearance of the feature carousel.
class FeatureCarouselTheme extends ComponentThemeData
    implements Mergeable<FeatureCarouselTheme> {
  /// Creates a feature carousel theme.
  const FeatureCarouselTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.cardFill,
    this.cardBorder,
    this.ghostFill,
    this.controlBackground,
    this.controlForeground,
    this.accentColor,
    this.radius,
    this.transitionDuration,
  });

  final ThemedColor? cardFill;

  /// Border of the centre card; the ghost cards derive theirs from it.
  final ThemedColor? cardBorder;

  final ThemedColor? ghostFill;

  final ThemedColor? controlBackground;

  final ThemedColor? controlForeground;

  final ThemedColor? accentColor;

  final double? radius;

  final Duration? transitionDuration;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FeatureCarouselTheme merge(FeatureCarouselTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return FeatureCarouselTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      cardFill: cardFill ?? fallback.cardFill,
      cardBorder: cardBorder ?? fallback.cardBorder,
      ghostFill: ghostFill ?? fallback.ghostFill,
      controlBackground: controlBackground ?? fallback.controlBackground,
      controlForeground: controlForeground ?? fallback.controlForeground,
      accentColor: accentColor ?? fallback.accentColor,
      radius: radius ?? fallback.radius,
      transitionDuration: transitionDuration ?? fallback.transitionDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureCarouselTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.cardFill == cardFill &&
        other.cardBorder == cardBorder &&
        other.ghostFill == ghostFill &&
        other.controlBackground == controlBackground &&
        other.controlForeground == controlForeground &&
        other.accentColor == accentColor &&
        other.radius == radius &&
        other.transitionDuration == transitionDuration;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    cardFill,
    cardBorder,
    ghostFill,
    controlBackground,
    controlForeground,
    accentColor,
    radius,
    transitionDuration,
  );
}

/// Default width of the carousel box.
const double featureCarouselDefaultWidth = 420;

/// Default height of the carousel box.
const double featureCarouselDefaultHeight = 370;

/// Default card width.
const double featureCarouselDefaultCardWidth = 250;

/// Default card height.
const double featureCarouselDefaultCardHeight = 300;

/// Default size of a nav arrow.
const double featureCarouselDefaultArrowSize = 44;

/// Default height of the call-to-action control.
const double featureCarouselDefaultCtaHeight = 46;

/// Default minimum width of the call-to-action control.
const double featureCarouselDefaultCtaMinWidth = 140;

/// Default title and description font size.
const double featureCarouselDefaultFontSize = 18;

/// Easing of the item transition.
const Curve featureCarouselTransitionCurve = Curves.easeOutCubic;

/// Token-derived baseline.
const FeatureCarouselTheme featureCarouselDefaults = FeatureCarouselTheme(
  cardFill: ThemedColor.ref(ColorRef.card),
  cardBorder: ThemedColor.ref(ColorRef.border),
  ghostFill: ThemedColor.ref(ColorRef.muted),
  controlBackground: ThemedColor.ref(ColorRef.muted, alpha: 0.35),
  controlForeground: ThemedColor.ref(ColorRef.mutedForeground),
  accentColor: ThemedColor.ref(ColorRef.primary),
  radius: 12,
  transitionDuration: Duration(milliseconds: 260),
);

/// Maps an animation style to the transform [AnimatedStyleTransition] plays.
///
/// [direction] is `1` forward and `-1` backward, so a slide starts on the side
/// the new item comes from.
AnimatedTransitionStyle featureCarouselTransitionStyle(
  FeatureCarouselAnimationStyle style,
  double direction,
) {
  return switch (style) {
    FeatureCarouselAnimationStyle.crossfadeScale =>
      const AnimatedTransitionStyle(beginScale: 0.985),
    FeatureCarouselAnimationStyle.slideFade => AnimatedTransitionStyle(
      beginOffset: Offset(0.05 * direction, 0),
      beginScale: 0.985,
    ),
    FeatureCarouselAnimationStyle.blurFade => const AnimatedTransitionStyle(
      beginBlur: 4,
    ),
    FeatureCarouselAnimationStyle.rotateParallax => AnimatedTransitionStyle(
      beginOffset: Offset(12 * direction, 6),
      beginRotation: 0.03 * direction,
      beginScale: 0.985,
    ),
    FeatureCarouselAnimationStyle.liftFade => const AnimatedTransitionStyle(
      beginOffset: Offset(0, 12),
      beginScale: 0.99,
    ),
    FeatureCarouselAnimationStyle.slideUpFade => const AnimatedTransitionStyle(
      beginOffset: Offset(0, 14),
    ),
    FeatureCarouselAnimationStyle.slideDownFade =>
      const AnimatedTransitionStyle(beginOffset: Offset(0, -14)),
    FeatureCarouselAnimationStyle.rotateFade => AnimatedTransitionStyle(
      beginRotation: 0.04 * direction,
    ),
    FeatureCarouselAnimationStyle.zoomFade => const AnimatedTransitionStyle(
      beginScale: 0.97,
    ),
  };
}

/// The centre card: a token-filled surface with an accent icon.
class FeatureCarouselCenterCard extends StatelessWidget {
  /// Creates a centre card.
  const FeatureCarouselCenterCard({
    super.key,
    required this.item,
    required this.radius,
    required this.fill,
    required this.border,
    required this.accent,
  });

  final FeatureCarouselItem item;

  final double radius;

  final Color fill;

  final Color border;

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final double iconSize = featureCarouselDefaultCardWidth * 0.28;
    final Widget icon =
        item.iconBuilder?.call(context, accent, iconSize) ??
        (item.icon == null
            ? const SizedBox.shrink()
            : Icon(item.icon, size: iconSize, color: accent));
    return Semantics(
      label: 'Feature preview: ${item.title ?? 'item'}',
      child: Container(
        width: featureCarouselDefaultCardWidth,
        height: featureCarouselDefaultCardHeight,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: border, width: 1.2),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x8C000000),
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}

/// A stacked, semi-transparent card behind the centre card.
class FeatureCarouselGhostCard extends StatelessWidget {
  /// Creates a ghost card.
  const FeatureCarouselGhostCard({
    super.key,
    required this.indexFromFront,
    required this.radius,
    required this.fill,
    required this.border,
  });

  final int indexFromFront;

  final double radius;

  final Color fill;

  final Color border;

  @override
  Widget build(BuildContext context) {
    final (
      double dx,
      double dy,
      double rotation,
      double scale,
      double opacity,
    ) = switch (indexFromFront) {
      1 => (-28, 6, -6 * math.pi / 180, 0.98, 0.55),
      2 => (22, 10, 6 * math.pi / 180, 0.96, 0.40),
      _ => (0, 14, 0, 0.94, 0.28),
    };
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: featureCarouselDefaultCardWidth,
              height: featureCarouselDefaultCardHeight,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: border),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
