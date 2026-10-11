// Unit tests for the `syntax` token group: the github-light/github-dark
// palettes, resolution through ShadcnThemeData for every preset in both
// brightnesses (no per-preset JSON edits required), the copyWith override
// leg, and lerp stepping.

import 'package:flutter/widgets.dart';

import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/syntax_colors.dart';
import 'package:flutter_shadcn_kit/registry/theme/tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/rearch/gen_app_theme.dart' as gen;
import '../themes/schema_check.dart';

/// Builds the 32 shadcn color tokens from a preset's light/dark value map.
ShadcnColors colorsFrom(Map<String, int> map, Brightness brightness) {
  Color color(String key) => Color(map[key]!);
  return ShadcnColors(
    brightness: brightness,
    background: color('background'),
    foreground: color('foreground'),
    card: color('card'),
    cardForeground: color('cardForeground'),
    popover: color('popover'),
    popoverForeground: color('popoverForeground'),
    primary: color('primary'),
    primaryForeground: color('primaryForeground'),
    secondary: color('secondary'),
    secondaryForeground: color('secondaryForeground'),
    muted: color('muted'),
    mutedForeground: color('mutedForeground'),
    accent: color('accent'),
    accentForeground: color('accentForeground'),
    destructive: color('destructive'),
    destructiveForeground: color('destructiveForeground'),
    border: color('border'),
    input: color('input'),
    ring: color('ring'),
    chart1: color('chart1'),
    chart2: color('chart2'),
    chart3: color('chart3'),
    chart4: color('chart4'),
    chart5: color('chart5'),
    sidebar: color('sidebar'),
    sidebarForeground: color('sidebarForeground'),
    sidebarPrimary: color('sidebarPrimary'),
    sidebarPrimaryForeground: color('sidebarPrimaryForeground'),
    sidebarAccent: color('sidebarAccent'),
    sidebarAccentForeground: color('sidebarAccentForeground'),
    sidebarBorder: color('sidebarBorder'),
    sidebarRing: color('sidebarRing'),
  );
}

/// Builds the non-color tokens the way the kit generator emits them.
ShadcnTokens tokensFrom(gen.ThemeValues values, Brightness brightness) {
  final atoms = brightness == Brightness.dark
      ? values.darkShadow
      : values.lightShadow;
  return ShadcnTokens(
    radius: values.radius,
    spacingBase: values.spacing,
    trackingNormal: values.tracking['normal'] ?? 0,
    trackingTight: values.tracking['tight'],
    trackingWide: values.tracking['wide'],
    shadows: ShadowScale.derive(
      color: Color(atoms.color),
      opacity: atoms.opacity,
      blur: atoms.blur,
      spread: atoms.spread,
      offsetX: atoms.offsetX,
      offsetY: atoms.offsetY,
    ),
  );
}

ShadcnThemeData themeFrom(gen.ThemeValues values, Brightness brightness) {
  return ShadcnThemeData(
    colors: colorsFrom(
      brightness == Brightness.dark ? values.dark : values.light,
      brightness,
    ),
    tokens: tokensFrom(values, brightness),
    fonts: ShadcnFonts(
      fontSans: values.fonts['sans'],
      fontSerif: values.fonts['serif'],
      fontMono: values.fonts['mono'],
    ),
  );
}

void main() {
  group('palettes', () {
    test('light and dark differ for the accent kinds', () {
      expect(SyntaxColors.light.keyword, isNot(SyntaxColors.dark.keyword));
      expect(SyntaxColors.light.string, isNot(SyntaxColors.dark.string));
      expect(SyntaxColors.light.comment, isNot(SyntaxColors.dark.comment));
      expect(SyntaxColors.light.tag, isNot(SyntaxColors.dark.tag));
    });

    test('forBrightness picks the palette', () {
      expect(SyntaxColors.forBrightness(Brightness.light), SyntaxColors.light);
      expect(SyntaxColors.forBrightness(Brightness.dark), SyntaxColors.dark);
    });

    test('colorFor covers every kind', () {
      for (final kind in SyntaxTokenKind.values) {
        expect(SyntaxColors.light.colorFor(kind), isA<Color>());
        expect(SyntaxColors.dark.colorFor(kind), isA<Color>());
      }
    });
  });

  group('preset resolution', () {
    test('syntax colors resolve in light and dark for all 43 presets', () {
      final files = presetFiles();
      expect(files.length, 43);
      for (final file in files) {
        final values = gen.ThemeValues.fromJson(
          readJsonMap('$themesDir/$file'),
        );
        final light = themeFrom(values, Brightness.light);
        final dark = themeFrom(values, Brightness.dark);
        // No per-preset JSON edits: the default palette resolves per
        // brightness for every preset.
        expect(light.syntaxColors, SyntaxColors.light, reason: file);
        expect(dark.syntaxColors, SyntaxColors.dark, reason: file);
        expect(
          light.syntaxColors.keyword,
          isNot(dark.syntaxColors.keyword),
          reason: file,
        );
      }
    });

    test('copyWith(syntax:) pins a custom palette', () {
      final values = gen.ThemeValues.fromJson(
        readJsonMap('$themesDir/neutral.json'),
      );
      final custom = const SyntaxColors(
        plain: Color(0xFF111111),
        keyword: Color(0xFF222222),
        type: Color(0xFF333333),
        function: Color(0xFF444444),
        string: Color(0xFF555555),
        number: Color(0xFF666666),
        comment: Color(0xFF777777),
        operator: Color(0xFF888888),
        annotation: Color(0xFF999999),
        variable: Color(0xFFAAAAAA),
        constant: Color(0xFFBBBBBB),
        tag: Color(0xFFCCCCCC),
        attribute: Color(0xFFDDDDDD),
      );
      final light = themeFrom(values, Brightness.light);
      final pinned = light.copyWith(syntax: () => custom);
      expect(pinned.syntaxColors, custom);
      // The override survives a brightness switch (it is mode-independent).
      final dark = themeFrom(values, Brightness.dark);
      expect(dark.copyWith(syntax: () => custom).syntaxColors, custom);
    });

    test('lerp steps at t = 0.5 like fonts', () {
      final values = gen.ThemeValues.fromJson(
        readJsonMap('$themesDir/neutral.json'),
      );
      final a = themeFrom(values, Brightness.light);
      final b = a.copyWith(syntax: () => SyntaxColors.dark);
      expect(ShadcnThemeData.lerp(a, b, 0.2).syntaxColors, SyntaxColors.light);
      expect(ShadcnThemeData.lerp(a, b, 0.8).syntaxColors, SyntaxColors.dark);
    });
  });
}
