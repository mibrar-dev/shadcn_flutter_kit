// The `async` component: renders a value that may already be available or may
// still be loading, through a single builder.
//
// Ported from `components/utility/async/**`. The old module declared its own
// `FutureOrWidgetBuilder<T>` typedef — a second name for Flutter's
// `AsyncWidgetBuilder<T>` — and needed a suppress-all-lints pragma to
// compile. Both are gone; `initialData` now has an explicit contract.

import 'dart:async';

import 'package:flutter/widgets.dart';

/// Renders a [FutureOr] value through one builder.
///
/// A synchronous value is reported once as
/// `AsyncSnapshot(ConnectionState.done, value)`; a [Future] is delegated to
/// [FutureBuilder], which owns the waiting/error transitions.
///
/// ```dart
/// FutureOrBuilder<User>(
///   future: repository.load(id),
///   initialData: repository.cached(id),
///   builder: (context, snapshot) => switch (snapshot.connectionState) {
///     ConnectionState.waiting || ConnectionState.none => const SizedBox(),
///     _ => Text(snapshot.data?.name ?? 'Unknown'),
///   },
/// )
/// ```
class FutureOrBuilder<T> extends StatelessWidget {
  /// Creates a builder for a synchronous or asynchronous value.
  const FutureOrBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.initialData,
  });

  /// The value to render: an already-available `T`, or a `Future<T>`.
  final FutureOr<T> future;

  /// Called with the current snapshot. Runs synchronously for a plain value
  /// and on every [Future] transition otherwise.
  final AsyncWidgetBuilder<T> builder;

  /// Value reported while a [Future] is still pending.
  ///
  /// Only consulted on the asynchronous path; a synchronous value is always
  /// complete, so the snapshot carries [future] itself and never
  /// [initialData].
  final T? initialData;

  @override
  Widget build(BuildContext context) {
    final Object? value = future;
    if (value is Future<T>) {
      return FutureBuilder<T>(
        future: value,
        initialData: initialData,
        builder: builder,
      );
    }
    return builder(
      context,
      AsyncSnapshot<T>.withData(ConnectionState.done, future as T),
    );
  }
}
