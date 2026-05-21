// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorState: full-page/section error UI built from shadcn Card/Divider/Button primitives.
// Renders optional illustration + icon + title/message and maps ErrorAction list to buttons.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/icons/radix_icons.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../control/button/button.dart';
import '../../../../display/divider/divider.dart';
import '../../../../layout/card/card.dart';
import '../themes/base/error_system_theme.dart';
import 'app_error.dart';
import 'error_action.dart';

/// ErrorState defines a reusable type for this registry module.
class ErrorState extends StatelessWidget {
  /// Creates a `ErrorState` instance.
  const ErrorState({
    super.key,
    required this.error,
    this.illustration,
    this.icon,
    this.maxWidth,
  });

  /// Stores `error` state/configuration for this implementation.
  final AppError error;

  /// Stores `illustration` state/configuration for this implementation.
  final Widget? illustration;

  /// Stores `icon` state/configuration for this implementation.
  final Widget? icon;

  /// Stores `maxWidth` state/configuration for this implementation.
  final double? maxWidth;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<ErrorSystemTheme>(context);
    final resolvedIcon =
        icon ??
        /// Creates a `Icon` instance.
        Icon(
          RadixIcons.exclamationTriangle,
          size: compTheme?.iconSize ?? 36 * scaling,
          color: compTheme?.iconColor ?? theme.colorScheme.destructive,
        );

    /// Stores `resolvedIllustration` state/configuration for this implementation.
    final resolvedIllustration = illustration;
    final titleStyle =
        compTheme?.titleStyle ??
        theme.typography.medium.merge(theme.typography.semiBold);
    final messageStyle =
        compTheme?.messageStyle ??
        theme.typography.small.copyWith(
          color: theme.colorScheme.mutedForeground,
        );
    final padding =
        compTheme?.cardPadding ??
        EdgeInsets.all(theme.density.baseContainerPadding * scaling * 1.5);

    /// Stores `borderRadius` state/configuration for this implementation.
    final borderRadius = compTheme?.cardBorderRadius;

    /// Stores `fillColor` state/configuration for this implementation.
    final fillColor = compTheme?.cardFillColor;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 520 * scaling),
        child: Card(
          padding: padding,
          borderRadius: borderRadius,
          filled: fillColor != null ? true : null,
          fillColor: fillColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (resolvedIllustration != null) ...[
                resolvedIllustration,

                /// Creates a `DensityGap` instance.
                DensityGap(gapLg),
              ],
              resolvedIcon,

              /// Creates a `DensityGap` instance.
              DensityGap(gapMd),

              /// Creates a `DefaultTextStyle.merge` instance.
              DefaultTextStyle.merge(
                style: titleStyle,
                textAlign: TextAlign.center,
                child: Text(error.title),
              ),

              /// Creates a `DensityGap` instance.
              DensityGap(0.75),

              /// Creates a `DefaultTextStyle.merge` instance.
              DefaultTextStyle.merge(
                style: messageStyle,
                textAlign: TextAlign.center,
                child: Text(error.message),
              ),
              if (error.hasActions) ...[
                /// Creates a `DensityGap` instance.
                DensityGap(gapLg),

                /// Creates a `Divider` instance.
                const Divider(),

                /// Creates a `DensityGap` instance.
                DensityGap(gapLg),

                /// Creates a `Wrap` instance.
                Wrap(
                  spacing: theme.density.baseGap * scaling * 1.5,
                  runSpacing: 8 * scaling,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final action in error.actions)
                      /// Creates a `_buildAction` instance.
                      _buildAction(context, action),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Executes `_buildAction` behavior for this component/composite.
  Widget _buildAction(BuildContext context, ErrorAction action) {
    /// Stores `icon` state/configuration for this implementation.
    final icon = action.icon;
    final child = icon == null
        ? Text(action.label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Creates a `Icon` instance.
              Icon(icon, size: 16 * Theme.of(context).scaling),

              /// Creates a `DensityGap` instance.
              DensityGap(gapSm),

              /// Creates a `Text` instance.
              Text(action.label),
            ],
          );
    if (action.primary) {
      return PrimaryButton(onPressed: action.onPressed, child: child);
    }
    return SecondaryButton(onPressed: action.onPressed, child: child);
  }
}
