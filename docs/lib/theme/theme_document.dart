// The site-wide theme model (D7, spec §2.7): a schema-v2 preset document as
// an immutable value object.
//
// The Theme Studio edits every `ShadcnThemeData` token, and each edit has to
// round-trip three ways: apply live to the whole site, persist to
// localStorage, and export as the exact `app_theme.dart` / preset JSON that
// `flutter_shadcn theme apply` consumes. The only representation that does all
// three is the preset document itself, so this class *is* the model: it parses
// and validates against `themes.schema.json`, edits token-wise (see
// `theme_document_edits.dart`), serialises back to the canonical key order,
// and resolves a real `ShadcnThemeData`.
//
// The schema primitives (token keys, hex codec, shadow atoms) live in
// `theme_document_schema.dart`.

import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../generated/docs_preset_sources.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/density.dart';
import '../ui/shadcn/theme/theme.dart';
import '../ui/shadcn/theme/tokens.dart';
import '../ui/shadcn/theme/typography.dart';
import 'theme_document_schema.dart';

export 'theme_document_schema.dart'
    show
        DocsShadowAtoms,
        ThemeDocumentException,
        docsColorOf,
        formatDocsHexColor,
        jsonNumber,
        kDocsChartTokenKeys,
        kDocsColorTokenKeys,
        kDocsFontSlots,
        kDocsHexColorPattern,
        kDocsTrackingSteps,
        parseDocsHexColor;

/// One validated preset document: the Theme Studio's source of truth.
@immutable
class ThemeDocument {
  /// Creates a document from already-validated parts.
  const ThemeDocument({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.radius,
    required this.spacing,
    required this.tracking,
    required this.lightShadow,
    required this.darkShadow,
    required this.fonts,
    this.schema,
    this.shadowsDerived,
  });

  /// Reads and validates a decoded preset document.
  ///
  /// Throws [ThemeDocumentException] with a field-qualified message; the
  /// registry's `themes.schema.json` is the contract (all 32 colour tokens
  /// required in both modes, `schemaVersion` 2, six shadow atoms per mode).
  factory ThemeDocument.fromJson(Map<String, Object?> json) {
    final String id = _stringField(json, 'id', 'preset') ?? '';
    if (id.isEmpty || !RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(id)) {
      throw const ThemeDocumentException(
        'preset.id must be a lower-case kebab-case string',
      );
    }
    final Object? version = json['schemaVersion'];
    if (version is! num || version.toInt() != 2) {
      throw const ThemeDocumentException('preset.schemaVersion must be 2');
    }
    final double radius = _numberField(json, 'radius', 'preset') ?? 0;
    if (radius < 0) {
      throw const ThemeDocumentException('preset.radius must be >= 0');
    }
    final double spacing = _numberField(json, 'spacing', 'preset') ?? 0;
    final Map<String, double> tracking = _trackingField(json);
    final Map<String, String> fonts = _fontsField(json);
    final Map<String, Object?> shadow = _objectField(json, 'shadow', 'preset');
    return ThemeDocument(
      schema: _stringField(json, r'$schema', 'preset'),
      id: id,
      name: _stringField(json, 'name', 'preset') ?? id,
      light: _colorField(json, 'light'),
      dark: _colorField(json, 'dark'),
      radius: radius,
      spacing: spacing,
      tracking: tracking,
      lightShadow: DocsShadowAtoms.fromJson(
        _objectField(shadow, 'light', 'preset.shadow'),
        path: 'preset.shadow.light',
      ),
      darkShadow: DocsShadowAtoms.fromJson(
        _objectField(shadow, 'dark', 'preset.shadow'),
        path: 'preset.shadow.dark',
      ),
      fonts: fonts,
      shadowsDerived: _stringField(json, 'shadowsDerived', 'preset'),
    );
  }

  /// Reads a registry preset from the generated preset sources.
  factory ThemeDocument.fromPreset(String presetId) {
    final DocsPresetSource? source = kPresetSources[presetId];
    if (source == null) {
      throw ThemeDocumentException('Unknown preset: $presetId');
    }
    return ThemeDocument.fromJson(
      jsonDecode(source.json) as Map<String, Object?>,
    );
  }

  /// The optional `$schema` pointer, carried through untouched.
  final String? schema;

  /// Preset id (`neutral`, or the pasted document's own id).
  final String id;

  /// Human readable name.
  final String name;

  /// Light-mode colour tokens, keyed by token name.
  final Map<String, String> light;

  /// Dark-mode colour tokens, keyed by token name.
  final Map<String, String> dark;

  /// Unitless radius factor (the schema's `radius` rem number).
  final double radius;

  /// Base spacing unit in rem (the schema's `spacing`).
  final double spacing;

  /// Letter-spacing steps in em; `normal` is always present.
  final Map<String, double> tracking;

