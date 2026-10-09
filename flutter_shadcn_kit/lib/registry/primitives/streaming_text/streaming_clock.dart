// Frame clock and reveal timing for streaming text: typewriter pacing,
// effect progress, settle detection, the shared ticker mixin and the inline
// span builders. Widgets-only; no theme, no components.

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Reveal delay of unit [index]: units after the first wait for the
/// typewriter to reach them.
Duration streamingRevealDelay(
  int index, {
  required bool enabled,
  required double charsPerSecond,
}) {
  if (!enabled || charsPerSecond <= 0 || index <= 0) return Duration.zero;
  final micros = (index / charsPerSecond) * Duration.microsecondsPerSecond;
  return Duration(microseconds: micros.round());
}

/// Units visible after [elapsed]: everything when the typewriter is off, at
/// least one unit otherwise (the stream never renders empty while pending).
int streamingVisibleCount({
  required int total,
  required Duration elapsed,
  required bool enabled,
  required double charsPerSecond,
}) {
  if (total <= 0) return 0;
  if (!enabled || charsPerSecond <= 0) return total;
  if (elapsed.inMicroseconds <= 0) return 1;
  final revealed =
      ((elapsed.inMicroseconds / Duration.microsecondsPerSecond) *
              charsPerSecond)
          .floor() +
      1;
  return revealed.clamp(0, total).toInt();
}

/// Age of unit [index] after [elapsed]: zero until the typewriter reaches it.
Duration streamingUnitAge({
  required Duration elapsed,
  required int index,
  required bool enabled,
  required double charsPerSecond,
}) {
  final delay = streamingRevealDelay(
    index,
    enabled: enabled,
    charsPerSecond: charsPerSecond,
  );
  return elapsed > delay ? elapsed - delay : Duration.zero;
}

/// Age of the newest visible unit (drives whole-block effects).
Duration streamingNewestAge({
  required Duration elapsed,
  required int visible,
  required bool enabled,
  required double charsPerSecond,
}) {
  if (visible <= 0) return elapsed;
  return streamingUnitAge(
    elapsed: elapsed,
    index: visible - 1,
    enabled: enabled,
    charsPerSecond: charsPerSecond,
  );
}

/// Normalized effect progress of a unit of [age] over [duration].
double streamingProgress({
  required Duration age,
  required Duration duration,
  required Curve curve,
}) {
  if (duration <= Duration.zero) return 1;
  final raw = age.inMicroseconds / duration.inMicroseconds;
  return curve.transform(raw.clamp(0.0, 1.0).toDouble());
}

/// Whether a revision has settled: every unit revealed and the newest
/// unit's effect past [settleDuration].
bool streamingIsSettled({
  required Duration elapsed,
  required int totalAnimated,
  required int visibleAnimated,
  required bool typewriterEnabled,
  required double charsPerSecond,
  required Duration settleDuration,
}) {
  if (totalAnimated == 0) return true;
  if (visibleAnimated < totalAnimated) return false;
  if (settleDuration <= Duration.zero) return true;
  final age = streamingUnitAge(
    elapsed: elapsed,
    index: totalAnimated - 1,
    enabled: typewriterEnabled,
    charsPerSecond: charsPerSecond,
  );
  return age >= settleDuration;
}

/// Whether a blinking cursor is in its visible half at [now].
bool streamingCursorBlinkOn({
  required Duration now,
  required Duration blinkPeriod,
}) {
  if (blinkPeriod.inMicroseconds <= 0) return true;
  return now.inMicroseconds % blinkPeriod.inMicroseconds <
      blinkPeriod.inMicroseconds ~/ 2;
}

/// Frame clock shared by the streaming widgets: a vsync ticker advancing a
/// monotonic clock plus one-shot settle notifications.
///
/// The ticker (not a wall-clock `Stopwatch`) drives reveal ages so pacing
/// follows fake time in widget tests and pauses offscreen. Ticks rebuild at
/// most every 16 ms. Under reduced motion (`MediaQuery.disableAnimations`)
/// the ticker never starts: callers render the settled frame instead.
///
/// States using this must also mix in [SingleTickerProviderStateMixin]
/// before it: `with SingleTickerProviderStateMixin, StreamingClock<X>`.
mixin StreamingClock<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  /// Monotonic clock reading; reveal ages are `now - snapshot.changedAt`.
  /// Accumulated by hand because a restarted ticker counts from zero again.
  Duration get streamingNow => _streamingElapsed;
  Duration _streamingElapsed = Duration.zero;
  Duration _streamingLastTickValue = Duration.zero;
  Duration _streamingLastTick = Duration.zero;

  /// True when the ambient `MediaQuery` requests reduced motion.
  bool get streamingReducedMotion => _streamingReducedMotion;
  bool _streamingReducedMotion = false;

  Ticker? _streamingTicker;
  int _streamingNotifiedRevision = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streamingReducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_streamingReducedMotion) _stopStreamingTicker();
  }

  @override
  void dispose() {
    _streamingTicker?.dispose();
    _streamingTicker = null;
    super.dispose();
  }

  /// Runs the ticker while [shouldTick]; each tick advances the clock and
  /// rebuilds (throttled to ~60 Hz). Stops it otherwise.
  void syncStreamingTicker(bool shouldTick) {
    if (!shouldTick || _streamingReducedMotion) {
      _stopStreamingTicker();
      return;
    }
    final ticker = _streamingTicker ??= createTicker(_onStreamingTick);
    if (!ticker.isActive) {
      _streamingLastTickValue = Duration.zero;
      ticker.start();
    }
  }

  void _onStreamingTick(Duration elapsed) {
    final delta = elapsed - _streamingLastTickValue;
    _streamingLastTickValue = elapsed;
    if (delta <= Duration.zero) return;
    _streamingElapsed += delta;
    if (_streamingElapsed - _streamingLastTick <
        const Duration(milliseconds: 16)) {
      return;
    }
    _streamingLastTick = _streamingElapsed;
    setState(() {});
  }

  void _stopStreamingTicker() {
    _streamingTicker?.stop();
  }

  /// Fires [onSettled] with [text] once [settled] for [revision]. A return
  /// to unsettled (new revision, or a swapped effect replaying the same
  /// revision) re-arms, so a replayed animation reports settling again.
  void notifyStreamingSettled({
    required bool settled,
    required int revision,
    required String text,
    required ValueChanged<String>? onSettled,
  }) {
    if (!settled) {
      _streamingNotifiedRevision = -1;
      return;
    }
    if (onSettled == null) return;
    if (_streamingNotifiedRevision == revision) return;
    _streamingNotifiedRevision = revision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) onSettled(text);
    });
  }
}

/// Wraps an animated character widget as an inline span on the baseline.
InlineSpan streamingCharacterSpan({required Widget child}) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: child,
  );
}

/// Cursor span: the cursor character in the base style plus its override.
InlineSpan streamingCursorSpan({
  required String character,
  required TextStyle baseStyle,
  TextStyle? cursorStyle,
}) {
  return TextSpan(text: character, style: baseStyle.merge(cursorStyle));
}

/// Memoized content section: rebuilds only when its data changes, so a
/// settled section never rebuilds on animation frames.
class StreamingSectionCache {
  Widget? widget;
  String data = '';

  /// Returns the cached widget, rebuilding through [build] on new [data].
  Widget render(String data, Widget Function(String data) build) {
    if (widget == null || this.data != data) {
      this.data = data;
      widget = build(data);
    }
    return widget!;
  }

  /// Drops the cached widget (call when non-data config changes).
  void invalidate() {
    widget = null;
    data = '';
  }
}
