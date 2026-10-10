// The docs site's shell state: the live theme plus the mode.
//
// Brightness defaults to **system** (the reference uses `next-themes` with
// the system default): [brightness] is the explicit choice when one was
// persisted, otherwise [systemBrightness]. Toggling stores an explicit mode
// and stops following the system until the storage is cleared.
//
// Every token of the theme lives in the [SiteThemeModel] (D7): the rail edits
// it, [theme] resolves it for the whole shell — home, docs, component pages,
// palette — and it persists as one canonical preset JSON. Keeping a second set
// of scalar overrides here (as the pre-D7 radius/density sliders had) would
// give the model two sources of truth and make the exported `app_theme.dart`
// drift from what the site renders.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/theme/theme.dart';
import 'docs_storage.dart';
import 'site_theme_model.dart';

export 'docs_storage.dart'
    show DocsStorage, kDocsBrightnessKey, kDocsPresetKey, kDocsThemeDocumentKey;
export 'site_theme_model.dart'
    show SiteThemeModel, kDefaultResetPresetId, kDocsFontOptions;

/// Preset id selected on a first visit: the official shadcn neutral base
/// (`themes/neutral.json`), matching the reference site's palette.
const String kDefaultDocsPresetId = kDefaultResetPresetId;

/// The docs site's theme state: the theme document and the mode.
class DocsState extends ChangeNotifier {
  /// Creates the state; call [restore] once to load persisted preferences.
  DocsState({
    required DocsStorage storage,
    String presetId = kDefaultDocsPresetId,
    Brightness? brightness,
    Brightness systemBrightness = Brightness.light,
  }) : themeModel = SiteThemeModel(storage: storage, presetId: presetId),
       _explicitBrightness = brightness,
       _platformBrightness = systemBrightness {
    // One notification chain: every Theme Studio edit reaches the shell
    // (the router delegate, the web bridge and the header toggle all listen
    // to `DocsState`), so the document changes have to travel through it.
    themeModel.addListener(notifyListeners);
  }

  /// The site-wide theme model (preset, colours, radius, spacing, fonts,
  /// shadows). Every Theme Studio edit lands here.
  final SiteThemeModel themeModel;

  /// Where the shell preferences live (the model's own storage).
  DocsStorage get storage => themeModel.storage;

  Brightness? _explicitBrightness;
  Brightness _platformBrightness;

  /// The document's id — a registry preset id, or `shuffled` / a pasted id.
  String get presetId => themeModel.presetId;

  /// The effective mode: the explicit choice or the system brightness.
  Brightness get brightness => _explicitBrightness ?? _platformBrightness;

  /// Whether the mode still follows the platform (no explicit choice stored).
  bool get followsSystem => _explicitBrightness == null;

  /// The last observed platform brightness.
  Brightness get systemBrightness => _platformBrightness;

  /// The radius in px (0–16) of the live document.
  double get effectiveRadiusPx => themeModel.radiusPx;

  /// The fully-resolved theme for the current state.
  ShadcnThemeData get theme => themeModel.themeFor(brightness);

  /// Loads persisted preferences; safe to call once before `runApp`.
  ///
  /// A stored `light`/`dark` value becomes the explicit mode; `system` (or no
  /// value) keeps following the platform brightness. A stored document that no
  /// longer validates is dropped by [SiteThemeModel.restore] and the site
  /// falls back to the default preset.
  void restore() {
    bool changed = false;
    themeModel.restore();
    final String? brightness = storage.read(kDocsBrightnessKey);
    if (brightness != null) {
      final Brightness? parsed = switch (brightness) {
        'light' => Brightness.light,
        'dark' => Brightness.dark,
        _ => null,
      };
      if (parsed != _explicitBrightness) {
        _explicitBrightness = parsed;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Switches the active preset (replaces the whole document).
  void setPreset(String presetId) => themeModel.selectPreset(presetId);

  /// Sets the explicit brightness and stops following the platform.
  void setBrightness(Brightness brightness) {
    if (brightness == _explicitBrightness) {
      return;
    }
    _explicitBrightness = brightness;
    storage.write(kDocsBrightnessKey, brightness.name);
    notifyListeners();
  }

  /// Records the platform brightness while no explicit mode is stored.
  void setSystemBrightness(Brightness brightness) {
    if (brightness == _platformBrightness) {
      return;
    }
    _platformBrightness = brightness;
    if (_explicitBrightness == null) {
      notifyListeners();
    }
  }

  /// Flips between light and dark (stores the explicit mode).
  void toggleBrightness() {
    setBrightness(
      brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );
  }

  // ---------------------------------------------------------------------------
  // Component preview state (P6-F4): one named example at a time.
  // ---------------------------------------------------------------------------

  /// Selected example name per component id (the `Select` above the stage).
  ///
  /// Null means "the default" (the first entry of `kComponentPreviews`).
  /// Stored here (not in the page) so the choice survives navigation between
  /// components; the page falls back to the first entry for unknown names.
  final Map<String, String> _previewExamples = <String, String>{};

  /// Components whose stage shows the opposite brightness of the site
  /// (the per-preview light/dark toggle). The stage keeps the same preset
  /// document and only flips the brightness leg.
  final Set<String> _previewInverted = <String>{};

  /// The selected example name for [componentId], or null for the default.
  String? previewExampleFor(String componentId) =>
      _previewExamples[componentId];

  /// Selects the [name] example for [componentId].
  void setPreviewExample(String componentId, String name) {
    if (_previewExamples[componentId] == name) {
      return;
    }
    _previewExamples[componentId] = name;
    notifyListeners();
  }

  /// Whether the [componentId] stage is inverted to the opposite brightness.
  bool isPreviewInverted(String componentId) =>
      _previewInverted.contains(componentId);

  /// Sets the inverted flag for [componentId].
  void setPreviewInverted(String componentId, bool inverted) {
    final bool current = _previewInverted.contains(componentId);
    if (current == inverted) {
      return;
    }
    if (inverted) {
      _previewInverted.add(componentId);
    } else {
      _previewInverted.remove(componentId);
    }
    notifyListeners();
  }

  /// Flips the stage brightness override for [componentId].
  void togglePreviewInverted(String componentId) {
    setPreviewInverted(componentId, !isPreviewInverted(componentId));
  }

  @override
  void dispose() {
    themeModel.removeListener(notifyListeners);
    themeModel.dispose();
    super.dispose();
  }
}
