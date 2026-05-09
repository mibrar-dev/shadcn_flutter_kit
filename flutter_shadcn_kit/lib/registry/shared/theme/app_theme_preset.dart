// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'preset_themes.dart';

/// InstalledThemePreset stores the currently installed preset payload.
///
/// CLI/theme tooling can replace this file to change the active preset without
/// rewriting app theme composition logic.
class InstalledThemePreset {
  /// Active preset used by [AppTheme].
  static RegistryThemePreset current = registryThemePresets.first;
}
