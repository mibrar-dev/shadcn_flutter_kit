// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror AvatarThemeDefaults
// ═══════════════════════════════════════════════════════════

class AvatarThemeTokens {
  const AvatarThemeTokens({
    this.size = 40.0,
    this.borderRadius = 20.0,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.badgeAlignment = const AlignmentDirectional(0.35, 0.35),
    this.badgeGap = 4.0,
    this.initialsPadding = 8.0,
    this.textStyle = const TextStyle(
      color: Color(0xFF0A0A0A),
      fontWeight: FontWeight.bold,
    ),
    this.imageFit = BoxFit.cover,
    this.groupClipBehavior = Clip.none,
    this.groupStackAlignment = Alignment.center,
    this.groupOffset = 0.5,
    this.badgeSize = 12.0,
    this.badgeBorderRadius = 6.0,
    this.badgeColor = const Color(0xFF171717),
    this.groupChildSize = 40.0,
    this.groupGap = 4.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double size;
  final double borderRadius;
  final Color backgroundColor;
  final AlignmentGeometry badgeAlignment;
  final double badgeGap;
  final double initialsPadding;
  final TextStyle textStyle;
  final BoxFit imageFit;
  final Clip groupClipBehavior;
  final AlignmentGeometry groupStackAlignment;
  final double groupOffset;
  final double badgeSize;
  final double badgeBorderRadius;
  final Color badgeColor;
  final double groupChildSize;
  final double groupGap;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const avatarThemeTokens = AvatarThemeTokens();
