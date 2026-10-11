// Radius token derivation vs shadcn v4 (`globals.css`): `lg` is the rem
// value in px (`radius * 16`); `sm`/`md` step down 4/2 px and `xl` steps
// up 4 px, clamped at zero. `xs`/`xxl` are kit extensions on the old
// linear steps and are pinned here so a change is deliberate.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry/theme/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

ShadcnThemeData _theme(double radius) =>
    ShadcnThemeData(tokens: ShadcnTokens(radius: radius));

void main() {
  group('radius steps follow shadcn v4', () {
    test('radius 0 clamps every step to 0', () {
      final ShadcnThemeData theme = _theme(0);
      expect(theme.radiusXs, 0);
      expect(theme.radiusSm, 0);
      expect(theme.radiusMd, 0);
      expect(theme.radiusLg, 0);
      expect(theme.radiusXl, 0);
      expect(theme.radiusXxl, 0);
      expect(theme.borderRadiusXl, BorderRadius.zero);
    });

    test('radius 0.5 (kit default): 2/4/6/8/12/12', () {
      final ShadcnThemeData theme = _theme(0.5);
      expect(theme.radiusXs, 2);
      expect(theme.radiusSm, 4);
      expect(theme.radiusMd, 6);
      expect(theme.radiusLg, 8);
      expect(theme.radiusXl, 12);
      expect(theme.radiusXxl, 12);
    });

    test('radius 0.625 (shadcn default 10px): 2.5/6/8/10/14/15', () {
      final ShadcnThemeData theme = _theme(0.625);
      expect(theme.radiusXs, 2.5);
      expect(theme.radiusSm, 6);
      expect(theme.radiusMd, 8);
      expect(theme.radiusLg, 10);
      expect(theme.radiusXl, 14);
      expect(theme.radiusXxl, 15);
      expect(theme.borderRadiusXl, BorderRadius.circular(14));
    });

    test('radius 1.0 (large): 4/12/14/16/20/24', () {
      final ShadcnThemeData theme = _theme(1.0);
      expect(theme.radiusXs, 4);
      expect(theme.radiusSm, 12);
      expect(theme.radiusMd, 14);
      expect(theme.radiusLg, 16);
      expect(theme.radiusXl, 20);
      expect(theme.radiusXxl, 24);
    });

    test('small radius 0.125 clamps sm/md instead of going negative', () {
      // lg = 2: sm would be -2 and md 0 without the clamp.
      final ShadcnThemeData theme = _theme(0.125);
      expect(theme.radiusLg, 2);
      expect(theme.radiusSm, 0);
      expect(theme.radiusMd, 0);
      expect(theme.radiusXl, 6);
    });
  });
}
