// Widget test over GENERATED theme files.
//
// `generated_theme.dart` parses the `app_theme.dart` that
// `tool/rearch/gen_app_theme.dart` emits (via package:analyzer) and rebuilds
// real `ShadcnColors` / `ShadcnTokens` objects from the literals found in that
// source, so the values under test are the ones a user app would compile -
// not objects rebuilt from the preset JSON. The expected values are then
// recomputed straight from the JSON, so JSON -> Dart -> runtime is checked
// end to end for both brightnesses.

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/rearch/gen_app_theme.dart' as gen;
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'generated_theme.dart';
import 'schema_check.dart';

/// `claude` has no fonts and from-legacy shadow atoms; `graphite` has all
/// three font slots and CLI atoms whose colour already carries alpha
/// (`hsl(0 0% 20% / 0.1)` -> `#3333331A`).
const List<String> presetsUnderTest = <String>['claude', 'graphite'];

/// Expected `shadowSm` detail layer from the raw JSON atoms.
///
/// `ShadowScale.derive` uses the tweakcn formula: `shadowSm` is the ambient
/// layer plus a detail layer at absolute geometry (`Offset(x, 1)`, blur 2,
/// spread - 1) whose alpha is `colourAlpha * opacity`.
BoxShadow expectedDetailLayer(Map<String, Object?> atoms) {
  final colour = gen.parseHexColor(atoms['color']! as String);
  final opacity = (atoms['opacity']! as num).toDouble();
  final alpha = ((colour >> 24) / 255 * opacity * 255).round();
  return BoxShadow(
    offset: Offset((atoms['offsetX']! as num).toDouble(), 1),
    blurRadius: 2,
    spreadRadius: (atoms['spread']! as num).toDouble() - 1,
    color: Color.fromARGB(
      alpha,
      (colour >> 16) & 0xFF,
      (colour >> 8) & 0xFF,
      colour & 0xFF,
    ),
  );
}

void main() {
  for (final id in presetsUnderTest) {
    testWidgets('$id: the generated theme resolves the JSON values', (
      tester,
    ) async {
      final preset = readJsonMap('$themesDir/$id.json');
      final generated = loadGeneratedTheme('$themesDir/$id.json');
      expect(generated.prefix, gen.camelCase(id));
      expect(
        generated.buildFunction,
        'build${id[0].toUpperCase()}${id.substring(1).replaceAll('-', '')}'
        'Theme',
      );
      expect(
        generated.source,
        contains('${generated.buildFunction}(Brightness brightness)'),
      );

      final radius = (preset['radius']! as num).toDouble();
      for (final mode in const ['light', 'dark']) {
        final brightness = mode == 'light' ? Brightness.light : Brightness.dark;
        final view = generated.view(brightness);
        final colors = view.colors;
        final tokens = view.tokens;
        final atoms = (preset['shadow']! as Map)[mode]! as Map<String, Object?>;

        ShadcnThemeData? resolved;
        await tester.pumpWidget(
          ShadcnTheme(
            data: ShadcnThemeData(
              colors: colors,
              tokens: tokens,
              fonts: view.fonts,
            ),
            child: Builder(
              builder: (context) {
                resolved = ShadcnTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final data = resolved;
        expect(data, isNotNull);
        if (data == null) return;

        // 1. Primary colour is the JSON literal, alpha included.
        expect(
          data.colors.primary,
          Color(
            gen.parseHexColor((preset[mode]! as Map)['primary']! as String),
          ),
          reason: '$id $mode primary',
        );
        expect(data.colors.brightness, brightness);

        // 2. Radius is the unitless rem factor; steps follow shadcn v4
        // (lg = rem px, sm/md step down 4/2, xl steps up 4, floored at 0).
        expect(data.tokens.radius, radius, reason: '$id $mode radius');
        final double lg = radius * 16;
        expect(data.radiusLg, lg, reason: '$id $mode radiusLg');
        expect(data.radiusSm, max(0.0, lg - 4), reason: '$id $mode radiusSm');
        expect(data.radiusMd, max(0.0, lg - 2), reason: '$id $mode radiusMd');
        expect(
          data.radiusXl,
          lg <= 0 ? 0 : lg + 4,
          reason: '$id $mode radiusXl',
        );
        expect(data.tokens.spacingBase, (preset['spacing']! as num) * 16);

        // 3. shadowSm is the derived two layer stack, not eight copies.
        expect(tokens.shadows.shadowSm, hasLength(2));
        expect(
          tokens.shadows.shadowSm[1],
          expectedDetailLayer(atoms),
          reason: '$id $mode shadowSm detail layer',
        );
        expect(tokens.shadows.shadow2xs, hasLength(1));
        expect(tokens.shadows.shadow2xl, hasLength(1));
        expect(
          tokens.shadows.shadow2xl.single.color.a,
          greaterThan(tokens.shadows.shadow2xs.single.color.a),
          reason: '2xl is 2.5x the ambient alpha of 2xs',
        );
      }
    });

    test('$id: fonts match the JSON block', () {
      final preset = readJsonMap('$themesDir/$id.json');
      final generated = loadGeneratedTheme('$themesDir/$id.json');
      final fonts = preset['fonts'];
      if (fonts == null) {
        expect(generated.fonts, isNull);
        return;
      }
      final block = (fonts as Map).cast<String, Object?>();
      expect(generated.fonts?.fontSans, block['sans']);
      expect(generated.fonts?.fontSerif, block['serif']);
      expect(generated.fonts?.fontMono, block['mono']);
    });
  }

  test('every preset parses back into the values it was generated from', () {
    for (final file in presetFiles()) {
      final preset = readJsonMap('$themesDir/$file');
      final generated = loadGeneratedTheme('$themesDir/$file');
      for (final mode in const ['light', 'dark']) {
        final expected = (preset[mode]! as Map).cast<String, Object?>();
        final actual = mode == 'light'
            ? generated.lightColors
            : generated.darkColors;
        for (final key in gen.colorTokenKeys) {
          expect(
            Color(gen.parseHexColor(expected[key]! as String)),
            switch (key) {
              'background' => actual.background,
              'foreground' => actual.foreground,
              'card' => actual.card,
              'cardForeground' => actual.cardForeground,
              'popover' => actual.popover,
              'popoverForeground' => actual.popoverForeground,
              'primary' => actual.primary,
              'primaryForeground' => actual.primaryForeground,
              'secondary' => actual.secondary,
              'secondaryForeground' => actual.secondaryForeground,
              'muted' => actual.muted,
              'mutedForeground' => actual.mutedForeground,
              'accent' => actual.accent,
              'accentForeground' => actual.accentForeground,
              'destructive' => actual.destructive,
              'destructiveForeground' => actual.destructiveForeground,
              'border' => actual.border,
              'input' => actual.input,
              'ring' => actual.ring,
              'chart1' => actual.chart1,
              'chart2' => actual.chart2,
              'chart3' => actual.chart3,
              'chart4' => actual.chart4,
              'chart5' => actual.chart5,
              'sidebar' => actual.sidebar,
              'sidebarForeground' => actual.sidebarForeground,
              'sidebarPrimary' => actual.sidebarPrimary,
              'sidebarPrimaryForeground' => actual.sidebarPrimaryForeground,
              'sidebarAccent' => actual.sidebarAccent,
              'sidebarAccentForeground' => actual.sidebarAccentForeground,
              'sidebarBorder' => actual.sidebarBorder,
              _ => actual.sidebarRing,
            },
            reason: '$file $mode.$key',
          );
        }
      }
    }
  });
}
