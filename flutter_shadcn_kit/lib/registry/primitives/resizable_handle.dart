// The resizable divider handle: the public [ResizableHandle] configuration and
// the interactive [ResizableHandleView] (hover cursor, focus, keyboard
// stepping, semantics and drag gesture). Extracted from the `resizable`
// component so its files stay within the layout budget.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/color_tokens.dart';

/// Keyboard step, in logical pixels, applied to a focused handle by an arrow
/// key.
const double resizableHandleStep = 10;

/// A draggable divider between two resizable panes.
///
/// The default is a 1px themed line with an enlarged hit area. Set
/// [withHandle] to draw a grip bar; the handle is focusable and moves with the
/// arrow keys (10px steps, Home/End to the extremes).
class ResizableHandle extends StatelessWidget {
  /// Creates a handle.
  const ResizableHandle({
    super.key,
    this.withHandle = false,
    this.enabled = true,
    this.thickness,
    this.hitThickness,
    this.color,
    this.gripColor,
    this.gripSize,
    this.cursor,
    this.focusNode,
    this.autofocus = false,
  });

  /// Whether to draw the grip bar.
  final bool withHandle;

  /// Whether the handle responds to drags and keyboard focus.
  final bool enabled;

  /// Divider line thickness; null resolves the theme default.
  final double? thickness;

  /// Gesture hit-area thickness; null resolves the theme default.
  final double? hitThickness;

  /// Divider colour override.
  final ThemedColor? color;

  /// Grip colour override.
  final ThemedColor? gripColor;

  /// Grip size for a horizontal group.
  final Size? gripSize;

  /// Mouse cursor override.
  final MouseCursor? cursor;

  /// Focus node override.
  final FocusNode? focusNode;

  /// Whether the handle autofocuses.
  final bool autofocus;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// The interactive region of a resizable divider. The owning component
/// positions it over the 1px divider line.
class ResizableHandleView extends StatefulWidget {
  /// Creates a handle view.
  const ResizableHandleView({
    super.key,
    required this.axis,
    required this.enabled,
    required this.withHandle,
    required this.gripColor,
    required this.gripSize,
    required this.active,
    required this.semanticsLabel,
    required this.onHoverChanged,
    required this.onStep,
    required this.onEdge,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    this.cursor,
    this.focusNode,
    this.autofocus = false,
  });

  /// The group axis (arrow keys map to it).
  final Axis axis;

  /// Whether the handle responds to drags and keyboard focus.
  final bool enabled;

  /// Whether the grip bar is drawn.
  final bool withHandle;

  /// Grip colour.
  final Color gripColor;

  /// Grip size for a horizontal group.
  final Size gripSize;

  /// Whether the handle is hovered or dragged (highlights the grip).
  final bool active;

  /// Semantics label.
  final String semanticsLabel;

  /// Called when the hover state changes.
  final ValueChanged<bool> onHoverChanged;

  /// Called with a pixel step along the main axis.
  final ValueChanged<double> onStep;

  /// Called with `true` for the end extreme, `false` for the start.
  final ValueChanged<bool> onEdge;

  /// Called when a drag starts.
  final VoidCallback onDragStart;

  /// Called with the drag delta along the main axis.
  final ValueChanged<double> onDragUpdate;

  /// Called when a drag ends.
  final VoidCallback onDragEnd;

  /// Called when a drag is cancelled.
  final VoidCallback onDragCancel;

  /// Mouse cursor override.
  final MouseCursor? cursor;

  /// Focus node override.
  final FocusNode? focusNode;

  /// Whether the handle autofocuses.
  final bool autofocus;

  @override
  State<ResizableHandleView> createState() => _ResizableHandleViewState();
}

class _ResizableHandleViewState extends State<ResizableHandleView> {
  FocusNode? _internalNode;

  FocusNode get _node =>
      widget.focusNode ??
      (_internalNode ??= FocusNode(debugLabel: 'resizable-handle'));

  @override
  void dispose() {
    _internalNode?.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final bool horizontal = widget.axis == Axis.horizontal;
    final LogicalKeyboardKey key = event.logicalKey;
    final LogicalKeyboardKey forward = horizontal
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowDown;
    final LogicalKeyboardKey backward = horizontal
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowUp;
    if (key == forward) {
      widget.onStep(resizableHandleStep);
      return KeyEventResult.handled;
    }
    if (key == backward) {
      widget.onStep(-resizableHandleStep);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      widget.onEdge(false);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      widget.onEdge(true);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final bool horizontal = widget.axis == Axis.horizontal;
    final Widget grip = widget.withHandle
        ? Center(
            child: Container(
              width: horizontal
                  ? widget.gripSize.width
                  : widget.gripSize.height,
              height: horizontal
                  ? widget.gripSize.height
                  : widget.gripSize.width,
              decoration: BoxDecoration(
                color: widget.gripColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )
        : const SizedBox.shrink();
    return MouseRegion(
      cursor: widget.enabled
          ? (widget.cursor ??
                (horizontal
                    ? SystemMouseCursors.resizeColumn
                    : SystemMouseCursors.resizeRow))
          : MouseCursor.defer,
      onEnter: (_) => widget.onHoverChanged(true),
      onExit: (_) => widget.onHoverChanged(false),
      child: Focus(
        focusNode: _node,
        canRequestFocus: widget.enabled,
        autofocus: widget.autofocus,
        onKeyEvent: _onKey,
        child: Listener(
          onPointerDown: widget.enabled ? (_) => _node.requestFocus() : null,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: horizontal && widget.enabled
                ? (_) => widget.onDragStart()
                : null,
            onHorizontalDragUpdate: horizontal && widget.enabled
                ? (DragUpdateDetails d) =>
                      widget.onDragUpdate(d.primaryDelta ?? 0)
                : null,
            onHorizontalDragEnd: horizontal && widget.enabled
                ? (_) => widget.onDragEnd()
                : null,
            onHorizontalDragCancel: horizontal && widget.enabled
                ? widget.onDragCancel
                : null,
            onVerticalDragStart: !horizontal && widget.enabled
                ? (_) => widget.onDragStart()
                : null,
            onVerticalDragUpdate: !horizontal && widget.enabled
                ? (DragUpdateDetails d) =>
                      widget.onDragUpdate(d.primaryDelta ?? 0)
                : null,
            onVerticalDragEnd: !horizontal && widget.enabled
                ? (_) => widget.onDragEnd()
                : null,
            onVerticalDragCancel: !horizontal && widget.enabled
                ? widget.onDragCancel
                : null,
            child: Semantics(label: widget.semanticsLabel, child: grip),
          ),
        ),
      ),
    );
  }
}

/// Resolves the divider colour: an explicit [override] wins, then the theme's
/// per-state [handleColor], then the `border` token.
Color resolveResizableHandleColor(
  ShadcnColors colors, {
  ThemedColor? override,
  required StateValue<ThemedColor> handleColor,
  required Set<WidgetState> states,
}) {
  if (override != null) {
    return override.resolve(colors);
  }
  final ThemedColor? themed = handleColor.resolve(states);
  return (themed ?? const ThemedColor.ref(ColorRef.border)).resolve(colors);
}
