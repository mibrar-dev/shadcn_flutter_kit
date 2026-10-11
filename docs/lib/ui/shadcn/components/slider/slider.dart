// The `slider` component: single- and range-slider widgets built directly on
// widgets primitives (GestureDetector + CustomPaint + Focus). No Material
// Slider, no `_impl/`, no overlay routes.
//
// Old -> new: `Slider.single` / `Slider.range` keep their names, `ShadSnap`
// becomes [SliderSnap], `ShadRangeValue` is replaced by the shared
// primitives `SliderValue`, and the preset string becomes [SliderVariant].

import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/form_core/form_value.dart';
import '../../primitives/slider_value.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../../primitives/slider/slider_controller.dart';
import '../../primitives/slider/slider_logic.dart';
import '../../primitives/slider/slider_painter.dart';
import 'slider_style.dart';

export '../../primitives/slider/slider_logic.dart'
    show SliderLogic, SliderSnap, SliderView;
export 'slider_style.dart';

/// Opacity applied to the whole slider while disabled.
const double _sliderDisabledOpacity = 0.5;

/// A single-thumb slider.
///
/// Two controlled shapes:
/// * [Slider] (single value) — `value` + `onChanged`;
/// * [Slider.range] — `value` as [SliderValue] + `onRangeChanged`.
class Slider extends StatefulWidget {
  const Slider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.snap = const SliderSnap.none(),
    this.variant = SliderVariant.standard,
    this.enabled = true,
    this.theme,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  }) : rangeValue = null,
       onRangeChanged = null,
       minRange = 0,
       allowSwap = false;

  /// Creates a two-thumb range slider.
  const Slider.range({
    super.key,
    required SliderValue value,
    required this.onRangeChanged,
    this.min = 0,
    this.max = 1,
    this.snap = const SliderSnap.none(),
    this.variant = SliderVariant.standard,
    this.enabled = true,
    this.minRange = 0,
    this.allowSwap = false,
    this.theme,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  }) : value = 0,
       onChanged = null,
       rangeValue = value;

  /// Current single value (single mode). Ignored in range mode.
  final double value;

  /// Called with the next value (single mode).
  final ValueChanged<double>? onChanged;

  /// Current range value (range mode). Null in single mode.
  final SliderValue? rangeValue;

  /// Called with the next range value (range mode).
  final ValueChanged<SliderValue>? onRangeChanged;

  /// Domain minimum.
  final double min;

  /// Domain maximum; must be greater than [min].
  final double max;

  /// Snapping applied to tap/drag/keyboard output.
  final SliderSnap snap;

  /// Visual variant (track/thumb/mark style).
  final SliderVariant variant;

  /// Whether the slider reacts to gestures and keys.
  final bool enabled;

  /// Minimum distance between the two range thumbs.
  final double minRange;

  /// Whether range thumbs may cross and swap roles while dragging.
  final bool allowSwap;

  /// Widget-leg theme override, merged under style/tree/app legs.
  final SliderStyle? theme;

  /// Accessibility label.
  final String? semanticLabel;

  /// Focus node; one is created internally when null.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Whether this slider is in range mode.
  bool get isRange => rangeValue != null;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider>
    with FormValueSupplier<SliderValue, Slider> {
  final SliderLogic _logic = SliderLogic();
  FocusNode? _ownedFocusNode;
  int? _activeThumb;
  bool _dragging = false;
  bool _focused = false;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  @override
  void initState() {
    super.initState();
    if (widget.autofocus && widget.focusNode == null) {
      _ownedFocusNode = FocusNode(debugLabel: 'Slider');
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

  void _emitSingle(double v) {
    if (widget.enabled) {
      widget.onChanged?.call(v);
    }
  }

  void _emitRange(double start, double end) {
    if (widget.enabled) {
      widget.onRangeChanged?.call(SliderValue.ranged(start, end));
    }
  }

  void _applyRangeValue(double v) {
    final idx = _activeThumb ?? 0;
    final (lo, hi) = sliderDraggedRange(
      v: v,
      thumbIndex: idx,
      start: widget.rangeValue!.start,
      end: widget.rangeValue!.end,
      min: widget.min,
      max: widget.max,
      minRange: widget.minRange,
      allowSwap: widget.allowSwap,
    );
    _emitRange(lo, hi);
  }

  void _handleDx(SliderView view, double dx) {
    final v = _logic.valueFromDx(view, widget.snap, dx);
    if (widget.isRange) {
      _applyRangeValue(v);
    } else {
      _emitSingle(v);
    }
  }

  void _handleKey(SliderView view, KeyEvent event) {
    final current = widget.isRange
        ? ((_activeThumb ?? 0) == 0
              ? widget.rangeValue!.start
              : widget.rangeValue!.end)
        : widget.value;
    final next = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft ||
      LogicalKeyboardKey.arrowDown => sliderStep(
        snap: widget.snap,
        current: current,
        direction: -1,
        min: widget.min,
        max: widget.max,
      ),
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.arrowUp => sliderStep(
        snap: widget.snap,
        current: current,
        direction: 1,
        min: widget.min,
        max: widget.max,
      ),
      LogicalKeyboardKey.home => widget.min,
      LogicalKeyboardKey.end => widget.max,
      LogicalKeyboardKey.pageUp => sliderPageStep(
        snap: widget.snap,
        current: current,
        direction: 1,
        min: widget.min,
        max: widget.max,
      ),
      LogicalKeyboardKey.pageDown => sliderPageStep(
        snap: widget.snap,
        current: current,
        direction: -1,
        min: widget.min,
        max: widget.max,
      ),
      _ => null,
    };
    if (next == null) {
      return;
    }
    if (widget.isRange) {
      _applyRangeValue(next);
    } else {
      _emitSingle(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.max > widget.min, 'max must exceed min');
    // Report the current value to the nearest form; a no-op without one.
    formValue = widget.isRange
        ? widget.rangeValue
        : SliderValue.single(widget.value);

    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final SliderStyle resolved =
        resolveComponentStyle<SliderTheme, SliderStyle>(
          context,
          widget: widget.theme,
          select: (t) => t.forVariant(widget.variant),
          defaults: sliderDefaults.forVariant(widget.variant)!,
        );
    final double trackHeight = resolved.trackHeight ?? 6;
    final double trackRadius = (resolved.trackRadius ?? trackHeight / 2).clamp(
      0,
      trackHeight / 2,
    );
    final Size thumbSize = resolved.thumbSize ?? const Size(18, 18);
    final Size renderThumbSize = thumbSize.isEmpty
        ? const Size(18, 18)
        : thumbSize;
    final SliderThumbShape thumbShape =
        resolved.thumbShape ?? SliderThumbShape.circle;

    Color? colorFor(StateValue<ThemedColor>? value) =>
        value?.resolve(const <WidgetState>{})?.resolve(theme.colors);

    final trackColor = colorFor(resolved.track) ?? theme.colors.secondary;
    final fillColor = colorFor(resolved.fill) ?? theme.colors.primary;
    final thumbColor = colorFor(resolved.thumb) ?? theme.colors.background;
    final thumbBorderColor =
        colorFor(resolved.thumbBorder) ?? theme.colors.primary;
    final markColor = colorFor(resolved.mark) ?? theme.colors.mutedForeground;

    return Semantics(
      label: widget.semanticLabel,
      slider: true,
      enabled: widget.enabled,
      value: widget.isRange
          ? '${widget.rangeValue!.start} - ${widget.rangeValue!.end}'
          : '${widget.value}',
      child: Opacity(
        opacity: widget.enabled ? 1 : _sliderDisabledOpacity,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
          onKeyEvent: (node, event) {
            if (!widget.enabled || event is! KeyDownEvent) {
              return KeyEventResult.ignored;
            }
            // We need the last built view; captured by closure below.
            final view = _lastView;
            if (view == null) {
              return KeyEventResult.ignored;
            }
            _handleKey(view, event);
            return KeyEventResult.handled;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final canvasHeight = math.max(
                trackHeight,
                renderThumbSize.height,
              );
              final trackTop = (canvasHeight - trackHeight) / 2;
              final trackRect = Rect.fromLTWH(0, trackTop, width, trackHeight);
              final view = _logic.buildView(
                min: widget.min,
                max: widget.max,
                snap: widget.snap,
                enabled: widget.enabled,
                trackRect: trackRect,
                trackRadius: trackRadius,
                thumbInset: renderThumbSize.width / 2,
                dragging: _dragging,
                activeThumb: _activeThumb,
                thumbSize: renderThumbSize,
                textDirection: Directionality.of(context),
                value: widget.isRange ? null : widget.value,
                rangeStart: widget.isRange ? widget.rangeValue!.start : null,
                rangeEnd: widget.isRange ? widget.rangeValue!.end : null,
              );
              _lastView = view;
              Widget content = SizedBox(
                height: canvasHeight,
                child: CustomPaint(
                  size: Size(width, canvasHeight),
                  painter: SliderPainter(
                    view: view,
                    marksStyle: marksStyleForVariant(widget.variant),
                    thumbShape: thumbShape,
                    trackColor: trackColor,
                    fillColor: fillColor,
                    thumbColor: thumbColor,
                    thumbBorderColor: thumbBorderColor,
                    markColor: markColor,
                    focused: _focused,
                    ringColor: theme.colors.ring,
                  ),
                ),
              );
              content = GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: widget.enabled
                    ? (d) {
                        _activeThumb = _logic.pickActiveThumb(
                          view,
                          d.localPosition.dx,
                        );
                        _handleDx(view, d.localPosition.dx);
                      }
                    : null,
                onHorizontalDragStart: widget.enabled
                    ? (d) => setState(() {
                        _dragging = true;
                        _activeThumb = _logic.pickActiveThumb(
                          view,
                          d.localPosition.dx,
                        );
                      })
                    : null,
                onHorizontalDragUpdate: widget.enabled
                    ? (d) => _handleDx(view, d.localPosition.dx)
                    : null,
                onHorizontalDragEnd: widget.enabled
                    ? (_) => setState(() {
                        _dragging = false;
                        _activeThumb = null;
                      })
                    : null,
                onHorizontalDragCancel: widget.enabled
                    ? () => setState(() {
                        _dragging = false;
                        _activeThumb = null;
                      })
                    : null,
                child: content,
              );
              return content;
            },
          ),
        ),
      ),
    );
  }

  SliderView? _lastView;

  /// Form validation asked for a different value.
  @override
  void didReplaceFormValue(SliderValue value) {
    if (widget.isRange) {
      widget.onRangeChanged?.call(value);
    } else {
      widget.onChanged?.call(value.value);
    }
  }
}
