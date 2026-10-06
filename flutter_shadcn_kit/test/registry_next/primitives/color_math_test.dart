import 'dart:ui';

import 'package:flutter_shadcn_kit/registry_next/primitives/color_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('colorFromHex', () {
    test('parses 6-digit colours with and without a hash', () {
      expect(colorFromHex('#FF0000'), const Color(0xFFFF0000));
      expect(colorFromHex('ff0000'), const Color(0xFFFF0000));
      expect(colorFromHex('00FF00'), const Color(0xFF00FF00));
      expect(colorFromHex('#0000ff'), const Color(0xFF0000FF));
    });

    test('parses 8-digit AARRGGBB colours', () {
      expect(colorFromHex('#80FF0000'), const Color(0x80FF0000));
      expect(colorFromHex('0x80FF0000'), const Color(0x80FF0000));
      expect(colorFromHex('80ff0000'), const Color(0x80FF0000));
    });

    test('parses the 3-digit RGB shorthand', () {
      expect(colorFromHex('#fff'), const Color(0xFFFFFFFF));
      expect(colorFromHex('#f00'), const Color(0xFFFF0000));
      expect(colorFromHex('abc'), const Color(0xFFAABBCC));
    });

    test('rejects unsupported input', () {
      expect(colorFromHex(''), isNull);
      expect(colorFromHex('#'), isNull);
      expect(colorFromHex('xyz'), isNull);
      expect(colorFromHex('#12345'), isNull);
      expect(colorFromHex('#1234567'), isNull);
      expect(colorFromHex('#123456789'), isNull);
      expect(colorFromHex('#gggggg'), isNull);
      expect(colorFromHex('+ff'), isNull);
      expect(colorFromHex('-ff0000'), isNull);
    });
  });

  group('contrast math', () {
    test('contrastRatio spans 1 to 21 by the WCAG formula', () {
      expect(
        contrastRatio(const Color(0xFFFFFFFF), const Color(0xFF000000)),
        closeTo(21, 0.001),
      );
      expect(
        contrastRatio(const Color(0xFF123456), const Color(0xFF123456)),
        closeTo(1, 0.001),
      );
      expect(
        contrastRatio(const Color(0xFFFFFFFF), const Color(0xFF000000)),
        contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      );
    });

    test('contrastRatio ignores alpha', () {
      expect(
        contrastRatio(const Color(0x00FFFFFF), const Color(0xFF000000)),
        closeTo(21, 0.001),
      );
    });

    test('pickContrastingColor picks the readable side', () {
      expect(
        pickContrastingColor(const Color(0xFF000000)),
        const Color(0xFFFFFFFF),
      );
      expect(
        pickContrastingColor(const Color(0xFFFFFFFF)),
        const Color(0xFF000000),
      );
      // A dark destructive colour gets a light label and vice versa.
      expect(
        pickContrastingColor(const Color(0xFF7F1D1D)),
        const Color(0xFFFFFFFF),
      );
      expect(
        pickContrastingColor(const Color(0xFFFDE68A)),
        const Color(0xFF000000),
      );
    });

    test('pickContrastingColor honours custom candidates', () {
      const light = Color(0xFFEEEEEE);
      const dark = Color(0xFF111111);
      expect(
        pickContrastingColor(const Color(0xFF000000), light: light, dark: dark),
        light,
      );
      expect(
        pickContrastingColor(const Color(0xFFFFFFFF), light: light, dark: dark),
        dark,
      );
    });

    test('isLightColor uses relative luminance', () {
      expect(isLightColor(const Color(0xFFFFFFFF)), isTrue);
      expect(isLightColor(const Color(0xFF000000)), isFalse);
      expect(isLightColor(const Color(0xFF808080)), isFalse);
      expect(isLightColor(const Color(0xFF808080), threshold: 0.2), isTrue);
      expect(isLightColor(const Color(0x00FFFFFF)), isTrue);
    });
  });
}
