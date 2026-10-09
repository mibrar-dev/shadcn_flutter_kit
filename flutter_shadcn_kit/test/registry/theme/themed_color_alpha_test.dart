import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ref alpha multiplies the token alpha (0.1 * 0.8 = 0.08)', () {
    const token = Color(0xFF336699);
    final colors = ShadcnColors.lightFallback.copyWith(
      primary: token.withValues(alpha: 0.1),
    );
    final resolved = const ThemedColor.ref(
      ColorRef.primary,
      alpha: 0.8,
    ).resolve(colors);
    expect(resolved.a, moreOrLessEquals(0.08, epsilon: 1e-9));
    // rgb channels pass through from the token.
    expect(resolved.r, token.r);
    expect(resolved.g, token.g);
    expect(resolved.b, token.b);
  });

  test('ref with alpha 1 returns the token untouched', () {
    const colors = ShadcnColors.lightFallback;
    expect(
      const ThemedColor.ref(ColorRef.primary).resolve(colors),
      colors.primary,
    );
  });

  test('value ignores the tokens', () {
    const literal = Color(0xFF123456);
    expect(
      const ThemedColor.value(literal).resolve(ShadcnColors.lightFallback),
      literal,
    );
  });

  test('ColorRef resolves every token without throwing', () {
    const colors = ShadcnColors.lightFallback;
    for (final ref in ColorRef.values) {
      expect(ref.resolve(colors), isA<Color>());
    }
    expect(ColorRef.values.length, 32);
    expect(ColorRef.primary.resolve(colors), colors.primary);
    expect(ColorRef.sidebarRing.resolve(colors), colors.sidebarRing);
  });
}
