import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror TextFieldThemeDefaults
// ═══════════════════════════════════════════════════════════

class TextFieldThemeTokens {
  const TextFieldThemeTokens({
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.filled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.border = const Border.fromBorderSide(
      BorderSide(
        color: Color(0xFFE5E5E5),
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
    ),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final BorderRadiusGeometry borderRadius;
  final bool filled;
  final EdgeInsetsGeometry padding;
  final Border border;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const textFieldThemeTokens = TextFieldThemeTokens();
