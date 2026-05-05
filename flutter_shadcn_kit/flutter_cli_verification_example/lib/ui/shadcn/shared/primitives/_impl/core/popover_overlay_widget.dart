part of '../../overlay.dart';

/// PopoverOverlayWidget defines a reusable type for this registry module.
class PopoverOverlayWidget extends StatefulWidget {
  /// Creates a [PopoverOverlayWidget].
  const PopoverOverlayWidget({
    super.key,
    required this.anchorContext,
    this.position,
    required this.alignment,
    this.themes,
    required this.builder,
    required this.animation,
    required this.anchorAlignment,
    this.widthConstraint = PopoverConstraint.flexible,
    this.heightConstraint = PopoverConstraint.flexible,
    this.anchorSize,
    // this.route,
    this.onTapOutside,
    this.regionGroupId,
    this.offset,
    this.transitionAlignment,
    this.margin,
    this.follow = true,
    this.consumeOutsideTaps = true,
    this.onTickFollow,
    this.allowInvertHorizontal = true,
    this.allowInvertVertical = true,
    this.data,
    this.onClose,
    this.onImmediateClose,
    this.onCloseWithResult,
    this.layerLink,
  });

  /// Explicit position for the popover.
  final Offset? position;

  /// Alignment of the popover relative to the anchor.
  final AlignmentGeometry alignment;

  /// Alignment point on the anchor widget.
  final AlignmentGeometry anchorAlignment;

  /// Captured theme data from context.
  final CapturedThemes? themes;

  /// Captured inherited data from context.
  final CapturedData? data;

  /// Builder function for popover content.
  final WidgetBuilder builder;

  /// Size of the anchor widget.
  final Size? anchorSize;

  /// Animation progress for show/hide transitions.
  final double animation;

  /// Width constraint mode for the popover.
  final PopoverConstraint widthConstraint;

  /// Height constraint mode for the popover.
  final PopoverConstraint heightConstraint;

  // final PopoverRoute? route;

  /// Callback when popover is closing.
  final FutureVoidCallback? onClose;

  /// Callback for immediate close without animation.
  final VoidCallback? onImmediateClose;

  /// Callback when user taps outside the popover.
  final VoidCallback? onTapOutside;

  /// Region group identifier for coordinating multiple overlays.
  final Object? regionGroupId;

  /// Additional offset applied to popover position.
  final Offset? offset;

  /// Alignment for transition animations.
  final AlignmentGeometry? transitionAlignment;

  /// Margin around the popover.
  final EdgeInsetsGeometry? margin;

  /// Whether popover follows anchor movement.
  final bool follow;

  /// Build context of the anchor widget.
  final BuildContext anchorContext;

  /// Whether to consume taps outside the popover.
  final bool consumeOutsideTaps;

  /// Callback on each frame when following anchor.
  final ValueChanged<PopoverOverlayWidgetState>? onTickFollow;

  /// Allow horizontal inversion when constrained.
  final bool allowInvertHorizontal;

  /// Allow vertical inversion when constrained.
  final bool allowInvertVertical;

  /// Callback when closing with a result value.
  final PopoverFutureVoidCallback<Object?>? onCloseWithResult;

  /// Layer link for positioning.
  final LayerLink? layerLink;

  @override
/// Executes `createState` behavior for this component/composite.
  State<PopoverOverlayWidget> createState() => PopoverOverlayWidgetState();
}

/// Callback type for popover futures with value transformation.
///
/// Parameters:
/// - [value] (T): Input value to transform
///
/// Returns a [Future] with the transformed value.
typedef PopoverFutureVoidCallback<T> = Future<T> Function(T value);

/// Size constraint strategies for popover overlays.
///
/// - `flexible`: Size flexibly based on content and available space
/// - `intrinsic`: Use intrinsic content size
/// - `anchorFixedSize`: Match anchor's exact size
/// - `anchorMinSize`: Use anchor size as minimum
/// - `anchorMaxSize`: Use anchor size as maximum
enum PopoverConstraint {
  /// Size flexibly based on content and available space
  flexible,

  /// Use intrinsic content size
  intrinsic,

  /// Match anchor's exact size
  anchorFixedSize,

  /// Use anchor size as minimum
  anchorMinSize,

  /// Use anchor size as maximum
  anchorMaxSize,
}

/// State class for [PopoverOverlayWidget] managing popover positioning and lifecycle.
///
/// Handles dynamic positioning, anchor tracking, size constraints, and
/// animation for popover overlays. Implements [OverlayHandlerStateMixin]
/// for standard overlay lifecycle management.
