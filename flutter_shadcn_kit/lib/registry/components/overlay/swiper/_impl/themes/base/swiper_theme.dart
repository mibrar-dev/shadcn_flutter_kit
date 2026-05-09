// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../swiper.dart';

/// SwiperTheme defines a reusable type for this registry module.
class SwiperTheme extends ComponentThemeData {
  /// Whether the swiper should expand to fill available space.
  final bool? expands;

  /// Whether the swiper can be dragged to dismiss.
  final bool? draggable;

  /// Whether tapping the barrier dismisses the swiper.
  final bool? barrierDismissible;

  /// Builder for custom backdrop content.
  final WidgetBuilder? backdropBuilder;

  /// Whether to respect device safe areas.
  final bool? useSafeArea;

  /// Whether to show the drag handle.
  final bool? showDragHandle;

  /// Border radius for the swiper container.
  final BorderRadiusGeometry? borderRadius;

  /// Size of the drag handle when displayed.
  final Size? dragHandleSize;

  /// Whether to transform the backdrop when shown.
  final bool? transformBackdrop;

  /// Opacity for surface effects.
  final double? surfaceOpacity;

  /// Blur intensity for surface effects.
  final double? surfaceBlur;

  /// Color of the modal barrier.
  final Color? barrierColor;

  /// Hit test behavior for gesture detection.
  final HitTestBehavior? behavior;

  /// Creates a [SwiperTheme].
  ///
  /// All parameters are optional and will use system defaults when null.
  ///
  /// Example:
  /// ```dart
  /// const SwiperTheme(
  ///   expands: true,
  ///   draggable: true,
  ///   transformBackdrop: true,
  /// )
  /// ```
  const SwiperTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.expands,
    this.draggable,
    this.barrierDismissible,
    this.backdropBuilder,
    this.useSafeArea,
    this.showDragHandle,
    this.borderRadius,
    this.dragHandleSize,
    this.transformBackdrop,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor,
    this.behavior,
  });

  /// Creates a copy of this theme with optionally replaced values.
  ///
  /// All parameters are wrapped in [ValueGetter] to allow lazy evaluation
  /// and dynamic theme changes.
  SwiperTheme copyWith({
    ValueGetter<bool?>? expands,
    ValueGetter<bool?>? draggable,
    ValueGetter<bool?>? barrierDismissible,
    ValueGetter<WidgetBuilder?>? backdropBuilder,
    ValueGetter<bool?>? useSafeArea,
    ValueGetter<bool?>? showDragHandle,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<Size?>? dragHandleSize,
    ValueGetter<bool?>? transformBackdrop,
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<Color?>? barrierColor,
    ValueGetter<HitTestBehavior?>? behavior,
  }) {
    return SwiperTheme(
      expands: expands == null ? this.expands : expands(),
      draggable: draggable == null ? this.draggable : draggable(),
      barrierDismissible: barrierDismissible == null
          ? this.barrierDismissible
          : barrierDismissible(),
      backdropBuilder: backdropBuilder == null
          ? this.backdropBuilder
          : backdropBuilder(),
      useSafeArea: useSafeArea == null ? this.useSafeArea : useSafeArea(),
      showDragHandle: showDragHandle == null
          ? this.showDragHandle
          : showDragHandle(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      dragHandleSize: dragHandleSize == null
          ? this.dragHandleSize
          : dragHandleSize(),
      transformBackdrop: transformBackdrop == null
          ? this.transformBackdrop
          : transformBackdrop(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      barrierColor: barrierColor == null ? this.barrierColor : barrierColor(),
      behavior: behavior == null ? this.behavior : behavior(),
    );
  }

  @override
  int get hashCode => Object.hash(
    expands,
    draggable,
    barrierDismissible,
    backdropBuilder,
    useSafeArea,
    showDragHandle,
    borderRadius,
    dragHandleSize,
    transformBackdrop,
    surfaceOpacity,
    surfaceBlur,
    barrierColor,
    behavior,
  );

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SwiperTheme &&
        other.expands == expands &&
        other.draggable == draggable &&
        other.barrierDismissible == barrierDismissible &&
        other.backdropBuilder == backdropBuilder &&
        other.useSafeArea == useSafeArea &&
        other.showDragHandle == showDragHandle &&
        other.borderRadius == borderRadius &&
        other.dragHandleSize == dragHandleSize &&
        other.transformBackdrop == transformBackdrop &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.barrierColor == barrierColor &&
        other.behavior == behavior;
  }

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'SwiperTheme(expands: $expands, draggable: $draggable, barrierDismissible: $barrierDismissible, backdropBuilder: $backdropBuilder, useSafeArea: $useSafeArea, showDragHandle: $showDragHandle, borderRadius: $borderRadius, dragHandleSize: $dragHandleSize, transformBackdrop: $transformBackdrop, surfaceOpacity: $surfaceOpacity, surfaceBlur: $surfaceBlur, barrierColor: $barrierColor, behavior: $behavior)';
  }
}

/// Abstract handler interface for swiper overlay implementations.
///
/// Defines the contract for creating different types of swiper overlays,
/// with built-in implementations for drawer-style and sheet-style swipers.
///
/// Features:
/// - Pluggable swiper behavior patterns
/// - Built-in drawer and sheet implementations
/// - Consistent API across swiper types
/// - Configurable overlay properties
///
/// Example:
/// ```dart
/// // Use built-in handlers
/// const SwiperHandler.drawer
/// const SwiperHandler.sheet
/// ```
