// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// Window defines a reusable type for this registry module.
class Window {
  /// Title widget displayed in the window's title bar.
  final Widget? title;

  /// Custom action widgets displayed in the title bar (e.g., minimize, maximize, close buttons).
  final Widget? actions;

  /// Main content widget displayed in the window body.
  final Widget? content;

  /// Controller for programmatic window management (position, size, state).
  final WindowController? controller;

  /// Initial bounds (position and size) of the window.
  final Rect? bounds;

  /// Bounds when window is in maximized state.
  final Rect? maximized;

  /// Whether the window starts in minimized state.
  final bool? minimized;

  /// Whether the window should always appear on top of other windows.
  final bool? alwaysOnTop;

  /// Whether window snapping is enabled (snap to edges or other windows).
  final bool? enableSnapping;

  /// Whether the window can be resized by dragging edges.
  final bool? resizable;

  /// Whether the window can be dragged by its title bar.
  final bool? draggable;

  /// Whether the window can be closed via the close button.
  final bool? closable;

  /// Whether the window can be maximized.
  final bool? maximizable;

  /// Whether the window can be minimized.
  final bool? minimizable;

  /// Size constraints for the window (min/max width and height).
  final BoxConstraints? constraints;

  final GlobalKey<_WindowWidgetState> _key = GlobalKey<_WindowWidgetState>(
    debugLabel: 'Window',
  );

  /// Notifier that indicates whether the window has been closed.
  ///
  /// External code can listen to this notifier to react to window close events.
  final ValueNotifier<bool> closed = ValueNotifier(false);

  /// Creates a controlled window with behavior managed by a [WindowController].
  ///
  /// This constructor creates a window whose state (position, size, minimized,
  /// maximized) is entirely controlled programmatically through the provided
  /// controller. All state properties are null and managed via the controller.
  ///
  /// Parameters:
  /// - [title] (Widget?): Title widget for the title bar
  /// - [actions] (Widget?): Custom action widgets, defaults to `WindowActions()`
  /// - [content] (Widget?): Main content widget
  /// - [controller] (WindowController, required): Controller for programmatic management
  ///
  /// Example:
  /// ```dart
  /// Window.controlled(
  ///   controller: myWindowController,
  ///   title: Text('Controlled Window'),
  ///   content: MyContentWidget(),
  /// )
  /// ```
  Window.controlled({
    this.title,
    this.actions = const WindowActions(),
    this.content,
    required this.controller,
  }) : bounds = null,
       maximized = null,
       minimized = null,
       alwaysOnTop = null,
       resizable = null,
       draggable = null,
       maximizable = null,
       minimizable = null,
       enableSnapping = null,
       closable = null,
       constraints = null;

  /// Creates a window with explicit state and configuration.
  ///
  /// This constructor creates a window with directly specified state properties
  /// rather than using a controller. The window's initial position, size, and
  /// capabilities are defined through the constructor parameters.
  ///
  /// Parameters:
  /// - [title] (Widget?): Title widget for the title bar
  /// - [actions] (Widget?): Custom action widgets, defaults to `WindowActions()`
  /// - [content] (Widget?): Main content widget
  /// - [resizable] (bool): Whether window can be resized, defaults to true
  /// - [draggable] (bool): Whether window can be dragged, defaults to true
  /// - [closable] (bool): Whether window can be closed, defaults to true
  /// - [maximizable] (bool): Whether window can be maximized, defaults to true
  /// - [minimizable] (bool): Whether window can be minimized, defaults to true
  /// - [enableSnapping] (bool): Whether snapping is enabled, defaults to true
  /// - [bounds] (Rect, required): Initial window bounds (position and size)
  /// - [maximized] (Rect?): Bounds when maximized
  /// - [minimized] (bool): Whether starts minimized, defaults to false
  /// - [alwaysOnTop] (bool): Whether always on top, defaults to false
  /// - [constraints] (BoxConstraints): Size constraints, defaults to `kDefaultWindowConstraints`
  ///
  /// Example:
  /// ```dart
  /// Window(
  ///   title: Text('My Window'),
  ///   bounds: Rect.fromLTWH(100, 100, 400, 300),
  ///   resizable: true,
  ///   content: MyContentWidget(),
  /// )
  /// ```
  Window({
    this.title,
    this.actions = const WindowActions(),
    this.content,
    bool this.resizable = true,
    bool this.draggable = true,
    bool this.closable = true,
    bool this.maximizable = true,
    bool this.minimizable = true,
    bool this.enableSnapping = true,
    required this.bounds,
    this.maximized,
    bool this.minimized = false,
    bool this.alwaysOnTop = false,
    BoxConstraints this.constraints = kDefaultWindowConstraints,
  }) : controller = null;

  /// Gets a handle to the window's internal state.
  ///
  /// Provides access to the window's state for programmatic control.
  /// The window must be mounted (added to the widget tree) before accessing
  /// this handle.
  ///
  /// Throws [AssertionError] if the window is not mounted.
  ///
  /// Returns [WindowHandle] for controlling the window state.
  WindowHandle get handle {
    /// Stores `currentState` state/configuration for this implementation.
    var currentState = _key.currentState;
    assert(currentState != null, 'Window is not mounted');
    return currentState!;
  }

  /// Indicates whether the window is currently mounted in the widget tree.
  ///
  /// A window is mounted when it has been added to the widget tree and has
  /// an associated build context. Unmounted windows cannot be controlled or
  /// accessed.
  ///
  /// Returns true if window is mounted, false otherwise.
  bool get mounted => _key.currentContext != null;

  Widget _build({
    required bool focused,
    required WindowNavigatorHandle navigator,
    required bool alwaysOnTop,
    required Size size,
    required bool minifyDragging,
    bool ignorePointer = false,
  }) {
    return ListenableBuilder(
      listenable: closed,
      child: Data.inherit(
        data: this,
        child: WindowWidget._raw(
          key: _key,
          title: title,
          actions: actions,
          content: content,
          resizable: resizable,
          draggable: draggable,
          closable: closable,
          maximizable: maximizable,
          minimizable: minimizable,
          enableSnapping: enableSnapping,
          controller: controller,
          bounds: bounds,
          maximized: maximized,
          minimized: minimized,
          constraints: constraints,
        ),
      ),
      builder: (context, child) {
        return Data.inherit(
          data: WindowViewport(
            ignorePointer: ignorePointer,
            size: size,
            navigator: navigator,
            focused: focused,
            alwaysOnTop: alwaysOnTop,
            closed: closed.value,
            minify: minifyDragging,
          ),
          child: child,
        );
      },
    );
  }
}
