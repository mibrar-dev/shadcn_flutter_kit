// Registry-owned theme data for the `gooey_toast` component: the state and
// animation enums (variant tables), the [GooeyToastTheme] container with the
// per-state tone fields, and the token-derived `gooeyToastDefaults`.
//
// User-owned overrides live in `gooey_toast_theme.dart`; CLI updates may
// replace this file. The card reads the resolved theme through
// `resolveComponentStyle<GooeyToastTheme, GooeyToastTheme>`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/animation.dart';
import '../../primitives/gooey/gooey_frame.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Semantic state of a gooey toast; picks the default icon and tone.
enum GooeyToastState {
  success,
  loading,
  error,
  warning,
  info,
  action;

  /// Default compact icon for this state.
  IconData get icon => switch (this) {
    GooeyToastState.success => LucideIcons.check,
    GooeyToastState.loading => LucideIcons.loaderCircle,
    GooeyToastState.error => LucideIcons.x,
    GooeyToastState.warning => LucideIcons.triangleAlert,
    GooeyToastState.info => LucideIcons.info,
    GooeyToastState.action => LucideIcons.arrowRight,
  };

  /// Resolved accent colour for this state.
  Color tone(GooeyToastTheme theme, ShadcnColors colors) => switch (this) {
    GooeyToastState.success => theme.successTone!.resolve(colors),
    GooeyToastState.loading => theme.loadingTone!.resolve(colors),
    GooeyToastState.error => theme.errorTone!.resolve(colors),
    GooeyToastState.warning => theme.warningTone!.resolve(colors),
    GooeyToastState.info => theme.infoTone!.resolve(colors),
    GooeyToastState.action => theme.actionTone!.resolve(colors),
  };
}

/// Open/close animation profile of a gooey toast.
enum GooeyToastAnimationStyle {
  sileo,
  smooth,
  snappy,
  bouncy,
  fluid,
  springEasing;

  /// Open/close duration for this profile.
  Duration get duration => switch (this) {
    GooeyToastAnimationStyle.sileo => const Duration(milliseconds: 600),
    GooeyToastAnimationStyle.smooth => const Duration(milliseconds: 760),
    GooeyToastAnimationStyle.snappy => const Duration(milliseconds: 420),
    GooeyToastAnimationStyle.bouncy => const Duration(milliseconds: 680),
    GooeyToastAnimationStyle.fluid => const Duration(milliseconds: 760),
    GooeyToastAnimationStyle.springEasing => const Duration(milliseconds: 600),
  };

  /// Open/close curve for this profile.
  Curve get curve => switch (this) {
    GooeyToastAnimationStyle.sileo => Curves.easeInOutCubic,
    GooeyToastAnimationStyle.smooth => Curves.easeInOutQuart,
    GooeyToastAnimationStyle.snappy => Curves.easeOutCubic,
    GooeyToastAnimationStyle.bouncy => Curves.elasticOut,
    GooeyToastAnimationStyle.fluid => const Cubic(0.20, 0.95, 0.20, 1.18),
    GooeyToastAnimationStyle.springEasing => const SileoSpringCurve(),
  };
}

/// Corner profile of the gooey silhouette.
enum GooeyToastShapeStyle {
  defaultShape,
  soft,
  sharp,
  capsule;

  /// Resolved roundness for a base [roundness] and pill height.
  double roundness(double base, double pillHeight) => switch (this) {
    GooeyToastShapeStyle.defaultShape => base * 1.35,
    GooeyToastShapeStyle.soft => base * 1.6,
    GooeyToastShapeStyle.sharp => base * 0.9,
    GooeyToastShapeStyle.capsule => pillHeight / 2,
  };
}

/// Animation profile of the expanded body content.
enum GooeyToastBodyAnimationStyle {
  fade,
  fadeSlide,
  fadeScale,
  none;

  /// Surface animation profile for this style.
  GooeySurfaceBodyAnimation animation() => switch (this) {
    GooeyToastBodyAnimationStyle.fade => GooeySurfaceBodyAnimation.fade,
    GooeyToastBodyAnimationStyle.fadeSlide =>
      GooeySurfaceBodyAnimation.fadeSlide,
    GooeyToastBodyAnimationStyle.fadeScale =>
      GooeySurfaceBodyAnimation.fadeScale,
    GooeyToastBodyAnimationStyle.none => GooeySurfaceBodyAnimation.none,
  };
}

/// Compact title style before the state tone is applied.
const TextStyle gooeyTitleTextStyle = TextStyle(
  fontSize: 13.2,
  height: 1.0,
  fontWeight: FontWeight.w500,
);

