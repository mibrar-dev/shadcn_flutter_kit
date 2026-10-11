// Shared interactive surface for the colour-field sliders (hsl, hsv, and the
// later color_picker / color_field batches): pointer drag/tap mapping to a
// normalized (x, y), keyboard nudges, disabled dimming, the cursor overlay and
// the rounded clip.
//
// Layer 2 primitive: knows nothing about colour channels or painting; the
// component supplies the gradient [child] and maps positions back to a value.
//
// Old -> new: replaces the per-component gesture/cursor/painter state of the
// old `_HSLColorSliderState` / `_HSVColorSliderState` (one shared
// implementation instead of two divergent 300-line copies).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Opacity applied to the whole control while disabled.
const double colorFieldDisabledOpacity = 0.5;

/// Keyboard nudge for one arrow press, as a fraction of the domain.
const double colorFieldKeyStep = 1 / 32;

/// Keyboard nudge for one page key press, as a fraction of the domain.
const double colorFieldPageStep = 1 / 8;

/// Called with a normalized interaction position, both values in `[0, 1]`.
typedef ColorFieldPositionCallback = void Function(double x, double y);

/// A rounded colour-field surface with a drag cursor.
class ColorFieldSlider extends StatefulWidget {
  /// Creates a colour-field surface.
  const ColorFieldSlider({
    super.key,
    required this.x,
    required this.y,
    required this.child,
    required this.cursorFillColor,
    required this.cursorRingColor,
    required this.cursorSize,
    required this.cursorWidth,
    required this.radius,
    required this.padding,
    required this.singleChannel,
    this.reverse = false,
    this.enabled = true,
    this.onPosition,
    this.onCommit,
    this.focusNode,
    this.autofocus = false,
  });

  /// Cursor x in `[0, 1]` (horizontal axis).
  final double x;

  /// Cursor y in `[0, 1]` (vertical axis).
  final double y;

  /// The gradient painted behind the cursor.
  final Widget child;

  /// Fill colour of the drag cursor (the current value's colour).
  final Color cursorFillColor;

  /// Ring colour of the drag cursor.
  final Color cursorRingColor;

  /// Bar thickness / circle diameter of the cursor.
  final double cursorSize;

  /// Width of the cursor ring.
  final double cursorWidth;

  /// Corner radius of the clipped gradient and bar cursor.
  final Radius radius;

  /// Inset between the gradient edge and the cursor bar.
  final EdgeInsets padding;

  /// True for a single-channel bar: reversed bars run horizontally,
  /// otherwise the bar runs horizontally and moves vertically.
  final bool singleChannel;

  /// Swaps the bar orientation for [singleChannel] fields.
  final bool reverse;

  /// Whether gestures and keys are accepted.
  final bool enabled;

  /// Called for every tap/drag keyboard position change (not the final one).
  final ColorFieldPositionCallback? onPosition;

  /// Called on tap/drag end with the last emitted position already applied.
  final VoidCallback? onCommit;

  /// Focus node; one is created internally when null and [autofocus].
  final FocusNode? focusNode;

  /// Request focus on first build.
  final bool autofocus;

  @override
  State<ColorFieldSlider> createState() => _ColorFieldSliderState();
}

class _ColorFieldSliderState extends State<ColorFieldSlider> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  @override
  void initState() {
    super.initState();
    if (widget.autofocus && widget.focusNode == null) {
      _ownedFocusNode = FocusNode(debugLabel: 'ColorFieldSlider');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _ownedFocusNode?.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _positionFromLocal(Offset localPosition, Size size) {
    final x =
        ((localPosition.dx - widget.padding.left) /
                (size.width - widget.padding.horizontal))
            .clamp(0.0, 1.0);
    final y =
        ((localPosition.dy - widget.padding.top) /
                (size.height - widget.padding.vertical))
            .clamp(0.0, 1.0);
    widget.onPosition?.call(x, y);
  }

  /// Arrow keys steer the axis matching the arrow; a single-channel field
  /// steers its one channel from any arrow. Home/End jump to the bounds.
  bool _handleKey(KeyEvent event) {
    var x = widget.x;
    var y = widget.y;
    const small = colorFieldKeyStep;
    const big = colorFieldPageStep;
    final twoChannel = !widget.singleChannel;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        x -= small;
        if (!twoChannel) {
          y -= small;
        }
      case LogicalKeyboardKey.arrowRight:
        x += small;
        if (!twoChannel) {
          y += small;
        }
      case LogicalKeyboardKey.arrowUp:
        if (!twoChannel) {
          x -= small;
        }
        y -= small;
      case LogicalKeyboardKey.arrowDown:
        if (!twoChannel) {
          x += small;
        }
        y += small;
      case LogicalKeyboardKey.pageUp:
        if (!twoChannel) {
          x -= big;
        }
        y -= big;
      case LogicalKeyboardKey.pageDown:
        if (!twoChannel) {
          x += big;
        }
        y += big;
      case LogicalKeyboardKey.home:
        if (!twoChannel) {
          x = 0.0;
        }
        y = 0.0;
      case LogicalKeyboardKey.end:
        if (!twoChannel) {
          x = 1.0;
        }
        y = 1.0;
      default:
        return false;
    }
    widget.onPosition?.call(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double cursorSize = widget.cursorSize;
    final bool showBar = widget.singleChannel;
    final double x = widget.x.clamp(0.0, 1.0);
    final double y = widget.y.clamp(0.0, 1.0);

    final BoxDecoration barDecoration = BoxDecoration(
      color: widget.cursorFillColor,
      border: Border.all(
        color: widget.cursorRingColor,
        width: widget.cursorWidth,
      ),
      borderRadius: BorderRadius.all(widget.radius),
    );

    final Widget cursor;
    if (showBar && widget.reverse) {
      cursor = Padding(
        padding: widget.padding.copyWith(top: 0, bottom: 0),
        child: Align(
          alignment: Alignment(x * 2 - 1, 0),
          child: Container(
            width: cursorSize,
            height: double.infinity,
            decoration: barDecoration,
          ),
        ),
      );
    } else if (showBar) {
      cursor = Padding(
        padding: widget.padding.copyWith(left: 0, right: 0),
        child: Align(
          alignment: Alignment(0, y * 2 - 1),
          child: Container(
            height: cursorSize,
            width: double.infinity,
            decoration: barDecoration,
          ),
        ),
      );
    } else {
      cursor = Padding(
        padding: widget.padding,
        child: Align(
          alignment: Alignment(x * 2 - 1, y * 2 - 1),
          child: Container(
            width: cursorSize,
            height: cursorSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.cursorFillColor,
              border: Border.all(
                color: widget.cursorRingColor,
                width: widget.cursorWidth,
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      slider: true,
      enabled: widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : colorFieldDisabledOpacity,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && widget.enabled && _handleKey(event)) {
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: widget.enabled
                ? (details) {
                    _positionFromLocal(
                      details.localPosition,
                      context.size ?? Size.zero,
                    );
                    widget.onCommit?.call();
                  }
                : null,
            onPanUpdate: widget.enabled
                ? (details) => _positionFromLocal(
                    details.localPosition,
                    context.size ?? Size.zero,
                  )
                : null,
            onPanEnd: widget.enabled ? (_) => widget.onCommit?.call() : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned.fill(
                  child: RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(widget.radius),
                      child: widget.child,
                    ),
                  ),
                ),
                Positioned(
                  left: -cursorSize / 2,
                  top: -cursorSize / 2,
                  right: -cursorSize / 2,
                  bottom: -cursorSize / 2,
                  child: cursor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
