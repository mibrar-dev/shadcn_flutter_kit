// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorSystemTheme: ComponentTheme overrides for error UI (icons, card, dialog, snackbar).
// Wrap a subtree with ComponentTheme<ErrorSystemTheme> to customize styling consistently.

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';
import '../../core/app_error.dart';

/// ErrorSystemTheme defines a reusable type for this registry module.
class ErrorSystemTheme extends ComponentThemeData {
  /// Creates a `ErrorSystemTheme` instance.
  const ErrorSystemTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
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
    this.bannerIcon,
    this.bannerBorderColor,
    this.snackbarBackgroundColor,
    this.snackbarTextStyle,
    this.snackbarBorderRadius,
    this.dialogSurfaceBlur,
    this.dialogSurfaceOpacity,
    this.dialogBarrierColor,
    this.dialogPadding,
  });

  /// Stores `iconColor` state/configuration for this implementation.
  final Color? iconColor;

  /// Stores `iconSize` state/configuration for this implementation.
  final double? iconSize;

  /// Stores `titleStyle` state/configuration for this implementation.
  final TextStyle? titleStyle;

  /// Stores `messageStyle` state/configuration for this implementation.
  final TextStyle? messageStyle;

  /// Stores `cardPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry? cardPadding;

  /// Stores `cardBorderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? cardBorderRadius;

  /// Stores `cardFillColor` state/configuration for this implementation.
  final Color? cardFillColor;

  /// Stores `bannerBackgroundColor` state/configuration for this implementation.
  final Color? bannerBackgroundColor;

  /// Stores `bannerBorderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? bannerBorderRadius;

  /// Stores `bannerPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry? bannerPadding;

  /// Stores `bannerTitleStyle` state/configuration for this implementation.
  final TextStyle? bannerTitleStyle;

  /// Stores `bannerMessageStyle` state/configuration for this implementation.
  final TextStyle? bannerMessageStyle;

  /// Stores `bannerIcon` state/configuration for this implementation.
  final IconData? bannerIcon;
  final Color Function(ThemeData theme, AppError error)? bannerBorderColor;

  /// Stores `snackbarBackgroundColor` state/configuration for this implementation.
  final Color? snackbarBackgroundColor;

  /// Stores `snackbarTextStyle` state/configuration for this implementation.
  final TextStyle? snackbarTextStyle;

  /// Stores `snackbarBorderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? snackbarBorderRadius;

  /// Stores `dialogSurfaceBlur` state/configuration for this implementation.
  final double? dialogSurfaceBlur;

  /// Stores `dialogSurfaceOpacity` state/configuration for this implementation.
  final double? dialogSurfaceOpacity;

  /// Stores `dialogBarrierColor` state/configuration for this implementation.
  final Color? dialogBarrierColor;

  /// Stores `dialogPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry? dialogPadding;
}
