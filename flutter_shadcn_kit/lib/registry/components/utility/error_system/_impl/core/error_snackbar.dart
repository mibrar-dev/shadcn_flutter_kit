// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorSnackbar: toast-style notification for AppError using shadcn ToastEntry.
// Inserts an OverlayEntry and decorates it with a border color derived from AppErrorCode severity.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/icons/radix_icons.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../overlay/toast/toast.dart';
import '../themes/base/error_system_theme.dart';
import 'app_error.dart';
import 'error_code.dart';

/// ErrorSnackbar defines a reusable type for this registry module.
class ErrorSnackbar {
  ErrorSnackbar._();

  /// Stores `_entries` state/configuration for this implementation.
  static final List<OverlayEntry> _entries = [];

  static void show({
    required BuildContext context,
    required AppError error,
    Duration? duration,
  }) {
    final overlay = Overlay.of(context);
    final compTheme = ComponentTheme.maybeOf<ErrorSystemTheme>(context);
    final toastTheme = ComponentTheme.maybeOf<ToastTheme>(context);
    final resolvedDuration =
        duration ?? toastTheme?.duration ?? const Duration(seconds: 3);

    /// Stores `entry` state/configuration for this implementation.
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        final overlayTheme = Theme.of(overlayContext);
        final padding =
            toastTheme?.padding ??
            EdgeInsets.all(overlayTheme.density.baseContentPadding);

        /// Stores `margin` state/configuration for this implementation.
        final margin = toastTheme?.margin ?? 8.0;

        /// Stores `totalOffset` state/configuration for this implementation.
        final totalOffset = _entries.length * margin;
        final backgroundColor =
            compTheme?.snackbarBackgroundColor ??
            toastTheme?.backgroundColor ??
            overlayTheme.colorScheme.background;
        final resolvedRadius = compTheme?.snackbarBorderRadius?.resolve(
          /// Creates a `Directionality.of` instance.
          Directionality.of(overlayContext),
        );
        final borderRadius =
            resolvedRadius ??
            (toastTheme?.borderRadius != null
                ? BorderRadius.circular(toastTheme!.borderRadius!)
                : BorderRadius.circular(12));
        return Positioned(
          top: 32 + totalOffset,
          right: 24,
          child: ToastEntry(
            duration: resolvedDuration,
            animationDuration:
                toastTheme?.animationDuration ??
                /// Creates a `Duration` instance.
                const Duration(milliseconds: 250),
            animationCurve: toastTheme?.animationCurve ?? Curves.easeOut,
            onDismissed: () {
              entry.remove();
              _entries.remove(entry);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: Border.all(
                  color: _resolveBorderColor(
                    /// Creates a `Theme.of` instance.
                    Theme.of(overlayContext),
                    error.code,
                  ),
                  width: 1,
                ),
              ),
              child: Container(
                padding: padding,
                width: toastTheme?.width,
                child: _ErrorSnackbarContent(error: error),
              ),
            ),
          ),
        );
      },
    );
    _entries.add(entry);
    overlay.insert(entry);
  }
}

/// _ErrorSnackbarContent defines a reusable type for this registry module.
class _ErrorSnackbarContent extends StatelessWidget {
  const _ErrorSnackbarContent({required this.error});

  /// Stores `error` state/configuration for this implementation.
  final AppError error;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<ErrorSystemTheme>(context);
    final textStyle =
        compTheme?.snackbarTextStyle ??
        theme.typography.xSmall.copyWith(color: theme.colorScheme.foreground);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Creates a `Icon` instance.
        Icon(
          RadixIcons.exclamationTriangle,
          size: 16 * scaling,
          color: compTheme?.iconColor ?? theme.colorScheme.destructive,
        ),

        /// Creates a `DensityGap` instance.
        DensityGap(gapSm),

        /// Creates a `Flexible` instance.
        Flexible(
          child: DefaultTextStyle.merge(
            style: textStyle,
            child: Text(error.message),
          ),
        ),
      ],
    );
  }
}

/// Executes `_resolveBorderColor` behavior for this component/composite.
Color _resolveBorderColor(ThemeData theme, AppErrorCode code) {
  switch (code) {
    case AppErrorCode.validation:
    case AppErrorCode.invalidInput:
      return theme.colorScheme.accent;
    case AppErrorCode.rateLimited:
    case AppErrorCode.timeout:
      return theme.colorScheme.primary;
    case AppErrorCode.unauthorized:
    case AppErrorCode.forbidden:
    case AppErrorCode.sessionExpired:
    case AppErrorCode.invalidCredentials:
    case AppErrorCode.permissionDenied:
      return theme.colorScheme.destructive;
    case AppErrorCode.network:
    case AppErrorCode.noInternet:
    case AppErrorCode.sslError:
      return theme.colorScheme.destructive;
    case AppErrorCode.server:
    case AppErrorCode.badRequest:
    case AppErrorCode.notFound:
    case AppErrorCode.conflict:
      return theme.colorScheme.destructive;
    case AppErrorCode.cancelled:
      return theme.colorScheme.mutedForeground;
    case AppErrorCode.platformError:
    case AppErrorCode.unknown:
      return theme.colorScheme.mutedForeground;
  }
  return theme.colorScheme.mutedForeground;
}
