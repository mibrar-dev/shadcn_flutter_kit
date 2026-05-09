// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

double _normalizedProgress({
  required Duration age,
  required Duration duration,
  required Curve curve,
}) {
  if (duration <= Duration.zero) return 1;

  final raw = age.inMicroseconds / duration.inMicroseconds;
  final clamped = raw.clamp(0.0, 1.0).toDouble();
  return curve.transform(clamped);
}

/// Implements `_revealDelayForUnitIndex` behavior for text animate.
Duration _revealDelayForUnitIndex(int index, TypewriterEffect typewriter) {
  if (!typewriter.enabled || typewriter.charsPerSecond <= 0 || index <= 0) {
    return Duration.zero;
  }
  final micros =
      (index / typewriter.charsPerSecond) * Duration.microsecondsPerSecond;
  return Duration(microseconds: micros.round());
}

int _visibleUnitCount({
  required int total,
  required Duration elapsed,
  required TypewriterEffect typewriter,
}) {
  if (total <= 0) return 0;
  if (!typewriter.enabled || typewriter.charsPerSecond <= 0) {
    return total;
  }

  final micros = elapsed.inMicroseconds;
  if (micros <= 0) {
    return 1;
  }
  final revealed =
      ((micros / Duration.microsecondsPerSecond) * typewriter.charsPerSecond)
          .floor() +
      1;
  return revealed.clamp(0, total).toInt();
}
