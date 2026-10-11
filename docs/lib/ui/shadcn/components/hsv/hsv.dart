// The `hsv` component: the HSV colour slider family.
//
// Widgets-only. Interaction (drag/tap/keys/cursor) is the shared
// `primitives/slider/color_field_slider.dart` surface, the gradient is the
// shared `primitives/color_field_paint.dart` engine, and outputs are clamped
// with the generic `SliderSnap.none` rule — no slider mechanics live here.

import 'package:flutter/widgets.dart';

import '../../primitives/color_field_paint.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/slider/color_field_slider.dart';
import '../../primitives/slider/slider_logic.dart';
import '../../theme/theme.dart';
import '../alpha/alpha.dart';
import 'hsv_style.dart';

export 'hsv_style.dart';

/// Which channel(s) the slider drives.
///
/// `hue`, `sat`, `val`, `alpha` are single-channel bars; the rest are 2D pads.
enum HSVColorSliderType {
  hue,
  hueSat,
  hueVal,
  hueAlpha,
  sat,
  satVal,
  satAlpha,
  val,
  valAlpha,
  alpha,
}

/// The axis each channel varies along; `none` means the channel is fixed.
({
  ColorFieldAxis hue,
  ColorFieldAxis sat,
  ColorFieldAxis val,
  ColorFieldAxis alpha,
})
_hsvAxes(HSVColorSliderType type, bool reverse) {
  const n = ColorFieldAxis.none;
  final f = reverse ? ColorFieldAxis.horizontal : ColorFieldAxis.vertical;
  final s = reverse ? ColorFieldAxis.vertical : ColorFieldAxis.horizontal;
  switch (type) {
    case HSVColorSliderType.hue:
      return (hue: f, sat: n, val: n, alpha: n);
    case HSVColorSliderType.hueSat:
      return (hue: f, sat: s, val: n, alpha: n);
    case HSVColorSliderType.hueVal:
      return (hue: f, sat: n, val: s, alpha: n);
    case HSVColorSliderType.hueAlpha:
      return (hue: f, sat: n, val: n, alpha: s);
    case HSVColorSliderType.sat:
      return (hue: n, sat: f, val: n, alpha: n);
    case HSVColorSliderType.satVal:
      return (hue: n, sat: f, val: s, alpha: n);
    case HSVColorSliderType.satAlpha:
      return (hue: n, sat: f, val: n, alpha: s);
    case HSVColorSliderType.val:
      return (hue: n, sat: n, val: f, alpha: n);
    case HSVColorSliderType.valAlpha:
      return (hue: n, sat: n, val: f, alpha: s);
    case HSVColorSliderType.alpha:
      return (hue: n, sat: n, val: n, alpha: f);
  }
}

/// Whether the slider type drives exactly one channel.
bool _hsvSingleChannel(HSVColorSliderType type) => switch (type) {
  HSVColorSliderType.hue ||
  HSVColorSliderType.sat ||
  HSVColorSliderType.val ||
  HSVColorSliderType.alpha => true,
  _ => false,
};

/// Interactive slider for one or two HSV channels.
class HSVColorSlider extends StatefulWidget {
  /// Creates an HSV slider.
  const HSVColorSlider({
    super.key,
    required this.color,
    required this.sliderType,
    this.onChanging,
    this.onChanged,
    this.reverse = false,
    this.radius = const Radius.circular(0),
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.style,
    this.focusNode,
    this.autofocus = false,
  });

  /// The current colour.
  final HSVColor color;

  /// Which channel(s) this slider drives.
  final HSVColorSliderType sliderType;

  /// Called while the value changes.
  final ValueChanged<HSVColor>? onChanging;

  /// Called when the interaction completes.
  final ValueChanged<HSVColor>? onChanged;

  /// Swaps the channel axes (and the cursor orientation).
  final bool reverse;

  /// Corner radius of the gradient.
  final Radius radius;

  /// Padding between gradient and cursor bar edge.
  final EdgeInsets padding;

  /// Whether gestures/keys are accepted.
  final bool enabled;

  /// Widget-leg style override.
  final HSVSliderStyle? style;

  /// Focus node; one is created internally when null and [autofocus].
  final FocusNode? focusNode;

  /// Request focus on first build.
  final bool autofocus;

  @override
  State<HSVColorSlider> createState() => _HSVColorSliderState();
}

