// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ScreenErrorScope: widget that owns a screen-level error channel and disposes it automatically.
// Provides a typed HubScreenScope plus run/runSync helpers so screens can publish AppError without guard().

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/app_error.dart';
import '../core/hub_scopes.dart';

/// ScreenErrorScope defines a reusable type for this registry module.
class ScreenErrorScope extends StatefulWidget {
  /// Creates a `ScreenErrorScope` instance.
  const ScreenErrorScope({
    super.key,
    required this.child,
    this.scopeKey,
    this.clearOnInit = false,
  });

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `scopeKey` state/configuration for this implementation.
  final String? scopeKey;

  /// Stores `clearOnInit` state/configuration for this implementation.
  final bool clearOnInit;

  /// Executes `of` behavior for this component/composite.
  static ScreenErrorScopeState of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_ScreenErrorScopeHost>();
    assert(scope != null, 'ScreenErrorScope.of() called with no ancestor.');
    return scope!.state;
  }

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ScreenErrorScope> createState() => ScreenErrorScopeState();
}

/// ScreenErrorScopeState defines a reusable type for this registry module.
class ScreenErrorScopeState extends State<ScreenErrorScope> {
  /// Stores `_counter` state/configuration for this implementation.
  static int _counter = 0;

  late final String _key =
      widget.scopeKey ??
      'screen.${DateTime.now().microsecondsSinceEpoch}-${_counter++}';
  late final HubScreenScope scope = HubScreenScope(_key);

  /// Stores `notifier` state/configuration for this implementation.
  ValueNotifier<AppError?> get notifier => scope.notifier;

  /// Executes `set` behavior for this component/composite.
  void set(AppError? error) => scope.notifier.value = error;

  /// Executes `clear` behavior for this component/composite.
  void clear() => scope.clear();

  Future<T?> run<T>(
    Future<T> Function() fn, {
    bool clearBeforeRun = true,
  }) async {
    if (clearBeforeRun) scope.clear();
    try {
      return await fn();
    } on AppError catch (e) {
      set(e);
      return null;
    }
  }

  T? runSync<T>(T Function() fn, {bool clearBeforeRun = true}) {
    if (clearBeforeRun) scope.clear();
    try {
      return fn();
    } on AppError catch (e) {
      set(e);
      return null;
    }
  }

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    if (widget.clearOnInit) {
      scope.clear();
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    scope.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return _ScreenErrorScopeHost(state: this, child: widget.child);
  }
}

/// _ScreenErrorScopeHost defines a reusable type for this registry module.
class _ScreenErrorScopeHost extends InheritedWidget {
  const _ScreenErrorScopeHost({required this.state, required super.child});

  /// Stores `state` state/configuration for this implementation.
  final ScreenErrorScopeState state;

  @override
  /// Executes `updateShouldNotify` behavior for this component/composite.
  bool updateShouldNotify(_ScreenErrorScopeHost oldWidget) => false;
}
