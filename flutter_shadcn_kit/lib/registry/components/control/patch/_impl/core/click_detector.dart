// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../state/click_detector_state.dart';
import '../utils/click_details.dart';

/// A widget that detects and reports click events with multi-click support.
///
/// Wraps a child widget and detects tap gestures, tracking consecutive clicks
/// within a configurable threshold duration. Useful for implementing double-click,
/// triple-click, or other multi-click interactions.
///
/// Features:
/// - **Click Count Tracking**: Automatically counts consecutive clicks
/// - **Configurable Threshold**: Set maximum time between clicks
/// - **Flexible Behavior**: Customize hit test behavior
/// - **Simple Integration**: Wraps any widget with tap detection
///
/// The widget calls [onClick] with [ClickDetails] containing the click count
/// each time a tap is detected. The count resets to 1 if taps are spaced
/// beyond the [threshold] duration.
class ClickDetector extends StatefulWidget {
  /// Callback invoked when the child widget is clicked.
  ///
  /// Called with [ClickDetails] containing the current click count.
  /// If `null`, the detector is effectively disabled (no taps detected).
  final ClickCallback<ClickDetails>? onClick;

  /// The widget that receives click detection.
  ///
  /// This widget will be wrapped with gesture detection capabilities.
  final Widget child;

  /// How to behave during hit testing.
  ///
  /// Determines whether this detector should participate in hit testing
  /// and how it should behave. Defaults to [HitTestBehavior.deferToChild].
  final HitTestBehavior behavior;

  /// Maximum time between clicks to count as consecutive.
  ///
  /// When clicks occur within this duration, they increment the click count.
  /// When clicks are spaced beyond this duration, the count resets to 1.
  ///
  /// Defaults to 300 milliseconds, which is a common double-click threshold.
  final Duration threshold;

  /// Creates a click detector widget.
  ///
  /// Parameters:
  /// - [child]: The widget to wrap with click detection (required)
  /// - [onClick]: Callback for click events (optional)
  /// - [behavior]: Hit test behavior (defaults to [HitTestBehavior.deferToChild])
  /// - [threshold]: Max time between consecutive clicks (defaults to 300ms)
  const ClickDetector({
    super.key,
    this.onClick,
    required this.child,
    this.behavior = HitTestBehavior.deferToChild,
    this.threshold = const Duration(milliseconds: 300),
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ClickDetector> createState() => ClickDetectorState();
}
