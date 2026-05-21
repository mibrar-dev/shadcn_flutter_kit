// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Error System preview screen.
// Demonstrates ErrorState, InlineError, ErrorDialog, and ErrorSnackbar in the gallery.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../layout/scaffold/scaffold.dart';
import '../../control/button/button.dart';
import '../../../shared/theme/theme.dart';
import 'error_system.dart';
import '../../../shared/icons/radix_icons.dart';

/// ErrorSystemPreview defines a reusable type for this registry module.
class ErrorSystemPreview extends StatelessWidget {
  const ErrorSystemPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final globalScope = HubAppScope('global');
    final sampleError = AppError(
      code: AppErrorCode.notFound,
      title: "Something's not right here",
      message:
          "We can’t find the page you’re looking for. Don’t worry, we can get you back home.",
      actions: [ErrorAction(label: 'Home', onPressed: () {}, primary: true)],
    );
    final gateError = AppError(
      code: AppErrorCode.noInternet,
      title: 'You are offline',
      message:
          'Reconnect to continue. We will restore your screen automatically.',
      actions: [
        /// Creates a `ErrorAction.retry` instance.
        ErrorAction.retry(() {
          globalScope.clear();
        }),
      ],
    );

    return Scaffold(
      headers: const [AppBar(title: Text('Error System'))],
      child: ScreenErrorScope(
        child: Builder(
          builder: (context) {
            final scope = ScreenErrorScope.of(context);
            return AppErrorGate.scope(
              scope: globalScope,
              child: ListView(
                padding: EdgeInsets.all(24 * scaling),
                children: [
                  /// Creates a `AppErrorBanner` instance.
                  AppErrorBanner(),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gapLg),

                  /// Creates a `Wrap` instance.
                  Wrap(
                    spacing: 12 * scaling,
                    runSpacing: 8 * scaling,
                    children: [
                      /// Creates a `SecondaryButton` instance.
                      SecondaryButton(
                        onPressed: () {
                          AppErrorHub.I
                              .app(AppErrorHub.networkUnavailable)
                              .value = sampleError.copyWithActions([
                            /// Creates a `ErrorAction.retry` instance.
                            ErrorAction.retry(() {}),
                          ]);
                        },
                        child: const Text('Trigger App Error'),
                      ),

                      /// Creates a `GhostButton` instance.
                      GhostButton(
                        onPressed: () => AppErrorHub.I.clearAllApp(),
                        child: const Text('Clear App Errors'),
                      ),

                      /// Creates a `SecondaryButton` instance.
                      SecondaryButton(
                        onPressed: () => globalScope.notifier.value = gateError,
                        child: const Text('Show App Gate'),
                      ),

                      /// Creates a `GhostButton` instance.
                      GhostButton(
                        onPressed: globalScope.clear,
                        child: const Text('Clear App Gate'),
                      ),
                    ],
                  ),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gap2xl),

                  /// Creates a `ErrorState` instance.
                  ErrorState(
                    error: sampleError,
                    illustration: Column(
                      children: [
                        /// Creates a `Text` instance.
                        Text(
                          'Error',
                          style: theme.typography.x4Large.copyWith(
                            color: theme.colorScheme.secondaryForeground,
                          ),
                        ),

                        /// Creates a `DensityGap` instance.
                        DensityGap(gapSm),

                        /// Creates a `Container` instance.
                        Container(
                          width: 220 * scaling,
                          height: 160 * scaling,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.border,
                            borderRadius: BorderRadius.circular(24 * scaling),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            RadixIcons.target,
                            size: 48 * scaling,
                            color: theme.colorScheme.secondaryForeground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gap2xl),

                  /// Creates a `ErrorSlot.scope` instance.
                  ErrorSlot.scope(
                    scope: scope.scope,
                    empty: const InlineError(message: 'No screen-level error.'),
                    builder: (context, error) {
                      final scaling = Theme.of(context).scaling;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Creates a `InlineError` instance.
                          InlineError(message: error.message),

                          /// Creates a `DensityGap` instance.
                          DensityGap(gapSm),

                          /// Creates a `Wrap` instance.
                          Wrap(
                            spacing: 12 * scaling,
                            runSpacing: 8 * scaling,
                            children: [
                              /// Creates a `GhostButton` instance.
                              GhostButton(
                                onPressed: scope.clear,
                                child: const Text('Dismiss'),
                              ),

                              /// Creates a `SecondaryButton` instance.
                              SecondaryButton(
                                onPressed: () => ErrorDialog.show(
                                  context: context,
                                  error: error,
                                ),
                                child: const Text('Dialog'),
                              ),

                              /// Creates a `SecondaryButton` instance.
                              SecondaryButton(
                                onPressed: () => ErrorSnackbar.show(
                                  context: context,
                                  error: error,
                                ),
                                child: const Text('Snackbar'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gap2xl),

                  /// Creates a `Wrap` instance.
                  Wrap(
                    spacing: 12 * scaling,
                    runSpacing: 8 * scaling,
                    children: [
                      /// Creates a `SecondaryButton` instance.
                      SecondaryButton(
                        onPressed: () async {
                          await scope.run<void>(() async {
                            /// Stores `sampleError` state/configuration for this implementation.
                            throw sampleError;
                          });
                        },
                        child: const Text('run() -> Screen Error'),
                      ),

                      /// Creates a `PrimaryButton` instance.
                      PrimaryButton(
                        onPressed: () => ErrorDialog.show(
                          context: context,
                          error: sampleError,
                        ),
                        child: const Text('Show Error Dialog'),
                      ),

                      /// Creates a `SecondaryButton` instance.
                      SecondaryButton(
                        onPressed: () => ErrorSnackbar.show(
                          context: context,
                          error: sampleError,
                        ),
                        child: const Text('Show Error Snackbar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
