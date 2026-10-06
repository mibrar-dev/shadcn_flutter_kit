import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/toast_queue/toast_entry.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/toast_queue/toast_placement.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/toast_queue/toast_queue.dart';

/// Behavioural notes for the fixed queue:
/// * the queue is the single owner of ids, slots, ordering and the auto-dismiss
///   timer; the two old controllers each carried a private `_nonce` plus their
///   own map, so ids and behaviour could not agree between `toast` and
///   `gooey_toast`;
/// * there is no global singleton: the old `showToast` used a file-level
///   `_defaultToastController` and a file-level `_toastSequence` counter;
/// * [ToastEntry.update] restarts the countdown. The old `ToastController`
///   bumped `refreshSignal` and left the running timer alone, so an updated
///   toast could disappear before the new content was visible;
/// * re-showing an id in a new slot releases the old slot.
///
/// Timer behaviour runs through `testWidgets`, which drives the fake clock the
/// `flutter_test` binding installs. The placement metadata is covered in
/// `toast_placement_test.dart`.
void main() {
  group('ids', () {
    test('nextId is unique per queue and never global', () {
      final first = ToastQueue<String>();
      addTearDown(first.dispose);
      final second = ToastQueue<String>();
      addTearDown(second.dispose);
      expect(first.nextId(), 'toast_0');
      expect(first.nextId(), 'toast_1');
      // A second queue starts from zero: no shared counter.
      expect(second.nextId(), 'toast_0');
    });

    test('a supplied id is used verbatim', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'upload-42',
      );
      expect(queue.activeIds, <String>['upload-42']);
    });
  });

  group('show', () {
    test('adds an entry and notifies', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      var notifications = 0;
      queue.addListener(() => notifications += 1);

      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'saved',
        autoDismiss: false,
      );

      expect(queue.activeIds, <String>[entry.id]);
      expect(queue.contains(entry.id), isTrue);
      expect(queue.entryOf(entry.id)!.data, 'saved');
      expect(queue.slotOccupied(entry.slot), isTrue);
      expect(notifications, 1);
    });

    test('orders the newest entry first', () {
      final clock = _FakeClock();
      final queue = ToastQueue<String>(clock: () => clock.now);
      addTearDown(queue.dispose);

      clock.advance(const Duration(seconds: 1));
      final first = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'first',
        autoDismiss: false,
      );
      clock.advance(const Duration(seconds: 1));
      final second = queue.show(
        placement: ToastPlacement.bottomTrailing,
        data: 'second',
        autoDismiss: false,
      );

      expect(queue.entries.map((entry) => entry.id), <String>[
        second.id,
        first.id,
      ]);
      expect(queue.activeIds.first, second.id);
    });

    test('singlePerSlot replaces the toast already in that slot', () {
      final queue = ToastQueue<String>(singlePerSlot: true);
      addTearDown(queue.dispose);
      final replaced = <String>[];
      final first = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'first',
        autoDismiss: false,
        onDismissed: replaced.add,
      );
      final dismissed = <String>[];
      final second = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'second',
        autoDismiss: false,
        onDismissed: dismissed.add,
      );
      expect(queue.contains(first.id), isFalse);
      expect(queue.contains(second.id), isTrue);
      expect(queue.activeIds, <String>[second.id]);
      expect(replaced, <String>[first.id]);
      expect(dismissed, isEmpty);
    });

    test('singlePerSlot false stacks the slot', () {
      final queue = ToastQueue<String>(singlePerSlot: false);
      addTearDown(queue.dispose);
      queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'first',
        autoDismiss: false,
      );
      final second = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'second',
        autoDismiss: false,
      );
      expect(queue.entriesIn(second.slot), hasLength(2));
    });

    test('a different slot is left alone', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final top = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'top',
        autoDismiss: false,
      );
      final bottom = queue.show(
        placement: ToastPlacement.bottomTrailing,
        data: 'bottom',
        autoDismiss: false,
      );
      expect(queue.contains(top.id), isTrue);
      expect(queue.contains(bottom.id), isTrue);
      expect(queue.entriesIn(bottom.slot), hasLength(1));
    });

    test('reusing an id updates the toast in place', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final first = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'uploading',
        autoDismiss: false,
        id: 'job',
      );
      final second = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'done',
        autoDismiss: false,
        id: 'job',
      );
      expect(identical(first, second), isTrue);
      expect(queue.activeIds, <String>['job']);
      expect(queue.entryOf('job')!.data, 'done');
    });

    test('reusing an id moves the toast to the new slot', () {
      final queue = ToastQueue<String>(singlePerSlot: false);
      addTearDown(queue.dispose);
      queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'job',
      );
      queue.show(
        placement: ToastPlacement.bottomTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'job',
      );
      expect(queue.entries, hasLength(1));
      expect(
        queue.slotOccupied(const ToastSlot(ToastPlacement.bottomTrailing)),
        isTrue,
      );
      expect(
        queue.slotOccupied(const ToastSlot(ToastPlacement.topTrailing)),
        isFalse,
      );
    });
  });

  group('update', () {
    testWidgets('replaces the payload and restarts the countdown', (
      tester,
    ) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 3),
      );
      addTearDown(queue.dispose);
      queue.show(placement: ToastPlacement.topTrailing, data: 'first');
      expect(queue.activeIds, hasLength(1));

      await tester.pump(const Duration(seconds: 2));
      expect(queue.update('toast_0', data: 'second'), isTrue);
      expect(queue.entryOf('toast_0')!.data, 'second');

      // Old behaviour: the original timer kept running, so the toast would have
      // gone at 3s even though it was refreshed at 2s.
      await tester.pump(const Duration(milliseconds: 1500));
      expect(queue.contains('toast_0'), isTrue);

      await tester.pump(const Duration(milliseconds: 1600));
      expect(queue.contains('toast_0'), isFalse);
    });

    test('reports an unknown id', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      expect(queue.update('nope', data: 'x'), isFalse);
      expect(queue.dismiss('nope'), isFalse);
      expect(queue.entryOf('nope'), isNull);
    });

    testWidgets('autoDismiss false stops the countdown', (tester) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 1),
      );
      addTearDown(queue.dispose);
      queue.show(placement: ToastPlacement.topTrailing, data: 'a');
      queue.update('toast_0', autoDismiss: false);
      await tester.pump(const Duration(seconds: 5));
      expect(queue.contains('toast_0'), isTrue);
    });
  });

  group('auto dismiss', () {
    testWidgets('a countdown removes the toast', (tester) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 2),
      );
      addTearDown(queue.dispose);
      final dismissed = <String>[];
      queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        onDismissed: dismissed.add,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(queue.activeIds, hasLength(1));
      await tester.pump(const Duration(seconds: 2));
      expect(queue.activeIds, isEmpty);
      expect(dismissed, <String>['toast_0']);
    });

    testWidgets('a zero duration never expires', (tester) async {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        duration: Duration.zero,
      );
      await tester.pump(const Duration(seconds: 10));
      expect(queue.contains('toast_0'), isTrue);
    });

    testWidgets('pausing keeps the toast and preserves the remaining time', (
      tester,
    ) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 3),
      );
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
      );
      await tester.pump(const Duration(seconds: 1));
      queue.setInteracting(entry.id, true);
      expect(entry.isPaused, isTrue);

      // Well past the original deadline, but paused.
      await tester.pump(const Duration(seconds: 10));
      expect(queue.contains(entry.id), isTrue);
      expect(entry.remaining!.inSeconds, lessThanOrEqualTo(2));
      expect(entry.remaining!.inSeconds, greaterThan(0));

      queue.setInteracting(entry.id, false);
      await tester.pump(const Duration(seconds: 3));
      expect(queue.contains(entry.id), isFalse);
    });

    testWidgets('resuming after the budget ran out dismisses at once', (
      tester,
    ) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 2),
      );
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
      );
      queue.setInteracting(entry.id, true);
      expect(entry.hasCountdown, isTrue);
      await tester.pump(const Duration(milliseconds: 100));
      queue.setInteracting(entry.id, false);
      await tester.pump(const Duration(seconds: 3));
      expect(queue.contains(entry.id), isFalse);
    });

    test('interacting with an unknown id is a no-op', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      expect(() => queue.setInteracting('nope', true), returnsNormally);
    });

    testWidgets('a slot can pause and resume the toasts it holds', (
      tester,
    ) async {
      final queue = ToastQueue<String>(
        singlePerSlot: false,
        defaultDuration: const Duration(seconds: 2),
      );
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
      );
      queue.pauseSlot(entry.slot);
      expect(entry.isPaused, isTrue);
      await tester.pump(const Duration(seconds: 5));
      expect(queue.contains(entry.id), isTrue);
      queue.resumeSlot(entry.slot);
      await tester.pump(const Duration(seconds: 3));
      expect(queue.contains(entry.id), isFalse);
    });

    testWidgets('the pause selector decides which toasts are held', (
      tester,
    ) async {
      final queue = ToastQueue<String>(
        singlePerSlot: false,
        defaultDuration: const Duration(seconds: 2),
      );
      addTearDown(queue.dispose);
      final hold = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'hold',
      );
      queue.show(placement: ToastPlacement.topTrailing, data: 'let-go');
      queue.pauseSlot(hold.slot, selector: (entry) => entry.data == 'hold');
      expect(hold.isPaused, isTrue);
      await tester.pump(const Duration(seconds: 3));
      expect(queue.contains(hold.id), isTrue);
    });

    // Pins the policy documented on `ToastQueue`: a stacked slot holds its
    // non-primary toasts, and the primary (newest) keeps counting down.
    testWidgets('a stacked slot holds its non-primary toasts', (tester) async {
      final queue = ToastQueue<String>(
        singlePerSlot: false,
        defaultDuration: const Duration(seconds: 2),
      );
      addTearDown(queue.dispose);
      final older = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'older',
      );
      queue.show(placement: ToastPlacement.topTrailing, data: 'newest');
      final primary = queue.entriesIn(older.slot).first;

      bool isPrimary(ToastEntry<String> entry) => identical(entry, primary);
      queue.pauseSlot(older.slot, selector: (entry) => !isPrimary(entry));

      expect(older.isPaused, isTrue);
      expect(primary.isPaused, isFalse);

      await tester.pump(const Duration(seconds: 3));
      // The covered toast survives; the one being read expires on schedule.
      expect(queue.contains(older.id), isTrue);
      expect(queue.contains(primary.id), isFalse);

      queue.resumeSlot(older.slot);
      await tester.pump(const Duration(seconds: 3));
      expect(queue.contains(older.id), isFalse);
    });
  });

  group('dismiss', () {
    test('removes one toast and fires its callback once', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final dismissed = <String>[];
      queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'one',
        onDismissed: dismissed.add,
      );
      expect(queue.dismiss('one'), isTrue);
      expect(dismissed, <String>['one']);
      expect(queue.dismiss('one'), isFalse);
      expect(dismissed, <String>['one']);
    });

    test('dismissSlot clears the slot and frees it', () {
      final queue = ToastQueue<String>(singlePerSlot: false);
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
      );
      expect(queue.dismissSlot(entry.slot), 1);
      expect(queue.slotOccupied(entry.slot), isFalse);
      expect(queue.dismissSlot(entry.slot), 0);
    });

    test('dismissAll empties the queue', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final dismissed = <String>[];
      for (final placement in ToastPlacement.values) {
        queue.show(
          placement: placement,
          data: placement.name,
          autoDismiss: false,
          onDismissed: dismissed.add,
        );
      }
      expect(queue.entries, hasLength(ToastPlacement.values.length));
      expect(queue.dismissAll(), ToastPlacement.values.length);
      expect(queue.entries, isEmpty);
      expect(dismissed, hasLength(ToastPlacement.values.length));
    });

    testWidgets('dispose cancels every countdown', (tester) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 1),
      );
      queue.show(placement: ToastPlacement.topTrailing, data: 'a');
      queue.dispose();
      // No timer survives, so nothing fires afterwards.
      await tester.pump(const Duration(seconds: 5));
    });
  });

  group('ToastEntry', () {
    test('describes itself', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'job',
      );
      expect(entry.toString(), 'ToastEntry(job, topTrailing)');
    });

    test('reports whether it counts down', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final persistent = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'persistent',
      );
      expect(persistent.hasCountdown, isFalse);
      expect(persistent.remaining, isNull);
      final timed = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'b',
        duration: const Duration(seconds: 1),
        id: 'timed',
      );
      expect(timed.hasCountdown, isTrue);
      expect(timed.remaining, const Duration(seconds: 1));
    });

    test('pause and resume are idempotent', () {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(seconds: 5),
      );
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
      );
      entry.pause();
      final paused = entry.remaining;
      entry.pause();
      expect(entry.remaining, paused);
      entry.resume();
      entry.resume();
      expect(entry.isPaused, isFalse);
    });

    test('update keeps the payload when none is given', () {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      final entry = queue.show(
        placement: ToastPlacement.topTrailing,
        data: 'a',
        autoDismiss: false,
        id: 'job',
      );
      entry.update(duration: const Duration(seconds: 9));
      expect(entry.data, 'a');
      expect(entry.duration, const Duration(seconds: 9));
      expect(entry.hasCountdown, isFalse);
    });
  });
}

/// A monotonic clock so ordering can be asserted without real time.
class _FakeClock {
  DateTime now = DateTime.utc(2026);

  void advance(Duration delta) => now = now.add(delta);
}
