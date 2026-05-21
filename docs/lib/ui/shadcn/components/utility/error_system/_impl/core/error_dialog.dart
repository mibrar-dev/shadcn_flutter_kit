// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorDialog: modal error UI using shadcn Dialog + AlertDialog components.
// ErrorDialog.show(...) opens the dialog and renders ErrorAction buttons in the footer.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/icons/radix_icons.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../control/button/button.dart';
import '../../../../overlay/alert_dialog/alert_dialog.dart';
import '../../../../overlay/dialog/dialog.dart' as shadcn_dialog;
import '../themes/base/error_system_theme.dart';
import 'app_error.dart';
import 'error_action.dart';

/// ErrorDialog defines a reusable type for this registry module.
class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.error, this.icon});

  /// Stores `error` state/configuration for this implementation.
  final AppError error;

  /// Stores `icon` state/configuration for this implementation.
  final Widget? icon;

  static Future<T?> show<T>({
    required BuildContext context,
    required AppError error,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    final compTheme = ComponentTheme.maybeOf<ErrorSystemTheme>(context);
    return shadcn_dialog.showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: compTheme?.dialogBarrierColor,
      builder: (context) => ErrorDialog(error: error, icon: icon),
    );
  }

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
          size: compTheme?.iconSize ?? 24 * scaling,
          color: compTheme?.iconColor ?? theme.colorScheme.destructive,
        );
    final titleStyle =
        compTheme?.titleStyle ??
        theme.typography.medium.merge(theme.typography.semiBold);
    final messageStyle =
        compTheme?.messageStyle ??
        theme.typography.small.copyWith(
          color: theme.colorScheme.mutedForeground,
        );

    /// Stores `dialogPadding` state/configuration for this implementation.
    final dialogPadding = compTheme?.dialogPadding;

    return AlertDialog(
      leading: resolvedIcon,
      title: DefaultTextStyle.merge(
        style: titleStyle,
        child: Text(error.title),
      ),
      content: DefaultTextStyle.merge(
        style: messageStyle,
        child: Text(error.message),
      ),
      padding: dialogPadding,
      surfaceBlur: compTheme?.dialogSurfaceBlur,
      surfaceOpacity: compTheme?.dialogSurfaceOpacity,
      barrierColor: compTheme?.dialogBarrierColor,
      actions: error.actions.isEmpty
          ? [
              /// Creates a `SecondaryButton` instance.
              SecondaryButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Dismiss'),
              ),
            ]
          : [for (final action in error.actions) _buildAction(context, action)],
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
