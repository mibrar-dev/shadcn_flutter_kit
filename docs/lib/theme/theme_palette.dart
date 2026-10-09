// Derives the three editable colour families of the Theme Studio from one
// seed colour (spec §2.7: `Base Color`, `Theme`, `Chart Color` rows).
//
// The reference's customizer lets you drag one base colour and one accent
// colour and regenerates the whole neutral/accent ramp; our preset schema has
// no ramps, only 32 flat tokens per mode, so the ramp has to be derived here.
// The lightness steps follow shadcn's neutral scale (`background` 100 %,
// `muted`/`accent` 97 %, `border` 92 %, `foreground` 8 %; dark: 6 / 12 / 18 /
// 24 / 98) with the seed hue desaturated, which is what makes a slate seed
// read as "slate" rather than as grey.

import 'package:flutter/widgets.dart';

import 'theme_document.dart';
import 'theme_document_edits.dart';

/// The neutral family: everything a base-colour change may rewrite.
const List<String> kDocsBaseColorTokens = <String>[
  'background',
  'foreground',
  'card',
  'cardForeground',
  'popover',
  'popoverForeground',
  'secondary',
  'secondaryForeground',
  'muted',
  'mutedForeground',
  'accent',
  'accentForeground',
  'border',
  'input',
  'sidebar',
  'sidebarForeground',
  'sidebarAccent',
  'sidebarAccentForeground',
  'sidebarBorder',
];

/// The accent family: the `Theme` row.
const List<String> kDocsAccentColorTokens = <String>[
  'primary',
  'primaryForeground',
  'ring',
  'sidebarPrimary',
  'sidebarPrimaryForeground',
  'sidebarRing',
];

/// The neutral lightness steps per mode (percentages, as in shadcn's neutral).
const List<double> _baseLightSteps = <double>[
  1.0, // background
  0.98, // card / popover
  0.97, // secondary / muted / accent / sidebarAccent
  0.92, // border / input / sidebarBorder
  0.08, // foreground
  0.45, // mutedForeground
];

const List<double> _baseDarkSteps = <double>[
  0.06, // background
  0.12, // card / popover / sidebar
  0.18, // secondary / muted / accent / sidebarAccent
  0.24, // border / input / sidebarBorder
  0.98, // foreground
  0.65, // mutedForeground
];

/// Rewrites the neutral family of [document] around [seed].
ThemeDocument applyBaseColor(ThemeDocument document, Color seed) =>
    _apply(document, seed, _baseRamp, kDocsBaseColorTokens);

/// Rewrites the accent family of [document] around [seed].
ThemeDocument applyAccentColor(ThemeDocument document, Color seed) =>
    _apply(document, seed, _accentRamp, kDocsAccentColorTokens);

/// Rewrites `chart1`…`chart5` as five evenly spaced hues around [seed].
ThemeDocument applyChartColors(ThemeDocument document, Color seed) {
  final HSLColor hsl = HSLColor.fromColor(seed);
  const List<double> offsets = <double>[0, 60, 120, 180, 240];
  ThemeDocument next = document;
  for (int i = 0; i < kDocsChartTokenKeys.length; i += 1) {
    final double lightness = hsl.lightness.clamp(0.35, 0.75);
    final String hex = _hex(
      HSLColor.fromAHSL(
        1,
        (hsl.hue + offsets[i]) % 360,
        hsl.saturation.clamp(0.35, 0.9),
        lightness,
      ).toColor(),
    );
    next = next
        .withLightColor(kDocsChartTokenKeys[i], hex)
        .withDarkColor(kDocsChartTokenKeys[i], hex);
  }
  return next;
}

ThemeDocument _apply(
  ThemeDocument document,
  Color seed,
  List<Map<String, String>> Function(HSLColor) ramp,
  List<String> tokens,
) {
  final HSLColor hsl = HSLColor.fromColor(seed);
  // The ramp yields exactly two maps: the light block, then the dark one.
  final List<Map<String, String>> blocks = ramp(hsl);
  final Map<String, String> light = blocks[0];
  final Map<String, String> dark = blocks[1];
  ThemeDocument next = document;
  for (final String token in tokens) {
    next = next.withLightColor(token, light[token]!);
    next = next.withDarkColor(token, dark[token]!);
  }
  return next;
}

