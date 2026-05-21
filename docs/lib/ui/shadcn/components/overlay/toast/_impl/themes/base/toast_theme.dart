// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../toast.dart';

/// Theme data for toast notifications.
class ToastTheme extends ComponentThemeData {
  /// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;

  /// Stores `margin` state/configuration for this implementation.
  final double? margin;

  /// Stores `duration` state/configuration for this implementation.
  final Duration? duration;

  /// Stores `animationDuration` state/configuration for this implementation.
  final Duration? animationDuration;

  /// Stores `animationCurve` state/configuration for this implementation.
  final Curve? animationCurve;

  /// Stores `width` state/configuration for this implementation.
  final double? width;

  /// Stores `borderRadius` state/configuration for this implementation.
  final double? borderRadius;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `pauseOnHover` state/configuration for this implementation.
  final bool? pauseOnHover;

  /// Stores `dismissDirections` state/configuration for this implementation.
  final Set<ToastSwipeDirection>? dismissDirections;

  /// Stores `dismissDragThreshold` state/configuration for this implementation.
  final double? dismissDragThreshold;

  /// Stores `overlapStackWhenMultiple` state/configuration for this implementation.
  final bool? overlapStackWhenMultiple;

  /// Stores `overlapStackOffset` state/configuration for this implementation.
  final double? overlapStackOffset;

  /// Stores `pauseAutoDismissWhenMultiple` state/configuration for this implementation.
  final bool? pauseAutoDismissWhenMultiple;

  /// Stores `stackAnimationDuration` state/configuration for this implementation.
  final Duration? stackAnimationDuration;

  /// Stores `stackAnimationCurve` state/configuration for this implementation.
  final Curve? stackAnimationCurve;

  /// Stores `maxVisibleCount` state/configuration for this implementation.
  final int? maxVisibleCount;

  /// Stores `dismissWholeStackWhenMultiple` state/configuration for this implementation.
  final bool? dismissWholeStackWhenMultiple;

  /// Creates a `ToastTheme` instance.
  const ToastTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.padding,
    this.margin,
    this.duration,
    this.animationDuration,
    this.animationCurve,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.pauseOnHover,
    this.dismissDirections,
    this.dismissDragThreshold,
    this.overlapStackWhenMultiple,
    this.overlapStackOffset,
    this.pauseAutoDismissWhenMultiple,
    this.stackAnimationDuration,
    this.stackAnimationCurve,
    this.maxVisibleCount,
    this.dismissWholeStackWhenMultiple,
  });

  /// Creates a `ToastTheme` instance.
  ToastTheme copyWith({
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? margin,
    ValueGetter<Duration?>? duration,
    ValueGetter<Duration?>? animationDuration,
    ValueGetter<Curve?>? animationCurve,
    ValueGetter<double?>? width,
    ValueGetter<double?>? borderRadius,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<bool?>? pauseOnHover,
    ValueGetter<Set<ToastSwipeDirection>?>? dismissDirections,
    ValueGetter<double?>? dismissDragThreshold,
    ValueGetter<bool?>? overlapStackWhenMultiple,
    ValueGetter<double?>? overlapStackOffset,
    ValueGetter<bool?>? pauseAutoDismissWhenMultiple,
    ValueGetter<Duration?>? stackAnimationDuration,
    ValueGetter<Curve?>? stackAnimationCurve,
    ValueGetter<int?>? maxVisibleCount,
    ValueGetter<bool?>? dismissWholeStackWhenMultiple,
  }) {
    return ToastTheme(
      padding: padding == null ? this.padding : padding(),
      margin: margin == null ? this.margin : margin(),
      duration: duration == null ? this.duration : duration(),
      animationDuration: animationDuration == null
          ? this.animationDuration
          : animationDuration(),
      animationCurve: animationCurve == null
          ? this.animationCurve
          : animationCurve(),
      width: width == null ? this.width : width(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      pauseOnHover: pauseOnHover == null ? this.pauseOnHover : pauseOnHover(),
      dismissDirections: dismissDirections == null
          ? this.dismissDirections
          : dismissDirections(),
      dismissDragThreshold: dismissDragThreshold == null
          ? this.dismissDragThreshold
          : dismissDragThreshold(),
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
    );
  }
}
