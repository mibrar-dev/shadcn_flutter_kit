// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// AppErrorHub: singleton "error bus" that holds ValueNotifier<AppError?> channels.
// Use app(key) for global, cross-navigation errors; use screen(key) for per-screen channels (dispose via ScreenErrorScope or disposeScreen()).

import 'package:flutter/foundation.dart';

import 'app_error.dart';

/// AppErrorHub defines a reusable type for this registry module.
class AppErrorHub {
  AppErrorHub._();

  /// Global singleton instance.
  static final AppErrorHub I = AppErrorHub._();

  // -------------------------
  // App-level (global) scopes
  // -------------------------

  /// Predefined app-level channels.
  static const String sessionExpired = 'app.sessionExpired';

  /// Stores `maintenanceMode` state/configuration for this implementation.
  static const String maintenanceMode = 'app.maintenanceMode';

  /// Stores `networkUnavailable` state/configuration for this implementation.
  static const String networkUnavailable = 'app.networkUnavailable';

  /// Stores `criticalUpdate` state/configuration for this implementation.
  static const String criticalUpdate = 'app.criticalUpdate';

  /// Stores `permissionDenied` state/configuration for this implementation.
  static const String permissionDenied = 'app.permissionDenied';

  /// Stores `_appScopes` state/configuration for this implementation.
  final Map<String, ValueNotifier<AppError?>> _appScopes = {};

  /// Returns a persistent app-level channel.
  ValueNotifier<AppError?> app(String key) {
    return _appScopes.putIfAbsent(key, () => ValueNotifier<AppError?>(null));
  }

  /// Executes `clearApp` behavior for this component/composite.
  void clearApp(String key) => _appScopes[key]?.value = null;

  /// Executes `clearAllApp` behavior for this component/composite.
  void clearAllApp() {
    for (final notifier in _appScopes.values) {
      notifier.value = null;
    }
  }

  bool get hasAppError => _appScopes.values.any((n) => n.value != null);

  List<AppError> get activeAppErrors => _appScopes.values
      .where((n) => n.value != null)
      .map((n) => n.value!)
      .toList(growable: false);

  // ----------------------------
  // Screen-level (scoped) scopes
  // ----------------------------

  /// Stores `_screenScopes` state/configuration for this implementation.
  final Map<String, ValueNotifier<AppError?>> _screenScopes = {};

  /// Returns a screen-level channel.
  ///
  /// Call [disposeScreen] when the screen unmounts (or use [ScreenErrorScope]).
  ValueNotifier<AppError?> screen(String key) {
    return _screenScopes.putIfAbsent(key, () => ValueNotifier<AppError?>(null));
  }

  /// Executes `clearScreen` behavior for this component/composite.
  void clearScreen(String key) => _screenScopes[key]?.value = null;

  /// Executes `clearAllScreens` behavior for this component/composite.
  void clearAllScreens() {
    for (final notifier in _screenScopes.values) {
      notifier.value = null;
    }
  }

  /// Executes `disposeScreen` behavior for this component/composite.
  void disposeScreen(String key) {
    _screenScopes[key]?.dispose();
    _screenScopes.remove(key);
  }

  /// Executes `disposeAllScreens` behavior for this component/composite.
  void disposeAllScreens() {
    for (final notifier in _screenScopes.values) {
      notifier.dispose();
    }
    _screenScopes.clear();
  }

  // ------------------
  // Legacy convenience
  // ------------------

  /// Legacy global channel (maps to an app-level "global" key).
  @Deprecated(
    'Use app(key) for app-level or screen(key) for screen-level channels.',
  )
  ValueNotifier<AppError?> get global => app('global');

  /// Legacy scoped channel (maps to screen-level).
  @Deprecated('Use screen(key) for screen-level channels.')
  ValueNotifier<AppError?> scope(String key) => screen(key);
}
