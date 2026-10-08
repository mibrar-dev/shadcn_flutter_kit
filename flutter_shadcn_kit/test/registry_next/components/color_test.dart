// Tests for the `color` component (the ColorDerivative model).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/color/color.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromColor creates a space-preserving derivative', () {
    final d = ColorDerivative.fromColor(const Color(0xFF0080FF));
    expect(d.toColor().toARGB32(), const Color(0xFF0080FF).toARGB32());
    expect(d.opacity, 1.0);
    expect(d.hsvVal, closeTo(1.0, 0.01));
    expect(d.blue, closeTo(255, 1));
  });

  test('HSV edits stay in HSV space; HSL edits stay in HSL space', () {
    final hsv = ColorDerivative.fromHSV(HSVColor.fromAHSV(1, 200, 0.5, 0.5));
    expect(hsv.changeToHSVSaturation(0.3).hsvSat, closeTo(0.3, 0.001));

    final hsl = ColorDerivative.fromHSL(HSLColor.fromAHSL(1, 200, 0.5, 0.5));
    final l = hsl.changeToHSLLightness(0.2);
    expect(l.hslVal, closeTo(0.2, 0.001));
    // An HSL derivative stays HSL across an HSV-space edit.
    final viaHsv = hsl.changeToHSVHue(210);
    expect(viaHsv.toHSLColor().hue, closeTo(210, 1));
  });

  test('transform converts representation without changing colour', () {
    final fromHsv = ColorDerivative.fromHSV(
      HSVColor.fromAHSV(1, 120, 0.4, 0.7),
    );
    final asHsl = fromHsv.transform(
      ColorDerivative.fromHSL(HSLColor.fromAHSL(1, 0, 0, 1)),
    );
    expect(asHsl.toColor().toARGB32(), fromHsv.toColor().toARGB32());
  });

  test('changeToOpacity multiplies through toColor', () {
    final d = ColorDerivative.fromColor(const Color(0xFF112233));
    expect(d.changeToOpacity(0.5).opacity, 0.5);
    expect(d.changeToOpacity(0.5).toColor().a, closeTo(0.5, 0.01));
  });

  test(
    'fromHex parses valid and rejects invalid (regression: old crashed)',
    () {
      expect(
        ColorDerivative.fromHex('#0080FF')?.toColor().toARGB32(),
        const Color(0xFF0080FF).toARGB32(),
      );
      expect(ColorDerivative.fromHex('80FF00')?.green, closeTo(255, 1));
      expect(ColorDerivative.fromHex('#f80'), isNotNull);
      expect(ColorDerivative.fromHex('not-a-color'), isNull);
      expect(ColorDerivative.fromHex('#12'), isNull);
      expect(ColorDerivative.fromHex(''), isNull);
    },
  );

  test(
    'equality works across HSV/HSL representations (old bug: always false)',
    () {
      final hsv = ColorDerivative.fromHSV(HSVColor.fromAHSV(1, 200, 0.5, 0.5));
      final hsl = ColorDerivative.fromHSL(HSLColor.fromColor(hsv.toColor()));
      expect(hsv == hsl, isTrue);
      expect(hsl == hsv, isTrue);
      expect(hsv.hashCode == hsl.hashCode, isTrue);
    },
  );

  test('channel edits clamp to the valid range', () {
    final d = ColorDerivative.fromColor(const Color(0xFF808080));
    expect(d.changeToColorRed(999).red, 255);
    expect(d.changeToColorBlue(-5).blue, 0);
  });
}
