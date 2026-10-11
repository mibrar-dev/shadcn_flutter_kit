// The `color_field` component: [ColorField], a custom-painted HSV/HSL
// gradient area with an optional transparency checkerboard and a themed ring.
//
// The old `form/color_field/**` directory held only the gradient engine; P4-B04
// moved that engine (and `ColorFieldAxis`) into
// `primitives/color_field_paint.dart`, which this component consumes and
// re-exports. B04's report: "color_field should re-export/import it, not fork
// it".
//
// The widget itself is new public API (the old component had no widget): it
// gives the primitive a sized, ringed surface so a picker or a swatch can
// embed it directly.
//
// Old bugs fixed, not ported: `paintHSVColorField`/`paintHSLColorField` and
// their axis helper are not duplicated here (single owner), and the old
// preview's `shouldRepaint` compared a hand-picked subset (missed colour
// edits) — the painter below compares colour, mode and every axis.

import 'package:flutter/widgets.dart';

import '../../primitives/color_field_paint.dart';
import '../../theme/theme.dart';
import '../alpha/alpha.dart';
import 'color_field_style.dart';

export 'color_field_style.dart';
export '../../primitives/color_field_paint.dart'
    show ColorFieldAxis, paintHSVColorField, paintHSLColorField;

/// Which colour space [ColorField] ramps in.
enum ColorFieldMode { hsv, hsl }

/// A gradient area that varies an HSV/HSL colour along configurable axes.
///
/// The field fills the box it is given, so wrap it in a `SizedBox`,
/// `AspectRatio` or an expanded slot:
///
/// ```dart
/// SizedBox(
///   width: 240,
///   height: 160,
///   child: ColorField(
///     color: const Color(0xFF0000FF),
///     saturationAxis: ColorFieldAxis.horizontal,
///     valueAxis: ColorFieldAxis.vertical,
///   ),
/// )
/// ```
class ColorField extends StatelessWidget {
  /// Creates a colour field.
  const ColorField({
    super.key,
    required this.color,
    this.mode = ColorFieldMode.hsv,
    this.hueAxis = ColorFieldAxis.none,
    this.saturationAxis = ColorFieldAxis.none,
    this.valueAxis = ColorFieldAxis.none,
    this.lightnessAxis = ColorFieldAxis.none,
    this.alphaAxis = ColorFieldAxis.none,
    this.theme,
  });

  /// The colour the field is built from.
  final Color color;

  /// Colour space used to paint the field.
  final ColorFieldMode mode;

  /// Hue ramp axis (both modes).
  final ColorFieldAxis hueAxis;

  /// Saturation ramp axis (both modes).
  final ColorFieldAxis saturationAxis;

  /// Value ramp axis ([ColorFieldMode.hsv] only).
  final ColorFieldAxis valueAxis;

  /// Lightness ramp axis ([ColorFieldMode.hsl] only).
  final ColorFieldAxis lightnessAxis;

  /// Alpha ramp axis (both modes).
  final ColorFieldAxis alphaAxis;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final ColorFieldTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ColorFieldTheme style =
        resolveComponentStyle<ColorFieldTheme, ColorFieldTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: colorFieldDefaults,
        );
    final BorderRadius radius = (style.borderRadius ?? ambient.borderRadiusMd)
        .resolve(Directionality.of(context));
    final bool translucent = alphaAxis != ColorFieldAxis.none || color.a < 1;
    final bool showCheckerboard = (style.checkerboard ?? true) && translucent;

    Widget field = ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (showCheckerboard) const CustomPaint(painter: AlphaPainter()),
          CustomPaint(
            painter: _ColorFieldPainter(
              mode: mode,
              color: color,
              hueAxis: hueAxis,
              saturationAxis: saturationAxis,
              valueAxis: valueAxis,
              lightnessAxis: lightnessAxis,
              alphaAxis: alphaAxis,
            ),
          ),
        ],
      ),
    );
    final double borderWidth = style.borderWidth ?? 0;
    if (borderWidth > 0) {
      final Color border =
          style.borderColor?.resolve(ambient.colors) ?? ambient.colors.border;
      field = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border.all(color: border, width: borderWidth),
          borderRadius: radius,
        ),
        child: field,
      );
    }
    // Display-only surface: expose the colour as a semantic value so screen
    // readers announce it; there is no interaction to expose.
    final String hex = color
        .toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase();
    return Semantics(
      label: mode == ColorFieldMode.hsv ? 'HSV color field' : 'HSL color field',
      value: '#$hex',
      child: field,
    );
  }
}

/// Paints one [ColorField] slice through the shared gradient engine.
class _ColorFieldPainter extends CustomPainter {
  const _ColorFieldPainter({
    required this.mode,
    required this.color,
    required this.hueAxis,
    required this.saturationAxis,
    required this.valueAxis,
    required this.lightnessAxis,
    required this.alphaAxis,
  });

  final ColorFieldMode mode;
  final Color color;
  final ColorFieldAxis hueAxis;
  final ColorFieldAxis saturationAxis;
  final ColorFieldAxis valueAxis;
  final ColorFieldAxis lightnessAxis;
  final ColorFieldAxis alphaAxis;

  @override
  void paint(Canvas canvas, Size size) {
    switch (mode) {
      case ColorFieldMode.hsv:
        paintHSVColorField(
          canvas,
          size,
          color: HSVColor.fromColor(color),
          hueAxis: hueAxis,
          saturationAxis: saturationAxis,
          valueAxis: valueAxis,
          alphaAxis: alphaAxis,
        );
      case ColorFieldMode.hsl:
        paintHSLColorField(
          canvas,
          size,
          color: HSLColor.fromColor(color),
          hueAxis: hueAxis,
          saturationAxis: saturationAxis,
          lightnessAxis: lightnessAxis,
          alphaAxis: alphaAxis,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _ColorFieldPainter oldDelegate) =>
      oldDelegate.mode != mode ||
      oldDelegate.color != color ||
      oldDelegate.hueAxis != hueAxis ||
      oldDelegate.saturationAxis != saturationAxis ||
      oldDelegate.valueAxis != valueAxis ||
      oldDelegate.lightnessAxis != lightnessAxis ||
      oldDelegate.alphaAxis != alphaAxis;
}
