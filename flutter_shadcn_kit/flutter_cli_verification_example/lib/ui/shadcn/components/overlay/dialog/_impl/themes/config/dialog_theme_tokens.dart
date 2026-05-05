import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror ModalBackdropThemeDefaults
// ═══════════════════════════════════════════════════════════

class ModalBackdropThemeTokens {
  const ModalBackdropThemeTokens({
    this.borderRadius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
    this.barrierColor = const Color.fromRGBO(0, 0, 0, 0.8),
    this.modal = true,
    this.surfaceClip = true,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final Color barrierColor;
  final bool modal;
  final bool surfaceClip;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const modalBackdropThemeTokens = ModalBackdropThemeTokens();
