part of '../../dialog.dart';

/// _DialogOverlayWrapperState defines a reusable type for this registry module.
class _DialogOverlayWrapperState<T> extends State<_DialogOverlayWrapper<T>>
    with OverlayHandlerStateMixin {
  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Data<OverlayHandlerStateMixin>.inherit(
      data: this,
      child: widget.child,
    );
  }

  @override
/// Executes `close` behavior for this component/composite.
  Future<void> close([bool immediate = false]) {
    if (immediate || !widget.route.isCurrent) {
      widget.route.navigator?.removeRoute(widget.route);
    } else {
      widget.route.navigator?.pop();
    }
    return widget.route.completed;
  }

  @override
/// Executes `closeLater` behavior for this component/composite.
  void closeLater() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.route.isCurrent) {
        widget.route.navigator?.pop();
      } else {
        widget.route.navigator?.removeRoute(widget.route);
      }
    });
  }

  @override
  Future<void> closeWithResult<X>([X? value]) {
    if (widget.route.isCurrent) {
      widget.route.navigator?.pop(value);
    } else {
      widget.route.navigator?.removeRoute(widget.route);
    }
    return widget.route.completed;
  }
}

/// Overlay handler that manages dialog display using the navigation stack.
///
/// Provides a standardized way to show dialogs through the overlay system
/// with proper theme inheritance, animation handling, and modal behavior.
/// Integrates with the shadcn_flutter overlay architecture for consistent
/// dialog management across the application.
///
/// Features:
/// - Navigation-based dialog management
/// - Theme and data inheritance
/// - Configurable modal barriers
/// - Animation integration
/// - Proper focus management
///
/// Example:
/// ```dart
/// const DialogOverlayHandler().show<String>(
///   context: context,
///   alignment: Alignment.center,
///   builder: (context) => MyCustomDialog(),
/// );
/// ```
