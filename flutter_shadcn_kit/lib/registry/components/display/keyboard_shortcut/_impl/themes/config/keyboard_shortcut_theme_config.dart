// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../keyboard_shortcut.dart';
import 'keyboard_shortcut_theme_defaults.dart';
import 'keyboard_shortcut_theme_tokens.dart';

class KeyboardShortcutThemeConfig {
  const KeyboardShortcutThemeConfig._();

  static const KeyboardShortcutTheme? global = null;
  static const String globalType = 'KeyboardShortcutTheme';
  static const KeyboardShortcutThemeDefaults defaults =
      KeyboardShortcutThemeDefaults();
  static const KeyboardShortcutThemeTokens tokens = keyboardShortcutThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    KeyboardShortcutTheme: global,
  };

  static T? resolve<T extends KeyboardShortcutTheme>() {
    return _resolveByType[T] as T?;
  }
}
