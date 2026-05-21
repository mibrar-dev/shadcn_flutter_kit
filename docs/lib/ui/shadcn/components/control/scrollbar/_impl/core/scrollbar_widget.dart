// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import 'shadcn_scrollbar.dart';

/// A customizable scrollbar widget.
class Scrollbar extends StatelessWidget {
  /// Creates a `Scrollbar` instance.
  const Scrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.color,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
  });

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `controller` state/configuration for this implementation.
  final ScrollController? controller;

  /// Stores `thumbVisibility` state/configuration for this implementation.
  final bool? thumbVisibility;

  /// Stores `trackVisibility` state/configuration for this implementation.
  final bool? trackVisibility;

  /// Stores `thickness` state/configuration for this implementation.
  final double? thickness;

  /// Stores `radius` state/configuration for this implementation.
  final Radius? radius;

  /// Stores `color` state/configuration for this implementation.
  final Color? color;

  /// Stores `interactive` state/configuration for this implementation.
  final bool? interactive;

  /// Stores `notificationPredicate` state/configuration for this implementation.
  final ScrollNotificationPredicate? notificationPredicate;

  /// Stores `scrollbarOrientation` state/configuration for this implementation.
  final ScrollbarOrientation? scrollbarOrientation;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return ShadcnScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thickness: thickness,
      radius: radius,
      color: color,
      notificationPredicate: notificationPredicate,
      interactive: interactive,
      scrollbarOrientation: scrollbarOrientation,
      child: child,
    );
  }
}
