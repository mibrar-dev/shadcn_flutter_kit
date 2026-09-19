// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../color_field/color_field.dart';

/// Preview for the shared HSV/HSL color-field gradient engine.
///
/// Exercises [paintHSVColorField] and [paintHSLColorField] through small
/// [CustomPaint] fields with different axis mappings.
class ColorFieldPreview extends StatelessWidget {
  const ColorFieldPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              children: [
                // HSV saturation/value field at full hue.
                SizedBox(
                  width: 240,
                  height: 120,
                  child: CustomPaint(
                    painter: _FieldPainter(
                      kind: _FieldKind.hsv,
                      hsv: HSVColor.fromColor(Colors.blue),
                      hsl: HSLColor.fromColor(Colors.blue),
                    ),
                  ),
                ),
                // HSV hue strip.
                SizedBox(
                  width: 240,
                  height: 32,
                  child: CustomPaint(
                    painter: _FieldPainter(
                      kind: _FieldKind.hsvHue,
                      hsv: HSVColor.fromColor(Colors.blue),
                      hsl: HSLColor.fromColor(Colors.blue),
                    ),
                  ),
                ),
                // HSL saturation/lightness field at full hue.
                SizedBox(
                  width: 240,
                  height: 120,
                  child: CustomPaint(
                    painter: _FieldPainter(
                      kind: _FieldKind.hsl,
                      hsv: HSVColor.fromColor(Colors.green),
                      hsl: HSLColor.fromColor(Colors.green),
                    ),
                  ),
                ),
                // HSL hue strip.
                SizedBox(
                  width: 240,
                  height: 32,
                  child: CustomPaint(
                    painter: _FieldPainter(
                      kind: _FieldKind.hslHue,
                      hsv: HSVColor.fromColor(Colors.green),
                      hsl: HSLColor.fromColor(Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

enum _FieldKind { hsv, hsvHue, hsl, hslHue }

class _FieldPainter extends CustomPainter {
  final _FieldKind kind;
  final HSVColor hsv;
  final HSLColor hsl;

  const _FieldPainter({required this.kind, required this.hsv, required this.hsl});

  @override
  void paint(Canvas canvas, Size size) {
    switch (kind) {
      case _FieldKind.hsv:
        paintHSVColorField(
          canvas,
          size,
          color: hsv,
          saturationAxis: ColorFieldAxis.horizontal,
          valueAxis: ColorFieldAxis.vertical,
        );
      case _FieldKind.hsvHue:
        paintHSVColorField(
          canvas,
          size,
          color: hsv,
          hueAxis: ColorFieldAxis.horizontal,
        );
      case _FieldKind.hsl:
        paintHSLColorField(
          canvas,
          size,
          color: hsl,
          saturationAxis: ColorFieldAxis.horizontal,
          lightnessAxis: ColorFieldAxis.vertical,
        );
      case _FieldKind.hslHue:
        paintHSLColorField(
          canvas,
          size,
          color: hsl,
          hueAxis: ColorFieldAxis.horizontal,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _FieldPainter oldDelegate) {
    return oldDelegate.kind != kind ||
        oldDelegate.hsv != hsv ||
        oldDelegate.hsl != hsl;
  }
}
