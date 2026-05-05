// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../multiple_choice.dart';
import 'multiple_choice_theme_defaults.dart';
import 'multiple_choice_theme_tokens.dart';

class MultipleChoiceThemeConfig {
  const MultipleChoiceThemeConfig._();

  static const MultipleChoiceTheme? global = null;
  static const String globalType = 'MultipleChoiceTheme';
  static const MultipleChoiceThemeDefaults defaults =
      MultipleChoiceThemeDefaults();
  static const MultipleChoiceThemeTokens tokens = multipleChoiceThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    MultipleChoiceTheme: global,
  };

  static T? resolve<T extends MultipleChoiceTheme>() {
    return _resolveByType[T] as T?;
  }
}
