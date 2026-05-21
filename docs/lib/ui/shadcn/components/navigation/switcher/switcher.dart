// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
part '_impl/core/_switcher_transition.dart';
part '_impl/core/_switcher_parent_data.dart';
part '_impl/state/_switcher_state.dart';
part '_impl/core/_render_switcher_transition.dart';

/// A swipeable container that transitions between multiple child widgets.
///
/// [Switcher] provides smooth animated transitions between different views
/// with gesture-based navigation. Users can swipe to change the active view,
/// and the component supports all four axis directions for transitions.
///
/// Features include:
/// - Gesture-based drag navigation between views
/// - Smooth animated transitions with configurable duration and curve
/// - Support for all axis directions (up, down, left, right)
/// - Automatic snapping to the nearest index after dragging
/// - Programmatic control via index changes
///
/// The component uses a custom render object to handle smooth interpolation
/// between child sizes and positions during transitions.
///
/// **Note: This component is experimental and may change in future versions.**
///
/// Example:
/// ```dart
/// Switcher(
///   index: currentIndex,
///   direction: AxisDirection.right,
///   onIndexChanged: (newIndex) => setState(() => currentIndex = newIndex),
///   children: [
///     Container(color: Colors.red, child: Center(child: Text('Page 1'))),
///     Container(color: Colors.blue, child: Center(child: Text('Page 2'))),
///     Container(color: Colors.green, child: Center(child: Text('Page 3'))),
///   ],
/// );
/// ```
class Switcher extends StatefulWidget {
  /// Current active child index.
  final int index;

  /// Callback invoked when the active index changes through gestures.
  final ValueChanged<int>? onIndexChanged;

  /// Direction of the swipe transition animation.
  final AxisDirection direction;

  /// List of child widgets to switch between.
  final List<Widget> children;

  /// Duration of the transition animation.
  final Duration duration;

  /// Animation curve for the transition.
  final Curve curve;

  /// Creates a [Switcher].
  const Switcher({
    super.key,
    this.index = 0,
    required this.direction,
    required this.children,
    this.onIndexChanged,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Switcher> createState() => _SwitcherState();
}
