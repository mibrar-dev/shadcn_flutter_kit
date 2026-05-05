// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../input_otp.dart';
import 'input_otp_theme_defaults.dart';
import 'input_otp_theme_tokens.dart';

class InputOtpThemeConfig {
  const InputOtpThemeConfig._();

  static const InputOTPTheme? inputOTPTheme = null;
  static const String inputOTPThemeType = 'InputOTPTheme';
  static const InputOTPThemeDefaults inputOTPThemeDefaults =
      InputOTPThemeDefaults();
  static const InputOTPThemeTokens inputOTPThemeTokenConfig =
      inputOTPThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    InputOTPTheme: inputOTPTheme,
  };

  static T? resolve<T extends InputOTPTheme>() {
    return _resolveByType[T] as T?;
  }
}