  /// Light-mode base shadow atoms.
  final DocsShadowAtoms lightShadow;

  /// Dark-mode base shadow atoms.
  final DocsShadowAtoms darkShadow;

  /// Family lists per slot; an absent slot means "preset names no family".
  final Map<String, String> fonts;

  /// The optional `shadowsDerived` marker, carried through untouched.
  final String? shadowsDerived;

  /// Whether the document names at least one family.
  bool get hasFonts => fonts.isNotEmpty;

  /// The radius in px (the registry's `radius * 16`).
  double get radiusPx => radius * 16;

  /// The colour value for [token] in [brightness].
  String colorOf(String token, Brightness brightness) =>
      (brightness == Brightness.dark ? dark : light)[token]!;

  /// The base shadow atoms for [brightness].
  DocsShadowAtoms shadowOf(Brightness brightness) =>
      brightness == Brightness.dark ? darkShadow : lightShadow;

  /// The family list for [slot], or null when the document names none.
  String? fontOf(String slot) => fonts[slot];

  /// The canonical preset JSON (2-space indent, registry key order).
  Map<String, Object?> toJson() => <String, Object?>{
    if (schema != null) r'$schema': schema,
    'id': id,
    'name': name,
    'schemaVersion': 2,
    'light': light,
    'dark': dark,
    if (hasFonts) 'fonts': fonts,
    'radius': jsonNumber(radius),
    'spacing': jsonNumber(spacing),
    'tracking': <String, Object?>{
      for (final String step in tracking.keys)
        step: jsonNumber(tracking[step]!),
    },
    'shadow': <String, Object?>{
      'light': lightShadow.toJson(),
      'dark': darkShadow.toJson(),
    },
    if (shadowsDerived != null) 'shadowsDerived': shadowsDerived,
  };

  /// The canonical preset JSON text (2-space indent).
  String get json => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Resolves the live `ShadcnThemeData` for [brightness].
  ///
  /// Mirrors the generated `build<Id>Theme` factories exactly (radius
  /// unitless, spacing/tracking ×16, `ShadowScale.derive`) and additionally
  /// wires the document's families into the type scale with
  /// `Typography.applyFonts` — see the registry gap in the D7 report: no
  /// registry widget calls `applyFonts`, so a preset's fonts would otherwise
  /// never reach the rendered text.
  ///
  ///
  /// It also bridges the two registry gaps this page would otherwise expose
  /// (both reported in the D7 notes): `Typography.applyFonts` is never called
  /// by a registry widget, and no widget reads `tokens.spacingBase` — they
  /// read `theme.spacing`/`theme.density`. Without these two lines the font
  /// and spacing rows would export values the site never renders.
  ShadcnThemeData theme(Brightness brightness) {
    final ShadcnFonts families = ShadcnFonts(
      fontSans: fonts['sans'],
      fontSerif: fonts['serif'],
      fontMono: fonts['mono'],
    );
    final SpacingScale scale = SpacingScale(spacing * 16);
    return ShadcnThemeData(
      colors: colorsFor(brightness),
      tokens: tokensFor(brightness),
      fonts: families,
      typography: const Typography.geist().applyFonts(families),
      spacing: scale,
      density: Density.fromSpacingScale(scale),
    );
  }

  /// The colour tokens for [brightness] as a `ShadcnColors`.
  ShadcnColors colorsFor(Brightness brightness) {
    final Map<String, String> map = brightness == Brightness.dark
        ? dark
        : light;
    return ShadcnColors(
      brightness: brightness,
      background: docsColorOf(map['background']!),
      foreground: docsColorOf(map['foreground']!),
      card: docsColorOf(map['card']!),
      cardForeground: docsColorOf(map['cardForeground']!),
      popover: docsColorOf(map['popover']!),
      popoverForeground: docsColorOf(map['popoverForeground']!),
      primary: docsColorOf(map['primary']!),
      primaryForeground: docsColorOf(map['primaryForeground']!),
      secondary: docsColorOf(map['secondary']!),
      secondaryForeground: docsColorOf(map['secondaryForeground']!),
      muted: docsColorOf(map['muted']!),
      mutedForeground: docsColorOf(map['mutedForeground']!),
      accent: docsColorOf(map['accent']!),
      accentForeground: docsColorOf(map['accentForeground']!),
      destructive: docsColorOf(map['destructive']!),
      destructiveForeground: docsColorOf(map['destructiveForeground']!),
      border: docsColorOf(map['border']!),
      input: docsColorOf(map['input']!),
      ring: docsColorOf(map['ring']!),
      chart1: docsColorOf(map['chart1']!),
      chart2: docsColorOf(map['chart2']!),
      chart3: docsColorOf(map['chart3']!),
      chart4: docsColorOf(map['chart4']!),
      chart5: docsColorOf(map['chart5']!),
      sidebar: docsColorOf(map['sidebar']!),
      sidebarForeground: docsColorOf(map['sidebarForeground']!),
      sidebarPrimary: docsColorOf(map['sidebarPrimary']!),
      sidebarPrimaryForeground: docsColorOf(map['sidebarPrimaryForeground']!),
      sidebarAccent: docsColorOf(map['sidebarAccent']!),
      sidebarAccentForeground: docsColorOf(map['sidebarAccentForeground']!),
      sidebarBorder: docsColorOf(map['sidebarBorder']!),
      sidebarRing: docsColorOf(map['sidebarRing']!),
    );
  }

