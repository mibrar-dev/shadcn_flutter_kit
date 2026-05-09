// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../gooey_toast.dart';

class GooeyToastTheme extends shad.ComponentThemeData {
  const GooeyToastTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,

    /// Preferred toast width in logical px.
    ///
    /// `null` falls back to widget override then `350`.
    this.width,

    /// Base gooey surface color for compact and expanded body.
    ///
    /// `null` falls back to widget override then `Color(0xFF0D1117)`.
    this.fill,

    /// Corner roundness in logical px for default shape.
    ///
    /// `null` falls back to widget override then `18`.
    this.roundness,

    /// Compact title text style override.
    ///
    /// `null` uses computed style from theme text tokens.
    this.titleStyle,

    /// Expanded description text style override.
    ///
    /// `null` uses computed style from theme text tokens.
    this.descriptionStyle,

    /// Whether toast lifetime pauses while pointer hovers the item.
    ///
    /// `null` falls back to widget override then `true`.
    this.pauseOnHover,

    /// Enables swipe dismiss gesture wiring on shown toasts.
    ///
    /// `null` falls back to widget override then `true`.
    this.swipeToDismiss,

    /// Allowed dismiss swipe directions.
    ///
    /// `null` resolves from position + expandDirection defaults.
    this.dismissDirections,

    /// Minimum drag distance in logical px before swipe dismiss triggers.
    ///
    /// Default fallback is `72`. Values `<= 0` are passed through.
    this.dismissDragThreshold,

    /// Vertical spacing between stacked toasts in logical px.
    ///
    /// `0` means touching stacks. Positive values add gaps.
    this.spacing,

    /// Enables overlap-stacking in the underlying toast stack.
    this.overlapStackWhenMultiple,

    /// Overlap offset per stacked item in logical px.
    ///
    /// `0` disables offset. Positive pushes stack depth visually.
    this.overlapStackOffset,

    /// Pauses auto-dismiss when multiple toasts are visible.
    this.pauseAutoDismissWhenMultiple,

    /// Duration used for stack reflow animation.
    this.stackAnimationDuration,

    /// Curve used for stack reflow animation.
    this.stackAnimationCurve,

    /// Max visible stack entries before clipping in stack renderer.
    ///
    /// Default fallback is `4`. `0`/negative are passed to stack controller.
    this.maxVisibleCount,

    /// Whether swipe dismiss removes the entire stack group when multi.
    this.dismissWholeStackWhenMultiple,

    /// Default expansion animation style for all `GooeyToast` instances.
    this.animationStyle,

    /// Default shape style variant for all `GooeyToast` instances.
    this.shapeStyle,

    /// Default expanded content animation style for all `GooeyToast` instances.
    this.bodyAnimationStyle,

    /// Enables the gooey blur compositing pass behind the crisp shape.
    ///
    /// `null` falls back to widget/controller override then `true`.
    this.enableGooeyBlur,

    /// Tone override for `success` state icon/title.
    this.successTone,

    /// Tone override for `loading` state icon/title.
    this.loadingTone,

    /// Tone override for `error` state icon/title.
    this.errorTone,

    /// Tone override for `warning` state icon/title.
    this.warningTone,

    /// Tone override for `info` state icon/title.
    this.infoTone,

