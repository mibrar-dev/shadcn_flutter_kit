// The overlay widget that renders a popover: positioning, transition, outside
// taps and captured theme/data.
//
// Ported from `shared/primitives/_impl/core/popover_overlay_widget.dart`; the
// state lives in `popover_overlay_state.dart`.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import 'overlay.dart';
import 'popover_overlay_state.dart';

/// A positioned overlay widget rendered inside the overlay stack.
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

  /// Popover alignment relative to the anchor.
  final AlignmentGeometry alignment;

  /// Alignment point on the anchor widget.
  final AlignmentGeometry anchorAlignment;

  /// Themes captured from the anchor context.
  final CapturedThemes? themes;

  /// Data captured from the anchor context.
  final CapturedData? data;

  /// Builds the popover content.
  final WidgetBuilder builder;

  /// Size of the anchor widget.
  final Size? anchorSize;

  /// Show/hide animation progress (0..1).
  final double animation;

  /// Width constraint strategy.
  final PopoverConstraint widthConstraint;

  /// Height constraint strategy.
  final PopoverConstraint heightConstraint;

  /// Called when the popover starts closing.
  final FutureVoidCallback? onClose;

  /// Called for immediate close without animation.
  final VoidCallback? onImmediateClose;

  /// Called when the user taps outside the popover.
  final VoidCallback? onTapOutside;

  /// Region group id for coordinating multiple overlays.
  final Object? regionGroupId;

  /// Additional offset applied to the computed position.
  final Offset? offset;

  /// Alignment used as the transition origin.
  final AlignmentGeometry? transitionAlignment;

  /// Margin around the popover.
  final EdgeInsetsGeometry? margin;

  /// Whether the popover follows the anchor.
  final bool follow;

  /// Anchor context used to compute the position.
  final BuildContext anchorContext;

  /// Whether outside taps are consumed.
  final bool consumeOutsideTaps;

  /// Called on every frame while following the anchor.
  final ValueChanged<PopoverOverlayWidgetState>? onTickFollow;

  /// Whether horizontal inversion is allowed.
  final bool allowInvertHorizontal;

  /// Whether vertical inversion is allowed.
  final bool allowInvertVertical;

  /// Called when closing with a result value.
  final PopoverFutureVoidCallback<Object?>? onCloseWithResult;

  /// Layer link used for positioning.
  final LayerLink? layerLink;

  @override
  State<PopoverOverlayWidget> createState() => PopoverOverlayWidgetState();
}
