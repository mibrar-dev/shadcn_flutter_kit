// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorAction: describes a user action rendered by error UI (Retry/Login/Settings/etc.).
// Factories set sensible defaults (label/icon/type/primary) for common actions.

import 'package:flutter/widgets.dart';

import '../../../../../shared/icons/radix_icons.dart';

/// ErrorAction defines a reusable type for this registry module.
class ErrorAction {
  /// Creates a `ErrorAction` instance.
  const ErrorAction({
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.icon,
    this.type = ErrorActionType.custom,
  });

  /// Stores `label` state/configuration for this implementation.
  final String label;

  /// Stores `onPressed` state/configuration for this implementation.
  final VoidCallback onPressed;

  /// Stores `primary` state/configuration for this implementation.
  final bool primary;

  /// Stores `icon` state/configuration for this implementation.
  final IconData? icon;

  /// Stores `type` state/configuration for this implementation.
  final ErrorActionType type;

  /// Factory constructor that creates `ErrorAction.retry` instances.
  factory ErrorAction.retry(VoidCallback onRetry) {
    return ErrorAction(
      label: 'Retry',
      onPressed: onRetry,
      primary: true,
      icon: RadixIcons.reload,
      type: ErrorActionType.retry,
    );
  }

  /// Factory constructor that creates `ErrorAction.report` instances.
  factory ErrorAction.report(VoidCallback onReport) {
    return ErrorAction(
      label: 'Report',
      onPressed: onReport,
      icon: RadixIcons.questionMarkCircled,
      type: ErrorActionType.report,
    );
  }

  /// Factory constructor that creates `ErrorAction.back` instances.
  factory ErrorAction.back(VoidCallback onBack) {
    return ErrorAction(
      label: 'Go Back',
      onPressed: onBack,
      icon: RadixIcons.arrowLeft,
      type: ErrorActionType.navigate,
    );
  }

  /// Factory constructor that creates `ErrorAction.login` instances.
  factory ErrorAction.login(VoidCallback onLogin) {
    return ErrorAction(
      label: 'Log In',
      onPressed: onLogin,
      primary: true,
      icon: RadixIcons.enter,
      type: ErrorActionType.navigate,
    );
  }

  /// Factory constructor that creates `ErrorAction.settings` instances.
  factory ErrorAction.settings(VoidCallback onSettings) {
    return ErrorAction(
      label: 'Settings',
      onPressed: onSettings,
      icon: RadixIcons.gear,
      type: ErrorActionType.navigate,
    );
  }

  /// Factory constructor that creates `ErrorAction.contactSupport` instances.
  factory ErrorAction.contactSupport(VoidCallback onContact) {
    return ErrorAction(
      label: 'Contact Support',
      onPressed: onContact,
      icon: RadixIcons.chatBubble,
      type: ErrorActionType.navigate,
    );
  }

  /// Factory constructor that creates `ErrorAction.dismiss` instances.
  factory ErrorAction.dismiss(VoidCallback onDismiss) {
    return ErrorAction(
      label: 'Dismiss',
      onPressed: onDismiss,
      type: ErrorActionType.custom,
    );
  }
}

/// ErrorActionType enumerates fixed values used by this implementation.
enum ErrorActionType { retry, report, navigate, custom }
