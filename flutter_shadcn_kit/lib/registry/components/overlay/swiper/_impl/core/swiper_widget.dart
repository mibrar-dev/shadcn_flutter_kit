// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../swiper.dart';

/// Swiper defines a reusable type for this registry module.
class Swiper extends StatefulWidget {
  /// Whether swipe gestures are enabled.
  final bool enabled;

  /// Position from which the overlay should appear.
  final OverlayPosition position;

  /// Builder function that creates the overlay content.
  final WidgetBuilder builder;

  /// Handler that defines the overlay behavior (drawer or sheet).
  final SwiperHandler handler;

  /// Whether the overlay should expand to fill available space.
  final bool? expands;

  /// Whether the overlay can be dragged to dismiss.
  final bool? draggable;

  /// Whether tapping the barrier dismisses the overlay.
  final bool? barrierDismissible;

  /// Builder for custom backdrop content.
  final WidgetBuilder? backdropBuilder;

  /// Whether to respect device safe areas.
  final bool? useSafeArea;

  /// Whether to show the drag handle.
  final bool? showDragHandle;

  /// Border radius for the overlay container.
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

  /// The child widget that responds to swipe gestures.
  final Widget child;

  /// Hit test behavior for gesture detection.
  final HitTestBehavior? behavior;

  /// Creates a [Swiper].
  ///
  /// The [position], [builder], [handler], and [child] parameters are required.
  /// Other parameters customize the overlay behavior and appearance.
  ///
  /// Parameters:
  /// - [enabled] (bool, default: true): whether swipe gestures are enabled
  /// - [position] (OverlayPosition, required): side from which overlay appears
  /// - [builder] (WidgetBuilder, required): builds the overlay content
  /// - [handler] (SwiperHandler, required): defines overlay behavior (drawer/sheet)
  /// - [child] (Widget, required): widget that responds to swipe gestures
  /// - [expands] (bool?, optional): whether overlay expands to fill space
  /// - [draggable] (bool?, optional): whether overlay can be dragged to dismiss
  /// - [barrierDismissible] (bool?, optional): whether barrier tap dismisses overlay
  /// - [backdropBuilder] (WidgetBuilder?, optional): custom backdrop builder
  /// - [useSafeArea] (bool?, optional): whether to respect safe areas
  /// - [showDragHandle] (bool?, optional): whether to show drag handle
  /// - [borderRadius] (BorderRadiusGeometry?, optional): overlay corner radius
  /// - [dragHandleSize] (Size?, optional): size of drag handle
  /// - [transformBackdrop] (bool?, optional): whether to transform backdrop
  /// - [surfaceOpacity] (double?, optional): surface opacity level
  /// - [surfaceBlur] (double?, optional): surface blur intensity
  /// - [barrierColor] (Color?, optional): modal barrier color
  /// - [behavior] (HitTestBehavior?, optional): gesture detection behavior
  ///
  /// Example:
  /// ```dart
  /// Swiper(
  ///   position: OverlayPosition.bottom,
  ///   handler: SwiperHandler.sheet,
  ///   builder: (context) => ActionSheet(),
  ///   child: FloatingActionButton(
  ///     onPressed: null,
  ///     child: Icon(Icons.more_horiz),
  ///   ),
  /// )
  /// ```
  const Swiper({
    super.key,
    this.enabled = true,
    required this.position,
    required this.builder,
    required this.handler,
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
    required this.child,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Swiper> createState() => _SwiperState();
}
