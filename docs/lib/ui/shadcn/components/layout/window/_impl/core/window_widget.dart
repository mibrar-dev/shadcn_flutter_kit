// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// WindowWidget defines a reusable type for this registry module.
class WindowWidget extends StatefulWidget {
  /// Widget displayed in the window's title bar.
  ///
  /// Typically a [Text] widget, but can be any widget. Positioned on the
  /// left side of the title bar by default.
  final Widget? title;

  /// Widget(s) displayed in the title bar's action area.
  ///
  /// Usually contains window control buttons (minimize, maximize, close)
  /// or custom action buttons. Positioned on the right side of the title bar.
  final Widget? actions;

  /// Main content widget displayed in the window body.
  ///
  /// This is the primary content area below the title bar. Can be any widget,
  /// such as forms, lists, or custom layouts.
  final Widget? content;

  /// Optional controller for programmatic window control.
  ///
  /// When provided (via [WindowWidget.controlled]), the controller manages
  /// all window state. When `null` (default constructor), widget properties
  /// control the state directly.
  final WindowController? controller;

  /// Whether the window can be resized by dragging edges/corners.
  ///
  /// Defaults to `true`. Ignored when using [WindowWidget.controlled].
  final bool? resizable;

  /// Whether the window can be moved by dragging the title bar.
  ///
  /// Defaults to `true`. Ignored when using [WindowWidget.controlled].
  final bool? draggable;

  /// Whether the window can be closed.
  ///
  /// Defaults to `true`. Ignored when using [WindowWidget.controlled].
  final bool? closable;

  /// Whether the window can be maximized.
  ///
  /// Defaults to `true`. Ignored when using [WindowWidget.controlled].
  final bool? maximizable;

  /// Whether the window can be minimized.
  ///
  /// Defaults to `true`. Ignored when using [WindowWidget.controlled].
  final bool? minimizable;

  /// Initial position and size of the window.
  ///
  /// Required for default constructor. Ignored when using [WindowWidget.controlled].
  final Rect? bounds;

  /// Initial maximized bounds, or `null` if not maximized.
  ///
  /// Ignored when using [WindowWidget.controlled].
  final Rect? maximized;

  /// Whether the window starts minimized.
  ///
  /// Defaults to `false`. Ignored when using [WindowWidget.controlled].
  final bool? minimized;

  /// Whether edge snapping is enabled.
  ///
  /// Defaults to `true`. Ignored when using [WindowWidget.controlled].
  final bool? enableSnapping;

  /// Size constraints for the window.
  ///
  /// Enforces min/max dimensions during resizing.
  /// Defaults to [kDefaultWindowConstraints]. Ignored when using [WindowWidget.controlled].
  final BoxConstraints? constraints;

  /// Height of the title bar in logical pixels.
  ///
  /// If `null`, uses the theme's default title bar height.
  final double? titleBarHeight;

  /// Thickness of the resize border in logical pixels.
  ///
  /// If `null`, uses the theme's default resize thickness.
  final double? resizeThickness;

  /// Creates a window with direct state management.
  ///
  /// All window state properties ([bounds], [minimized], etc.) are managed
  /// directly through widget properties. State changes require rebuilding
  /// the widget with new property values.
  ///
  /// Parameters:
  /// - [title]: Title bar content
  /// - [actions]: Action buttons area content
  /// - [content]: Main window content
  /// - [titleBarHeight]: Custom title bar height (optional)
  /// - [resizeThickness]: Custom resize border thickness (optional)
  /// - [resizable]: Enable resizing (defaults to `true`)
  /// - [draggable]: Enable dragging (defaults to `true`)
  /// - [closable]: Enable closing (defaults to `true`)
  /// - [maximizable]: Enable maximizing (defaults to `true`)
  /// - [minimizable]: Enable minimizing (defaults to `true`)
  /// - [enableSnapping]: Enable edge snapping (defaults to `true`)
  /// - [bounds]: Initial window bounds (required)
  /// - [maximized]: Initial maximized bounds (optional)
  /// - [minimized]: Start minimized (defaults to `false`)
  /// - [constraints]: Size constraints (defaults to [kDefaultWindowConstraints])
  const WindowWidget({
    super.key,
    this.title,
    this.actions,
    this.content,
    this.titleBarHeight,
    this.resizeThickness,
    bool this.resizable = true,
    bool this.draggable = true,
    bool this.closable = true,
    bool this.maximizable = true,
    bool this.minimizable = true,
    bool this.enableSnapping = true,
    required Rect this.bounds,
    this.maximized,
    bool this.minimized = false,
    BoxConstraints this.constraints = kDefaultWindowConstraints,
  }) : controller = null;

  /// Creates a window with controller-based state management.
  ///
  /// State is managed entirely through the provided [controller]. All state
  /// properties from the default constructor are unavailable and must be
  /// controlled via the controller instead.
  ///
  /// This pattern is recommended when you need:
  /// - Programmatic control over window state
  /// - To listen to state changes
  /// - To share state across multiple widgets
  /// - More reactive state updates
  ///
  /// Parameters:
  /// - [controller]: The window controller (required)
  /// - [title]: Title bar content
  /// - [actions]: Action buttons area content
  /// - [content]: Main window content
  /// - [titleBarHeight]: Custom title bar height (optional)
  /// - [resizeThickness]: Custom resize border thickness (optional)
  ///
  /// Example:
  /// ```dart
  /// final controller = WindowController(
  ///   bounds: Rect.fromLTWH(100, 100, 800, 600),
  /// );
  ///
  /// // Later, programmatically control:
  /// controller.minimized = true;
  /// controller.bounds = Rect.fromLTWH(200, 200, 900, 700);
  /// ```
  const WindowWidget.controlled({
    super.key,
    this.title,
    this.actions,
    this.content,
    required WindowController this.controller,
    this.titleBarHeight,
    this.resizeThickness,
  }) : bounds = null,
       maximized = null,
       minimized = null,
       resizable = null,
       draggable = null,
       closable = null,
       maximizable = null,
       minimizable = null,
       enableSnapping = null,
       constraints = null;

  const WindowWidget._raw({
    super.key,
    this.title,
    this.actions,
    this.content,
    this.resizable = true,
    this.draggable = true,
    this.closable = true,
    this.maximizable = true,
    this.minimizable = true,
    this.enableSnapping = true,
    this.controller,
    this.bounds,
    this.maximized,
    this.minimized,
    this.constraints,
  }) : titleBarHeight = null,
       resizeThickness = null;

  @override
  /// Executes `createState` behavior for this component/composite.
  State<WindowWidget> createState() => _WindowWidgetState();
}
