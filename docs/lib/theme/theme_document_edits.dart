// Immutable token edits for [ThemeDocument] (D7).
//
// Split out of `theme_document.dart` purely for the ~400-line rule: an
// extension resolves across libraries, so callers import both files. Every
// method returns a new document, which is what lets the Theme Studio drive
// one `AnimatedShadcnTheme` tween per edit while the document itself stays
// the single source of truth for the live site, localStorage and the export.

import 'package:flutter/widgets.dart';

import 'theme_document.dart';

export 'theme_document.dart' show ThemeDocumentException;

// ---------------------------------------------------------------------------
// Token edits
// ---------------------------------------------------------------------------

/// Immutable token edits. Every method returns a new document, so the Theme
/// Studio can drive one tween per change and the site stays a single source.
extension ThemeDocumentEdits on ThemeDocument {
  /// Renames the document (used by `Shuffle`, so a random combination is not
  /// claimed by a registry id).
  ThemeDocument renamed(String id, String name) => ThemeDocument(
    schema: schema,
    id: id,
    name: name,
    light: light,
    dark: dark,
    radius: radius,
    spacing: spacing,
    tracking: tracking,
    lightShadow: lightShadow,
    darkShadow: darkShadow,
    fonts: fonts,
    shadowsDerived: shadowsDerived,
  );

  /// Sets one colour [token] in both mode blocks.
  ThemeDocument withColor(String token, String hex) =>
      withLightColor(token, hex).withDarkColor(token, hex);

  /// Sets one colour [token] in the light mode block.
  ThemeDocument withLightColor(String token, String hex) {
    _checkToken(token);
    return ThemeDocument(
      schema: schema,
      id: id,
      name: name,
      light: <String, String>{...light, token: _checkColor(hex)},
      dark: dark,
      radius: radius,
      spacing: spacing,
      tracking: tracking,
      lightShadow: lightShadow,
      darkShadow: darkShadow,
      fonts: fonts,
      shadowsDerived: shadowsDerived,
    );
  }

  /// Sets one colour [token] in the dark mode block.
  ThemeDocument withDarkColor(String token, String hex) {
    _checkToken(token);
    return ThemeDocument(
      schema: schema,
      id: id,
      name: name,
      light: light,
      dark: <String, String>{...dark, token: _checkColor(hex)},
      radius: radius,
      spacing: spacing,
      tracking: tracking,
      lightShadow: lightShadow,
      darkShadow: darkShadow,
      fonts: fonts,
      shadowsDerived: shadowsDerived,
    );
  }

  /// Sets [token] in one [brightness] block.
  ThemeDocument withModeColor(
    String token,
    String hex,
    Brightness brightness,
  ) => brightness == Brightness.dark
      ? withDarkColor(token, hex)
      : withLightColor(token, hex);

  /// Sets a light token and a dark token in one edit (ramp families).
  ThemeDocument withPair(
    String lightToken,
    String lightHex,
    String darkToken,
    String darkHex,
  ) => withLightColor(lightToken, lightHex).withDarkColor(darkToken, darkHex);

  /// Sets the radius from [px] logical pixels.
  ThemeDocument withRadiusPx(double px) => _copy(radius: px / 16);

  /// Sets the base spacing unit in [rem].
  ThemeDocument withSpacingRem(double rem) => _copy(spacing: rem);

  /// Sets the family list of [slot]; a null or empty [spec] removes it.
  ThemeDocument withFont(String slot, String? spec) {
    final Map<String, String> next = <String, String>{...fonts};
    if (spec == null || spec.isEmpty) {
      next.remove(slot);
    } else {
      next[slot] = spec;
    }
    return _copy(
      fonts: <String, String>{
        for (final String s in kDocsFontSlots)
          if (next.containsKey(s)) s: next[s]!,
      },
    );
  }

  /// Sets one tracking [step] in em.
  ThemeDocument withTracking(String step, double em) =>
      _copy(tracking: <String, double>{...tracking, step: em});

  /// Sets the base shadow atoms of one mode.
  ThemeDocument withShadow(Brightness brightness, DocsShadowAtoms atoms) =>
      brightness == Brightness.dark
      ? _copy(darkShadow: atoms)
      : _copy(lightShadow: atoms);

  ThemeDocument _copy({
    double? radius,
    double? spacing,
    Map<String, double>? tracking,
    Map<String, String>? fonts,
    DocsShadowAtoms? lightShadow,
    DocsShadowAtoms? darkShadow,
  }) => ThemeDocument(
    schema: schema,
    id: id,
    name: name,
    light: light,
    dark: dark,
    radius: radius ?? this.radius,
    spacing: spacing ?? this.spacing,
    tracking: tracking ?? this.tracking,
    lightShadow: lightShadow ?? this.lightShadow,
    darkShadow: darkShadow ?? this.darkShadow,
    fonts: fonts ?? this.fonts,
    shadowsDerived: shadowsDerived,
  );

  static void _checkToken(String token) {
    if (!kDocsColorTokenKeys.contains(token)) {
      throw ThemeDocumentException('Unknown colour token: $token');
    }
  }

  static String _checkColor(String hex) {
    if (!kDocsHexColorPattern.hasMatch(hex)) {
      throw ThemeDocumentException('Not a #RRGGBB[AA] colour: $hex');
    }
    return hex.toUpperCase();
  }
}
