// The `error_system` component: the visual error surfaces ([ErrorState],
// [InlineError], [AppErrorBanner], [ErrorDialog], [ErrorSnackbar],
// [AppErrorGate], [ErrorSlot]) over the `error_handling` primitive.
//
// The non-visual machinery (models, rules, scopes, recovery helpers) is
// re-exported from `primitives/error_handling/`; the theme lives in
// `error_system_style.dart`.

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/error_handling/error_handling.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../alert_dialog/alert_dialog.dart';
import '../button/button.dart';
import '../card/card.dart';
import '../divider/divider.dart';
import '../toast/toast.dart';
import 'error_system_style.dart';

export '../../primitives/error_handling/error_handling.dart';
export 'error_system_style.dart';

/// A full-page (or section) error surface built from `Card`, `Divider` and
/// `Button`.
class ErrorState extends StatelessWidget {
  /// Creates an error state.
  const ErrorState({
    super.key,
    required this.error,
    this.icon,
    this.maxWidth,
    this.theme,
  });

  /// The error to render.
  final AppError error;

  /// Replaces the default icon.
  final Widget? icon;

  /// Maximum width of the card; null resolves 520.
  final double? maxWidth;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final ErrorSystemTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ErrorSystemTheme style = _errorSystemStyle(context, theme);
    final ShadcnColors colors = ambient.colors;
    final Widget resolvedIcon =
        icon ??
        Icon(
          LucideIcons.triangleAlert,
          size: style.iconSize,
          color: style.iconColor!.resolve(colors),
        );
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 520),
        child: Card(
          padding: style.cardPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              resolvedIcon,
              Gap(ambient.spacing.md),
              Text(
                error.title,
                textAlign: TextAlign.center,
                style: style.titleStyle!.copyWith(color: colors.foreground),
              ),
              const Gap(6),
              Text(
                error.message,
                textAlign: TextAlign.center,
                style: style.messageStyle!.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              if (error.hasActions) ...<Widget>[
                Gap(ambient.spacing.md),
                const Divider(),
                Gap(ambient.spacing.md),
                Wrap(
                  spacing: ambient.spacing.sm,
                  runSpacing: ambient.spacing.xs,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    for (final ErrorAction action in error.actions)
                      errorActionButton(action),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class InlineError extends StatelessWidget {
  /// Creates an inline error.
  const InlineError({super.key, required this.message, this.icon});

  /// The message.
  final String message;

  /// Replaces the default icon.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        icon ??
            Icon(LucideIcons.circleAlert, size: 16, color: colors.destructive),
        const Gap(8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 14, color: colors.destructive),
          ),
        ),
      ],
    );
  }
}

class AppErrorBanner extends StatelessWidget {
  /// Creates a banner.
  const AppErrorBanner({super.key, required this.scope, this.theme});

  /// The channel to render.
  final ErrorScope scope;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final ErrorSystemTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ErrorSystemTheme style = _errorSystemStyle(context, theme);
    return ValueListenableBuilder<AppError?>(
      valueListenable: scope.notifier,
      builder: (BuildContext context, AppError? error, Widget? _) {
        if (error == null) {
          return const SizedBox.shrink();
        }
        return _banner(context, error, style);
      },
    );
  }

  Widget _banner(BuildContext context, AppError error, ErrorSystemTheme style) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    final ThemedColor border = style.bannerBorder!;
    final Widget? action = error.actions.isEmpty
        ? null
        : errorActionButton(error.actions.first);
    return Card(
      background: style.bannerBackground,
      borderColor: border,
      borderWidth: 1,
      padding: style.bannerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            LucideIcons.triangleAlert,
            size: 18,
            color: border.resolve(colors),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  error.title,
                  style: style.titleStyle!.copyWith(color: colors.foreground),
                ),
                const Gap(4),
                Text(
                  error.message,
                  style: style.messageStyle!.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...<Widget>[const Gap(12), action],
          const Gap(8),
          Button(
            variant: ButtonVariant.ghost,
            size: ButtonSize.sm,
            onPressed: scope.clear,
            child: const Icon(LucideIcons.x, size: 16),
          ),
        ],
      ),
    );
  }
}

