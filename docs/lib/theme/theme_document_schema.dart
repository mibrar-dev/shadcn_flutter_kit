// Schema primitives of the docs theme model (D7): the colour alphabet, the
// hex codec and the base shadow atoms of a schema-v2 preset document.
//
// Split out of `theme_document.dart` for the ~400-line rule. Nothing here is
// hand-typed: the token keys come from the generated preset sources, and the
// hex rules are the registry schema's (`colorToken`: `#RRGGBB` with an
// optional, never-flattened alpha channel).

// The site-wide theme model (D7, spec §2.7): a schema-v2 preset document as
// an immutable value object.
//
// The Theme Studio edits every `ShadcnThemeData` token, and the edit has to
// round-trip three ways: apply live to the whole site, persist to
// localStorage, and export as the exact `app_theme.dart` / preset JSON that
// `flutter_shadcn theme apply` consumes. The only representation that does
// all three is the preset document itself, so this class *is* the model: it
// parses and validates against `themes.schema.json` (as enforced by the
// registry's own rules), edits token-wise, serialises back to the canonical
// key order, and resolves a real `ShadcnThemeData`.
//
// Nothing here is hand-typed: the 32 colour token keys are read from the
// generated `docs_preset_sources.dart`, and the numbers follow the kit
// generator (`tool/rearch/gen_app_theme.dart`): radius stays unitless,
// spacing and tracking multiply by 16 into logical pixels, and the eight
// shadow sizes are always recomputed with `ShadowScale.derive`.

import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../generated/docs_preset_sources.dart';

/// A rejected preset document. [message] names the offending field so the
/// `Open Preset` dialog can show it verbatim.
class ThemeDocumentException implements Exception {
  /// Creates the exception.
  const ThemeDocumentException(this.message);

  /// Human readable reason.
  final String message;

  @override
  String toString() => message;
}

/// The 32 colour token keys of the preset schema, read from the generated
/// preset sources (never hand-typed).
final List<String> kDocsColorTokenKeys = List<String>.unmodifiable(
  _lightMapOfFirstPreset().keys,
);

/// The chart token keys, in schema order (`chart1` … `chart5`).
final List<String> kDocsChartTokenKeys = List<String>.unmodifiable(
  kDocsColorTokenKeys.where((String key) => key.startsWith('chart')),
);

/// The font slots of the schema (`sans`, `serif`, `mono`).
const List<String> kDocsFontSlots = <String>['sans', 'serif', 'mono'];

/// The tracking steps of the schema (`normal` plus the optional pair).
const List<String> kDocsTrackingSteps = <String>['normal', 'tight', 'wide'];

/// Matches the schema `colorToken` pattern (the registry generator also
/// accepts lower case, so pasted documents are not rejected on case alone).
final RegExp kDocsHexColorPattern = RegExp(
  r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$',
);

/// Parses `#RRGGBB` / `#RRGGBBAA` into a 32-bit ARGB int; alpha defaults to
/// `FF` and is never dropped when present (shadcn's 10 % dark border).
int parseDocsHexColor(String value) {
  if (!kDocsHexColorPattern.hasMatch(value)) {
    throw ThemeDocumentException('Not a #RRGGBB[AA] colour: $value');
  }
  final String digits = value.substring(1);
  final int rgb = int.parse(digits.substring(0, 6), radix: 16);
  final int alpha = digits.length == 8
      ? int.parse(digits.substring(6, 8), radix: 16)
      : 0xFF;
  return (alpha << 24) | rgb;
}

/// Formats ARGB as upper-case `#RRGGBB`, or `#RRGGBBAA` when translucent.
String formatDocsHexColor(int argb) {
  final int alpha = (argb >> 24) & 0xFF;
  final String rgb = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
  if (alpha == 0xFF) {
    return '#${rgb.toUpperCase()}';
  }
  final String a = alpha.toRadixString(16).padLeft(2, '0');
  return '#${rgb.toUpperCase()}$a'.toUpperCase();
}

