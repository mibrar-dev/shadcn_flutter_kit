// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../code_snippet.dart';
import 'code_snippet_theme_defaults.dart';
import 'code_snippet_theme_tokens.dart';

class CodeSnippetThemeConfig {
  const CodeSnippetThemeConfig._();

  static const CodeSnippetTheme? global = null;
  static const String globalType = 'CodeSnippetTheme';
  static const CodeSnippetThemeDefaults defaults = CodeSnippetThemeDefaults();
  static const CodeSnippetThemeTokens tokens = codeSnippetThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    CodeSnippetTheme: global,
  };

  static T? resolve<T extends CodeSnippetTheme>() {
    return _resolveByType[T] as T?;
  }
}
