// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
