// Window model and manager contracts shared by the `window` component
// (P4-B23: moved out of `components/window/window.dart`, which was over the
// ~400-line budget with the model inline).

import 'package:flutter/widgets.dart';

/// Default size constraints for windows: at least 200x200.
const BoxConstraints kDefaultWindowConstraints = BoxConstraints(
  minWidth: 200,
  minHeight: 200,
);

/// Immutable configuration and runtime state of one window.
class WindowState {
  /// Creates a window state.
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

  /// Position and size, in navigator coordinates.
  final Rect bounds;

  /// Relative bounds while maximized, or null when restored.
  final Rect? maximized;

  /// Whether the window is minimized.
  final bool minimized;

  /// Whether the window stays above non-top windows.
  final bool alwaysOnTop;

  /// Whether the window can be closed.
  final bool closable;

  /// Whether the window can be resized by its edges.
  final bool resizable;

  /// Whether the window can be dragged by its title bar.
  final bool draggable;

  /// Whether the window can be maximized.
  final bool maximizable;

  /// Whether the window can be minimized.
  final bool minimizable;

  /// Whether dragging near the navigator edges snaps the window.
  final bool enableSnapping;

  /// Resize limits.
  final BoxConstraints constraints;

  /// Returns a copy with the given fields replaced.
  WindowState copyWith({
    Rect? bounds,
    bool? minimized,
    bool? alwaysOnTop,
    bool? closable,
    bool? resizable,
    bool? draggable,
    bool? maximizable,
    bool? minimizable,
    bool? enableSnapping,
    BoxConstraints? constraints,
  }) {
    return WindowState(
      bounds: bounds ?? this.bounds,
      maximized: maximized,
      minimized: minimized ?? this.minimized,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      closable: closable ?? this.closable,
      resizable: resizable ?? this.resizable,
      draggable: draggable ?? this.draggable,
      maximizable: maximizable ?? this.maximizable,
      minimizable: minimizable ?? this.minimizable,
      enableSnapping: enableSnapping ?? this.enableSnapping,
      constraints: constraints ?? this.constraints,
    );
  }

