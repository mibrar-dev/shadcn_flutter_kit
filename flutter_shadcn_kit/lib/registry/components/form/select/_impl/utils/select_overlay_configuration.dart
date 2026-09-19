// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Describes how a [Select] popup is presented.
///
/// Registry passthrough mirroring the upstream `OverlayConfiguration` API so
/// code written against upstream compiles. Only [PopoverConfiguration] is
/// currently honored, and it is wired directly to [PopoverController.show]:
/// there is no adaptive conversion (e.g. popover becoming a drawer on mobile)
/// yet. [Select.adaptiveOverlay] is accepted and stored for API parity but
/// the presentation is always a popover.
abstract class OverlayConfiguration {
  /// Creates an [OverlayConfiguration].
  const OverlayConfiguration();
}

/// Presents [Select] popup content as a popover.
///
/// Every field maps to the corresponding [PopoverController.show] parameter
/// in [SelectState]; fields with no popover equivalent (upstream concepts
/// such as anchors) are intentionally omitted.
class PopoverConfiguration extends OverlayConfiguration {
  /// Popover alignment relative to the anchor.
  final AlignmentGeometry alignment;

  /// Anchor alignment point.
  final AlignmentGeometry? anchorAlignment;

  /// Width constraint mode.
  final PopoverConstraint widthConstraint;

  /// Height constraint mode.
  final PopoverConstraint heightConstraint;

  /// Additional position offset.
  final Offset? offset;

  /// Margin around the popover.
  final EdgeInsetsGeometry? margin;

  /// Whether the popover is modal.
  final bool modal;

  /// Whether the popover follows the anchor if it moves.
  final bool follow;

  /// Whether outside taps are consumed.
  final bool consumeOutsideTaps;

  /// Whether horizontal inversion is allowed when space is constrained.
  final bool allowInvertHorizontal;

  /// Whether vertical inversion is allowed when space is constrained.
  final bool allowInvertVertical;

  /// Whether to dismiss when backdrop gains focus.
  final bool dismissBackdropFocus;

  /// Region grouping identifier.
  final Object? regionGroupId;

  /// Transition origin alignment.
  final AlignmentGeometry? transitionAlignment;

  /// Callback invoked on every follow tick.
  final ValueChanged<PopoverOverlayWidgetState>? onTickFollow;

  /// Show animation duration.
  final Duration? showDuration;

  /// Dismiss animation duration.
  final Duration? dismissDuration;

  /// Custom barrier configuration.
  final OverlayBarrier? overlayBarrier;

  /// Creates a [PopoverConfiguration].
  const PopoverConfiguration({
    required this.alignment,
    this.anchorAlignment,
    this.widthConstraint = PopoverConstraint.flexible,
    this.heightConstraint = PopoverConstraint.flexible,
    this.offset,
    this.margin,
    this.modal = true,
    this.follow = true,
    this.consumeOutsideTaps = true,
    this.allowInvertHorizontal = true,
    this.allowInvertVertical = true,
    this.dismissBackdropFocus = true,
    this.regionGroupId,
    this.transitionAlignment,
    this.onTickFollow,
    this.showDuration,
    this.dismissDuration,
    this.overlayBarrier,
  });
}
