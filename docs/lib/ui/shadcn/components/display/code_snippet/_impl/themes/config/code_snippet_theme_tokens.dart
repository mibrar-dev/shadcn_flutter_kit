// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror CodeSnippetThemeDefaults
// ═══════════════════════════════════════════════════════════

class CodeSnippetThemeTokens {
  const CodeSnippetThemeTokens({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE5E5E5),
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.padding = const EdgeInsets.only(
      left: 16.0,
      right: 56.0,
      top: 16.0,
      bottom: 16.0,
    ),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const codeSnippetThemeTokens = CodeSnippetThemeTokens();
