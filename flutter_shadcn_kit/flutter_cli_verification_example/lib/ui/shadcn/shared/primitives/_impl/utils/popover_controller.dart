part of '../../overlay.dart';

/// PopoverController defines a reusable type for this registry module.
class PopoverController extends ChangeNotifier {
/// Stores `_disposed` state/configuration for this implementation.
  bool _disposed = false;
/// Stores `_openPopovers` state/configuration for this implementation.
  final List<Popover> _openPopovers = [];

  /// Whether there are any open popovers that haven't completed.
  ///
  /// Returns true if any popover is currently open and not yet completed.
  bool get hasOpenPopover =>
      _openPopovers.isNotEmpty &&
      _openPopovers.any((element) => !element.entry.isCompleted);

  /// Whether there are any mounted popovers with animations in progress.
  ///
  /// Returns true if any popover is mounted and its animation hasn't completed.
  bool get hasMountedPopover =>
      _openPopovers.isNotEmpty &&
      _openPopovers.any((element) => !element.entry.isAnimationCompleted);

  /// Gets an unmodifiable view of currently open popovers.
  ///
  /// Returns an iterable of [Popover] instances that are currently managed
  /// by this controller.
  Iterable<Popover> get openPopovers => List.unmodifiable(_openPopovers);

  /// Shows a popover with the specified configuration.
  ///
  /// Creates and displays a popover overlay with extensive customization options.
  /// If [closeOthers] is true, closes existing popovers before showing the new one.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  /// - [builder] (WidgetBuilder, required): Popover content builder
  /// - [alignment] (AlignmentGeometry, required): Popover alignment
  /// - [anchorAlignment] (AlignmentGeometry?): Anchor alignment
  /// - [widthConstraint] (PopoverConstraint): Width constraint, defaults to flexible
  /// - [heightConstraint] (PopoverConstraint): Height constraint, defaults to flexible
  /// - [modal] (bool): Modal behavior, defaults to true
  /// - [closeOthers] (bool): Close other popovers, defaults to true
  /// - [offset] (Offset?): Position offset
  /// - [key] (`GlobalKey<OverlayHandlerStateMixin>?`): Widget key
  /// - [regionGroupId] (Object?): Region group ID
  /// - [transitionAlignment] (AlignmentGeometry?): Transition alignment
  /// - [consumeOutsideTaps] (bool): Consume outside taps, defaults to true
  /// - [margin] (EdgeInsetsGeometry?): Popover margin
  /// - [onTickFollow] (`ValueChanged<PopoverOverlayWidgetState>?`): Follow tick callback
  /// - [follow] (bool): Follow anchor on move, defaults to true
  /// - [allowInvertHorizontal] (bool): Allow horizontal inversion, defaults to true
  /// - [allowInvertVertical] (bool): Allow vertical inversion, defaults to true
  /// - [dismissBackdropFocus] (bool): Dismiss on backdrop focus, defaults to true
  /// - [showDuration] (Duration?): Show animation duration
  /// - [hideDuration] (Duration?): Hide animation duration
  /// - [overlayBarrier] (OverlayBarrier?): Custom barrier configuration
  /// - [handler] (OverlayHandler?): Custom overlay handler
  ///
  /// Returns a [Future] that completes with the popover result when dismissed.
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

    OverlayCompleter<T?> res = showPopover<T>(
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
    var popover = Popover._(key, res);
    _openPopovers.add(popover);
    notifyListeners();
    await res.future;
    _openPopovers.remove(popover);
    if (!_disposed) {
      notifyListeners();
    }
    return res.future;
  }

  /// Closes all managed popovers.
  ///
  /// Closes all popovers managed by this controller. If [immediate] is true,
  /// closes without animation.
  ///
  /// Parameters:
  /// - [immediate] (bool): Skip animation if true, defaults to false
  void close([bool immediate = false]) {
    for (Popover key in _openPopovers) {
      key.close(immediate);
    }
    _openPopovers.clear();
    notifyListeners();
  }

  /// Schedules closure of all popovers for the next frame.
  ///
  /// Defers closing to avoid issues when called during widget builds.
  void closeLater() {
    for (Popover key in _openPopovers) {
      key.closeLater();
    }
    _openPopovers.clear();
    notifyListeners();
  }

/// Executes `anchorContext` behavior for this component/composite.
  set anchorContext(BuildContext value) {
    for (Popover key in _openPopovers) {
      key.currentState?.anchorContext = value;
    }
  }

/// Executes `alignment` behavior for this component/composite.
  set alignment(AlignmentGeometry value) {
    for (Popover key in _openPopovers) {
      key.currentState?.alignment = value;
    }
  }

/// Executes `anchorAlignment` behavior for this component/composite.
  set anchorAlignment(AlignmentGeometry value) {
    for (Popover key in _openPopovers) {
      key.currentState?.anchorAlignment = value;
    }
  }

/// Executes `widthConstraint` behavior for this component/composite.
  set widthConstraint(PopoverConstraint value) {
    for (Popover key in _openPopovers) {
      key.currentState?.widthConstraint = value;
    }
  }

/// Executes `heightConstraint` behavior for this component/composite.
  set heightConstraint(PopoverConstraint value) {
    for (Popover key in _openPopovers) {
      key.currentState?.heightConstraint = value;
    }
  }

/// Executes `margin` behavior for this component/composite.
  set margin(EdgeInsets value) {
    for (Popover key in _openPopovers) {
      key.currentState?.margin = value;
    }
  }

/// Executes `follow` behavior for this component/composite.
  set follow(bool value) {
    for (Popover key in _openPopovers) {
      key.currentState?.follow = value;
    }
  }

/// Executes `offset` behavior for this component/composite.
  set offset(Offset? value) {
    for (Popover key in _openPopovers) {
      key.currentState?.offset = value;
    }
  }

/// Executes `allowInvertHorizontal` behavior for this component/composite.
  set allowInvertHorizontal(bool value) {
    for (Popover key in _openPopovers) {
      key.currentState?.allowInvertHorizontal = value;
    }
  }

/// Executes `allowInvertVertical` behavior for this component/composite.
  set allowInvertVertical(bool value) {
    for (Popover key in _openPopovers) {
      key.currentState?.allowInvertVertical = value;
    }
  }

  /// Disposes all managed popovers.
  ///
  /// Schedules closure of all popovers. Called automatically when the
  /// controller is disposed.
  void disposePopovers() {
    for (Popover key in _openPopovers) {
      key.closeLater();
    }
  }

  @override
/// Executes `dispose` behavior for this component/composite.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    disposePopovers();
    super.dispose();
  }
}

/// Custom layout widget for positioning popover content.
///
/// Handles popover positioning with alignment, sizing constraints, and
/// automatic inversion when content would overflow screen bounds.
