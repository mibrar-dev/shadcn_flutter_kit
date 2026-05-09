// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// WindowController defines a reusable type for this registry module.
class WindowController extends ValueNotifier<WindowState> {
  /// Stores `_attachedState` state/configuration for this implementation.
  WindowHandle? _attachedState;

  /// Creates a [WindowController].
  ///
  /// Parameters:
  /// - [bounds] (`Rect`, required): Initial window bounds.
  /// - [maximized] (`Rect?`, optional): Maximized bounds, or null if not maximized.
  /// - [minimized] (`bool`, default: `false`): Initial minimized state.
  /// - [focused] (`bool`, default: `false`): Initial focused state.
  /// - [closable] (`bool`, default: `true`): Whether window can be closed.
  /// - [resizable] (`bool`, default: `true`): Whether window can be resized.
  /// - [draggable] (`bool`, default: `true`): Whether window can be dragged.
  /// - [maximizable] (`bool`, default: `true`): Whether window can be maximized.
  /// - [minimizable] (`bool`, default: `true`): Whether window can be minimized.
  /// - [enableSnapping] (`bool`, default: `true`): Whether window snapping is enabled.
  /// - [constraints] (`BoxConstraints`, default: `kDefaultWindowConstraints`): Size constraints.
  WindowController({
    required Rect bounds,
    Rect? maximized,
    bool minimized = false,
    bool focused = false,
    bool closable = true,
    bool resizable = true,
    bool draggable = true,
    bool maximizable = true,
    bool minimizable = true,
    bool enableSnapping = true,
    BoxConstraints constraints = kDefaultWindowConstraints,
  }) : super(
         WindowState(
           bounds: bounds,
           maximized: maximized,
           minimized: minimized,
           alwaysOnTop: focused,
           closable: closable,
           resizable: resizable,
           draggable: draggable,
           maximizable: maximizable,
           minimizable: minimizable,
           enableSnapping: enableSnapping,
           constraints: constraints,
         ),
       );

  /// Whether the controller is currently attached to a window widget.
  ///
  /// Returns `true` if the controller is mounted within a window widget
  /// and can safely access [attachedState]. Returns `false` otherwise.
  bool get mounted => _attachedState != null;

  /// The window handle this controller is attached to.
  ///
  /// Provides access to the underlying window implementation for advanced
  /// operations. Only accessible when [mounted] is `true`.
  ///
  /// Throws an assertion error if accessed when not mounted.
  WindowHandle get attachedState {
    assert(mounted, 'Window is not attached');
    return _attachedState!;
  }

  /// Current position and size of the window.
  ///
  /// Setting this property updates the window bounds and triggers a UI refresh.
  /// The setter is a no-op if the new value equals the current value.
  Rect get bounds => value.bounds;

  /// Updates the window bounds.
  ///
  /// Changes take effect immediately and trigger listener notifications.
  set bounds(Rect value) {
    if (value == bounds) return;
    this.value = this.value.copyWith(bounds: () => value);
  }

  /// Maximized bounds, or `null` if the window is not maximized.
  ///
  /// When non-null, indicates the window is in maximized state.
  Rect? get maximized => value.maximized;

  /// Sets the maximized state and bounds.
  ///
  /// Pass a [Rect] to maximize the window to those bounds.
  /// Pass `null` to restore the window from maximized state.
  set maximized(Rect? value) {
    if (value == maximized) return;
    this.value = this.value.withMaximized(value);
  }

  /// Whether the window is currently minimized.
  ///
  /// When `true`, the window is hidden from view (e.g., in taskbar).
  bool get minimized => value.minimized;

  /// Sets the minimized state.
  ///
  /// Set to `true` to minimize the window, `false` to restore it.
  set minimized(bool value) {
    if (value == minimized) return;
    this.value = this.value.copyWith(minimized: () => value);
  }

  /// Whether the window always appears on top of other windows.
  bool get alwaysOnTop => value.alwaysOnTop;

  /// Sets the always-on-top behavior.
  ///
  /// When `true`, the window renders above other windows regardless of focus.
  set alwaysOnTop(bool value) {
    if (value == alwaysOnTop) return;
    this.value = this.value.copyWith(alwaysOnTop: () => value);
  }

  /// Whether the window can be closed.
  bool get closable => value.closable;

  /// Sets whether the window can be closed.
  ///
  /// When `false`, the close button is disabled or hidden.
  set closable(bool value) {
    if (value == closable) return;
    this.value = this.value.copyWith(closable: () => value);
  }

  /// Whether the window can be resized by dragging edges/corners.
  bool get resizable => value.resizable;

  /// Sets whether the window can be resized.
  set resizable(bool value) {
    if (value == resizable) return;
    this.value = this.value.copyWith(resizable: () => value);
  }

  /// Whether the window can be moved by dragging the title bar.
  bool get draggable => value.draggable;

  /// Sets whether the window can be dragged.
  set draggable(bool value) {
    if (value == draggable) return;
    this.value = this.value.copyWith(draggable: () => value);
  }

  /// Whether the window can be maximized.
  bool get maximizable => value.maximizable;

  /// Sets whether the window can be maximized.
  ///
  /// When `false`, the maximize button is disabled or hidden.
  set maximizable(bool value) {
    if (value == maximizable) return;
    this.value = this.value.copyWith(maximizable: () => value);
  }

  /// Whether the window can be minimized.
  bool get minimizable => value.minimizable;

  /// Sets whether the window can be minimized.
  ///
  /// When `false`, the minimize button is disabled or hidden.
  set minimizable(bool value) {
    if (value == minimizable) return;
    this.value = this.value.copyWith(minimizable: () => value);
  }

  /// Whether edge snapping is enabled for the window.
  bool get enableSnapping => value.enableSnapping;

  /// Sets whether edge snapping is enabled.
  ///
  /// When `true`, dragging near screen edges triggers snap behavior.
  set enableSnapping(bool value) {
    if (value == enableSnapping) return;
    this.value = this.value.copyWith(enableSnapping: () => value);
  }

  /// Size constraints for the window.
  ///
  /// Defines min/max width and height limits for resizing.
  BoxConstraints get constraints => value.constraints;

  /// Sets the size constraints for the window.
  set constraints(BoxConstraints value) {
    if (value == constraints) return;
    this.value = this.value.copyWith(constraints: () => value);
  }
}
