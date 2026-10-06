import 'package:flutter_shadcn_kit/registry_next/primitives/menu_nav.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('nextEnabledIndex', () {
    test('skips disabled entries walking forward', () {
      expect(
        nextEnabledIndex(
          count: 5,
          current: 0,
          isEnabled: (index) => index != 1,
        ),
        2,
      );
    });

    test('skips disabled entries walking backward', () {
      expect(
        nextEnabledIndex(
          count: 4,
          current: 3,
          forward: false,
          isEnabled: (index) => index != 2,
        ),
        1,
      );
    });

    test('wraps around by default', () {
      expect(
        nextEnabledIndex(
          count: 4,
          current: 3,
          isEnabled: (index) => index == 1,
        ),
        1,
      );
      expect(
        nextEnabledIndex(
          count: 4,
          current: 0,
          forward: false,
          isEnabled: (index) => index == 2,
        ),
        2,
      );
    });

    test('without wrapping it stops at the edge', () {
      expect(
        nextEnabledIndex(
          count: 3,
          current: 2,
          wrap: false,
          isEnabled: (index) => index == 0,
        ),
        isNull,
      );
      expect(
        nextEnabledIndex(
          count: 3,
          current: 0,
          forward: false,
          wrap: false,
          isEnabled: (index) => index == 2,
        ),
        isNull,
      );
      expect(
        nextEnabledIndex(
          count: 3,
          current: 1,
          wrap: false,
          isEnabled: (i) => i != 1,
        ),
        2,
      );
    });

    test('returns null when nothing is enabled or the list is empty', () {
      expect(
        nextEnabledIndex(count: 3, current: 0, isEnabled: (index) => false),
        isNull,
      );
      expect(nextEnabledIndex(count: 0, current: 0), isNull);
    });

    test('treats every entry as enabled when no test is given', () {
      expect(nextEnabledIndex(count: 3, current: 0), 1);
      expect(nextEnabledIndex(count: 3, current: 2, forward: false), 1);
    });
  });

  group('first/lastEnabledIndex', () {
    test('find the outermost enabled entries', () {
      expect(firstEnabledIndex(4, isEnabled: (index) => index > 1), 2);
      expect(lastEnabledIndex(4, isEnabled: (index) => index < 2), 1);
      expect(firstEnabledIndex(4, isEnabled: (index) => false), isNull);
      expect(lastEnabledIndex(0), isNull);
      expect(firstEnabledIndex(4), 0);
      expect(lastEnabledIndex(4), 3);
    });
  });

  group('MenuTypeahead', () {
    test('accumulates characters within the reset delay', () {
      final typeahead = MenuTypeahead();
      typeahead.type('b', now: const Duration(milliseconds: 100));
      typeahead.type('l', now: const Duration(milliseconds: 200));
      typeahead.type('u', now: const Duration(milliseconds: 300));
      expect(typeahead.query, 'blu');
    });

    test('restarts the prefix after a longer pause', () {
      final typeahead = MenuTypeahead();
      typeahead.type('b', now: const Duration(milliseconds: 100));
      typeahead.type('c', now: const Duration(milliseconds: 1000));
      expect(typeahead.query, 'c');
    });

    test('ignores input that is not exactly one character', () {
      final typeahead = MenuTypeahead();
      typeahead.type('Enter', now: const Duration(milliseconds: 100));
      typeahead.type('', now: const Duration(milliseconds: 200));
      expect(typeahead.query, isEmpty);
    });

    test('reset clears the prefix', () {
      final typeahead = MenuTypeahead();
      typeahead.type('b', now: const Duration(milliseconds: 100));
      typeahead.reset();
      expect(typeahead.query, isEmpty);
    });

    test('match finds a case-insensitive prefix from an offset', () {
      final typeahead = MenuTypeahead();
      typeahead.type('b', now: Duration.zero);
      const labels = ['Apple', 'Banana', 'Blueberry', 'Cherry'];
      expect(typeahead.match(labels), 1);
      expect(typeahead.match(labels, start: 1), 1);
      expect(typeahead.match(labels, start: 2), 2);
      typeahead.reset();
      typeahead.type('B', now: Duration.zero);
      typeahead.type('L', now: const Duration(milliseconds: 50));
      expect(typeahead.match(labels), 2);
    });

    test('match wraps and skips disabled labels', () {
      final typeahead = MenuTypeahead();
      typeahead.type('b', now: Duration.zero);
      const labels = ['Banana', 'Blueberry'];
      expect(typeahead.match(labels, start: 1), 1);
      expect(typeahead.match(labels, start: 1, isEnabled: (i) => i != 1), 0);
    });

    test('match returns null for an empty query or no match', () {
      final typeahead = MenuTypeahead();
      expect(typeahead.match(const ['Apple']), isNull);
      typeahead.type('z', now: Duration.zero);
      expect(typeahead.match(const ['Apple']), isNull);
      expect(typeahead.match(const []), isNull);
    });
  });
}
