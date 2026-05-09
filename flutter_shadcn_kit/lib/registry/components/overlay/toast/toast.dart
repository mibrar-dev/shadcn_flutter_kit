// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';

part '_impl/themes/base/toast_theme.dart';
part '_impl/core/toast_entry.dart';
part '_impl/utils/toast_controller.dart';
part '_impl/state/_toast_entry_state.dart';

/// Allowed gesture directions for swipe-to-dismiss toast behavior.
enum ToastSwipeDirection { up, down, left, right }

/// Compatibility location options for `showToast`.
enum ToastLocation {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Handle for closing a toast shown via `showToast`.
class ToastOverlay {
  const ToastOverlay(this.close);

  final VoidCallback close;
}

final ToastController _defaultToastController = ToastController();
int _toastSequence = 0;

/// Compatibility helper API used by docs/examples and installed projects.
void showToast({
  required BuildContext context,
  required Widget Function(BuildContext context, ToastOverlay overlay) builder,
  ToastLocation location = ToastLocation.topRight,
  Duration duration = const Duration(seconds: 3),
  double spacing = 8,
}) {
  final toastTheme = ComponentTheme.maybeOf<ToastTheme>(context);
  final resolvedDuration = toastTheme?.duration ?? duration;
  final resolvedSpacing = toastTheme?.margin ?? spacing;
  final toastId =
      'toast_${DateTime.now().microsecondsSinceEpoch}_${_toastSequence++}';

  final isTop = switch (location) {
    ToastLocation.topLeft ||
    ToastLocation.topCenter ||
    ToastLocation.topRight => true,
    _ => false,
  };
  final isCenter = switch (location) {
    ToastLocation.topCenter || ToastLocation.bottomCenter => true,
    _ => false,
  };
  final isLeft = switch (location) {
    ToastLocation.topLeft || ToastLocation.bottomLeft => true,
    _ => false,
  };

  final top = isTop ? 32.0 : null;
  final bottom = isTop ? null : 32.0;
  final left = isCenter ? 0.0 : (isLeft ? 24.0 : null);
  final right = isCenter ? 0.0 : (isLeft ? null : 24.0);

  late final ToastOverlay overlayHandle;
  overlayHandle = ToastOverlay(() {
    _defaultToastController.dismissById(toastId);
  });

  _defaultToastController.show(
    context: context,
    toastId: toastId,
    duration: resolvedDuration,
    spacing: resolvedSpacing,
    top: top,
    right: right,
    bottom: bottom,
    left: left,
    builder: (overlayContext) {
      final content = builder(overlayContext, overlayHandle);
      if (!isCenter) return content;
      return Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: content,
      );
    },
  );
}

/// Shared stack context for grouped toast overlays.
class ToastStackContext {
  const ToastStackContext({
    required this.expanded,
    required this.itemExpanded,
    required this.hasMultiple,
    required this.visibleCount,
    required this.isPrimary,
    required this.toggleExpanded,
    required this.setExpanded,
    required this.dismissAll,
  });

  final bool expanded;
  final bool itemExpanded;
  final bool hasMultiple;
  final int visibleCount;
  final bool isPrimary;
  final VoidCallback toggleExpanded;
  final ValueChanged<bool> setExpanded;
  final VoidCallback dismissAll;
}

/// Inherited scope that exposes stack interaction state to toast content.
class ToastStackScope extends InheritedWidget {
  const ToastStackScope({super.key, required this.data, required super.child});

  final ToastStackContext data;

  static ToastStackContext? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToastStackScope>()?.data;
  }

  @override
  bool updateShouldNotify(covariant ToastStackScope oldWidget) {
    return oldWidget.data.expanded != data.expanded ||
        oldWidget.data.itemExpanded != data.itemExpanded ||
        oldWidget.data.hasMultiple != data.hasMultiple ||
        oldWidget.data.visibleCount != data.visibleCount ||
        oldWidget.data.isPrimary != data.isPrimary;
  }
}
