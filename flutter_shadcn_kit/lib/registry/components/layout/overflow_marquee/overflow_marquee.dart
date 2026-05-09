// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
part '_impl/core/_overflow_marquee_layout.dart';
part '_impl/core/_overflow_marquee_parent_data.dart';
part '_impl/state/_overflow_marquee_state.dart';
part '_impl/core/overflow_marquee_2.dart';
part '_impl/core/_render_overflow_marquee_layout.dart';

/// Theme configuration for [OverflowMarquee] scrolling text displays.
///
/// Provides comprehensive styling and behavior options for marquee animations
/// including scroll direction, timing, fade effects, and animation curves.
/// All properties are optional and will fall back to default values when not specified.
///
/// Animation Properties:
/// - [direction]: Horizontal or vertical scrolling axis
/// - [duration]: Complete cycle time for one full scroll
/// - [delayDuration]: Pause time before restarting animation
/// - [curve]: Easing function for smooth animation transitions
///
/// Visual Properties:
/// - [step]: Pixel step size for scroll speed calculation
/// - [fadePortion]: Edge fade effect intensity (0.0 to 1.0)
///
/// Example:
/// ```dart
/// OverflowMarqueeTheme(
///   direction: Axis.horizontal,
///   duration: Duration(seconds: 5),
///   delayDuration: Duration(seconds: 1),
///   fadePortion: 0.1,
///   curve: Curves.easeInOut,
/// )
/// ```
class OverflowMarqueeTheme extends ComponentThemeData {
  /// Scrolling direction of the marquee.
  final Axis? direction;

  /// Duration of one full scroll cycle.
  final Duration? duration;

  /// Delay before scrolling starts again.
  final Duration? delayDuration;

  /// Step size used to compute scroll speed.
  final double? step;

  /// Portion of the child to fade at the edges.
  final double? fadePortion;

  /// Animation curve of the scroll.
  final Curve? curve;

  /// Creates an [OverflowMarqueeTheme].
  const OverflowMarqueeTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.duration,
    this.delayDuration,
    this.step,
    this.fadePortion,
    this.curve,
  });

  /// Creates a copy of this theme with the given fields replaced.
  OverflowMarqueeTheme copyWith({
    ValueGetter<Axis?>? direction,
    ValueGetter<Duration?>? duration,
    ValueGetter<Duration?>? delayDuration,
    ValueGetter<double?>? step,
    ValueGetter<double?>? fadePortion,
    ValueGetter<Curve?>? curve,
  }) {
    return OverflowMarqueeTheme(
      direction: direction == null ? this.direction : direction(),
      duration: duration == null ? this.duration : duration(),
      delayDuration: delayDuration == null
          ? this.delayDuration
          : delayDuration(),
      step: step == null ? this.step : step(),
      fadePortion: fadePortion == null ? this.fadePortion : fadePortion(),
      curve: curve == null ? this.curve : curve(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OverflowMarqueeTheme &&
        other.direction == direction &&
        other.duration == duration &&
        other.delayDuration == delayDuration &&
        other.step == step &&
        other.fadePortion == fadePortion &&
        other.curve == curve;
  }

  @override
  int get hashCode =>
      Object.hash(direction, duration, delayDuration, step, fadePortion, curve);
}

/// Automatically scrolling widget for content that overflows its container.
///
/// Creates smooth, continuous scrolling animation for content that exceeds the
/// available space. Commonly used for long text labels, news tickers, or any
/// content that needs horizontal or vertical scrolling to be fully visible.
///
/// Key Features:
/// - **Auto-scroll Detection**: Only animates when content actually overflows
/// - **Bi-directional Support**: Horizontal and vertical scrolling modes
/// - **Edge Fading**: Smooth fade effects at container boundaries
/// - **Customizable Timing**: Configurable duration, delay, and animation curves
/// - **Performance Optimized**: Uses Flutter's Ticker system for smooth 60fps animation
/// - **Theme Integration**: Respects OverflowMarqueeTheme configuration
///
/// Animation Behavior:
/// 1. Measures content size vs. container size
/// 2. If content fits, displays normally without animation
/// 3. If content overflows, starts continuous scrolling animation
/// 4. Scrolls content from start to end position
/// 5. Pauses briefly (delayDuration) before restarting
/// 6. Applies edge fade effects for smooth visual transitions
///
/// The widget automatically handles text direction (RTL/LTR) and adapts
/// scroll behavior accordingly for proper internationalization support.
///
/// Example:
/// ```dart
/// OverflowMarquee(
///   direction: Axis.horizontal,
///   duration: Duration(seconds: 8),
///   delayDuration: Duration(seconds: 2),
///   fadePortion: 0.15,
///   child: Text(
///     'This is a very long text that will scroll horizontally when it overflows the container',
///     style: TextStyle(fontSize: 16),
///   ),
/// )
/// ```