/// The [Color] for a document colour [value].
Color docsColorOf(String value) => Color(parseDocsHexColor(value));

Map<String, Object?> _lightMapOfFirstPreset() {
  final Map<String, Object?> decoded =
      jsonDecode(kPresetSources.values.first.json) as Map<String, Object?>;
  return decoded['light']! as Map<String, Object?>;
}

/// The six base shadow atoms of one mode (the eight derived sizes are always
/// recomputed by `ShadowScale.derive`, never stored).
@immutable
class DocsShadowAtoms {
  /// Creates the atoms.
  const DocsShadowAtoms({
    required this.color,
    required this.opacity,
    required this.blur,
    required this.spread,
    required this.offsetX,
    required this.offsetY,
  });

  /// Reads a validated `shadowAtoms` object.
  factory DocsShadowAtoms.fromJson(
    Map<String, Object?> json, {
    required String path,
  }) {
    return DocsShadowAtoms(
      color: parseDocsHexColor(
        schemaStringField(json, 'color', path) ?? '#000000',
      ),
      opacity: schemaNumberField(json, 'opacity', path, fallback: 0.1),
      blur: schemaNumberField(json, 'blur', path, fallback: 3),
      spread: schemaNumberField(json, 'spread', path),
      offsetX: schemaNumberField(json, 'offsetX', path),
      offsetY: schemaNumberField(json, 'offsetY', path, fallback: 1),
    );
  }

  /// ARGB shadow colour.
  final int color;

  /// Base alpha in 0..1.
  final double opacity;

  /// Blur radius in px.
  final double blur;

  /// Spread radius in px.
  final double spread;

  /// Horizontal offset in px.
  final double offsetX;

  /// Vertical offset in px.
  final double offsetY;

  /// The `shadowAtoms` object, key order as in the registry files.
  Map<String, Object?> toJson() => <String, Object?>{
    'color': formatDocsHexColor(color),
    'opacity': jsonNumber(opacity),
    'blur': jsonNumber(blur),
    'spread': jsonNumber(spread),
    'offsetX': jsonNumber(offsetX),
    'offsetY': jsonNumber(offsetY),
  };

  /// A copy with the given fields replaced.
  DocsShadowAtoms copyWith({
    double? opacity,
    double? blur,
    double? spread,
    double? offsetX,
    double? offsetY,
    int? color,
  }) {
    return DocsShadowAtoms(
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
      spread: spread ?? this.spread,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocsShadowAtoms &&
          other.color == color &&
          other.opacity == opacity &&
          other.blur == blur &&
          other.spread == spread &&
          other.offsetX == offsetX &&
          other.offsetY == offsetY;

  @override
  int get hashCode =>
      Object.hash(color, opacity, blur, spread, offsetX, offsetY);
}

/// [value] as JSON: an integral double becomes an `int` so a re-encoded
/// document is byte-identical to the checked-in registry files (they write
/// `0`, `3`, `-1`, never `0.0`, `3.0`, `-1.0`).
Object jsonNumber(double value) =>
    value.isFinite && value == value.roundToDouble() && value.abs() < 1e15
    ? value.toInt()
    : value;

/// Reads an optional string field; null when absent.
String? schemaStringField(Map<String, Object?> json, String key, String path) {
  final Object? value = json[key];
  if (value == null) {
    return null;
  }
  if (value is! String) {
    throw ThemeDocumentException('$path.$key must be a string');
  }
  return value;
}

/// Reads an optional number field as a double; [fallback] when absent.
double schemaNumberField(
  Map<String, Object?> json,
  String key,
  String path, {
  double fallback = 0,
}) {
  final Object? value = json[key];
  if (value == null) {
    return fallback;
  }
  if (value is! num) {
    throw ThemeDocumentException('$path.$key must be a number');
  }
  return value.toDouble();
}
