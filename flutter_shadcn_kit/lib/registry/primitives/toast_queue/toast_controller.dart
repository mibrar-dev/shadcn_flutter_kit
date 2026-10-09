// The toast controller: a thin `show` surface over [ToastQueue].
//
// Shared by the `toast` component and (later) `gooey_toast`, so neither
// component re-declares a controller or a queue. The context lookup and the
// widget stack stay in the component.

import 'package:flutter/widgets.dart';

import 'toast_placement.dart';
import 'toast_queue.dart';

/// Builds the content of one toast.
typedef ToastBuilder = Widget Function(BuildContext context);

/// Owns a toast stack and exposes a small `show` surface over [ToastQueue].
class ToastController extends ToastQueue<ToastBuilder> {
  /// Creates a controller.
  ToastController({
    super.defaultDuration = const Duration(seconds: 3),
    super.singlePerSlot = true,
  });

  /// Shows a toast and returns its id.
  String showToast({
    required ToastBuilder builder,
    ToastPlacement placement = ToastPlacement.bottomTrailing,
    Duration? duration,
    bool autoDismiss = true,
    String? id,
    VoidCallback? onDismissed,
  }) {
    return show(
      placement: placement,
      data: builder,
      id: id,
      duration: duration,
      autoDismiss: autoDismiss,
      onDismissed: onDismissed == null ? null : (_) => onDismissed(),
    ).id;
  }
}
