// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in avatar widgets
// ═══════════════════════════════════════════════════════════

class AvatarThemeDefaults {
  const AvatarThemeDefaults({
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
  });

  /// From `_AvatarState`: `theme.scaling * 40`
  final double size;

  /// From `_AvatarState`: `theme.radius * size`
  final double borderRadius;

  /// From `_AvatarState`: `theme.colorScheme.muted`
  final Color backgroundColor;

  /// From `_AvatarState`: `AlignmentDirectional(offset, offset)`
  final AlignmentGeometry badgeAlignment;

  /// From `_AvatarState`: `theme.density.baseGap * theme.scaling * gapXs`
  final double badgeGap;

  /// From `_AvatarState`: `theme.density.baseContentPadding * theme.scaling * padXs`
  final double initialsPadding;

  /// From `_AvatarState`: foreground + bold
  final TextStyle textStyle;

  /// From `_AvatarState` image branch: `fit: BoxFit.cover`
  final BoxFit imageFit;

  /// From `AvatarGroup` default: `clipBehavior ?? Clip.none`
  final Clip groupClipBehavior;

  /// From `AvatarGroup` stack default: `alignment: Alignment.center`
  final AlignmentGeometry groupStackAlignment;

  /// From `AvatarGroup` named constructors: `offset = 0.5`
  final double groupOffset;

  /// From `AvatarBadge`: `theme.scaling * 12`
  final double badgeSize;

  /// From `AvatarBadge`: `theme.radius * resolvedSize`
  final double badgeBorderRadius;

  /// From `AvatarBadge`: `theme.colorScheme.primary`
  final Color badgeColor;

  /// From `AvatarGroup`: `avatar.size ?? theme.scaling * 40`
  final double groupChildSize;

  /// From `AvatarGroup`: `gap ?? theme.scaling * 4`
  final double groupGap;
}
