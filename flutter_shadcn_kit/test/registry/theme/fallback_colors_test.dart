import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fallback foreground tokens are never fully transparent', () {
    for (final colors in [
      ShadcnColors.lightFallback,
      ShadcnColors.darkFallback,
    ]) {
      expect(colors.destructiveForeground.a, 1.0);
      expect(colors.primaryForeground.a, 1.0);
      expect(colors.foreground.a, 1.0);
    }
  });
}
