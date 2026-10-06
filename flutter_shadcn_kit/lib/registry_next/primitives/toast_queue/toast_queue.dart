// The shared toast stack: ids, slots, ordering and dismissal.
//
// Ported from the old `overlay/toast/_impl/utils/toast_controller.dart`
// (entries, group keys, id updates) and the record bookkeeping of
// `overlay/gooey_toast/_impl/core/gooey_toast_controller.dart` (newest-first
// order, slot queries).
//
// The queue holds no overlay entries and no widgets: it decides *what* is in the
// stack and *when* a toast goes away. The route/overlay mechanism stays with
// `OverlayManager` and the components.

import 'package:flutter/foundation.dart';

import 'toast_entry.dart';
import 'toast_placement.dart';

/// The toast stack: which toasts are live, in which slot, and when they expire.
///
/// The queue is presentation-free on purpose. A component shows a toast by
/// calling [show], watches [entries] for the current list, and lets the queue
/// decide about dismissal. Both old controllers kept their entries in private
/// maps with their own `_nonce` counters; those counters are per-queue here, so
/// two queues in one app never collide and neither needs a global.
///
/// ## Auto-dismiss policy (the `toast` and `gooey_toast` house rule)
///
/// Both components MUST behave the same way; this is the single rule for the
/// whole registry:
///
/// 1. A toast's countdown runs on its own. It is never shortened, restarted or
///    cancelled by a neighbour arriving in the same slot.
/// 2. While the user interacts with one toast (pointer down, hover when the
///    component enables `pauseOnHover`), that toast alone pauses via
///    [setInteracting]; its remaining budget is preserved and resumes from there.
/// 3. When a slot holds more than one toast, the **non-primary** toasts pause
///    (the primary is `entriesIn(slot).first`, the newest) and resume as soon as
///    the slot is down to one again — [pauseSlot] and [resumeSlot] do this, with
///    `selector: (entry) => !isPrimary(entry)` if the component needs the newest
///    to keep counting while the component itself is on screen.
///
/// Rationale: a stacked toast that is covered by a newer one is not being read,
/// so letting it expire under the user's eyes loses the message; the toast the
/// user is actually looking at must keep its full budget. The old
/// `pauseAutoDismissWhenMultiple` flag was read from inside the gooey controller
/// and had no counterpart in `ToastController`, so the two components disagreed;
/// the rule now lives here.
class ToastQueue<T> extends ChangeNotifier {
  /// Creates a queue.
  ///
  /// [singlePerSlot] dismisses the previous toast in a slot when a new one
  /// arrives there, matching the old `singleToastPerGroup` behaviour.
  ToastQueue({
    this.defaultDuration = const Duration(seconds: 3),
    this.singlePerSlot = true,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// Duration used when [show] is called without one.
  final Duration defaultDuration;

  /// Whether a new toast replaces the toast already in its slot.
  final bool singlePerSlot;

  final DateTime Function() _clock;
  final Map<String, ToastEntry<T>> _entries = <String, ToastEntry<T>>{};
  final Map<ToastSlot, String> _slotActive = <ToastSlot, String>{};
  int _nonce = 0;

  /// The live toasts, newest first.
  List<ToastEntry<T>> get entries {
    final list = _entries.values.toList()
      ..sort((a, b) => b.shownAt.compareTo(a.shownAt));
    return List<ToastEntry<T>>.unmodifiable(list);
  }

  /// The live ids, newest first.
  List<String> get activeIds =>
      entries.map((entry) => entry.id).toList(growable: false);

  /// Whether [id] is currently in the queue.
  bool contains(String id) => _entries.containsKey(id);

  /// The entry for [id], or null.
  ToastEntry<T>? entryOf(String id) => _entries[id];

  /// The live toasts in [slot], newest first.
  List<ToastEntry<T>> entriesIn(ToastSlot slot) =>
      entries.where((entry) => entry.slot == slot).toList(growable: false);

  /// Whether [slot] holds at least one toast.
  bool slotOccupied(ToastSlot slot) => _slotActive.containsKey(slot);

  /// A fresh unique id, for callers that do not supply their own.
  String nextId() => 'toast_${_nonce++}';

  /// Shows a toast and returns its entry.
  ///
  /// Passing an id that is already live updates that toast in place instead of
  /// adding a second one, which is how the old controller avoided the
  /// remove/add flicker. [data] replaces the payload and [duration] restarts the
  /// countdown.
  ToastEntry<T> show({
    required ToastPlacement placement,
    T? data,
    String? id,
    Duration? duration,
    bool autoDismiss = true,
    void Function(String id)? onDismissed,
  }) {
    final slot = ToastSlot(placement);
    final resolvedId = id ?? nextId();
    final resolvedDuration = duration ?? defaultDuration;

    final existing = _entries[resolvedId];
    if (existing != null) {
      final previousSlot = existing.slot;
      existing
        ..slot = slot
        ..autoDismiss = autoDismiss
        ..update(data: data, duration: resolvedDuration)
        ..shownAt = _clock();
      if (previousSlot != slot && _slotActive[previousSlot] == resolvedId) {
        // The toast left its old slot; otherwise that slot stays occupied by an
        // id that no longer lives there.
        _slotActive.remove(previousSlot);
      }
      _slotActive[slot] = resolvedId;
      if (singlePerSlot) {
        _dismissSlot(slot, keeping: resolvedId);
      }
      notifyListeners();
      return existing;
    }

    if (singlePerSlot) {
      _dismissSlot(slot);
    }

    final entry = ToastEntry<T>(
      id: resolvedId,
      slot: slot,
      data: data as T,
      duration: resolvedDuration,
      autoDismiss: autoDismiss,
      onDismissed: onDismissed,
      shownAt: _clock(),
    )..onExpired = () => dismiss(resolvedId);
    entry.start();
    _entries[resolvedId] = entry;
    _slotActive[slot] = resolvedId;
    notifyListeners();
    return entry;
  }

  /// Updates a live toast in place; returns false when [id] is unknown.
  bool update(String id, {T? data, Duration? duration, bool? autoDismiss}) {
    final entry = _entries[id];
    if (entry == null) {
      return false;
    }
    entry
      ..update(data: data, duration: duration, autoDismiss: autoDismiss)
      ..shownAt = _clock();
    notifyListeners();
    return true;
  }

  /// Pauses the countdown of every toast in [slot] that [selector] accepts.
  ///
  /// Part of the auto-dismiss policy documented on [ToastQueue]: hold the
  /// non-primary toasts while a slot is stacked. [selector] keeps the decision
  /// in the component — pass `null` to hold everything in the slot. The old
  /// `pauseAutoDismissWhenMultiple` was read from the render data inside the
  /// gooey controller and had no counterpart in `ToastController`.
  void pauseSlot(
    ToastSlot slot, {
    bool Function(ToastEntry<T> entry)? selector,
  }) {
    for (final entry in entriesIn(slot)) {
      if (selector == null || selector(entry)) {
        entry.pause();
      }
    }
  }

  /// Resumes the countdown of every toast in [slot].
  void resumeSlot(ToastSlot slot) {
    for (final entry in entriesIn(slot)) {
      entry.resume();
    }
  }

  /// Pauses or resumes the countdown of one toast.
  void setInteracting(String id, bool interacting) {
    _entries[id]?.setInteracting(interacting);
  }

  /// Removes the toast with [id]; returns whether it was live.
  bool dismiss(String id) {
    final entry = _entries.remove(id);
    if (entry == null) {
      return false;
    }
    entry.cancelTimer();
    final activeForSlot = _slotActive[entry.slot];
    if (activeForSlot == id) {
      _slotActive.remove(entry.slot);
    }
    entry.onDismissed?.call(id);
    notifyListeners();
    return true;
  }

  /// Removes every toast in [slot]; returns how many went away.
  int dismissSlot(ToastSlot slot) => _dismissSlot(slot);

  /// Removes every toast; returns how many went away.
  int dismissAll() {
    final ids = _entries.keys.toList(growable: false);
    var removed = 0;
    for (final id in ids) {
      if (dismiss(id)) {
        removed += 1;
      }
    }
    return removed;
  }

  int _dismissSlot(ToastSlot slot, {String? keeping}) {
    final ids = _entries.values
        .where((entry) => entry.slot == slot && entry.id != keeping)
        .map((entry) => entry.id)
        .toList(growable: false);
    var removed = 0;
    for (final id in ids) {
      if (dismiss(id)) {
        removed += 1;
      }
    }
    return removed;
  }

  @override
  void dispose() {
    for (final entry in _entries.values) {
      entry.cancelTimer();
    }
    _entries.clear();
    _slotActive.clear();
    super.dispose();
  }
}