    /// Tone override for `action` state icon/title.
    this.actionTone,
  });

  /// Theme-level width override in logical px.
  final double? width;

  /// Theme-level surface fill override.
  final Color? fill;

  /// Theme-level corner roundness override in logical px.
  final double? roundness;

  /// Theme-level compact title style override.
  final TextStyle? titleStyle;

  /// Theme-level expanded description style override.
  final TextStyle? descriptionStyle;

  /// Theme-level hover pause toggle.
  final bool? pauseOnHover;

  /// Theme-level swipe dismiss toggle.
  final bool? swipeToDismiss;

  /// Theme-level dismiss direction override.
  final Set<GooeyToastSwipeDirection>? dismissDirections;

  /// Theme-level swipe threshold in logical px.
  final double? dismissDragThreshold;

  /// Theme-level stack spacing in logical px.
  final double? spacing;

  /// Theme-level overlap stack toggle.
  final bool? overlapStackWhenMultiple;

  /// Theme-level overlap offset in logical px.
  final double? overlapStackOffset;

  /// Theme-level multi-toast pause toggle.
  final bool? pauseAutoDismissWhenMultiple;

  /// Theme-level stack animation duration.
  final Duration? stackAnimationDuration;

  /// Theme-level stack animation curve.
  final Curve? stackAnimationCurve;

  /// Theme-level max visible stack size.
  final int? maxVisibleCount;

  /// Theme-level dismiss-whole-stack toggle.
  final bool? dismissWholeStackWhenMultiple;

  /// Theme-level default animation style.
  final GooeyToastAnimationStyle? animationStyle;

  /// Theme-level default shape style.
  final GooeyToastShapeStyle? shapeStyle;

  /// Theme-level expanded content animation style.
  final GooeyToastBodyAnimationStyle? bodyAnimationStyle;

  /// Theme-level gooey blur pass toggle.
  final bool? enableGooeyBlur;

  /// Theme-level success tone override.
  final Color? successTone;

  /// Theme-level loading tone override.
  final Color? loadingTone;

  /// Theme-level error tone override.
  final Color? errorTone;

  /// Theme-level warning tone override.
  final Color? warningTone;

  /// Theme-level info tone override.
  final Color? infoTone;

  /// Theme-level action tone override.
  final Color? actionTone;

  /// Returns a new theme where each provided callback overrides one field.
  ///
  /// Pass a callback returning `null` to explicitly clear a nullable override
  /// and restore downstream fallback (widget override -> hard default).
  GooeyToastTheme copyWith({
    /// Resolves next `width`; omit to keep existing value.
    ValueGetter<double?>? width,

    /// Resolves next `fill`; omit to keep existing value.
    ValueGetter<Color?>? fill,

    /// Resolves next `roundness`; omit to keep existing value.
    ValueGetter<double?>? roundness,

    /// Resolves next `titleStyle`; omit to keep existing value.
    ValueGetter<TextStyle?>? titleStyle,

    /// Resolves next `descriptionStyle`; omit to keep existing value.
    ValueGetter<TextStyle?>? descriptionStyle,

    /// Resolves next `pauseOnHover`; omit to keep existing value.
    ValueGetter<bool?>? pauseOnHover,

    /// Resolves next `swipeToDismiss`; omit to keep existing value.
    ValueGetter<bool?>? swipeToDismiss,

    /// Resolves next `dismissDirections`; omit to keep existing value.
    ValueGetter<Set<GooeyToastSwipeDirection>?>? dismissDirections,

    /// Resolves next `dismissDragThreshold`; omit to keep existing value.
    ValueGetter<double?>? dismissDragThreshold,

    /// Resolves next `spacing`; omit to keep existing value.
    ValueGetter<double?>? spacing,

    /// Resolves next `overlapStackWhenMultiple`; omit to keep existing value.
    ValueGetter<bool?>? overlapStackWhenMultiple,

    /// Resolves next `overlapStackOffset`; omit to keep existing value.
    ValueGetter<double?>? overlapStackOffset,

    /// Resolves next `pauseAutoDismissWhenMultiple`; omit to keep existing value.
    ValueGetter<bool?>? pauseAutoDismissWhenMultiple,

    /// Resolves next `stackAnimationDuration`; omit to keep existing value.
    ValueGetter<Duration?>? stackAnimationDuration,

    /// Resolves next `stackAnimationCurve`; omit to keep existing value.
    ValueGetter<Curve?>? stackAnimationCurve,

    /// Resolves next `maxVisibleCount`; omit to keep existing value.
    ValueGetter<int?>? maxVisibleCount,

    /// Resolves next `dismissWholeStackWhenMultiple`; omit to keep existing value.
    ValueGetter<bool?>? dismissWholeStackWhenMultiple,

    /// Resolves next `animationStyle`; omit to keep existing value.
    ValueGetter<GooeyToastAnimationStyle?>? animationStyle,

    /// Resolves next `shapeStyle`; omit to keep existing value.
    ValueGetter<GooeyToastShapeStyle?>? shapeStyle,

    /// Resolves next `bodyAnimationStyle`; omit to keep existing value.
    ValueGetter<GooeyToastBodyAnimationStyle?>? bodyAnimationStyle,

    /// Resolves next `enableGooeyBlur`; omit to keep existing value.
    ValueGetter<bool?>? enableGooeyBlur,

    /// Resolves next `successTone`; omit to keep existing value.
    ValueGetter<Color?>? successTone,

    /// Resolves next `loadingTone`; omit to keep existing value.
    ValueGetter<Color?>? loadingTone,

    /// Resolves next `errorTone`; omit to keep existing value.
    ValueGetter<Color?>? errorTone,

    /// Resolves next `warningTone`; omit to keep existing value.
    ValueGetter<Color?>? warningTone,

    /// Resolves next `infoTone`; omit to keep existing value.
    ValueGetter<Color?>? infoTone,

    /// Resolves next `actionTone`; omit to keep existing value.
    ValueGetter<Color?>? actionTone,
  }) {
    return GooeyToastTheme(
      width: width == null ? this.width : width(),
      fill: fill == null ? this.fill : fill(),
      roundness: roundness == null ? this.roundness : roundness(),
      titleStyle: titleStyle == null ? this.titleStyle : titleStyle(),
      descriptionStyle: descriptionStyle == null
          ? this.descriptionStyle
          : descriptionStyle(),
      pauseOnHover: pauseOnHover == null ? this.pauseOnHover : pauseOnHover(),
      swipeToDismiss: swipeToDismiss == null
          ? this.swipeToDismiss
          : swipeToDismiss(),
      dismissDirections: dismissDirections == null
          ? this.dismissDirections
          : dismissDirections(),
      dismissDragThreshold: dismissDragThreshold == null
          ? this.dismissDragThreshold
          : dismissDragThreshold(),
      spacing: spacing == null ? this.spacing : spacing(),
      overlapStackWhenMultiple: overlapStackWhenMultiple == null
          ? this.overlapStackWhenMultiple
          : overlapStackWhenMultiple(),
      overlapStackOffset: overlapStackOffset == null
          ? this.overlapStackOffset
          : overlapStackOffset(),
      pauseAutoDismissWhenMultiple: pauseAutoDismissWhenMultiple == null
          ? this.pauseAutoDismissWhenMultiple
          : pauseAutoDismissWhenMultiple(),
      stackAnimationDuration: stackAnimationDuration == null
          ? this.stackAnimationDuration
          : stackAnimationDuration(),
      stackAnimationCurve: stackAnimationCurve == null
          ? this.stackAnimationCurve
          : stackAnimationCurve(),
      maxVisibleCount: maxVisibleCount == null
          ? this.maxVisibleCount
          : maxVisibleCount(),
      dismissWholeStackWhenMultiple: dismissWholeStackWhenMultiple == null
          ? this.dismissWholeStackWhenMultiple
          : dismissWholeStackWhenMultiple(),
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
}
