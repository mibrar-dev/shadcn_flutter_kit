import 'package:flutter/widgets.dart';

import '../web_bridge.dart';
import 'ease.dart';

/// Publish the effective reduced-motion decision to the subtree.
///
/// The decision is the OR of:
///  * the web `prefers-reduced-motion` probe ([webPrefersReducedMotion],
///    read once at startup — the mockups' JS does the same), and
///  * [MediaQuery.disableAnimations]. The probe is needed because Flutter's
///    web engine does not always surface the browser preference through
///    accessibility features.
///
/// Widgets that animate read it through [MotionScope.of] or the
/// [ReduceMotionContext] helpers so "no transforms, opacity only, ≤150ms"
/// holds everywhere. Tests can force a value with [prefersReducedMotion].
class MotionScope extends StatelessWidget {
  /// Wraps [child], computing the effective reduced-motion flag.
  const MotionScope({
    super.key,
    required this.child,
    this.prefersReducedMotion,
  });

  /// The wrapped subtree.
  final Widget child;

  /// Test/override hook: when non-null it replaces the platform probes.
  final bool? prefersReducedMotion;

  @override
  Widget build(BuildContext context) {
    final bool reduced =
        prefersReducedMotion ??
        webPrefersReducedMotion() || MediaQuery.disableAnimationsOf(context);
    return _MotionScope(reduceMotion: reduced, child: child);
  }

  /// Whether animations should be reduced in the given [context].
  static bool of(BuildContext context) {
    final _MotionScope? scope = context
        .dependOnInheritedWidgetOfExactType<_MotionScope>();
    return scope?.reduceMotion ?? MediaQuery.disableAnimationsOf(context);
  }
}

class _MotionScope extends InheritedWidget {
  const _MotionScope({required this.reduceMotion, required super.child});

  final bool reduceMotion;

  @override
  bool updateShouldNotify(_MotionScope oldWidget) =>
      oldWidget.reduceMotion != reduceMotion;
}

/// Ergonomic access to the motion decision + spec-capped durations.
extension ReduceMotionContext on BuildContext {
  /// See [MotionScope.of].
  bool get reduceMotion => MotionScope.of(this);

  /// [normal] when motion is allowed, else capped at 150ms (opacity-only).
  Duration motionDuration(Duration normal) =>
      reduceMotion && normal > kDurationFast ? kDurationFast : normal;

  /// The transform distance for a `slide in`; zero when motion is reduced so
  /// only the fade remains.
  double motionOffset(double normal) => reduceMotion ? 0 : normal;
}
