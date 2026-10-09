// `PopoverController`: manages the lifetime of several popovers at once.
//
// Ported from `shared/primitives/_impl/utils/popover_controller.dart`.

import 'package:flutter/widgets.dart';

import 'overlay.dart';
import 'popover.dart';
import 'popover_overlay_state.dart';

/// Manages a set of open popovers: show, close, update and dispose.
class PopoverController extends ChangeNotifier {
  bool _disposed = false;
  final List<Popover> _openPopovers = [];

  /// Whether any managed popover is open and not yet completed.
  bool get hasOpenPopover =>
      _openPopovers.isNotEmpty &&
      _openPopovers.any((element) => !element.entry.isCompleted);

  /// Whether any managed popover is mounted with an animation in progress.
  bool get hasMountedPopover =>
      _openPopovers.isNotEmpty &&
      _openPopovers.any((element) => !element.entry.isAnimationCompleted);

  /// Unmodifiable view of the currently open popovers.
  Iterable<Popover> get openPopovers => List.unmodifiable(_openPopovers);

  /// Shows a popover and completes with its result.
  ///
  /// When [closeOthers] is true the currently open popovers are closed first.
  Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    required AlignmentGeometry alignment,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    bool modal = true,
    bool closeOthers = true,
    Offset? offset,
    GlobalKey<OverlayHandlerStateMixin>? key,
    Object? regionGroupId,
    AlignmentGeometry? transitionAlignment,
    bool consumeOutsideTaps = true,
    EdgeInsetsGeometry? margin,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool follow = true,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? hideDuration,
    OverlayBarrier? overlayBarrier,
    OverlayHandler? handler,
  }) async {
    if (closeOthers) {
      close();
    }
    key ??= GlobalKey<OverlayHandlerStateMixin>(
      debugLabel: 'PopoverAnchor$hashCode',
    );
    final OverlayCompleter<T?> res = showPopover<T>(
      context: context,
      alignment: alignment,
      anchorAlignment: anchorAlignment,
      builder: builder,
      modal: modal,
      widthConstraint: widthConstraint,
      heightConstraint: heightConstraint,
      key: key,
      regionGroupId: regionGroupId,
      offset: offset,
      transitionAlignment: transitionAlignment,
      consumeOutsideTaps: consumeOutsideTaps,
      margin: margin,
      onTickFollow: onTickFollow,
      follow: follow,
      allowInvertHorizontal: allowInvertHorizontal,
      allowInvertVertical: allowInvertVertical,
      dismissBackdropFocus: dismissBackdropFocus,
      showDuration: showDuration,
      dismissDuration: hideDuration,
      overlayBarrier: overlayBarrier,
      handler: handler,
    );
    final popover = Popover.from(key, res);
    _openPopovers.add(popover);
    notifyListeners();
    await res.future;
    _openPopovers.remove(popover);
    if (!_disposed) {
      notifyListeners();
    }
    return res.future;
  }

  /// Closes all managed popovers, optionally without animation.
  void close([bool immediate = false]) {
    for (final popover in _openPopovers) {
      popover.close(immediate);
    }
    _openPopovers.clear();
    notifyListeners();
  }

  /// Schedules closure of all managed popovers for the next frame.
  void closeLater() {
    for (final popover in _openPopovers) {
      popover.closeLater();
    }
    _openPopovers.clear();
    notifyListeners();
  }

  /// Updates the anchor context of every open popover.
  set anchorContext(BuildContext value) {
    for (final popover in _openPopovers) {
      popover.currentState?.anchorContext = value;
    }
  }

  /// Updates the alignment of every open popover.
  set alignment(AlignmentGeometry value) {
    for (final popover in _openPopovers) {
      popover.currentState?.alignment = value;
    }
  }

  /// Updates the anchor alignment of every open popover.
  set anchorAlignment(AlignmentGeometry value) {
    for (final popover in _openPopovers) {
      popover.currentState?.anchorAlignment = value;
    }
  }

  /// Updates the width constraint of every open popover.
  set widthConstraint(PopoverConstraint value) {
    for (final popover in _openPopovers) {
      popover.currentState?.widthConstraint = value;
    }
  }

  /// Updates the height constraint of every open popover.
  set heightConstraint(PopoverConstraint value) {
    for (final popover in _openPopovers) {
      popover.currentState?.heightConstraint = value;
    }
  }

  /// Updates the margin of every open popover.
  set margin(EdgeInsets value) {
    for (final popover in _openPopovers) {
      popover.currentState?.margin = value;
    }
  }

  /// Updates the follow flag of every open popover.
  set follow(bool value) {
    for (final popover in _openPopovers) {
      popover.currentState?.follow = value;
    }
  }

  /// Updates the offset of every open popover.
  set offset(Offset? value) {
    for (final popover in _openPopovers) {
      popover.currentState?.offset = value;
    }
  }

  /// Updates horizontal inversion permission of every open popover.
  set allowInvertHorizontal(bool value) {
    for (final popover in _openPopovers) {
      popover.currentState?.allowInvertHorizontal = value;
    }
  }

  /// Updates vertical inversion permission of every open popover.
  set allowInvertVertical(bool value) {
    for (final popover in _openPopovers) {
      popover.currentState?.allowInvertVertical = value;
    }
  }

  /// Schedules closure of all popovers (used on dispose).
  void disposePopovers() {
    for (final popover in _openPopovers) {
      popover.closeLater();
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    disposePopovers();
    super.dispose();
  }
}