Future<T?> showErrorDialog<T>({
  required BuildContext context,
  required AppError error,
  Widget? icon,
  bool barrierDismissible = true,
  ThemedColor? barrierColor,
}) {
  final List<Widget> actions = error.actions.isEmpty
      ? <Widget>[
          Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(ShadcnLocalizations.of(context).dialogDismiss),
          ),
        ]
      : <Widget>[
          for (final ErrorAction a in error.actions) errorActionButton(a),
        ];
  return showAlertDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    icon: icon ?? const Icon(LucideIcons.triangleAlert, size: 20),
    title: Text(error.title),
    description: Text(error.message),
    actions: actions,
  );
}

String showErrorSnackbar(
  BuildContext context,
  AppError error, {
  Duration? duration,
}) {
  return showToast(
    context,
    duration: duration,
    builder: (BuildContext context) {
      final ShadcnColors colors = ShadcnTheme.of(context).colors;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(LucideIcons.triangleAlert, size: 16, color: colors.destructive),
          const Gap(8),
          Flexible(child: Text(error.message)),
        ],
      );
    },
  );
}

class AppErrorGate extends StatelessWidget {
  /// Creates an error gate.
  const AppErrorGate({
    super.key,
    required this.child,
    required this.notifier,
    this.overlayBuilder,
    this.blockInteraction = true,
  });

  /// The subtree kept mounted behind the overlay.
  final Widget child;

  /// The channel to watch.
  final ValueListenable<AppError?> notifier;

  /// Replaces the default overlay.
  final Widget Function(BuildContext context, AppError error)? overlayBuilder;

  /// Whether the subtree is blocked while an error is shown.
  final bool blockInteraction;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ValueListenableBuilder<AppError?>(
      valueListenable: notifier,
      builder: (BuildContext context, AppError? error, Widget? _) {
        return Stack(
          children: <Widget>[
            if (error != null && blockInteraction)
              AbsorbPointer(child: child)
            else
              child,
            if (error != null)
              Positioned.fill(
                child: ColoredBox(
                  color: colors.background,
                  child:
                      overlayBuilder?.call(context, error) ??
                      ErrorState(error: error),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ErrorSlot extends StatelessWidget {
  /// Creates an error slot.
  const ErrorSlot({
    super.key,
    required this.scope,
    this.builder,
    this.empty = const SizedBox.shrink(),
  });

  /// The channel to watch.
  final ErrorScope scope;

  /// Replaces the default [ErrorState].
  final Widget Function(BuildContext context, AppError error)? builder;

  /// Rendered when there is no error.
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppError?>(
      valueListenable: scope.notifier,
      builder: (BuildContext context, AppError? error, Widget? _) {
        if (error == null) {
          return empty;
        }
        return builder?.call(context, error) ?? ErrorState(error: error);
      },
    );
  }
}

Widget errorActionButton(ErrorAction action) => Button(
  variant: action.primary ? ButtonVariant.primary : ButtonVariant.outline,
  size: ButtonSize.sm,
  onPressed: action.onPressed,
  child: Text(action.label),
);

Future<T?> _showDialog<T>(
  BuildContext context,
  AppError error,
  bool barrierDismissible,
) {
  return showErrorDialog<T>(
    context: context,
    error: error,
    barrierDismissible: barrierDismissible,
  );
}

String _showSnack(BuildContext context, AppError error, Duration? duration) {
  return showErrorSnackbar(context, error, duration: duration);
}

ErrorSystemTheme _errorSystemStyle(
  BuildContext context,
  ErrorSystemTheme? widget,
) {
  return resolveComponentStyle<ErrorSystemTheme, ErrorSystemTheme>(
    context,
    widget: widget,
    select: (t) => t,
    defaults: errorSystemDefaults,
  );
}

extension ErrorSystemContext on BuildContext {
  /// Opens [showErrorDialog] for [error].
  Future<T?> showErrorDialog<T>(
    AppError error, {
    bool barrierDismissible = true,
  }) {
    return _showDialog<T>(this, error, barrierDismissible);
  }

  /// Shows a toast for [error].
  String showErrorSnackbar(AppError error, {Duration? duration}) {
    return _showSnack(this, error, duration);
  }
}