class _HSVColorSliderState extends State<HSVColorSlider>
    with FormValueSupplier<HSVColor, HSVColorSlider> {
  HSVColor? _lastChanging;

  HSVColor get _current => _lastChanging ?? widget.color;

  /// Value 0..1 of the channel mapped to [axis]; 0 when unassigned.
  double _valueForAxis(ColorFieldAxis axis) {
    final a = _hsvAxes(widget.sliderType, widget.reverse);
    final c = _current;
    if (a.hue == axis) {
      return (c.hue / 360).clamp(0.0, 1.0);
    }
    if (a.sat == axis) {
      return c.saturation.clamp(0.0, 1.0);
    }
    if (a.val == axis) {
      return c.value.clamp(0.0, 1.0);
    }
    if (a.alpha == axis) {
      return c.alpha.clamp(0.0, 1.0);
    }
    return 0;
  }

  bool _hasAxis(ColorFieldAxis axis) {
    final a = _hsvAxes(widget.sliderType, widget.reverse);
    return a.hue == axis || a.sat == axis || a.val == axis || a.alpha == axis;
  }

  /// Cursor coordinates: x from the horizontal-axis channel, y from the
  /// vertical-axis channel; an unassigned axis mirrors the other.
  ({double x, double y}) get _cursorOffset {
    final hx = _hasAxis(ColorFieldAxis.horizontal)
        ? _valueForAxis(ColorFieldAxis.horizontal)
        : _valueForAxis(ColorFieldAxis.vertical);
    final vy = _hasAxis(ColorFieldAxis.vertical)
        ? _valueForAxis(ColorFieldAxis.vertical)
        : hx;
    return (x: hx, y: vy);
  }

  double _pick(ColorFieldAxis axis, double x, double y) =>
      axis == ColorFieldAxis.horizontal ? x : y;

  /// Resolves the colour described by axes along [x]/[y].
  HSVColor _colorAt(double x, double y) {
    final a = _hsvAxes(widget.sliderType, widget.reverse);
    final c = widget.color;
    final b = SliderSnap.none();
    double channel(ColorFieldAxis axis, double current, double span) =>
        axis == ColorFieldAxis.none ? current : _pick(axis, x, y) * span;
    return HSVColor.fromAHSV(
      b.apply(channel(a.alpha, c.alpha, 1), 0, 1),
      b.apply(channel(a.hue, c.hue, 360), 0, 360),
      b.apply(channel(a.sat, c.saturation, 1), 0, 1),
      b.apply(channel(a.val, c.value, 1), 0, 1),
    );
  }

  void _onPosition(double x, double y) {
    final next = _colorAt(x, y);
    setState(() => _lastChanging = next);
    formValue = next;
    widget.onChanging?.call(next);
  }

  void _onCommit() {
    final next = _lastChanging ?? widget.color;
    formValue = next;
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    formValue = widget.color;
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final HSVSliderStyle resolved =
        resolveComponentStyle<HSVSliderTheme, HSVSliderStyle>(
          context,
          widget: widget.style,
          select: (t) => t.slider,
          defaults: hsvSliderDefaults.slider!,
        );
    final double cursorSize = resolved.cursorSize ?? 16;
    final double cursorWidth = resolved.cursorWidth ?? 2;
    final Color cursorColor =
        resolved.cursorColor?.resolve(theme.colors) ?? const Color(0xFFFFFFFF);
    final offset = _cursorOffset;
    final a = _hsvAxes(widget.sliderType, widget.reverse);
    final color = _current;

    return ColorFieldSlider(
      x: offset.x,
      y: offset.y,
      cursorFillColor: color.toColor(),
      cursorRingColor: cursorColor,
      cursorSize: cursorSize,
      cursorWidth: cursorWidth,
      radius: widget.radius,
      padding: widget.padding,
      singleChannel: _hsvSingleChannel(widget.sliderType),
      reverse: widget.reverse,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onPosition: _onPosition,
      onCommit: _onCommit,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const CustomPaint(painter: AlphaPainter()),
          CustomPaint(
            painter: HSVColorSliderPainter(
              color: a.alpha == ColorFieldAxis.none
                  ? HSVColor.fromAHSV(
                      1,
                      color.hue,
                      color.saturation,
                      color.value,
                    )
                  : color,
              hueAxis: a.hue,
              saturationAxis: a.sat,
              valueAxis: a.val,
              alphaAxis: a.alpha,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didReplaceFormValue(HSVColor value) {
    widget.onChanged?.call(value);
  }
}

/// Painter for [HSVColorSlider]; the gradient comes from the shared engine in
/// `primitives/color_field_paint.dart`.
class HSVColorSliderPainter extends CustomPainter {
  /// Creates the painter.
  const HSVColorSliderPainter({
    required this.color,
    required this.hueAxis,
    required this.saturationAxis,
    required this.valueAxis,
    required this.alphaAxis,
  });

  /// The colour the gradient is derived from; the alpha channel passes
  /// through only when [alphaAxis] varies.
  final HSVColor color;

  /// Axis the hue varies along.
  final ColorFieldAxis hueAxis;

  /// Axis the saturation varies along.
  final ColorFieldAxis saturationAxis;

  /// Axis the value varies along.
  final ColorFieldAxis valueAxis;

  /// Axis the alpha varies along.
  final ColorFieldAxis alphaAxis;

  @override
  void paint(Canvas canvas, Size size) {
    paintHSVColorField(
      canvas,
      size,
      color: color,
      hueAxis: hueAxis,
      saturationAxis: saturationAxis,
      valueAxis: valueAxis,
      alphaAxis: alphaAxis,
    );
  }

  @override
  bool shouldRepaint(covariant HSVColorSliderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.hueAxis != hueAxis ||
      oldDelegate.saturationAxis != saturationAxis ||
      oldDelegate.valueAxis != valueAxis ||
      oldDelegate.alphaAxis != alphaAxis;
}
