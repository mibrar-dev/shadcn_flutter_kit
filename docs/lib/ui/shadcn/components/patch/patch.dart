// The `patch` component: tap counting for multi-click gestures.
//
// Ported from `components/control/patch/**`. Fixes, all verified against the
// old source:
//   * `ClickDetectorState` was a public `State` with public mutable `count` /
//     `lastClick` fields — any app code could corrupt the click count. The
//     state is private now.
//   * The threshold used `DateTime.now()`, wall-clock time. A clock change
//     (NTP, DST, a user editing the date) reset or extended a click sequence.
//     The gap is now measured with a [Stopwatch], which reads the VM's
//     monotonic clock and cannot be moved by the user.
//   * The count never considered *where* the tap landed, so two taps at
//     opposite ends of a large canvas inside `threshold` read as a double
//     click. Taps further apart than [kDoubleTapSlop] now restart the count.
//   * `ClickDetails` had no `==`/`hashCode`, so callers could not compare two
//     events.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Details about one detected click.
class ClickDetails {
  /// Creates click details.
  const ClickDetails({required this.clickCount, this.localPosition});

  /// Consecutive clicks seen inside `ClickDetector.threshold`; `1` for the
  /// first click of a sequence.
  final int clickCount;

  /// Where the click landed, in the detector's local coordinates.
  final Offset? localPosition;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ClickDetails &&
        other.clickCount == clickCount &&
        other.localPosition == localPosition;
  }

  @override
  int get hashCode => Object.hash(clickCount, localPosition);

  @override
  String toString() =>
      'ClickDetails(clickCount: $clickCount, localPosition: $localPosition)';
}

/// Callback for a detected click.
///
/// [T] is the details type; [ClickDetector] passes [ClickDetails].
typedef ClickCallback<T> = void Function(T details);

/// Counts consecutive taps inside a time and distance window.
///
/// ```dart
/// ClickDetector(
///   threshold: const Duration(milliseconds: 300),
///   onClick: (ClickDetails details) => print(details.clickCount),
///   child: tile,
/// )
/// ```
///
/// A click is part of the current sequence when it arrives within
/// [threshold] of the previous one **and** within [kDoubleTapSlop] of it. The
/// first click of a sequence reports `clickCount: 1`.
class ClickDetector extends StatefulWidget {
  /// Creates a click counter.
  const ClickDetector({
    super.key,
    this.onClick,
    required this.child,
    this.behavior = HitTestBehavior.deferToChild,
    this.threshold = const Duration(milliseconds: 300),
  });

  /// Called for every tap with the running click count. A null callback
  /// disables the detector, so no gesture recogniser is built.
  final ClickCallback<ClickDetails>? onClick;

  /// The widget that receives the clicks.
  final Widget child;

  /// How to behave during hit testing.
  final HitTestBehavior behavior;

  /// Longest gap between two clicks that still counts as consecutive.
  final Duration threshold;

  @override
  State<ClickDetector> createState() => _ClickDetectorState();
}

class _ClickDetectorState extends State<ClickDetector> {
  /// Monotonic clock started with the widget; a [Stopwatch] reads the VM's
  /// monotonic clock, so it cannot be moved by a system clock change the way
  /// `DateTime.now()` can.
  final Stopwatch _clock = Stopwatch()..start();

  /// Elapsed time of the last counted click; null before the first one.
  Duration? _lastClickAt;
  Offset? _lastPosition;
  int _count = 0;

  @override
  void dispose() {
    _clock.stop();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    final Duration now = _clock.elapsed;
    final Duration? last = _lastClickAt;
    final Offset? previous = _lastPosition;
    final bool consecutive =
        last != null &&
        now - last <= widget.threshold &&
        (previous == null ||
            (details.localPosition - previous).distance <= kDoubleTapSlop);
    _count = consecutive ? _count + 1 : 1;
    _lastClickAt = now;
    _lastPosition = details.localPosition;
    widget.onClick?.call(
      ClickDetails(clickCount: _count, localPosition: details.localPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: widget.onClick == null ? null : _handleTap,
      child: widget.child,
    );
  }
}
