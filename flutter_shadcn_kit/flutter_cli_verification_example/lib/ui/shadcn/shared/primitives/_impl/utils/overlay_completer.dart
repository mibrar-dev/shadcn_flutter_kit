part of '../../overlay.dart';

/// OverlayCompleter defines a reusable type for this registry module.
abstract class OverlayCompleter<T> {
  /// Removes the overlay from the screen.
  void remove();

  /// Disposes resources associated with the overlay.
  void dispose();

  /// Whether the overlay operation has completed.
  bool get isCompleted;

  /// Whether the overlay's animation has completed.
  bool get isAnimationCompleted;

  /// Future that completes with the overlay's result value.
  Future<T?> get future;

  /// Future that completes when the overlay animation finishes.
  Future<void> get animationFuture;
}

/// Abstract handler for managing overlay presentation and lifecycle.
///
/// Provides common interface for different overlay types (popover, sheet, dialog)
/// with customizable display, positioning, and interaction behavior.
