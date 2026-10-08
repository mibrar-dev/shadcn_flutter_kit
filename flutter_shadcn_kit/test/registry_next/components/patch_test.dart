// Widget tests for the `patch` component.
//
// Covers single / double / triple counting, the time threshold, the distance
// reset, a disabled detector and the three regressions from the old module:
// wall-clock timing, no spatial check, and `ClickDetails` without equality.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/patch/patch.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
}

/// A wide target so the distance rule can be exercised.
Widget _target({
  required void Function(ClickDetails) onClick,
  Duration threshold = const Duration(milliseconds: 300),
  ShadcnThemeData data = const ShadcnThemeData(),
}) {
  return _frame(
    ClickDetector(
      threshold: threshold,
      onClick: onClick,
      child: const SizedBox(width: 400, height: 400, child: Text('target')),
    ),
    data: data,
  );
}

void main() {
  group('counting', () {
    testWidgets('a single tap reports 1', (tester) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(_target(onClick: events.add));
      await tester.tap(find.text('target'));
      expect(events, hasLength(1));
      expect(events.single.clickCount, 1);
    });

    testWidgets('rapid taps count up', (tester) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(_target(onClick: events.add));
      final Offset centre = tester.getCenter(find.text('target'));
      await tester.tapAt(centre);
      await tester.tapAt(centre);
      await tester.tapAt(centre);
      expect(events.map((ClickDetails e) => e.clickCount).toList(), <int>[
        1,
        2,
        3,
      ]);
    });

    testWidgets('a null onClick never reports a click', (tester) async {
      await tester.pumpWidget(
        _frame(
          const ClickDetector(
            child: ColoredBox(
              color: Color(0xFF00FF00),
              child: SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(ColoredBox));
      expect(tester.takeException(), isNull);
    });

    testWidgets('each tap reports exactly once', (tester) async {
      final List<int> counts = <int>[];
      await tester.pumpWidget(
        _frame(
          ClickDetector(
            onClick: (ClickDetails details) => counts.add(details.clickCount),
            child: const ColoredBox(
              color: Color(0xFF00FF00),
              child: SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(ColoredBox));
      expect(counts, <int>[1]);
    });

    testWidgets('reports the tap position', (tester) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(_target(onClick: events.add));
      final Rect box = tester.getRect(find.text('target'));
      await tester.tapAt(box.center);
      expect(events.single.localPosition, isNotNull);
      expect(events.single.localPosition!.dx, closeTo(200, 0.5));
      expect(events.single.localPosition!.dy, closeTo(200, 0.5));
    });
  });

  group('regressions', () {
    testWidgets('regression: a slow tap restarts the sequence', (tester) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(
        _target(
          onClick: events.add,
          threshold: const Duration(milliseconds: 300),
        ),
      );
      final Offset centre = tester.getCenter(find.text('target'));
      await tester.tapAt(centre);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)),
      );
      await tester.tapAt(centre);
      expect(events.map((ClickDetails e) => e.clickCount).toList(), <int>[
        1,
        1,
      ]);
    });

    testWidgets('regression: a far tap restarts the sequence', (tester) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(_target(onClick: events.add));
      final Rect box = tester.getRect(find.text('target'));
      await tester.tapAt(box.topLeft + const Offset(5, 5));
      await tester.tapAt(box.bottomRight - const Offset(5, 5));
      expect(events.map((ClickDetails e) => e.clickCount).toList(), <int>[
        1,
        1,
      ]);
    });

    testWidgets('regression: the threshold is honoured exactly', (
      tester,
    ) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(
        _target(
          onClick: events.add,
          threshold: const Duration(milliseconds: 100),
        ),
      );
      final Offset centre = tester.getCenter(find.text('target'));
      await tester.tapAt(centre);
      await tester.tapAt(centre);
      expect(events.map((ClickDetails e) => e.clickCount).toList(), <int>[
        1,
        2,
      ]);
    });

    testWidgets('regression: ClickDetails compares by value', (tester) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(_target(onClick: events.add));
      await tester.tap(find.text('target'));
      expect(
        events.single,
        const ClickDetails(clickCount: 1, localPosition: Offset(200, 200)),
      );
      expect(
        events.single.hashCode,
        const ClickDetails(
          clickCount: 1,
          localPosition: Offset(200, 200),
        ).hashCode,
      );
    });

    testWidgets('regression: kDoubleTapSlop bounds the distance reset', (
      tester,
    ) async {
      final List<ClickDetails> events = <ClickDetails>[];
      await tester.pumpWidget(_target(onClick: events.add));
      final Rect box = tester.getRect(find.text('target'));
      await tester.tapAt(box.center);
      await tester.tapAt(box.center + const Offset(kDoubleTapSlop - 4, 0));
      expect(events.last.clickCount, 2);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('builds under $name tokens', (tester) async {
        await tester.pumpWidget(
          _target(
            onClick: (ClickDetails details) {},
            data: ShadcnThemeData(colors: colors),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('target'), findsOneWidget);
      });
    }
  });
}