/// Expanded description style; the colour matches the default dark fill.
const TextStyle gooeyDescriptionTextStyle = TextStyle(
  fontSize: 14,
  height: 1.43,
  fontWeight: FontWeight.w400,
  color: Color(0xFFC0C5CB),
);

/// Visual and timing contract of a gooey toast.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. The six `*Tone` fields
/// are direct (Studio-editable) theme fields; shadcn has no
/// success/warning/info tokens, so their defaults are literal accents that
/// users can replace with a `ThemedColor.ref`.
class GooeyToastTheme extends ComponentThemeData
    implements Mergeable<GooeyToastTheme> {
  const GooeyToastTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.width,
    this.fill,
    this.roundness,
    this.titleStyle,
    this.descriptionStyle,
    this.duration,
    this.animationStyle,
    this.shapeStyle,
    this.bodyAnimationStyle,
    this.enableGooeyBlur,
    this.successTone,
    this.loadingTone,
    this.errorTone,
    this.warningTone,
    this.infoTone,
    this.actionTone,
  });

  final double? width;

  /// Surface fill. Default: literal `#0D1117`, the signature dark pill; a
  /// `ThemedColor.ref` follows preset switches.
  final ThemedColor? fill;

  final double? roundness;

  /// Compact title style; null uses `gooeyTitleTextStyle` + the state tone.
  final TextStyle? titleStyle;

  /// Expanded description style; null uses `gooeyDescriptionTextStyle`.
  final TextStyle? descriptionStyle;

  final Duration? duration;

  final GooeyToastAnimationStyle? animationStyle;

  final GooeyToastShapeStyle? shapeStyle;

  final GooeyToastBodyAnimationStyle? bodyAnimationStyle;

  final bool? enableGooeyBlur;

  /// `success` accent. Default: literal `#63C65E`.
  final ThemedColor? successTone;

  /// `loading` accent. Default: literal `#8A8F98`.
  final ThemedColor? loadingTone;

  /// `error` accent. Default: literal `#EF5E5E`.
  final ThemedColor? errorTone;

  /// `warning` accent. Default: literal `#EABB4B`.
  final ThemedColor? warningTone;

  /// `info` accent. Default: literal `#6EA8FF`.
  final ThemedColor? infoTone;

  /// `action` accent. Default: literal `#7A8DFF`.
  final ThemedColor? actionTone;

  /// Returns a copy with the given fields replaced.
  GooeyToastTheme copyWith({
    ValueGetter<double?>? width,
    ValueGetter<ThemedColor?>? fill,
    ValueGetter<double?>? roundness,
    ValueGetter<TextStyle?>? titleStyle,
    ValueGetter<TextStyle?>? descriptionStyle,
    ValueGetter<Duration?>? duration,
    ValueGetter<GooeyToastAnimationStyle?>? animationStyle,
    ValueGetter<GooeyToastShapeStyle?>? shapeStyle,
    ValueGetter<GooeyToastBodyAnimationStyle?>? bodyAnimationStyle,
    ValueGetter<bool?>? enableGooeyBlur,
    ValueGetter<ThemedColor?>? successTone,
    ValueGetter<ThemedColor?>? loadingTone,
    ValueGetter<ThemedColor?>? errorTone,
    ValueGetter<ThemedColor?>? warningTone,
    ValueGetter<ThemedColor?>? infoTone,
    ValueGetter<ThemedColor?>? actionTone,
  }) {
    return GooeyToastTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      width: width == null ? this.width : width(),
      fill: fill == null ? this.fill : fill(),
      roundness: roundness == null ? this.roundness : roundness(),
      titleStyle: titleStyle == null ? this.titleStyle : titleStyle(),
      descriptionStyle: descriptionStyle == null
          ? this.descriptionStyle
          : descriptionStyle(),
      duration: duration == null ? this.duration : duration(),
      animationStyle: animationStyle == null
          ? this.animationStyle
          : animationStyle(),
      shapeStyle: shapeStyle == null ? this.shapeStyle : shapeStyle(),
      bodyAnimationStyle: bodyAnimationStyle == null
          ? this.bodyAnimationStyle
          : bodyAnimationStyle(),
      enableGooeyBlur: enableGooeyBlur == null
          ? this.enableGooeyBlur
          : enableGooeyBlur(),
      successTone: successTone == null ? this.successTone : successTone(),
      loadingTone: loadingTone == null ? this.loadingTone : loadingTone(),
      errorTone: errorTone == null ? this.errorTone : errorTone(),
      warningTone: warningTone == null ? this.warningTone : warningTone(),
      infoTone: infoTone == null ? this.infoTone : infoTone(),
      actionTone: actionTone == null ? this.actionTone : actionTone(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  GooeyToastTheme merge(GooeyToastTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return GooeyToastTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      width: width ?? fallback.width,
      fill: fill ?? fallback.fill,
      roundness: roundness ?? fallback.roundness,
      titleStyle: titleStyle ?? fallback.titleStyle,
      descriptionStyle: descriptionStyle ?? fallback.descriptionStyle,
      duration: duration ?? fallback.duration,
      animationStyle: animationStyle ?? fallback.animationStyle,
      shapeStyle: shapeStyle ?? fallback.shapeStyle,
      bodyAnimationStyle: bodyAnimationStyle ?? fallback.bodyAnimationStyle,
      enableGooeyBlur: enableGooeyBlur ?? fallback.enableGooeyBlur,
      successTone: successTone ?? fallback.successTone,
      loadingTone: loadingTone ?? fallback.loadingTone,
      errorTone: errorTone ?? fallback.errorTone,
      warningTone: warningTone ?? fallback.warningTone,
      infoTone: infoTone ?? fallback.infoTone,
      actionTone: actionTone ?? fallback.actionTone,
    );
  }

  /// Colours, styles and flags step at `t < 0.5`; dimensions interpolate.
  static GooeyToastTheme lerp(GooeyToastTheme a, GooeyToastTheme b, double t) {
    return GooeyToastTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      width: lerpDouble(a.width, b.width, t),
      fill: t < 0.5 ? a.fill : b.fill,
      roundness: lerpDouble(a.roundness, b.roundness, t),
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      descriptionStyle: TextStyle.lerp(
        a.descriptionStyle,
        b.descriptionStyle,
        t,
      ),
      duration: t < 0.5 ? a.duration : b.duration,
      animationStyle: t < 0.5 ? a.animationStyle : b.animationStyle,
      shapeStyle: t < 0.5 ? a.shapeStyle : b.shapeStyle,
      bodyAnimationStyle: t < 0.5 ? a.bodyAnimationStyle : b.bodyAnimationStyle,
      enableGooeyBlur: t < 0.5 ? a.enableGooeyBlur : b.enableGooeyBlur,
      successTone: t < 0.5 ? a.successTone : b.successTone,
      loadingTone: t < 0.5 ? a.loadingTone : b.loadingTone,
      errorTone: t < 0.5 ? a.errorTone : b.errorTone,
      warningTone: t < 0.5 ? a.warningTone : b.warningTone,
      infoTone: t < 0.5 ? a.infoTone : b.infoTone,
      actionTone: t < 0.5 ? a.actionTone : b.actionTone,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is GooeyToastTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.width == width &&
        other.fill == fill &&
        other.roundness == roundness &&
        other.titleStyle == titleStyle &&
        other.descriptionStyle == descriptionStyle &&
        other.duration == duration &&
        other.animationStyle == animationStyle &&
        other.shapeStyle == shapeStyle &&
        other.bodyAnimationStyle == bodyAnimationStyle &&
        other.enableGooeyBlur == enableGooeyBlur &&
        other.successTone == successTone &&
        other.loadingTone == loadingTone &&
        other.errorTone == errorTone &&
        other.warningTone == warningTone &&
        other.infoTone == infoTone &&
        other.actionTone == actionTone;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    width,
    fill,
    roundness,
    titleStyle,
    descriptionStyle,
    duration,
    animationStyle,
    shapeStyle,
    bodyAnimationStyle,
    enableGooeyBlur,
    successTone,
    loadingTone,
    errorTone,
    warningTone,
    infoTone,
    actionTone,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const GooeyToastTheme gooeyToastDefaults = GooeyToastTheme(
  width: 350,
  fill: ThemedColor.value(Color(0xFF0D1117)),
  roundness: 18,
  titleStyle: gooeyTitleTextStyle,
  descriptionStyle: gooeyDescriptionTextStyle,
  duration: Duration(milliseconds: 6000),
  animationStyle: GooeyToastAnimationStyle.sileo,
  shapeStyle: GooeyToastShapeStyle.defaultShape,
  bodyAnimationStyle: GooeyToastBodyAnimationStyle.fade,
  enableGooeyBlur: true,
  successTone: ThemedColor.value(Color(0xFF63C65E)),
  loadingTone: ThemedColor.value(Color(0xFF8A8F98)),
  errorTone: ThemedColor.value(Color(0xFFEF5E5E)),
  warningTone: ThemedColor.value(Color(0xFFEABB4B)),
  infoTone: ThemedColor.value(Color(0xFF6EA8FF)),
  actionTone: ThemedColor.value(Color(0xFF7A8DFF)),
);
