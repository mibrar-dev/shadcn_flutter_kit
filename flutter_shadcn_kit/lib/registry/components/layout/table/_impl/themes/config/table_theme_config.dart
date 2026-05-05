// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../table.dart';
import 'table_theme_defaults.dart';
import 'table_theme_tokens.dart';

class TableThemeConfig {
  const TableThemeConfig._();

  static const TableTheme? global = null;
  static const String globalType = 'TableTheme';
  static const TableThemeDefaults defaults = TableThemeDefaults();
  static const TableThemeTokens tokens = tableThemeTokens;

  static const ResizableTableTheme? resizableTableTheme = null;
  static const String resizableTableThemeType = 'ResizableTableTheme';
  static const ResizableTableThemeDefaults resizableTableThemeDefaults =
      ResizableTableThemeDefaults();
  static const ResizableTableThemeTokens resizableTableThemeTokenConfig =
      resizableTableThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TableTheme: global,
    ResizableTableTheme: resizableTableTheme,
  };

  static T? resolve<T>() {
    return _resolveByType[T] as T?;
  }
}
