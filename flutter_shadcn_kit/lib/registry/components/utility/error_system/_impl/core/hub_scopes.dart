// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Hub scopes: typed adapters that connect ErrorScope to AppErrorHub channels.
// Avoids passing raw string keys around and makes testing easy by swapping the scope implementation.

import 'package:flutter/foundation.dart';

import 'app_error.dart';
import 'app_error_hub.dart';
import 'error_scope.dart';

/// HubAppScope defines a reusable type for this registry module.
class HubAppScope implements ErrorScope {
  HubAppScope(this.key);

  /// Stores `key` state/configuration for this implementation.
  final String key;

  @override
  ValueNotifier<AppError?> get notifier => AppErrorHub.I.app(key);

  @override
  /// Executes `clear` behavior for this component/composite.
  void clear() => AppErrorHub.I.clearApp(key);
}

/// HubScreenScope defines a reusable type for this registry module.
class HubScreenScope implements DisposableErrorScope {
  HubScreenScope(this.key);

  /// Stores `key` state/configuration for this implementation.
  final String key;

  @override
  ValueNotifier<AppError?> get notifier => AppErrorHub.I.screen(key);

  @override
  /// Executes `clear` behavior for this component/composite.
  void clear() => AppErrorHub.I.clearScreen(key);

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() => AppErrorHub.I.disposeScreen(key);
}
