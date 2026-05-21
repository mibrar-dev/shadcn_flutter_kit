// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorScope: typed handle to an error channel, avoiding string keys in UI/business logic.
// Use HubAppScope/HubScreenScope (hub_scopes.dart) or ScreenErrorScope widget to obtain one.

import 'package:flutter/foundation.dart';

import 'app_error.dart';

abstract interface class ErrorScope {
  /// Stores `notifier` state/configuration for this implementation.
  ValueNotifier<AppError?> get notifier;
  void clear();
}

abstract interface class DisposableErrorScope extends ErrorScope {
  void dispose();
}
