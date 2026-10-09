// Colour format round trip: `#RRGGBB` and `#RRGGBBAA`, alpha never dropped.
//
// The regression this guards is the one P1-D found: 0/42 legacy presets carried
// a translucent colour, so shadcn's `oklch(1 0 0 / 10%)` dark border was
// flattened. tweakcn atoms DO carry alpha (`hsl(0 0% 20% / 0.1)` for graphite,
// `rgba(29,161,242,0.15)` for twitter), so the format has to round trip it.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/rearch/gen_app_theme.dart' as gen;
import 'package:flutter_shadcn_kit/registry/theme/tokens.dart';
import 'generated_theme.dart';
import 'schema_check.dart';

void main() {
  test('six digit colours default to opaque', () {
    expect(gen.parseHexColor('#1A2B3C'), 0xFF1A2B3C);
    expect(gen.formatHexColor(0xFF1A2B3C), '#1A2B3C');
  });

  test('eight digit colours keep their alpha byte', () {
    // The string form is #RRGGBBAA; the int is the usual Dart 0xAARRGGBB.
    expect(gen.parseHexColor('#1A2B3C4D'), 0x4D1A2B3C);
    expect((gen.parseHexColor('#FFFFFF1A') >> 24) & 0xFF, 0x1A);
    expect(gen.formatHexColor(0x4D1A2B3C), '#1A2B3C4D');
  });

  test('every alpha byte round trips', () {
    for (var alpha = 0; alpha <= 0xFF; alpha += 1) {
      final argb = (alpha << 24) | 0x123456;
      expect(gen.parseHexColor(gen.formatHexColor(argb)), argb);
    }
  });

  test('lower case input is accepted and normalised to upper case', () {
    expect(gen.parseHexColor('#abcdef12'), 0x12ABCDEF);
    expect(gen.formatHexColor(gen.parseHexColor('#abcdef12')), '#ABCDEF12');
  });

  test('the 0x prefix and short hex are rejected', () {
    expect(() => gen.parseHexColor('0xFF1A2B3C'), throwsFormatException);
    expect(() => gen.parseHexColor('#FFF'), throwsFormatException);
    expect(() => gen.parseHexColor('#1A2B3C4D5E'), throwsFormatException);
    expect(() => gen.parseHexColor('rgb(1,2,3)'), throwsFormatException);
    expect(() => gen.parseHexColor(''), throwsFormatException);
  });

  test('alpha survives JSON -> Dart -> Color', () {
    final atoms =
        ((readJsonMap('$themesDir/graphite.json')['shadow']! as Map)
                .cast<String, Object?>()['light']!
            as Map<String, Object?>);
    // tweakcn: hsl(0 0% 20% / 0.1) * shadowOpacity 0.15.
    expect(atoms['color'], '#3333331A');
    final colour = Color(gen.parseHexColor(atoms['color']! as String));
    expect(colour.a, closeTo(26 / 255, 1e-9));

    final generated = loadGeneratedTheme('$themesDir/graphite.json');

    final derived = ShadowScale.derive(
      color: colour,
      opacity: (atoms['opacity']! as num).toDouble(),
      blur: (atoms['blur']! as num).toDouble(),
      spread: (atoms['spread']! as num).toDouble(),
      offsetX: (atoms['offsetX']! as num).toDouble(),
      offsetY: (atoms['offsetY']! as num).toDouble(),
    );
    // 0.1 * 0.15 = 0.015 -> alpha byte 4, the legacy literal 0x04333333.
    final ambient = derived.shadow.first;
    expect((ambient.color.a * 255).round(), 4);
    expect((ambient.color.r * 255).round(), 0x33);
    expect((ambient.color.g * 255).round(), 0x33);
    expect((ambient.color.b * 255).round(), 0x33);
    expect(derived.shadow[1].color, ambient.color);
    // The same numbers, reached through the generated file.
    expect(generated.lightTokens.shadows.shadow.first, ambient);
  });

  test('an opaque token never gains an alpha suffix', () {
    // shadcn's official neutral CSS defines three dark tokens with alpha
    // (`oklch(1 0 0 / 10%)` border, `/ 15%` input and sidebar-border); those
    // are the only documented 8-digit colour tokens. Every other token must
    // stay opaque: the P1-D regression was alpha appearing where the source
    // had none.
    const alphaTokens = <String>{
      'neutral.json dark.border',
      'neutral.json dark.input',
      'neutral.json dark.sidebarBorder',
    };
    for (final file in presetFiles()) {
      final preset = readJsonMap('$themesDir/$file');
      for (final mode in const ['light', 'dark']) {
        final colors = (preset[mode]! as Map).cast<String, Object?>();
        for (final key in gen.colorTokenKeys) {
          final value = colors[key]! as String;
          final hasAlpha = value.length == 9;
          if (alphaTokens.contains('$file $mode.$key')) {
            expect(hasAlpha, isTrue, reason: '$file $mode.$key');
            continue;
          }
          expect(value.length, 7, reason: '$file $mode.$key');
        }
      }
    }
  });
}
