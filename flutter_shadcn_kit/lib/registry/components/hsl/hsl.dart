// The `hsl` component: the HSL colour slider family.
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
import 'hsl_style.dart';

export 'hsl_style.dart';

/// Which channel(s) the slider drives.
///
/// `hue`, `sat`, `lum`, `alpha` are single-channel bars; the rest are 2D pads.
enum HSLColorSliderType {
  hue,
  hueSat,
  hueLum,
  hueAlpha,
  sat,
  satLum,
  satAlpha,
  lum,
  lumAlpha,
  alpha,
}

/// The axis each channel varies along; `none` means the channel is fixed.
({
  ColorFieldAxis hue,
  ColorFieldAxis sat,
  ColorFieldAxis lum,
  ColorFieldAxis alpha,
})
_hslAxes(HSLColorSliderType type, bool reverse) {
  const n = ColorFieldAxis.none;
  final f = reverse ? ColorFieldAxis.horizontal : ColorFieldAxis.vertical;
  final s = reverse ? ColorFieldAxis.vertical : ColorFieldAxis.horizontal;
  switch (type) {
    case HSLColorSliderType.hue:
      return (hue: f, sat: n, lum: n, alpha: n);
    case HSLColorSliderType.hueSat:
      return (hue: f, sat: s, lum: n, alpha: n);
    case HSLColorSliderType.hueLum:
      return (hue: f, sat: n, lum: s, alpha: n);
    case HSLColorSliderType.hueAlpha:
      return (hue: f, sat: n, lum: n, alpha: s);
    case HSLColorSliderType.sat:
      return (hue: n, sat: f, lum: n, alpha: n);
    case HSLColorSliderType.satLum:
      return (hue: n, sat: f, lum: s, alpha: n);
    case HSLColorSliderType.satAlpha:
      return (hue: n, sat: f, lum: n, alpha: s);
    case HSLColorSliderType.lum:
      return (hue: n, sat: n, lum: f, alpha: n);
    case HSLColorSliderType.lumAlpha:
      return (hue: n, sat: n, lum: f, alpha: s);
    case HSLColorSliderType.alpha:
      return (hue: n, sat: n, lum: n, alpha: f);
  }
}

/// Whether the slider type drives exactly one channel.
bool _hslSingleChannel(HSLColorSliderType type) => switch (type) {
  HSLColorSliderType.hue ||
  HSLColorSliderType.sat ||
  HSLColorSliderType.lum ||
  HSLColorSliderType.alpha => true,
  _ => false,
};