  /// The non-colour tokens for [brightness] as a `ShadcnTokens`.
  ///
  /// Spacing and tracking multiply by 16 exactly like the kit generator: the
  /// schema stores rem/em with the unit stripped, Flutter wants px.
  ShadcnTokens tokensFor(Brightness brightness) {
    final DocsShadowAtoms atoms = shadowOf(brightness);
    return ShadcnTokens(
      radius: radius,
      spacingBase: spacing * 16,
      trackingNormal: (tracking['normal'] ?? 0) * 16,
      trackingTight: tracking['tight'] == null ? null : tracking['tight']! * 16,
      trackingWide: tracking['wide'] == null ? null : tracking['wide']! * 16,
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
}

// ---------------------------------------------------------------------------
// Validation helpers
// ---------------------------------------------------------------------------

Map<String, Object?> _stringKeyed(Object? value, String path) {
  if (value is! Map) {
    throw ThemeDocumentException('$path is not an object: $value');
  }
  return <String, Object?>{
    for (final MapEntry<Object?, Object?> entry in value.entries)
      entry.key.toString(): entry.value,
  };
}

Map<String, Object?> _objectField(
  Map<String, Object?> json,
  String key,
  String path,
) {
  final Object? value = json[key];
  if (value == null) {
    throw ThemeDocumentException('$path.$key is required');
  }
  return _stringKeyed(value, '$path.$key');
}

String? _stringField(Map<String, Object?> json, String key, String path) {
  final Object? value = json[key];
  if (value == null) {
    return null;
  }
  if (value is! String) {
    throw ThemeDocumentException('$path.$key must be a string');
  }
  return value;
}

double? _numberField(
  Map<String, Object?> json,
  String key,
  String path, {
  double? fallback,
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

/// The 32 colour tokens of one mode, all required and all `#RRGGBB[AA]`.
Map<String, String> _colorField(Map<String, Object?> json, String key) {
  final Map<String, Object?> map = _objectField(json, key, 'preset');
  final Map<String, String> colors = <String, String>{};
  for (final String token in kDocsColorTokenKeys) {
    final Object? value = map[token];
    if (value == null) {
      throw ThemeDocumentException('preset.$key.$token is required');
    }
    if (value is! String || !kDocsHexColorPattern.hasMatch(value)) {
      throw ThemeDocumentException(
        'preset.$key.$token must be a #RRGGBB[AA] colour, got $value',
      );
    }
    colors[token] = value.toUpperCase();
  }
  final List<String> extra = map.keys
      .where((String token) => !kDocsColorTokenKeys.contains(token))
      .toList();
  if (extra.isNotEmpty) {
    throw ThemeDocumentException(
      'preset.$key has unknown tokens: ${extra.join(', ')}',
    );
  }
  return <String, String>{
    for (final String token in kDocsColorTokenKeys) token: colors[token]!,
  };
}

Map<String, double> _trackingField(Map<String, Object?> json) {
  final Map<String, Object?> map = _objectField(json, 'tracking', 'preset');
  final Map<String, double> tracking = <String, double>{};
  for (final String step in kDocsTrackingSteps) {
    final Object? value = map[step];
    if (value == null) {
      continue;
    }
    if (value is! num) {
      throw ThemeDocumentException('preset.tracking.$step must be a number');
    }
    tracking[step] = value.toDouble();
  }
  if (!tracking.containsKey('normal')) {
    throw const ThemeDocumentException('preset.tracking.normal is required');
  }
  return tracking;
}

Map<String, String> _fontsField(Map<String, Object?> json) {
  final Object? value = json['fonts'];
  if (value == null) {
    return const <String, String>{};
  }
  final Map<String, Object?> map = _stringKeyed(value, 'preset.fonts');
  final Map<String, String> fonts = <String, String>{};
  for (final String slot in kDocsFontSlots) {
    final Object? spec = map[slot];
    if (spec == null) {
      continue;
    }
    if (spec is! String || spec.isEmpty) {
      throw ThemeDocumentException(
        'preset.fonts.$slot must be a non-empty string',
      );
    }
    fonts[slot] = spec;
  }
  return fonts;
}