  /// Returns a copy with [maximized] replaced (null restores the window).
  WindowState withMaximized(Rect? maximized) {
    return WindowState(
      bounds: bounds,
      maximized: maximized,
      minimized: minimized,
      alwaysOnTop: alwaysOnTop,
      closable: closable,
      resizable: resizable,
      draggable: draggable,
      maximizable: maximizable,
      minimizable: minimizable,
      enableSnapping: enableSnapping,
      constraints: constraints,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is WindowState &&
        other.bounds == bounds &&
        other.maximized == maximized &&
        other.minimized == minimized &&
        other.alwaysOnTop == alwaysOnTop &&
        other.closable == closable &&
        other.resizable == resizable &&
        other.draggable == draggable &&
        other.maximizable == maximizable &&
        other.minimizable == minimizable &&
        other.enableSnapping == enableSnapping &&
        other.constraints == constraints;
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
}

/// Reactive controller for one window's [WindowState].
class WindowController extends ValueNotifier<WindowState> {
  /// Creates a controller.
  WindowController({
    required Rect bounds,
    Rect? maximized,
    bool minimized = false,
    bool alwaysOnTop = false,
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
           alwaysOnTop: alwaysOnTop,
           closable: closable,
           resizable: resizable,
           draggable: draggable,
           maximizable: maximizable,
           minimizable: minimizable,
           enableSnapping: enableSnapping,
           constraints: constraints,
         ),
       );

  void _set(WindowState next) {
    if (next != value) {
      value = next;
    }
  }

  /// Current position and size.
  Rect get bounds => value.bounds;
  set bounds(Rect value) => _set(this.value.copyWith(bounds: value));

  /// Relative bounds while maximized, or null.
  Rect? get maximized => value.maximized;

  /// Maximizes to [value] or restores with null.
  set maximized(Rect? value) {
    if (value != maximized) {
      _set(this.value.withMaximized(value));
    }
  }

  bool get minimized => value.minimized;
  set minimized(bool value) => _set(this.value.copyWith(minimized: value));
  bool get alwaysOnTop => value.alwaysOnTop;
  set alwaysOnTop(bool value) => _set(this.value.copyWith(alwaysOnTop: value));
  bool get closable => value.closable;
  set closable(bool value) => _set(this.value.copyWith(closable: value));
  bool get resizable => value.resizable;
  set resizable(bool value) => _set(this.value.copyWith(resizable: value));
  bool get draggable => value.draggable;
  set draggable(bool value) => _set(this.value.copyWith(draggable: value));
  bool get maximizable => value.maximizable;
  set maximizable(bool value) => _set(this.value.copyWith(maximizable: value));
  bool get minimizable => value.minimizable;
  set minimizable(bool value) => _set(this.value.copyWith(minimizable: value));
  bool get enableSnapping => value.enableSnapping;
  set enableSnapping(bool value) =>
      _set(this.value.copyWith(enableSnapping: value));
  BoxConstraints get constraints => value.constraints;
  set constraints(BoxConstraints value) =>
      _set(this.value.copyWith(constraints: value));
}

/// The live handle a rendered window exposes to its chrome and actions.
abstract class WindowHandle {
  /// Current position and size.
  Rect get bounds;
  set bounds(Rect value);

  /// Relative bounds while maximized, or null.
  Rect? get maximized;
  set maximized(Rect? value);

  bool get minimized;
  set minimized(bool value);
  bool get closable;
  bool get resizable;
  bool get draggable;
  bool get maximizable;
  bool get minimizable;

  /// Whether this window currently has focus.
  bool get focused;

  /// Closes the window (removes it after its exit animation).
  void close();
}

/// Relative target a dragged window snaps to.
class WindowSnapStrategy {
  /// Creates a snap strategy.
  const WindowSnapStrategy({
    required this.relativeBounds,
    this.shouldMinifyWindow = true,
  });

  /// Target region in 0..1 navigator coordinates (e.g. left half).
  final Rect relativeBounds;

  /// Whether the window shrinks while hovering this target.
  final bool shouldMinifyWindow;
}

/// The data a [WindowManager] passes down to each rendered window.
class WindowViewport {
  /// Creates a viewport.
  const WindowViewport({
    required this.size,
    required this.manager,
    required this.focused,
    required this.alwaysOnTop,
    required this.minify,
    required this.ignorePointer,
  });

  /// Size of the visible navigator area.
  final Size size;

  /// The navigator managing this window.
  final WindowManager manager;

  /// Whether this window is the focused one in its layer.
  final bool focused;

  /// Whether this window is in the always-on-top layer.
  final bool alwaysOnTop;

  /// Whether the window shrinks for a snap preview.
  final bool minify;

  /// Whether pointer events are ignored (the window is being dragged).
  final bool ignorePointer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is WindowViewport &&
        other.size == size &&
        other.manager == manager &&
        other.focused == focused &&
        other.alwaysOnTop == alwaysOnTop &&
        other.minify == minify &&
        other.ignorePointer == ignorePointer;
  }

  @override
  int get hashCode =>
      Object.hash(size, manager, focused, alwaysOnTop, minify, ignorePointer);
}

/// Window management contract implemented by the `window` component's
/// navigator and exposed through [WindowViewport.manager].
///
/// Window identities are the `Window` widgets themselves.
abstract class WindowManager {
  /// Drag/snap state of the current gesture.
  WindowDragController get drag;

  /// Adds [window] to the front.
  void push(Object window);

  /// Moves [window] to the front of its layer and focuses it.
  void focus(Object window);

  /// Drops the focused layer without reordering.
  void unfocus(Object window);

  /// Removes [window].
  void remove(Object window);

  /// Moves [window] between the normal and always-on-top layers.
  void setAlwaysOnTop(Object window, bool value);

  /// Whether [window] is the focused window of its layer.
  bool isFocused(Object window);

  /// All windows, top layer last.
  List<Object> get windows;
}

/// Drag and snap bookkeeping for one navigator.
///
/// The navigator listens for rebuilds; the dragged window itself calls
/// [stop] on pan end and applies the returned strategy.
class WindowDragController extends ChangeNotifier {
  Object? _window;
  WindowSnapStrategy? _strategy;

  /// The window being dragged, or null.
  Object? get window => _window;

  /// The snap target under the pointer, or null.
  WindowSnapStrategy? get strategy => _strategy;

  /// Begins dragging [window] (clearing any hovered snap target).
  void start(Object window) {
    if (_window != null) {
      return;
    }
    _window = window;
    _strategy = null;
    notifyListeners();
  }

  /// Re-notifies listeners while the pointer moves.
  void update() => notifyListeners();

  /// Sets or clears the snap target under the pointer.
  void hover(WindowSnapStrategy? strategy) {
    if (strategy == _strategy) {
      return;
    }
    _strategy = strategy;
    notifyListeners();
  }

  /// Ends the drag and returns the snap target to apply, if any.
  WindowSnapStrategy? stop() {
    final WindowSnapStrategy? strategy = _strategy;
    _window = null;
    _strategy = null;
    notifyListeners();
    return strategy;
  }
}
