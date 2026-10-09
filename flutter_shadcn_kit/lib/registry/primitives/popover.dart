// Popover handle + entry and the top-level `showPopover` entry point.
//
// Ported from `shared/primitives/overlay.dart` + `_impl/core/popover.dart`,
// `_impl/core/overlay_popover_entry.dart` and
// `_impl/core/overlay_popover_entry.dart` (showPopover).

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'overlay.dart';
import 'overlay_manager.dart';
import 'popover_overlay_state.dart';

/// A handle to a presented popover.
class Popover {
  /// Key of the overlay widget, used to reach its state.
  final GlobalKey<OverlayHandlerStateMixin> key;

  /// Completer that tracks this popover's lifecycle.
  final OverlayCompleter entry;

  /// Creates a popover handle. Used by `PopoverController`.
  Popover.from(this.key, this.entry);

  /// Closes this popover, optionally without animation.
  Future<void> close([bool immediate = false]) {
    final currentState = key.currentState;
    if (currentState != null) {
      return currentState.close(immediate);
    } else {
      entry.remove();
    }
    return Future.value();
  }

  /// Schedules this popover to close after the current frame.
  void closeLater() {
    final currentState = key.currentState;
    if (currentState != null) {
      currentState.closeLater();
    } else {
      entry.remove();
    }
  }

  /// Removes this popover without animation.
  void remove() {
    entry.remove();
  }

  /// Current overlay state, or null when not mounted.
  OverlayHandlerStateMixin? get currentState => key.currentState;
}

/// [OverlayCompleter] implementation for popover overlays.
class OverlayPopoverEntry<T> implements OverlayCompleter<T> {
  late OverlayEntry _overlayEntry;
  late OverlayEntry? _barrierEntry;

  /// Completes with the popover result value.
  final Completer<T?> completer = Completer();

  /// Completes when the popover's entry/exit animation finishes.
  final Completer<T?> animationCompleter = Completer();

  bool _removed = false;
  bool _disposed = false;

  @override
  bool get isCompleted => completer.isCompleted;

  /// Initializes the entry with its overlay entries.
  void initialize(OverlayEntry overlayEntry, [OverlayEntry? barrierEntry]) {
    _overlayEntry = overlayEntry;
    _barrierEntry = barrierEntry;
  }

  @override
  void remove() {
    if (_removed) return;
    _removed = true;
    _overlayEntry.remove();
    _barrierEntry?.remove();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _overlayEntry.dispose();
    _barrierEntry?.dispose();
  }

  @override
  Future<T?> get future => completer.future;

  @override
  Future<T?> get animationFuture => animationCompleter.future;

  @override
  bool get isAnimationCompleted => animationCompleter.isCompleted;
}

/// Shows a popover over [context].
///
/// Uses [OverlayManager.of] (the app-level overlay stack) unless [handler] is
/// given. See [OverlayHandler.show] for the parameter semantics.
OverlayCompleter<T?> showPopover<T>({
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
  OverlayHandler? handler,
}) {
  handler ??= OverlayManager.of(context);
  return handler.show<T>(
    context: context,
    alignment: alignment,
    builder: builder,
    position: position,
    anchorAlignment: anchorAlignment,
    widthConstraint: widthConstraint,
    heightConstraint: heightConstraint,
    key: key,
    rootOverlay: rootOverlay,
    modal: modal,
    barrierDismissable: barrierDismissable,
    clipBehavior: clipBehavior,
    regionGroupId: regionGroupId,
    offset: offset,
    transitionAlignment: transitionAlignment,
    margin: margin,
    follow: follow,
    consumeOutsideTaps: consumeOutsideTaps,
    onTickFollow: onTickFollow,
    allowInvertHorizontal: allowInvertHorizontal,
    allowInvertVertical: allowInvertVertical,
    dismissBackdropFocus: dismissBackdropFocus,
    showDuration: showDuration,
    dismissDuration: dismissDuration,
    overlayBarrier: overlayBarrier,
  );
}
