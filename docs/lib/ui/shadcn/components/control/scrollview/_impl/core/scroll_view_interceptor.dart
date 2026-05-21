// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../state/scroll_view_interceptor_state.dart';

/// Widget that intercepts scroll events to simulate middle-button drag scrolling.
class ScrollViewInterceptor extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `enabled` state/configuration for this implementation.
  final bool enabled;

  /// Creates a `ScrollViewInterceptor` instance.
  const ScrollViewInterceptor({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ScrollViewInterceptor> createState() => ScrollViewInterceptorState();
}
