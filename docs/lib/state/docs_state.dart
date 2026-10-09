import 'package:flutter/foundation.dart';

import '../ui/shadcn/theme/density.dart';
import '../ui/shadcn/theme/theme.dart';
import '../web_bridge.dart';

/// Builds the base [ShadcnThemeData] for one preset id + brightness.
///
/// D2's generated `app_theme.dart` provides the real resolver (all presets);
/// until then `generated/stub_docs_data.dart` supplies a stub. Keeping the
/// resolver injectable means the state never embeds preset values itself.
typedef DocsThemeResolver =
    ShadcnThemeData Function(String presetId, Brightness brightness);

/// Where theme preferences are persisted. `window.localStorage` on web, no-op
/// elsewhere (and in tests, inject a memory-backed instance).
class DocsStorage {
  /// Creates the default, platform-selecting storage.
  const DocsStorage();

  /// Reads [key], or null.
  String? read(String key) => webLocalStorageRead(key);

  /// Writes [key] = [value].
  void write(String key, String value) => webLocalStorageWrite(key, value);
}

/// Preset id selected on a first visit (the design's default, not the CLI's).
const String kDefaultDocsPresetId = 'modern-minimal';

/// localStorage keys for the theme preferences.
const String kDocsPresetKey = 'docs.theme.presetId';
const String kDocsBrightnessKey = 'docs.theme.brightness';
const String kDocsRadiusKey = 'docs.theme.radiusPx';
const String kDocsDensityKey = 'docs.theme.densityScale';

/// The docs site's theme state: preset, mode, radius override and density.
///
/// One [ChangeNotifier] for the whole shell (plan §1.3). The derived
/// [theme] applies the radius/density overrides on top of the resolved preset
/// so a preset switch only ever tweens colours, never layout.
class DocsState extends ChangeNotifier {
  /// Creates the state; call [restore] once to load persisted preferences.
  DocsState({
    required DocsThemeResolver resolveTheme,
    DocsStorage storage = const DocsStorage(),
    String presetId = kDefaultDocsPresetId,
    Brightness brightness = Brightness.dark,
    double? radiusPx,
    double densityScale = 1,
  }) : _resolveTheme = resolveTheme,
       _storage = storage,
       _presetId = presetId,
       _brightness = brightness,
       _radiusPx = radiusPx,
       _densityScale = densityScale;

  final DocsThemeResolver _resolveTheme;
  final DocsStorage _storage;

  String _presetId;
  Brightness _brightness;
  double? _radiusPx;
  double _densityScale;

  /// Current preset id.
  String get presetId => _presetId;

  /// Current mode.
  Brightness get brightness => _brightness;

  /// Radius override in px (0–16), or null for the preset's own radius.
  double? get radiusPx => _radiusPx;

  /// Density multiplier (0.85–1.15).
  double get densityScale => _densityScale;

  /// The preset's radius in px, ignoring the override.
  double get presetRadiusPx =>
      _resolveTheme(_presetId, _brightness).tokens.radius * 16;

  /// The effective radius in px (override or preset).
  double get effectiveRadiusPx => _radiusPx ?? presetRadiusPx;

  /// The fully-resolved theme for the current state.
  ShadcnThemeData get theme {
    ShadcnThemeData data = _resolveTheme(_presetId, _brightness);
    final double? radius = _radiusPx;
    if (radius != null) {
      data = data.copyWith(
        tokens: () => data.tokens.copyWith(radius: radius / 16),
      );
    }
    if (_densityScale != 1) {
      final Density density = data.density;
      data = data.copyWith(
        density: () => density.copyWith(
          baseContainerPadding: density.baseContainerPadding * _densityScale,
          baseGap: density.baseGap * _densityScale,
          baseContentPadding: density.baseContentPadding * _densityScale,
        ),
      );
    }
    return data;
  }

  /// Loads persisted preferences; safe to call once before `runApp`.
  void restore() {
    final String? preset = _storage.read(kDocsPresetKey);
    final String? brightness = _storage.read(kDocsBrightnessKey);
    final double? radius = double.tryParse(_storage.read(kDocsRadiusKey) ?? '');
    final double? density = double.tryParse(
      _storage.read(kDocsDensityKey) ?? '',
    );
    bool changed = false;
    if (preset != null && preset.isNotEmpty && preset != _presetId) {
      _presetId = preset;
      changed = true;
    }
    if (brightness != null && brightness != _brightness.name) {
      _brightness = brightness == Brightness.light.name
          ? Brightness.light
          : Brightness.dark;
      changed = true;
    }
    if (radius != null && radius != _radiusPx) {
      _radiusPx = radius.clamp(0, 16).toDouble();
      changed = true;
    }
    if (density != null && density != _densityScale) {
      _densityScale = density.clamp(0.85, 1.15).toDouble();
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Switches the active preset.
  void setPreset(String presetId) {
    if (presetId == _presetId) {
      return;
    }
    _presetId = presetId;
    _storage.write(kDocsPresetKey, presetId);
    notifyListeners();
  }

  /// Sets the explicit brightness.
  void setBrightness(Brightness brightness) {
    if (brightness == _brightness) {
      return;
    }
    _brightness = brightness;
    _storage.write(kDocsBrightnessKey, brightness.name);
    notifyListeners();
  }

  /// Flips between light and dark.
  void toggleBrightness() {
    setBrightness(
      _brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );
  }

  /// Sets the radius override in px; null restores the preset radius.
  void setRadiusPx(double? px) {
    final double? next = px?.clamp(0, 16).toDouble();
    if (next == _radiusPx) {
      return;
    }
    _radiusPx = next;
    if (next == null) {
      _storage.write(kDocsRadiusKey, '');
    } else {
      _storage.write(kDocsRadiusKey, next.toString());
    }
    notifyListeners();
  }

  /// Sets the density multiplier (0.85–1.15).
  void setDensityScale(double scale) {
    final double next = scale.clamp(0.85, 1.15).toDouble();
    if (next == _densityScale) {
      return;
    }
    _densityScale = next;
    _storage.write(kDocsDensityKey, next.toString());
    notifyListeners();
  }
}
