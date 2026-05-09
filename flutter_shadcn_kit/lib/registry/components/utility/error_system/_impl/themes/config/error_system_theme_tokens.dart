// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/icons/radix_icons.dart';
import '../../../../../../shared/theme/theme.dart';
import '../../../error_system.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class ErrorSystemThemeTokens {
  const ErrorSystemThemeTokens({
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.messageStyle,
    this.cardPadding,
    this.cardBorderRadius,
    this.cardFillColor,
    this.bannerBackgroundColor,
    this.bannerBorderRadius,
    this.bannerPadding,
    this.bannerTitleStyle,
    this.bannerMessageStyle,
    this.bannerIcon = RadixIcons.exclamationTriangle,
    this.bannerBorderColor,
    this.snackbarBackgroundColor,
    this.snackbarTextStyle,
    this.snackbarBorderRadius,
    this.dialogSurfaceBlur,
    this.dialogSurfaceOpacity,
    this.dialogBarrierColor,
    this.dialogPadding,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color? iconColor;
  final double? iconSize;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final EdgeInsetsGeometry? cardPadding;
  final BorderRadiusGeometry? cardBorderRadius;
  final Color? cardFillColor;
  final Color? bannerBackgroundColor;
  final BorderRadiusGeometry? bannerBorderRadius;
  final EdgeInsetsGeometry? bannerPadding;
  final TextStyle? bannerTitleStyle;
  final TextStyle? bannerMessageStyle;
  final IconData bannerIcon;
  final Color Function(ThemeData theme, AppError error)? bannerBorderColor;
  final Color? snackbarBackgroundColor;
  final TextStyle? snackbarTextStyle;
  final BorderRadiusGeometry? snackbarBorderRadius;
  final double? dialogSurfaceBlur;
  final double? dialogSurfaceOpacity;
  final Color? dialogBarrierColor;
  final EdgeInsetsGeometry? dialogPadding;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const errorSystemThemeTokens = ErrorSystemThemeTokens();
