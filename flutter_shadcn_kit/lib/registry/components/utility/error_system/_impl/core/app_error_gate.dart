// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// AppErrorGate: full-screen overlay for app-level blocking errors.
// Keeps the navigator subtree mounted so state is preserved while showing a global error UI.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import 'app_error.dart';
import 'error_scope.dart';
import 'error_state.dart';

/// AppErrorGate defines a reusable type for this registry module.
class AppErrorGate extends StatelessWidget {
  /// Creates a `AppErrorGate` instance.
  const AppErrorGate({
    super.key,
    required this.child,
    required this.notifier,
    this.overlayBuilder,
    this.blockInteraction = true,
  });

  /// Subtree that should stay mounted (typically your Navigator/Scaffold tree).
  final Widget child;

  /// App-level error channel (use HubAppScope(...).notifier).
  final ValueListenable<AppError?> notifier;

  /// Optional custom overlay builder.
  final Widget Function(BuildContext context, AppError error)? overlayBuilder;

  /// When true, blocks pointer events behind the overlay.
  final bool blockInteraction;

  /// Factory constructor that creates `AppErrorGate.scope` instances.
  factory AppErrorGate.scope({
    Key? key,
    required Widget child,
    required ErrorScope scope,
    Widget Function(BuildContext context, AppError error)? overlayBuilder,
    bool blockInteraction = true,
  }) {
    return AppErrorGate(
      key: key,
      child: child,
      notifier: scope.notifier,
      overlayBuilder: overlayBuilder,
      blockInteraction: blockInteraction,
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppError?>(
      valueListenable: notifier,
      builder: (context, error, _) {
        return Stack(
          children: [
            if (error != null && blockInteraction)
              /// Creates a `AbsorbPointer` instance.
              AbsorbPointer(child: child)
            else
              child,
            if (error != null)
              /// Creates a `Positioned.fill` instance.
              Positioned.fill(
                child: _AppErrorGateOverlay(
                  error: error,
                  overlayBuilder: overlayBuilder,
                  blockInteraction: blockInteraction,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// _AppErrorGateOverlay defines a reusable type for this registry module.
class _AppErrorGateOverlay extends StatelessWidget {
  /// Creates a `_AppErrorGateOverlay` instance.
  const _AppErrorGateOverlay({
    required this.error,
    required this.overlayBuilder,
    required this.blockInteraction,
  });

  /// Stores `error` state/configuration for this implementation.
  final AppError error;
  final Widget Function(BuildContext context, AppError error)? overlayBuilder;

  /// Stores `blockInteraction` state/configuration for this implementation.
  final bool blockInteraction;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `background` state/configuration for this implementation.
    final background = theme.colorScheme.background;
    final content =
        overlayBuilder?.call(context, error) ?? ErrorState(error: error);
    final overlay = Container(
      color: background,
      alignment: Alignment.center,
      child: content,
    );
    return overlay;
  }
}
