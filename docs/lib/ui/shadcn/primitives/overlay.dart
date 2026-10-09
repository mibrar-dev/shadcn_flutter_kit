// Core overlay contracts: the `OverlayHandler` interface used to present
// overlays, the completion handle they return, barrier configuration and the
// shared close helpers.
//
// Ported from `shared/primitives/overlay.dart` + `_impl/utils/overlay_completer.dart`
// and `_impl/utils/overlay_handler.dart` and `_impl/core/overlay_barrier.dart`.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import 'popover_overlay_handler.dart';
import 'popover_overlay_state.dart';

/// Callback returning a future, used by overlay close hooks.
typedef FutureVoidCallback = Future<void> Function();

/// Callback mapping a value to a future of the same value.
typedef PopoverFutureVoidCallback<T> = Future<T> Function(T value);

/// Size constraint strategies for popover overlays.
enum PopoverConstraint {
  /// Size flexibly based on content and available space.
  flexible,

  /// Use the intrinsic content size.
  intrinsic,

  /// Match the anchor's exact size.
  anchorFixedSize,

  /// Use the anchor size as a minimum.
  anchorMinSize,

  /// Use the anchor size as a maximum.
  anchorMaxSize,
}

/// Handle to a presented overlay: removal, completion and animation futures.
abstract class OverlayCompleter<T> {
  /// Removes the overlay from the screen.
  void remove();

  /// Disposes the overlay resources.
  void dispose();

  /// Whether the overlay result future has completed.
  bool get isCompleted;

  /// Whether the overlay animation has completed.
  bool get isAnimationCompleted;

  /// Completes with the overlay result value.
  Future<T?> get future;

  /// Completes when the overlay animation finishes.
  Future<void> get animationFuture;
}

/// Presents overlays (popover, tooltip, menu) and returns their completer.
abstract class OverlayHandler {
  /// Default popover overlay handler.
  static const OverlayHandler popover = PopoverOverlayHandler();

  /// Creates an [OverlayHandler].
  const OverlayHandler();

  /// Shows an overlay.
  ///
  /// See the parameter documentation on the concrete handlers; the defaults
  /// match `PopoverOverlayHandler.show`.
  OverlayCompleter<T?> show<T>({
    required BuildContext context,
    required AlignmentGeometry alignment,
    required WidgetBuilder builder,
    Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    Offset? offset,
    AlignmentGeometry? transitionAlignment,
    EdgeInsetsGeometry? margin,
    bool follow = true,
    bool consumeOutsideTaps = true,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? dismissDuration,
    OverlayBarrier? overlayBarrier,
    LayerLink? layerLink,
  });
}

/// Visual configuration of the modal barrier behind an overlay.
class OverlayBarrier {
  /// Padding around the barrier.
  final EdgeInsetsGeometry padding;

  /// Border radius of the barrier shape.
  final BorderRadiusGeometry borderRadius;

  /// Barrier color (typically semi-transparent).
  final Color? barrierColor;

  /// Creates an overlay barrier configuration.
  const OverlayBarrier({
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    this.barrierColor,
  });
}

/// State-level contract implemented by every overlay widget.
///
/// The setters allow a `PopoverController` to update a live overlay; the
/// default no-op implementations let simple overlays ignore them.
mixin OverlayHandlerStateMixin<T extends StatefulWidget> on State<T> {
  /// Closes the overlay.
  Future<void> close([bool immediate = false]);

  /// Schedules overlay closure for the next frame.
  void closeLater();

  /// Closes the overlay with a result value.
  Future<void> closeWithResult<X>([X? value]);

  /// Updates the anchor context for positioning.
  set anchorContext(BuildContext value) {}

  /// Updates the overlay alignment.
  set alignment(AlignmentGeometry value) {}

  /// Updates the anchor alignment.
  set anchorAlignment(AlignmentGeometry value) {}

  /// Updates the width constraint.
  set widthConstraint(PopoverConstraint value) {}

  /// Updates the height constraint.
  set heightConstraint(PopoverConstraint value) {}

  /// Updates the margin.
  set margin(EdgeInsets value) {}

  /// Updates whether the overlay follows the anchor.
  set follow(bool value) {}

  /// Updates the position offset.
  set offset(Offset? value) {}

  /// Updates horizontal inversion permission.
  set allowInvertHorizontal(bool value) {}

  /// Updates vertical inversion permission.
  set allowInvertVertical(bool value) {}
}

/// Closes the overlay that [context] is inside, with an optional result.
Future<void> closeOverlay<T>(BuildContext context, [T? value]) {
  return Data.maybeFind<OverlayHandlerStateMixin>(
        context,
      )?.closeWithResult(value) ??
      Future.value();
}
