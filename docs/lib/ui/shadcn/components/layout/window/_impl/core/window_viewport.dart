// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// WindowViewport defines a reusable type for this registry module.
class WindowViewport {
  /// The size of the window's visible area.
  final Size size;

  /// Reference to the window navigator managing this window.
  final WindowNavigatorHandle navigator;

  /// Whether this window currently has focus.
  final bool focused;

  /// Whether this window is set to always appear on top.
  final bool alwaysOnTop;

  /// Whether this window has been closed.
  final bool closed;

  /// Whether the window is being minimized (transitioning to minimized state).
  final bool minify;

  /// Whether pointer events should be ignored for this window.
  final bool ignorePointer;

  /// Creates a window viewport data object.
  ///
  /// All parameters are required and define the current state of the window
  /// within its viewport context.
  ///
  /// Parameters:
  /// - [size] (Size, required): Visible area size
  /// - [navigator] (WindowNavigatorHandle, required): Managing navigator
  /// - [focused] (bool, required): Focus state
  /// - [alwaysOnTop] (bool, required): Always-on-top state
  /// - [closed] (bool, required): Closed state
  /// - [minify] (bool, required): Minimizing state
  /// - [ignorePointer] (bool, required): Pointer event state
  const WindowViewport({
    required this.size,
    required this.navigator,
    required this.focused,
    required this.alwaysOnTop,
    required this.closed,
    required this.minify,
    required this.ignorePointer,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WindowViewport) return false;
    return size == other.size &&
        navigator == other.navigator &&
        focused == other.focused &&
        alwaysOnTop == other.alwaysOnTop &&
        closed == other.closed &&
        minify == other.minify;
  }

  @override
  int get hashCode =>
      Object.hash(size, navigator, focused, alwaysOnTop, closed, minify);
}
