// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../state/hover_activity_state.dart';

/// A widget that tracks mouse hover state and triggers callbacks.
///
/// [HoverActivity] monitors when the mouse cursor enters, hovers over, and exits
/// its child widget, calling appropriate callbacks. The [onHover] callback can be
/// called repeatedly while hovering if [debounceDuration] is set.
///
/// Example:
/// ```dart
/// HoverActivity(
///   debounceDuration: Duration(milliseconds: 500),
///   onEnter: () => print('Mouse entered'),
///   onHover: () => print('Still hovering'),
///   onExit: () => print('Mouse exited'),
///   child: Container(
///     width: 100,
///     height: 100,
///     color: Colors.blue,
///   ),
/// )
/// ```
class HoverActivity extends StatefulWidget {
  /// The widget to track for hover events.
  final Widget child;

  /// Called periodically while hovering, at intervals of [debounceDuration].
  ///
  /// If [debounceDuration] is `null`, this is called only once on initial hover.
  final VoidCallback? onHover;

  /// Called when the mouse cursor exits the widget bounds.
  final VoidCallback? onExit;

  /// Called when the mouse cursor first enters the widget bounds.
  final VoidCallback? onEnter;

  /// Interval for repeated [onHover] callbacks while the cursor remains over the widget.
  ///
  /// If `null`, [onHover] is called only once when hover begins.
  final Duration? debounceDuration;

  /// Hit test behavior determining how this widget participates in pointer event handling.
  final HitTestBehavior? hitTestBehavior;

  /// Creates a [HoverActivity] widget.
  const HoverActivity({
    super.key,
    required this.child,
    this.onHover,
    this.onExit,
    this.onEnter,
    this.hitTestBehavior,
    this.debounceDuration,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<HoverActivity> createState() => HoverActivityState();
}