/// Interactive slider for one or two HSL channels.
class HSLColorSlider extends StatefulWidget {
  /// Creates an HSL slider.
  const HSLColorSlider({
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
  final HSLColor color;

  /// Which channel(s) this slider drives.
  final HSLColorSliderType sliderType;

  /// Called while the value changes.
  final ValueChanged<HSLColor>? onChanging;

  /// Called when the interaction completes.
  final ValueChanged<HSLColor>? onChanged;

  /// Swaps the channel axes (and the cursor orientation).
  final bool reverse;

  /// Corner radius of the gradient.
  final Radius radius;

  /// Padding between gradient and cursor bar edge.
  final EdgeInsets padding;

  /// Whether gestures/keys are accepted.
  final bool enabled;

  /// Widget-leg style override.
  final HSLSliderStyle? style;

  /// Focus node; one is created internally when null and [autofocus].
  final FocusNode? focusNode;

  /// Request focus on first build.
  final bool autofocus;

  @override
  State<HSLColorSlider> createState() => _HSLColorSliderState();
}

class _HSLColorSliderState extends State<HSLColorSlider>
    with FormValueSupplier<HSLColor, HSLColorSlider> {
  HSLColor? _lastChanging;

  HSLColor get _current => _lastChanging ?? widget.color;

  /// Value 0..1 of the channel mapped to [axis]; 0 when unassigned.
  double _valueForAxis(ColorFieldAxis axis) {
    final a = _hslAxes(widget.sliderType, widget.reverse);
    final c = _current;
    if (a.hue == axis) {
      return (c.hue / 360).clamp(0.0, 1.0);
    }
    if (a.sat == axis) {
      return c.saturation.clamp(0.0, 1.0);
    }
    if (a.lum == axis) {
      return c.lightness.clamp(0.0, 1.0);
    }
    if (a.alpha == axis) {
      return c.alpha.clamp(0.0, 1.0);
    }
    return 0;
  }

  bool _hasAxis(ColorFieldAxis axis) {
    final a = _hslAxes(widget.sliderType, widget.reverse);
    return a.hue == axis || a.sat == axis || a.lum == axis || a.alpha == axis;
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
  HSLColor _colorAt(double x, double y) {
    final a = _hslAxes(widget.sliderType, widget.reverse);
    final c = widget.color;
    final b = SliderSnap.none();
    double channel(ColorFieldAxis axis, double current, double span) =>
        axis == ColorFieldAxis.none ? current : _pick(axis, x, y) * span;
    return HSLColor.fromAHSL(
      b.apply(channel(a.alpha, c.alpha, 1), 0, 1),
      b.apply(channel(a.hue, c.hue, 360), 0, 360),
      b.apply(channel(a.sat, c.saturation, 1), 0, 1),
      b.apply(channel(a.lum, c.lightness, 1), 0, 1),
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
    final HSLSliderStyle resolved =
        resolveComponentStyle<HSLSliderTheme, HSLSliderStyle>(
          context,
          widget: widget.style,
          select: (t) => t.slider,
          defaults: hslSliderDefaults.slider!,
        );
    final double cursorSize = resolved.cursorSize ?? 16;
    final double cursorWidth = resolved.cursorWidth ?? 2;
    final Color cursorColor =
        resolved.cursorColor?.resolve(theme.colors) ?? const Color(0xFFFFFFFF);
    final offset = _cursorOffset;
    final a = _hslAxes(widget.sliderType, widget.reverse);
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
      singleChannel: _hslSingleChannel(widget.sliderType),
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
            painter: HSLColorSliderPainter(
              color: a.alpha == ColorFieldAxis.none
                  ? HSLColor.fromAHSL(
                      1,
                      color.hue,
                      color.saturation,
                      color.lightness,
                    )
                  : color,
              hueAxis: a.hue,
              saturationAxis: a.sat,
              lightnessAxis: a.lum,
              alphaAxis: a.alpha,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didReplaceFormValue(HSLColor value) {
    widget.onChanged?.call(value);
  }
}

/// Painter for [HSLColorSlider]; the gradient comes from the shared engine in
/// `primitives/color_field_paint.dart`.
class HSLColorSliderPainter extends CustomPainter {
  /// Creates the painter.
  const HSLColorSliderPainter({
    required this.color,
    required this.hueAxis,
    required this.saturationAxis,
    required this.lightnessAxis,
    required this.alphaAxis,
  });

  /// The colour the gradient is derived from; the alpha channel passes
  /// through only when [alphaAxis] varies.
  final HSLColor color;

  /// Axis the hue varies along.
  final ColorFieldAxis hueAxis;

  /// Axis the saturation varies along.
  final ColorFieldAxis saturationAxis;

  /// Axis the lightness varies along.
  final ColorFieldAxis lightnessAxis;

  /// Axis the alpha varies along.
  final ColorFieldAxis alphaAxis;

  @override
  void paint(Canvas canvas, Size size) {
    paintHSLColorField(
      canvas,
      size,
      color: color,
      hueAxis: hueAxis,
      saturationAxis: saturationAxis,
      lightnessAxis: lightnessAxis,
      alphaAxis: alphaAxis,
    );
  }

  @override
  bool shouldRepaint(covariant HSLColorSliderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.hueAxis != hueAxis ||
      oldDelegate.saturationAxis != saturationAxis ||
      oldDelegate.lightnessAxis != lightnessAxis ||
      oldDelegate.alphaAxis != alphaAxis;
}
