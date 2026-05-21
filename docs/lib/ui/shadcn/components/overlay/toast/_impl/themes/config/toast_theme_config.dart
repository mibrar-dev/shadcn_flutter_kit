// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../toast.dart';
import 'toast_theme_defaults.dart';
import 'toast_theme_tokens.dart';

class ToastThemeConfig {
  const ToastThemeConfig._();

  static const ToastTheme? global = null;
  static const String globalType = 'ToastTheme';
  static const ToastThemeDefaults defaults = ToastThemeDefaults();
  static const ToastThemeTokens tokens = toastThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ToastTheme: global,
  };

  static T? resolve<T extends ToastTheme>() {
    return _resolveByType[T] as T?;
  }
}
