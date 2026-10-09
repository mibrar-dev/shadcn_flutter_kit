import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/text_input.dart';
import 'package:flutter_shadcn_kit/registry/foundation/time_of_day.dart';
import 'package:flutter_shadcn_kit/registry/foundation/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('wrapDouble / unlerpDouble', () {
    test('wrapDouble wraps into [min, max)', () {
      expect(wrapDouble(370, 0, 360), 10);
      expect(wrapDouble(-10, 0, 360), 350);
      expect(wrapDouble(180, 0, 360), 180);
      expect(wrapDouble(5, 5, 5), 5);
    });

    test('unlerpDouble maps a range to 0..1', () {
      expect(unlerpDouble(5, 5, 10), 0);
      expect(unlerpDouble(10, 5, 10), 1);
      expect(unlerpDouble(7.5, 5, 10), 0.5);
    });
  });

  group('TimeOfDay', () {
    test('value equality and hashing', () {
      const a = TimeOfDay(hour: 9, minute: 30);
      const b = TimeOfDay(hour: 9, minute: 30);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(const TimeOfDay(hour: 9, minute: 31)));
    });

    test('constructors', () {
      expect(const TimeOfDay.pm(hour: 1, minute: 0).hour, 13);
      expect(const TimeOfDay.am(hour: 11, minute: 5).second, 0);
      expect(
        TimeOfDay.fromDuration(const Duration(hours: 2, minutes: 61)).minute,
        1,
      );
      expect(TimeOfDay.fromDateTime(DateTime(2026, 1, 1, 23, 59, 58)).hour, 23);
    });

    test('copyWith and replacing', () {
      const time = TimeOfDay(hour: 1, minute: 2, second: 3);
      expect(time.copyWith(hour: () => 4).hour, 4);
      expect(time.copyWith().minute, 2);
      expect(time.replacing(minute: 9).minute, 9);
      expect(time.toString(), 'TimeOfDay{hour: 1, minute: 2, second: 3}');
    });
  });

  group('ListExtension.swapItem', () {
    test('moves an existing item forward', () {
      final list = [1, 2, 3, 4];
      expect(list.swapItem(2, 3), isTrue);
      expect(list, [1, 3, 2, 4]);
    });

    test('moves an item backward', () {
      final list = [1, 2, 3];
      list.swapItem(3, 0);
      expect(list, [3, 1, 2]);
    });

    test('inserts a missing item, clamping an out-of-range target', () {
      final list = [1, 2];
      list.swapItem(9, 2);
      expect(list, [1, 2, 9]);
      // Fixed vs the old code (which threw RangeError): clamp to the end.
      final clamped = [1, 2];
      expect(clamped.swapItem(9, 7), isTrue);
      expect(clamped, [1, 2, 9]);
    });
  });

  group('joinSeparator', () {
    test('joins an iterable lazily', () {
      final joined = [1, 2, 3].joinSeparator(0);
      expect(joined, [1, 0, 2, 0, 3]);
    });

    test('joins a lazy iterable', () {
      Iterable<int> iterable = [1, 2, 3].where((value) => true);
      expect(iterable.joinSeparator(9), [1, 9, 2, 9, 3]);
    });

    test('Joinable returns a list for widget lists', () {
      final joined = <Widget>[
        const SizedBox(),
        const SizedBox(),
      ].joinSeparator(const SizedBox(width: 1));
      expect(joined, isA<List<Widget>>());
      expect(joined, hasLength(3));
    });
  });

  group('CachedValueWidget', () {
    testWidgets('rebuilds when the value changes', (tester) async {
      var builds = 0;
      Widget build(int value) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: CachedValueWidget<int>(
            value: value,
            builder: (context, value) {
              builds++;
              return Text('$value');
            },
          ),
        );
      }

      await tester.pumpWidget(build(1));
      expect(builds, 1);
      await tester.pumpWidget(build(1));
      expect(builds, 1);
      await tester.pumpWidget(build(2));
      expect(builds, 2);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('honours CachedValue.shouldRebuild', (tester) async {
      // Fixed vs the old code, which tested `T is CachedValue` (always false
      // in Dart), so shouldRebuild was never consulted.
      var builds = 0;
      Widget build(_ChangeableValue value) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: CachedValueWidget<_ChangeableValue>(
            value: value,
            builder: (context, value) {
              builds++;
              return Text('${value.value}');
            },
          ),
        );
      }

      await tester.pumpWidget(build(const _ChangeableValue(1)));
      expect(builds, 1);
      // shouldRebuild returns false → cached widget kept despite a new value.
      await tester.pumpWidget(build(const _ChangeableValue(2)));
      expect(builds, 1);
      expect(find.text('1'), findsOneWidget);
      expect(const _ChangeableValue(1), isA<CachedValue>());
      expect(
        const _ChangeableValue(1).shouldRebuild(const _ChangeableValue(2)),
        isFalse,
      );
    });
  });

  group('CallbackContextAction', () {
    test('invokes its callback with the intent', () {
      final action = CallbackContextAction<_TestIntent>(
        onInvoke: (intent, [context]) => (intent as _TestIntent).value,
      );
      expect(action.invoke(const _TestIntent(5)), 5);
    });
  });

  group('text input helpers', () {
    test('replaceWordAtCaret replaces the word around the caret', () {
      final result = replaceWordAtCaret(
        'hello world',
        8,
        'there',
        (char) => char == ' ',
      );
      expect(result.$1, 6);
      expect(result.$2, 'hello there');
    });

    test('replaceWordAtCaret throws on an out-of-range caret', () {
      expect(
        () => replaceWordAtCaret('a', 2, 'b', (char) => false),
        throwsRangeError,
      );
    });

    test('replaceText keeps the selection within bounds', () {
      const value = TextEditingValue(
        text: 'abcdef',
        selection: TextSelection.collapsed(offset: 5),
      );
      final replaced = value.replaceText('ab');
      expect(replaced.text, 'ab');
      expect(replaced.selection.baseOffset, 2);
    });
  });
}

class _ChangeableValue with CachedValue {
  const _ChangeableValue(this.value);

  final int value;

  @override
  bool shouldRebuild(covariant CachedValue oldValue) => false;
}

class _TestIntent extends Intent {
  const _TestIntent(this.value);

  final int value;
}
