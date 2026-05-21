// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorSlot: reactive error rendering for a specific ErrorScope.
// Pair with ScreenErrorScope (screen-level) or HubAppScope (app-level) to render errors without string keys.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app_error.dart';
import 'error_scope.dart';
import 'error_state.dart';

/// ErrorSlot defines a reusable type for this registry module.
class ErrorSlot extends StatelessWidget {
  /// Creates a `ErrorSlot._` instance.
  const ErrorSlot._({
    super.key,
    required this.notifier,
    this.builder,
    this.empty = const SizedBox.shrink(),
  });

  /// Channel to listen to.
  final ValueListenable<AppError?> notifier;

  /// Optional renderer; defaults to [ErrorState].
  final Widget Function(BuildContext context, AppError error)? builder;

  /// Widget to render when there is no error.
  final Widget empty;

  /// Factory constructor that creates `ErrorSlot.scope` instances.
  factory ErrorSlot.scope({
    Key? key,
    required ErrorScope scope,
    Widget Function(BuildContext context, AppError error)? builder,
    Widget empty = const SizedBox.shrink(),
  }) {
    return ErrorSlot._(
      key: key,
      notifier: scope.notifier,
      builder: builder,
      empty: empty,
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppError?>(
      valueListenable: notifier,
      builder: (context, error, _) {
        if (error == null) return empty;
        return builder?.call(context, error) ?? ErrorState(error: error);
      },
    );
  }
}
