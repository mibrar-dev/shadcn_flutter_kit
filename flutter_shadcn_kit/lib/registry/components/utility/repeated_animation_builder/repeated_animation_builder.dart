// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../shared/utils/util.dart' as util;

/// Type alias for `RepeatedAnimationBuilder` used by public or internal APIs.
typedef RepeatedAnimationBuilder = util.RepeatedAnimationBuilder;

/// A ready-to-use repeated fade + scale composite animation wrapper.
class PulsingAnimation extends StatelessWidget {
  /// Creates a `PulsingAnimation` instance.
  const PulsingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeInOut,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.minOpacity = 0.7,
    this.maxOpacity = 1,
  });

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  /// Stores `curve` state/configuration for this implementation.
  final Curve curve;

  /// Stores `minScale` state/configuration for this implementation.
  final double minScale;

  /// Stores `maxScale` state/configuration for this implementation.
  final double maxScale;

  /// Stores `minOpacity` state/configuration for this implementation.
  final double minOpacity;

  /// Stores `maxOpacity` state/configuration for this implementation.
  final double maxOpacity;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return RepeatedAnimationBuilder(
      start: 0,
      end: 1,
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, value, child) {
        final scale = minScale + (maxScale - minScale) * value;
        final opacity = minOpacity + (maxOpacity - minOpacity) * value;
        return Opacity(
          opacity: opacity.clamp(0, 1),
          child: Transform.scale(scale: scale, child: child),
        );
      },
    );
  }
}
