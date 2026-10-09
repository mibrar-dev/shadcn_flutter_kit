// The auto-dismiss countdown of one toast.
//
// Ported from the old `overlay/toast/_impl/core/toast_entry.dart` (timer
// ownership) and the `_GooeyToastRecord` bookkeeping in
// `overlay/gooey_toast/_impl/core/gooey_toast_controller.dart`
// (`_scheduleAutoDismiss`, `_pauseAutoDismiss`, `_resumeAutoDismiss`).

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'toast_placement.dart';

/// Bookkeeping for one live toast.
///
/// The queue owns the timer, the remaining pause budget and the ordering stamp;
/// everything else about rendering belongs to the component.
class ToastEntry<T> {
  /// Creates an entry.
  ToastEntry({
    required this.id,
    required this.slot,
    required this.data,
    required this.duration,
    this.autoDismiss = true,
    this.onDismissed,
    DateTime? shownAt,
  }) : shownAt = shownAt ?? DateTime.now();

  /// Stable identity of this toast.
  final String id;

  /// The slot the toast occupies.
  ToastSlot slot;

  /// The component-owned payload (title, state, widget, ...).
  T data;

  /// How long the toast stays up before auto-dismiss.
  Duration duration;

  /// Whether the queue dismisses the toast on a timer.
  bool autoDismiss;

  /// Called once when the toast leaves the queue, for any reason.
  final void Function(String id)? onDismissed;

  /// When the toast entered the queue; the LIFO sort key.
  DateTime shownAt;

  Timer? _timer;
  Duration? _remaining;
  DateTime? _startedAt;
  bool _interacting = false;
  bool _exiting = false;

  /// Whether the toast is playing its exit animation before removal.
  ///
  /// Set by [ToastQueue.dismiss]; the component animates the toast out and
  /// then calls [ToastQueue.remove], so the queue stays the single source of
  /// truth for what is on screen.
  bool get isExiting => _exiting;

  /// Starts the exit phase: stops the countdown and freezes interaction.
  void beginExit() {
    if (_exiting) {
      return;
    }
    _exiting = true;
    _interacting = false;
    cancelTimer();
    _remaining = null;
  }

  /// Whether the auto-dismiss countdown is currently paused.
  bool get isPaused => _interacting;

  /// The time left before auto-dismiss, or null when not counting down.
  Duration? get remaining => _remaining;

  /// Whether this toast has a countdown that can be paused.
  bool get hasCountdown => autoDismiss && duration > Duration.zero;

  /// Updates the payload and refreshes the countdown.
  ///
  /// Passing a new [duration] restarts the countdown from zero, which is what an
  /// in-place content update should do: the old `ToastController` bumped
  /// `refreshSignal` and left the original timer running, so an updated toast
  /// could vanish before the new content had been on screen at all.
  void update({T? data, Duration? duration, bool? autoDismiss}) {
    if (_exiting) {
      return;
    }
    if (data != null) {
      this.data = data;
    }
    if (duration != null) {
      this.duration = duration;
    }
    if (autoDismiss != null) {
      this.autoDismiss = autoDismiss;
    }
    // Always re-arm: a payload-only change restarts the countdown, and turning
    // auto-dismiss off has to cancel the running timer rather than leave it to
    // fire anyway.
    if (hasCountdown) {
      _restartCountdown();
    } else {
      cancelTimer();
      _remaining = null;
    }
  }

  /// Pauses or resumes the auto-dismiss countdown, keeping the remaining time.
  void setInteracting(bool value) {
    if (_exiting || _interacting == value) {
      return;
    }
    _interacting = value;
    if (value) {
      _pauseCountdown();
    } else {
      _resumeCountdown();
    }
  }

  /// Cancels the countdown without removing the toast.
  void pause() => setInteracting(true);

  /// Resumes a paused countdown.
  void resume() => setInteracting(false);

  /// Stops the countdown; the queue still owns removal.
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _startedAt = null;
  }

  /// Arms the countdown of a freshly shown toast.
  void start() => _restartCountdown();

  void _restartCountdown() {
    cancelTimer();
    _remaining = hasCountdown ? duration : null;
    if (!hasCountdown || _interacting) {
      return;
    }
    _armTimer(duration);
  }

  void _pauseCountdown() {
    if (!hasCountdown) {
      return;
    }
    final startedAt = _startedAt;
    if (startedAt != null) {
      final elapsed = DateTime.now().difference(startedAt);
      final next = (_remaining ?? duration) - elapsed;
      _remaining = next.isNegative ? Duration.zero : next;
    } else {
      _remaining ??= duration;
    }
    cancelTimer();
  }

  void _resumeCountdown() {
    if (!hasCountdown) {
      return;
    }
    final left = _remaining ?? duration;
    if (left <= Duration.zero) {
      _remaining = Duration.zero;
      return;
    }
    _armTimer(left);
  }

  void _armTimer(Duration time) {
    _startedAt = DateTime.now();
    _timer = Timer(time, onExpired);
  }

  /// Called by the countdown timer; the queue wires this to its own removal.
  VoidCallback onExpired = _noOp;

  static void _noOp() {}

  @override
  String toString() => 'ToastEntry($id, ${slot.placement.name})';
}
