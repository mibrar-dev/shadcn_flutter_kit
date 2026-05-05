import 'preset_themes.dart';

/// InstalledThemePreset stores the currently installed preset payload.
///
/// CLI/theme tooling can replace this file to change the active preset without
/// rewriting app theme composition logic.
class InstalledThemePreset {
  /// Active preset used by [AppTheme].
  static RegistryThemePreset current = registryThemePresets.first;
}
