// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../overflow_marquee.dart';

/// OverflowMarquee defines a reusable type for this registry module.
class OverflowMarquee extends StatefulWidget {
  /// The child widget to display and potentially scroll.
  final Widget child;

  /// Scroll direction (horizontal or vertical).
  ///
  /// If `null`, uses theme default or [Axis.horizontal].
  final Axis? direction;

  /// Total duration for one complete scroll cycle.
  ///
  /// If `null`, uses theme default.
  final Duration? duration;

  /// Distance to scroll per animation step.
  ///
  /// If `null`, scrolls the entire overflow amount.
  final double? step;

  /// Pause duration between scroll cycles.
  ///
  /// If `null`, uses theme default.
  final Duration? delayDuration;

  /// Portion of edges to apply fade effect (0.0 to 1.0).
  ///
  /// For example, 0.15 fades 15% of each edge. If `null`, uses theme default.
  final double? fadePortion;

  /// Animation curve for scroll motion.
  ///
  /// If `null`, uses theme default or [Curves.linear].
  final Curve? curve;

  /// Creates an [OverflowMarquee] widget with customizable scrolling behavior.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Content to display and potentially scroll
  /// - [direction] (Axis?, optional): Scroll direction, defaults to horizontal
  /// - [duration] (Duration?, optional): Time for one complete scroll cycle
  /// - [delayDuration] (Duration?, optional): Pause time before restarting animation
  /// - [step] (double?, optional): Step size for scroll speed calculation
  /// - [fadePortion] (double?, optional): Fade effect intensity at edges (0.0-1.0)
  /// - [curve] (Curve?, optional): Animation easing curve
  ///
  /// All optional parameters will use theme defaults or built-in fallback values
  /// when not explicitly provided.
  ///
  /// Example:
  /// ```dart
  /// OverflowMarquee(
  ///   duration: Duration(seconds: 10),
  ///   delayDuration: Duration(seconds: 1),
  ///   fadePortion: 0.2,
  ///   child: Text('Long scrolling text content'),
  /// )
  /// ```
  const OverflowMarquee({
    super.key,
    required this.child,
    this.direction,
    this.duration,
    this.delayDuration,
    this.step,
    this.fadePortion,
    this.curve,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<OverflowMarquee> createState() => _OverflowMarqueeState();
}
