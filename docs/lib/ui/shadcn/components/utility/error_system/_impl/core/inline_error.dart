// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// InlineError: compact error row for forms and inline validation.
// Shows an icon + message using shadcn theme typography and destructive/accent colors.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/icons/radix_icons.dart';
import '../../../../../shared/theme/theme.dart';
import '../themes/base/error_system_theme.dart';

/// InlineError defines a reusable type for this registry module.
class InlineError extends StatelessWidget {
  const InlineError({super.key, required this.message, this.icon});

  /// Stores `message` state/configuration for this implementation.
  final String message;

  /// Stores `icon` state/configuration for this implementation.
  final Widget? icon;

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
          RadixIcons.infoCircled,
          size: compTheme?.iconSize ?? 16 * scaling,
          color: compTheme?.iconColor ?? theme.colorScheme.destructive,
        );
    final messageStyle =
        compTheme?.messageStyle ??
        theme.typography.xSmall.copyWith(color: theme.colorScheme.destructive);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        resolvedIcon,

        /// Creates a `DensityGap` instance.
        DensityGap(gapSm),

        /// Creates a `Expanded` instance.
        Expanded(
          child: DefaultTextStyle.merge(
            style: messageStyle,
            child: Text(message),
          ),
        ),
      ],
    );
  }
}
