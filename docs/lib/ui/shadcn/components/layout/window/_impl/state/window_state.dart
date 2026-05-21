// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// WindowState defines a reusable type for this registry module.
class WindowState {
  /// Current position and size of the window.
  ///
  /// Represents the window's bounding rectangle in logical pixels,
  /// with coordinates relative to the screen's top-left corner.
  final Rect bounds;

  /// Bounds of the window when maximized, or `null` if not maximized.
  ///
  /// When non-null, indicates the window is in maximized state and
  /// stores the previous bounds for restoration when un-maximizing.
  final Rect? maximized;

  /// Whether the window is currently minimized to the taskbar.
  ///
  /// When `true`, the window is hidden from view but remains in memory.
  /// Defaults to `false`.
  final bool minimized;

  /// Whether the window should always appear on top of other windows.
  ///
  /// When `true`, this window will be rendered above other windows
  /// regardless of focus state. Defaults to `false`.
  final bool alwaysOnTop;

  /// Whether the window can be closed by the user.
  ///
  /// When `false`, the close button is disabled or hidden.
  /// Defaults to `true`.
  final bool closable;

  /// Whether the window can be resized by dragging its edges or corners.
  ///
  /// When `false`, the window maintains a fixed size.
  /// Defaults to `true`.
  final bool resizable;

  /// Whether the window can be moved by dragging its title bar.
  ///
  /// When `false`, the window position is fixed.
  /// Defaults to `true`.
  final bool draggable;

  /// Whether the window can be maximized to fill the screen.
  ///
  /// When `false`, the maximize button is disabled or hidden.
  /// Defaults to `true`.
  final bool maximizable;

  /// Whether the window can be minimized to the taskbar.
  ///
  /// When `false`, the minimize button is disabled or hidden.
  /// Defaults to `true`.
  final bool minimizable;

  /// Whether edge snapping is enabled for this window.
  ///
  /// When `true`, dragging the window near screen edges or regions
  /// will trigger snap-to-edge behavior. Defaults to `true`.
  final bool enableSnapping;

  /// Size constraints for the window.
  ///
  /// Enforces minimum and maximum width/height limits when resizing.
  /// Defaults to [kDefaultWindowConstraints].
  final BoxConstraints constraints;

  /// Creates a window state with the specified configuration.
  ///
  /// Parameters:
  /// - [bounds]: Current window bounds (required)
  /// - [maximized]: Maximized state bounds (optional, `null` if not maximized)
  /// - [minimized]: Minimized state (defaults to `false`)
  /// - [alwaysOnTop]: Always-on-top behavior (defaults to `false`)
  /// - [closable]: Allow closing (defaults to `true`)
  /// - [resizable]: Allow resizing (defaults to `true`)
  /// - [draggable]: Allow dragging (defaults to `true`)
  /// - [maximizable]: Allow maximizing (defaults to `true`)
  /// - [minimizable]: Allow minimizing (defaults to `true`)
  /// - [enableSnapping]: Enable edge snapping (defaults to `true`)
  /// - [constraints]: Size constraints (defaults to [kDefaultWindowConstraints])
  const WindowState({
    required this.bounds,
    this.maximized,
    this.minimized = false,
    this.alwaysOnTop = false,
    this.closable = true,
    this.resizable = true,
    this.draggable = true,
    this.maximizable = true,
    this.minimizable = true,
    this.enableSnapping = true,
    this.constraints = kDefaultWindowConstraints,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WindowState) return false;
    return bounds == other.bounds &&
        maximized == other.maximized &&
        minimized == other.minimized &&
        alwaysOnTop == other.alwaysOnTop &&
        closable == other.closable &&
        resizable == other.resizable &&
        draggable == other.draggable &&
        maximizable == other.maximizable &&
        minimizable == other.minimizable &&
        enableSnapping == other.enableSnapping &&
        constraints == other.constraints;
  }

  @override
  int get hashCode => Object.hash(
    bounds,
    maximized,
    minimized,
    alwaysOnTop,
    closable,
    resizable,
    draggable,
    maximizable,
    minimizable,
    enableSnapping,
    constraints,
  );

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'WindowState(bounds: $bounds, maximized: $maximized, minimized: $minimized, alwaysOnTop: $alwaysOnTop, closable: $closable, resizable: $resizable, draggable: $draggable, maximizable: $maximizable, minimizable: $minimizable, enableSnapping: $enableSnapping, constraints: $constraints)';
  }

  /// Creates a copy of this state with only the maximized bounds changed.
  ///
  /// This is a specialized version of [copyWith] that only modifies the
  /// [maximized] property while preserving all other state values.
  ///
  /// Parameters:
  /// - [maximized]: New maximized bounds, or `null` to restore window
  ///
  /// Returns a new [WindowState] with updated maximized property.
  WindowState withMaximized(Rect? maximized) {
    return WindowState(
      bounds: bounds,
      minimized: minimized,
      alwaysOnTop: alwaysOnTop,
      closable: closable,
      resizable: resizable,
      draggable: draggable,
      maximizable: maximizable,
      minimizable: minimizable,
      enableSnapping: enableSnapping,
      constraints: constraints,
      maximized: maximized,
    );
  }

  /// Creates a copy of this state with selectively updated properties.
  ///
  /// Uses [ValueGetter] functions to allow nullable value replacement.
  /// Properties not provided (null) retain their current values. When
  /// a getter is provided, it's called to obtain the new value.
  ///
  /// Note: This method does not allow updating [maximized]. Use
  /// [withMaximized] instead for that purpose.
  ///
  /// Parameters:
  /// - [bounds]: Optional getter for new window bounds
  /// - [minimized]: Optional getter for minimized state
  /// - [alwaysOnTop]: Optional getter for always-on-top behavior
  /// - [closable]: Optional getter for closable state
  /// - [resizable]: Optional getter for resizable state
  /// - [draggable]: Optional getter for draggable state
  /// - [maximizable]: Optional getter for maximizable state
  /// - [minimizable]: Optional getter for minimizable state
  /// - [enableSnapping]: Optional getter for snapping enabled state
  /// - [constraints]: Optional getter for size constraints
  ///
  /// Returns a new [WindowState] instance with updated values.
  WindowState copyWith({
    ValueGetter<Rect>? bounds,
    ValueGetter<bool>? minimized,
    ValueGetter<bool>? alwaysOnTop,
    ValueGetter<bool>? closable,
    ValueGetter<bool>? resizable,
    ValueGetter<bool>? draggable,
    ValueGetter<bool>? maximizable,
    ValueGetter<bool>? minimizable,
    ValueGetter<bool>? enableSnapping,
    ValueGetter<BoxConstraints>? constraints,
  }) {
    return WindowState(
      bounds: bounds == null ? this.bounds : bounds(),
      minimized: minimized == null ? this.minimized : minimized(),
      alwaysOnTop: alwaysOnTop == null ? this.alwaysOnTop : alwaysOnTop(),
      closable: closable == null ? this.closable : closable(),
      resizable: resizable == null ? this.resizable : resizable(),
      draggable: draggable == null ? this.draggable : draggable(),
      maximizable: maximizable == null ? this.maximizable : maximizable(),
      minimizable: minimizable == null ? this.minimizable : minimizable(),
      enableSnapping: enableSnapping == null
          ? this.enableSnapping
          : enableSnapping(),
      constraints: constraints == null ? this.constraints : constraints(),
    );
  }
}
