// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../avatar.dart';
import 'avatar_theme_defaults.dart';
import 'avatar_theme_tokens.dart';

class AvatarThemeConfig {
  const AvatarThemeConfig._();

  static const AvatarTheme? global = null;
  static const String globalType = 'AvatarTheme';
  static const AvatarThemeDefaults defaults = AvatarThemeDefaults();
  static const AvatarThemeTokens tokens = avatarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    AvatarTheme: global,
  };

  static T? resolve<T extends AvatarTheme>() {
    return _resolveByType[T] as T?;
  }
}
