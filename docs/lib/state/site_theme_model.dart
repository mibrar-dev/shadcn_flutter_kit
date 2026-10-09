// The site-wide theme model (D7, spec §2.7 requirement 2).
//
// One `ChangeNotifier` over the whole `ThemeDocument`: every row of the
// customizer edits it, `DocsState.theme` resolves it for the shell, it is
// persisted as one canonical preset JSON, and `Get Code` / `Open Preset` read
// and write it. Because the applied theme and the exported file are the same
// document, what the user previews is exactly what they download.

import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';

import '../generated/docs_preset_sources.dart';
import '../theme/theme_dart_source.dart';
import '../theme/theme_document.dart';
import '../theme/theme_document_edits.dart';
import '../theme/theme_palette.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_storage.dart';

/// Font family lists offered by the picker, collected from the generated
/// preset sources (never a hand-typed list) and sorted for a stable order.
final List<String> kDocsFontOptions = List<String>.unmodifiable(
  _collectFontOptions()..sort(),
);

List<String> _collectFontOptions() {
  final Set<String> specs = <String>{};
  for (final DocsPresetSource source in kPresetSources.values) {
    final Object? fonts =
        (jsonDecode(source.json) as Map<String, Object?>)['fonts'];
    if (fonts is Map) {
      specs.addAll(fonts.values.whereType<String>());
    }
  }
  return specs.toList();
}

/// The token a `Shuffle` picks from, as the reference's "Theme" row does.
const String kShuffledPresetId = 'shuffled';

/// Owns the live theme document behind [DocsState].
class SiteThemeModel extends ChangeNotifier {
  /// Creates the model; call [restore] once to load a persisted document.
  SiteThemeModel({
    required this._storage,
    String presetId = kDefaultResetPresetId,
  }) : _document = ThemeDocument.fromPreset(presetId);

  final DocsStorage _storage;
  ThemeDocument _document;

  /// The preference store the document is persisted to.
  DocsStorage get storage => _storage;

  /// The live document.
  ThemeDocument get document => _document;

  /// The document's id — a registry preset id, or `shuffled`/`custom`.
  String get presetId => _document.id;

  /// The preset id when the document is exactly a registry preset, else null.
  String? get matchedPresetId {
    for (final String id in kPresetSources.keys) {
      if (kPresetSources[id]!.json == _document.json) {
        return id;
      }
    }
    return null;
  }

  /// The radius in px (the rail's slider unit).
  double get radiusPx => _document.radiusPx;

  /// The base spacing unit in px (`spacing * 16`, what components lay out with).
  double get spacingPx => _document.spacing * 16;

  /// The canonical preset JSON (what `Get Code` → JSON and `Open Preset` use).
  String get json => _document.json;

  /// The exact `app_theme.dart` for the document.
  String get dartSource => themeDartSource(_document);

  /// The resolved theme for [brightness].
  ShadcnThemeData themeFor(Brightness brightness) =>
      _document.theme(brightness);

  /// Replaces the document with the registry preset [presetId].
  void selectPreset(String presetId) =>
      _assign(ThemeDocument.fromPreset(presetId));

  /// Sets one colour [token] in both mode blocks.
  void setColor(String token, String hex) =>
      _assign(_document.withColor(token, hex));

  /// Rewrites the neutral family around [seed] (the `Base colour` row).
  void setBaseColor(Color seed) => _assign(applyBaseColor(_document, seed));

  /// Rewrites the accent family around [seed] (the `Theme colour` row).
  void setAccentColor(Color seed) => _assign(applyAccentColor(_document, seed));

  /// Rewrites `chart1`…`chart5` around [seed] (the `Chart colours` row).
  void setChartColors(Color seed) => _assign(applyChartColors(_document, seed));

  /// Sets the radius in px (0–16), the value the rail slider drives.
  void setRadiusPx(double px) => _assign(_document.withRadiusPx(px));

  /// Sets the base spacing unit in rem.
  void setSpacingRem(double rem) => _assign(_document.withSpacingRem(rem));

  /// Sets the family list of [slot] (`sans`, `serif`, `mono`).
  void setFont(String slot, String? spec) =>
      _assign(_document.withFont(slot, spec));

  /// Sets the base shadow atoms of one mode.
  void setShadow(Brightness brightness, DocsShadowAtoms atoms) =>
      _assign(_document.withShadow(brightness, atoms));

  /// Applies a pasted preset document.
  ///
  /// Throws [ThemeDocumentException] with a field-qualified message; the
  /// `Open Preset` dialog shows it verbatim and leaves the theme untouched.
  void applyPresetJson(String source) {
    final Object? decoded = jsonDecode(source);
    if (decoded is! Map) {
      throw const ThemeDocumentException('A preset must be a JSON object');
    }
    _assign(
      ThemeDocument.fromJson(<String, Object?>{
        for (final MapEntry<Object?, Object?> entry in decoded.entries)
          entry.key.toString(): entry.value,
      }),
    );
  }

  /// Picks a random but always valid combination (the `Shuffle` action).
  ///
  /// The id becomes `shuffled` so a random combination is never mistaken for a
  /// registry preset, and the name says what it is in `Get Code`.
  void shuffle({Random? random}) {
    final Random rng = random ?? Random();
    ThemeDocument next = ThemeDocument.fromPreset(
      kPresetSources.keys.elementAt(rng.nextInt(kPresetSources.length)),
    ).renamed(kShuffledPresetId, 'Shuffled');
    final Color base = _randomColor(rng);
    final Color accent = _randomColor(rng);
    next = applyBaseColor(next, base);
    next = applyAccentColor(next, accent);
    next = applyChartColors(next, accent);
    next = next
        .withRadiusPx(rng.nextInt(17).toDouble())
        .withSpacingRem(0.2 + rng.nextInt(8) / 100);
    _assign(next);
  }

  /// Back to the registry default (`neutral`).
  void reset() => selectPreset(kDefaultResetPresetId);

  /// Loads the persisted document; a broken entry falls back to the default.
  void restore() {
    final String? stored = _storage.read(kDocsThemeDocumentKey);
    if (stored == null || stored.isEmpty) {
      return;
    }
    try {
      _assign(
        ThemeDocument.fromJson(jsonDecode(stored) as Map<String, Object?>),
      );
    } on Object {
      // A stale document from an older build must never break boot.
      _storage.write(kDocsThemeDocumentKey, '');
    }
  }

  void _assign(ThemeDocument next) {
    if (next.json == _document.json) {
      return;
    }
    _document = next;
    _storage.write(kDocsThemeDocumentKey, next.json);
    notifyListeners();
  }
}

/// The preset `Reset` returns to: the shadcn neutral base.
const String kDefaultResetPresetId = 'neutral';

Color _randomColor(Random rng) => HSLColor.fromAHSL(
  1,
  rng.nextInt(360).toDouble(),
  0.3 + rng.nextInt(60) / 100,
  0.35 + rng.nextInt(40) / 100,
).toColor();
