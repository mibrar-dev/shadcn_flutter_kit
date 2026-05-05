part of '../../dialog.dart';

/// DialogOverlayCompleter defines a reusable type for this registry module.
class DialogOverlayCompleter<T> extends OverlayCompleter<T> {
  /// The dialog route managed by this completer.
  final DialogRoute<T> route;

  /// Creates a [DialogOverlayCompleter].
  ///
  /// Parameters:
  /// - [route] (`DialogRoute<T>`, required): the dialog route to manage
  ///
  /// Example:
  /// ```dart
  /// DialogOverlayCompleter(myDialogRoute)
  /// ```
  DialogOverlayCompleter(this.route);

  @override
/// Stores `animationFuture` state/configuration for this implementation.
  Future<void> get animationFuture => route.completed;

  @override
/// Executes `dispose` behavior for this component/composite.
  void dispose() {
    route.dispose();
  }

  @override
  Future<T> get future => route.popped.then((value) {
    assert(value is T, 'Dialog route was closed without returning a value');
    return value as T;
  });

  @override
/// Stores `isAnimationCompleted` state/configuration for this implementation.
  bool get isAnimationCompleted => route.animation?.isCompleted ?? true;

  @override
/// Stores `isCompleted` state/configuration for this implementation.
  bool get isCompleted => route.animation?.isCompleted ?? true;

  @override
/// Executes `remove` behavior for this component/composite.
  void remove() {
    if (route.isCurrent) {
      route.navigator?.pop();
    } else {
      route.navigator?.removeRoute(route);
    }
  }
}
