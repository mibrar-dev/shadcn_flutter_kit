// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// DrawerOverlayCompleter defines a reusable type for this registry module.
class DrawerOverlayCompleter<T> extends OverlayCompleter<T> {
  /// Stores `_entry` state/configuration for this implementation.
  final DrawerOverlayEntry<T> _entry;

  /// Creates a drawer overlay completer.
  ///
  /// Parameters:
  /// - [_entry] (`DrawerOverlayEntry<T>`, required): The drawer entry to manage
  DrawerOverlayCompleter(this._entry);

  @override
  /// Stores `animationFuture` state/configuration for this implementation.
  Future<void> get animationFuture => _entry.completer.future;

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _entry.completer.complete();
  }

  /// Gets the animation controller for the drawer.
  ///
  /// Returns the external animation controller if provided, otherwise
  /// returns the internal controller from the drawer entry widget state.
  ///
  /// Returns [AnimationController] or null if not available.
  AnimationController? get animationController =>
      _entry.animationController ?? _entry.key.currentState?._controller;

  @override
  /// Stores `future` state/configuration for this implementation.
  Future<T> get future => _entry.completer.future;

  @override
  /// Stores `isAnimationCompleted` state/configuration for this implementation.
  bool get isAnimationCompleted => _entry.completer.isCompleted;

  @override
  /// Stores `isCompleted` state/configuration for this implementation.
  bool get isCompleted => _entry.completer.isCompleted;

  @override
  /// Executes `remove` behavior for this component/composite.
  void remove() {
    _entry.completer.complete();
  }
}

/// Overlay handler specialized for sheet-style overlays.
///
/// Provides a simplified API for showing sheet overlays (bottom sheets,
/// side sheets, etc.) with standard positioning and barrier behavior.
