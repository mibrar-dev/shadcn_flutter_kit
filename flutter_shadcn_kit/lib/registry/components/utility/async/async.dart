// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:flutter/widgets.dart';

/// Builds widgets based on a [FutureOr] snapshot.
///
/// Useful when you need to render either a synchronous value or wait for a
/// future without duplicating the handling logic.
typedef FutureOrWidgetBuilder<T> =
    Widget Function(BuildContext context, AsyncSnapshot<T> snapshot);

/// A widget that renders based on a [FutureOr] value.
///
/// If the provided value is already available, the builder runs immediately.
/// Otherwise it falls back to [FutureBuilder] until the future completes.
class FutureOrBuilder<T> extends StatelessWidget {
  /// Creates a [FutureOrBuilder].
  const FutureOrBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.initialValue,
  });

  /// The synchronous or asynchronous value to track.
  final FutureOr<T> future;

  /// Called with the current snapshot when the value changes.
  final FutureOrWidgetBuilder<T> builder;

  /// Optional initial data used before the future completes.
  final T? initialValue;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (future is Future<T>) {
      return FutureBuilder<T>(
        future: future as Future<T>,
        initialData: initialValue,
        builder: builder,
      );
    }
    return builder(
      context,
      AsyncSnapshot.withData(ConnectionState.done, future as T),
    );
  }
}
