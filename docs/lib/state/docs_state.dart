import 'package:flutter/foundation.dart';

import '../ui/shadcn/theme/density.dart';
import '../ui/shadcn/theme/theme.dart';
import '../web_bridge.dart';

/// Builds the base [ShadcnThemeData] for one preset id + brightness.
///
/// D2's generated `app_theme.dart` provides the real resolver (all 42
/// presets; `buildDocsTheme`). Keeping the resolver injectable means the
/// state never embeds preset values itself.
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

/// Preset id selected on a first visit: the official shadcn neutral base
/// (`themes/neutral.json`), matching the reference site's palette.
const String kDefaultDocsPresetId = 'neutral';

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
///
/// Brightness defaults to **system** (the reference uses `next-themes` with
/// the system default): [brightness] is the explicit choice when one was
/// persisted, otherwise [systemBrightness]. Toggling stores an explicit mode
/// and stops following the system until the storage is cleared.
class DocsState extends ChangeNotifier {
  /// Creates the state; call [restore] once to load persisted preferences.
  ///
  /// The arguments are assigned in the body (not the initializer list) so the
  /// public parameter names stay `resolveTheme`/`presetId`/… while the fields
  /// remain private — `prefer_initializing_formals` cannot apply to a private
  /// field with a public named parameter.
  DocsState({
    required DocsThemeResolver resolveTheme,
    DocsStorage storage = const DocsStorage(),
    String presetId = kDefaultDocsPresetId,
    Brightness? brightness,
    Brightness systemBrightness = Brightness.light,
    double? radiusPx,
    double densityScale = 1,
  }) {
    _resolveTheme = resolveTheme;
    _storage = storage;
    _presetId = presetId;
    _explicitBrightness = brightness;
    _systemBrightness = systemBrightness;
    _radiusPx = radiusPx;
    _densityScale = densityScale;
  }

  late final DocsThemeResolver _resolveTheme;
  late final DocsStorage _storage;

  late String _presetId;
  Brightness? _explicitBrightness;
  late Brightness _systemBrightness;
  double? _radiusPx;
  late double _densityScale;

  /// Current preset id.
  String get presetId => _presetId;

  /// The effective mode: the explicit choice or the system brightness.
  Brightness get brightness => _explicitBrightness ?? _systemBrightness;

  /// Whether the mode still follows the platform (no explicit choice stored).
  bool get followsSystem => _explicitBrightness == null;

  /// The last observed platform brightness.
  Brightness get systemBrightness => _systemBrightness;

  /// Radius override in px (0–16), or null for the preset's own radius.
  double? get radiusPx => _radiusPx;

  /// Density multiplier (0.85–1.15).
  double get densityScale => _densityScale;

  /// The preset's radius in px, ignoring the override.
  double get presetRadiusPx =>
      _resolveTheme(_presetId, brightness).tokens.radius * 16;

  /// The effective radius in px (override or preset).
  double get effectiveRadiusPx => _radiusPx ?? presetRadiusPx;

  /// The fully-resolved theme for the current state.
  ShadcnThemeData get theme {
    ShadcnThemeData data = _resolveTheme(_presetId, brightness);
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
  ///
  /// A stored `light`/`dark` value becomes the explicit mode; `system` (or no
  /// value) keeps following the platform brightness.
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

  /// Sets the explicit brightness and stops following the platform.
  void setBrightness(Brightness brightness) {
    if (brightness == _explicitBrightness) {
      return;
    }
    _explicitBrightness = brightness;
    _storage.write(kDocsBrightnessKey, brightness.name);
    notifyListeners();
  }

  /// Records the platform brightness while no explicit mode is stored.
  void setSystemBrightness(Brightness brightness) {
    if (brightness == _systemBrightness) {
      return;
    }
    _systemBrightness = brightness;
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