List<Map<String, String>> _baseRamp(HSLColor hsl) {
  final double saturation = hsl.saturation.clamp(0.0, 0.3) * 0.45;
  Color at(double lightness) =>
      HSLColor.fromAHSL(1, hsl.hue, saturation, lightness).toColor();
  return <Map<String, String>>[
    <String, String>{
      'background': _hex(at(_baseLightSteps[0])),
      'card': _hex(at(_baseLightSteps[1])),
      'popover': _hex(at(_baseLightSteps[1])),
      'sidebar': _hex(at(_baseLightSteps[1])),
      'sidebarForeground': _hex(at(_baseLightSteps[4])),
      'cardForeground': _hex(at(_baseLightSteps[4])),
      'popoverForeground': _hex(at(_baseLightSteps[4])),
      'secondary': _hex(at(_baseLightSteps[2])),
      'muted': _hex(at(_baseLightSteps[2])),
      'accent': _hex(at(_baseLightSteps[2])),
      'sidebarAccent': _hex(at(_baseLightSteps[2])),
      'secondaryForeground': _hex(at(_baseLightSteps[4])),
      'accentForeground': _hex(at(_baseLightSteps[4])),
      'sidebarAccentForeground': _hex(at(_baseLightSteps[4])),
      'border': _hex(at(_baseLightSteps[3])),
      'input': _hex(at(_baseLightSteps[3])),
      'sidebarBorder': _hex(at(_baseLightSteps[3])),
      'mutedForeground': _hex(at(_baseLightSteps[5])),
      'foreground': _hex(at(_baseLightSteps[4])),
    },
    <String, String>{
      'background': _hex(at(_baseDarkSteps[0])),
      'card': _hex(at(_baseDarkSteps[1])),
      'popover': _hex(at(_baseDarkSteps[1])),
      'sidebar': _hex(at(_baseDarkSteps[1])),
      'sidebarForeground': _hex(at(_baseDarkSteps[4])),
      'cardForeground': _hex(at(_baseDarkSteps[4])),
      'popoverForeground': _hex(at(_baseDarkSteps[4])),
      'secondary': _hex(at(_baseDarkSteps[2])),
      'muted': _hex(at(_baseDarkSteps[2])),
      'accent': _hex(at(_baseDarkSteps[2])),
      'sidebarAccent': _hex(at(_baseDarkSteps[2])),
      'secondaryForeground': _hex(at(_baseDarkSteps[4])),
      'accentForeground': _hex(at(_baseDarkSteps[4])),
      'sidebarAccentForeground': _hex(at(_baseDarkSteps[4])),
      'border': _hex(at(_baseDarkSteps[3])),
      'input': _hex(at(_baseDarkSteps[3])),
      'sidebarBorder': _hex(at(_baseDarkSteps[3])),
      'mutedForeground': _hex(at(_baseDarkSteps[5])),
      'foreground': _hex(at(_baseDarkSteps[4])),
    },
  ];
}

List<Map<String, String>> _accentRamp(HSLColor hsl) {
  final double saturation = hsl.saturation.clamp(0.15, 1);
  final double lightPrimary = hsl.lightness.clamp(0.25, 0.55);
  final double darkPrimary = hsl.lightness.clamp(0.6, 0.85);
  Color primary(bool light) => HSLColor.fromAHSL(
    1,
    hsl.hue,
    saturation,
    light ? lightPrimary : darkPrimary,
  ).toColor();
  Color onPrimary(bool light) {
    final Color base = primary(light);
    return base.computeLuminance() > 0.45
        ? HSLColor.fromAHSL(1, hsl.hue, saturation * 0.3, 0.08).toColor()
        : HSLColor.fromAHSL(1, hsl.hue, saturation * 0.2, 0.98).toColor();
  }

  Color ring(bool light) => HSLColor.fromAHSL(
    1,
    hsl.hue,
    saturation * 0.6,
    light ? lightPrimary * 1.2 : darkPrimary * 0.8,
  ).toColor();

  return <Map<String, String>>[
    <String, String>{
      'primary': _hex(primary(true)),
      'primaryForeground': _hex(onPrimary(true)),
      'ring': _hex(ring(true)),
      'sidebarPrimary': _hex(primary(true)),
      'sidebarPrimaryForeground': _hex(onPrimary(true)),
      'sidebarRing': _hex(ring(true)),
    },
    <String, String>{
      'primary': _hex(primary(false)),
      'primaryForeground': _hex(onPrimary(false)),
      'ring': _hex(ring(false)),
      'sidebarPrimary': _hex(primary(false)),
      'sidebarPrimaryForeground': _hex(onPrimary(false)),
      'sidebarRing': _hex(ring(false)),
    },
  ];
}

/// Upper-case `#RRGGBB[AA]` for the document.
String _hex(Color color) => formatDocsHexColor(color.toARGB32());

/// The name the reference shows for a picked colour ("Neutral", "Blue", …).
///
/// Derived from the nearest CSS basic colour by hue, so it needs no table of
/// hand-typed labels per token; unknown hues fall back to the hex value.
String docsColorName(Color color) {
  final HSLColor hsl = HSLColor.fromColor(color);
  if (hsl.saturation < 0.12) {
    return 'Neutral';
  }
  String best = 'Neutral';
  double bestDistance = double.infinity;
  for (final _NamedColor named in _namedColors) {
    final double distance = _hueDistance(hsl.hue, named.hue);
    final double penalty = (hsl.lightness - named.lightness).abs() * 0.35;
    if (distance + penalty < bestDistance) {
      bestDistance = distance + penalty;
      best = named.name;
    }
  }
  return best;
}

double _hueDistance(double a, double b) {
  final double delta = (a - b).abs() % 360;
  return delta > 180 ? 360 - delta : delta;
}

/// The CSS basic colours the picker names its swatches after.
const List<_NamedColor> _namedColors = <_NamedColor>[
  _NamedColor('Red', 0, 0.5),
  _NamedColor('Orange', 30, 0.6),
  _NamedColor('Amber', 45, 0.55),
  _NamedColor('Yellow', 55, 0.6),
  _NamedColor('Lime', 85, 0.5),
  _NamedColor('Green', 140, 0.5),
  _NamedColor('Emerald', 155, 0.5),
  _NamedColor('Teal', 175, 0.5),
  _NamedColor('Cyan', 195, 0.55),
  _NamedColor('Sky', 205, 0.55),
  _NamedColor('Blue', 220, 0.5),
  _NamedColor('Indigo', 245, 0.5),
  _NamedColor('Violet', 265, 0.5),
  _NamedColor('Purple', 285, 0.5),
  _NamedColor('Fuchsia', 320, 0.5),
  _NamedColor('Pink', 335, 0.55),
  _NamedColor('Rose', 350, 0.55),
];

class _NamedColor {
  const _NamedColor(this.name, this.hue, this.lightness);

  final String name;
  final double hue;
  final double lightness;
}
