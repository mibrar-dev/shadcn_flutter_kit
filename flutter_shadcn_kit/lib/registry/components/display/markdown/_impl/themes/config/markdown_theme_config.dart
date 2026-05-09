// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../markdown.dart';
import 'markdown_theme_defaults.dart';
import 'markdown_theme_tokens.dart';

class MarkdownThemeConfig {
  const MarkdownThemeConfig._();

  static const MarkdownTheme? global = null;
  static const String globalType = 'MarkdownTheme';
  static const MarkdownThemeDefaults defaults = MarkdownThemeDefaults();
  static const MarkdownThemeTokens tokens = markdownThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    MarkdownTheme: global,
  };

  static T? resolve<T extends MarkdownTheme>() {
    return _resolveByType[T] as T?;
  }
}
