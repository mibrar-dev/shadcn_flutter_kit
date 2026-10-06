import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

int _alphaByte(Color color) => (color.a * 255).round() & 0xFF;

List<BoxShadow> _sizes(ShadowScale scale) => [
  ...scale.shadow2xs,
  ...scale.shadowXs,
  ...scale.shadowSm,
  ...scale.shadow,
  ...scale.shadowMd,
  ...scale.shadowLg,
  ...scale.shadowXl,
  ...scale.shadow2xl,
];

void main() {
  test('derive with default atoms matches defaults: exact geometry, '
      'alpha within 1/255', () {
    final derived = ShadowScale.derive();
    const expected = defaultShadowScale;
    final a = _sizes(derived);
    final b = _sizes(expected);
    expect(a.length, b.length);
    for (var i = 0; i < a.length; i++) {
      // Geometry is assigned directly from the atoms: bit-exact.
      expect(a[i].offset, b[i].offset, reason: 'shadow $i offset');
      expect(a[i].blurRadius, b[i].blurRadius, reason: 'shadow $i blur');
      expect(a[i].spreadRadius, b[i].spreadRadius, reason: 'shadow $i spread');
      // Alpha is ratio-scaled then byte-rounded: halving/doubling the even
      // byte 38 cannot hit the odd old remainders (19 vs 0x12, 96 vs 0x61).
      expect(
        (_alphaByte(a[i].color) - _alphaByte(b[i].color)).abs(),
        lessThanOrEqualTo(1),
        reason: 'shadow $i alpha byte',
      );
      expect(a[i].color.r, b[i].color.r);
      expect(a[i].color.g, b[i].color.g);
      expect(a[i].color.b, b[i].color.b);
    }
  });

  test('shadcn default base gives the tailwind shadow ramp', () {
    final derived = ShadowScale.derive(
      color: const Color(0xFF000000),
      opacity: 0.1,
      blur: 3,
      spread: 0,
      offsetX: 0,
      offsetY: 1,
    );
    expect(derived.shadowSm.length, 2);
    final ambient = derived.shadowSm[0];
    expect(ambient.offset, const Offset(0, 1));
    expect(ambient.blurRadius, 3);
    expect(ambient.spreadRadius, 0);
    expect(ambient.color.a, moreOrLessEquals(0.1, epsilon: 1 / 255));
    final detail = derived.shadowSm[1];
    expect(detail.offset, const Offset(0, 1));
    expect(detail.blurRadius, 2);
    expect(detail.spreadRadius, -1);
    expect(detail.color.a, moreOrLessEquals(0.1, epsilon: 1 / 255));
    final mdDetail = derived.shadowMd[1];
    expect(mdDetail.offset, const Offset(0, 2));
    expect(mdDetail.blurRadius, 4);
    expect(mdDetail.spreadRadius, -1);
  });

  test('no negative blur or offset with the shadcn base', () {
    final derived = ShadowScale.derive(
      color: const Color(0xFF000000),
      opacity: 0.1,
      blur: 3,
      spread: 0,
      offsetX: 0,
      offsetY: 1,
    );
    for (final shadow in _sizes(derived)) {
      expect(shadow.blurRadius, greaterThanOrEqualTo(0));
      expect(shadow.offset.dx, greaterThanOrEqualTo(0));
      expect(shadow.offset.dy, greaterThanOrEqualTo(0));
    }
  });
}
