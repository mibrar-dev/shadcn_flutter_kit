// Error channels for the `error_handling` primitive: the [AppErrorHub] bus, the
// typed [ErrorScope] handles and their hub-backed adapters.
//
// Ported from `components/utility/error_system/_impl/core/{app_error_hub,
// error_scope,hub_scopes}.dart`. The deprecated `global` / `scope` aliases are
// dropped (clean break).

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'error_models.dart';

/// A typed handle to an error channel.
abstract interface class ErrorScope {
  /// The channel.
  ValueNotifier<AppError?> get notifier;

  /// Clears the channel.
  void clear();
}

/// An [ErrorScope] that owns its channel.
abstract interface class DisposableErrorScope implements ErrorScope {
  /// Disposes the channel.
  void dispose();
}

/// Singleton bus of [AppError] channels.
///
/// Use [app] for global, cross-navigation errors and [screen] for per-screen
/// channels (dispose via [disposeScreen] or a screen-scope widget).
class AppErrorHub {
  AppErrorHub._();

  /// The shared instance.
  static final AppErrorHub I = AppErrorHub._();

  /// Channel key for a session that expired.
  static const String sessionExpired = 'app.sessionExpired';

  /// Channel key for maintenance mode.
  static const String maintenanceMode = 'app.maintenanceMode';

  /// Channel key for an unavailable network.
  static const String networkUnavailable = 'app.networkUnavailable';

  /// Channel key for a critical update.
  static const String criticalUpdate = 'app.criticalUpdate';

  /// Channel key for a denied permission.
  static const String permissionDenied = 'app.permissionDenied';

  final Map<String, ValueNotifier<AppError?>> _appScopes =
      <String, ValueNotifier<AppError?>>{};
  final Map<String, ValueNotifier<AppError?>> _screenScopes =
      <String, ValueNotifier<AppError?>>{};

  /// A persistent app-level channel.
  ValueNotifier<AppError?> app(String key) =>
      _appScopes.putIfAbsent(key, () => ValueNotifier<AppError?>(null));

  /// Clears an app-level channel.
  void clearApp(String key) => _appScopes[key]?.value = null;

  /// Clears every app-level channel.
  void clearAllApp() {
    for (final ValueNotifier<AppError?> notifier in _appScopes.values) {
      notifier.value = null;
    }
  }

  /// Whether any app-level channel currently holds an error.
  bool get hasAppError =>
      _appScopes.values.any((ValueNotifier<AppError?> n) => n.value != null);

  /// Every non-null app-level error.
  List<AppError> get activeAppErrors => <AppError>[
    for (final ValueNotifier<AppError?> n in _appScopes.values)
      if (n.value != null) n.value!,
  ];

  /// A screen-level channel; dispose it with [disposeScreen].
  ValueNotifier<AppError?> screen(String key) =>
      _screenScopes.putIfAbsent(key, () => ValueNotifier<AppError?>(null));

  /// Clears a screen-level channel.
  void clearScreen(String key) => _screenScopes[key]?.value = null;

  /// Clears every screen-level channel.
  void clearAllScreens() {
    for (final ValueNotifier<AppError?> notifier in _screenScopes.values) {
      notifier.value = null;
    }
  }

  /// Disposes a screen-level channel.
  void disposeScreen(String key) => _screenScopes.remove(key)?.dispose();

  /// Disposes every screen-level channel.
  void disposeAllScreens() {
    for (final ValueNotifier<AppError?> notifier in _screenScopes.values) {
      notifier.dispose();
    }
    _screenScopes.clear();
  }
}

/// An [ErrorScope] backed by an app-level [AppErrorHub] channel.
class HubAppScope implements ErrorScope {
  /// Creates an app scope for [key].
  HubAppScope(this.key);

  /// Channel key.
  final String key;

  @override
  ValueNotifier<AppError?> get notifier => AppErrorHub.I.app(key);

  @override
  void clear() => AppErrorHub.I.clearApp(key);
}

/// An [ErrorScope] backed by a screen-level [AppErrorHub] channel.
class HubScreenScope implements DisposableErrorScope {
  /// Creates a screen scope for [key].
  HubScreenScope(this.key);

  /// Channel key.
  final String key;

  @override
  ValueNotifier<AppError?> get notifier => AppErrorHub.I.screen(key);

  @override
  void clear() => AppErrorHub.I.clearScreen(key);

  @override
  void dispose() => AppErrorHub.I.disposeScreen(key);
}

/// Owns a screen-level error channel and disposes it on unmount.
///
/// A widget, but non-visual (it only provides the scope), so it lives with the
/// rest of the scope machinery.
class ScreenErrorScope extends StatefulWidget {
  /// Creates a screen error scope.
  const ScreenErrorScope({
    super.key,
    required this.child,
    this.scopeKey,
    this.clearOnInit = false,
  });

  /// Subtree that can read the scope.
  final Widget child;

  /// Explicit channel key; a unique key is generated when null.
  final String? scopeKey;

  /// Whether the channel is cleared when the scope mounts.
  final bool clearOnInit;

  /// The nearest [ScreenErrorScopeState].
  static ScreenErrorScopeState of(BuildContext context) {
    final _ScreenErrorScopeHost? host = context
        .dependOnInheritedWidgetOfExactType<_ScreenErrorScopeHost>();
    assert(host != null, 'ScreenErrorScope.of() called with no ancestor.');
    return host!.state;
  }

  @override
  State<ScreenErrorScope> createState() => ScreenErrorScopeState();
}

/// State of a [ScreenErrorScope].
class ScreenErrorScopeState extends State<ScreenErrorScope> {
  static int _counter = 0;

  late final HubScreenScope scope = HubScreenScope(
    widget.scopeKey ??
        'screen.${DateTime.now().microsecondsSinceEpoch}-${_counter++}',
  );

  /// The channel.
  ValueNotifier<AppError?> get notifier => scope.notifier;

  /// Publishes [error].
  void set(AppError? error) => scope.notifier.value = error;

  /// Clears the channel.
  void clear() => scope.clear();

  /// Runs [fn], publishing an [AppError] to this scope.
  Future<T?> run<T>(
    Future<T> Function() fn, {
    bool clearBeforeRun = true,
  }) async {
    if (clearBeforeRun) {
      scope.clear();
    }
    try {
      return await fn();
    } on AppError catch (error) {
      set(error);
      return null;
    }
  }

  /// The synchronous form of [run].
  T? runSync<T>(T Function() fn, {bool clearBeforeRun = true}) {
    if (clearBeforeRun) {
      scope.clear();
    }
    try {
      return fn();
    } on AppError catch (error) {
      set(error);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.clearOnInit) {
      scope.clear();
    }
  }

  @override
  void dispose() {
    scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _ScreenErrorScopeHost(state: this, child: widget.child);
}

class _ScreenErrorScopeHost extends InheritedWidget {
  const _ScreenErrorScopeHost({required this.state, required super.child});

  final ScreenErrorScopeState state;

  @override
  bool updateShouldNotify(_ScreenErrorScopeHost oldWidget) => false;
}
