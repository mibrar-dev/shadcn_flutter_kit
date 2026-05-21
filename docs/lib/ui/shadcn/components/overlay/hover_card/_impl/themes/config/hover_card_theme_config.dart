// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../hover_card.dart';
import 'hover_card_theme_defaults.dart';
import 'hover_card_theme_tokens.dart';

class HoverCardThemeConfig {
  const HoverCardThemeConfig._();

  static const HoverCardTheme? global = null;
  static const String globalType = 'HoverCardTheme';
  static const HoverCardThemeDefaults defaults = HoverCardThemeDefaults();
  static const HoverCardThemeTokens tokens = hoverCardThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    HoverCardTheme: global,
  };

  static T? resolve<T extends HoverCardTheme>() {
    return _resolveByType[T] as T?;
  }
}
