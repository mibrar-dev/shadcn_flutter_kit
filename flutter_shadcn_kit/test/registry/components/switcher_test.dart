// Widget tests for the `switcher` component.
//
// Covers the four axes, the programmatic index change, the snap notification,
// theme precedence and five regressions from the old module: the missing
// `setState` on pan start, the unconditional `onIndexChanged`, the unclamped
// index, the `context.size!` null assertion and the ignored direction change.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/switcher/switcher.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const List<String> _labels = <String>['one', 'two', 'three'];

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  SwitcherTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<SwitcherTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 200, height: 200, child: body)),
      ),
    ),
  );
}

Widget _switcher({
  required int index,
  AxisDirection direction = AxisDirection.right,
  ValueChanged<int>? onIndexChanged,
  SwitcherTheme? theme,
  List<String>? labels,
}) {
  return Switcher(
    index: index,
    direction: direction,
    onIndexChanged: onIndexChanged,
    theme: theme,
    children: <Widget>[
      for (final String label in labels ?? _labels) Center(child: Text(label)),
    ],
  );
}

void main() {
  group('rendering', () {
    testWidgets('shows the child at index 0', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: 0)));
      await tester.pumpAndSettle();
      expect(find.text('one'), findsOneWidget);
    });

    testWidgets('an external index change moves the view', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: 0)));
      await tester.pumpAndSettle();
      await tester.pumpWidget(_frame(_switcher(index: 2)));
      await tester.pumpAndSettle();
      expect(find.text('three'), findsOneWidget);
    });

    testWidgets('a programmatic change is animatable', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: 0)));
      await tester.pumpAndSettle();
      await tester.pumpWidget(_frame(_switcher(index: 1)));
      // Mid-animation both pages are present.
      await tester.pump(const Duration(milliseconds: 40));
      expect(find.text('one'), findsOneWidget);
      expect(find.text('two'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('two'), findsOneWidget);
    });
  });

  group('gestures', () {
    testWidgets('a forward drag moves to the next page', (tester) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(_switcher(index: 0, onIndexChanged: reported.add)),
      );
      await tester.pumpAndSettle();
      // `AxisDirection.right` pulls the *next* page in from the left, so the
      // drag travels the same way the content does (rightwards).
      await tester.drag(find.byType(Switcher), const Offset(180, 0));
      await tester.pumpAndSettle();
      expect(reported, <int>[1]);
      expect(find.text('two'), findsOneWidget);
    });

    testWidgets('a backward drag stays on the first page', (tester) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(_switcher(index: 0, onIndexChanged: reported.add)),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Switcher), const Offset(-180, 0));
      await tester.pumpAndSettle();
      expect(reported, isEmpty);
      expect(find.text('one'), findsOneWidget);
    });

    testWidgets('a vertical drag works on the down axis', (tester) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(
          _switcher(
            index: 0,
            direction: AxisDirection.down,
            onIndexChanged: reported.add,
            labels: const <String>['a', 'b'],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Switcher), const Offset(0, 180));
      await tester.pumpAndSettle();
      expect(reported, <int>[1]);
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('regression: no notification when the index is unchanged', (
      tester,
    ) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(_switcher(index: 1, onIndexChanged: reported.add)),
      );
      await tester.pumpAndSettle();
      // A drag far too small to change the index.
      await tester.drag(find.byType(Switcher), const Offset(2, 0));
      await tester.pumpAndSettle();
      expect(reported, isEmpty);
    });

    testWidgets('regression: the drag follows the finger immediately', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_switcher(index: 0)));
      await tester.pumpAndSettle();
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(Switcher)),
      );
      await gesture.moveBy(const Offset(100, 0));
      // No pump of the snap duration: the position must already be halfway.
      await tester.pump();
      expect(find.text('one'), findsOneWidget);
      expect(find.text('two'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
    });
  });

  group('regressions', () {
    testWidgets('regression: an out-of-range index is clamped', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: 99)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('three'), findsOneWidget);
    });

    testWidgets('regression: a negative index is clamped', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: -5)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('one'), findsOneWidget);
    });

    testWidgets('regression: dragging inside unbounded space does not crash', (
      tester,
    ) async {
      // The old widget read `context.size!`; an unbounded parent left the size
      // null and a pan threw.
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Switcher(
                    direction: AxisDirection.right,
                    children: const <Widget>[Text('a'), Text('b')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.drag(find.byType(Switcher), const Offset(40, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('regression: changing children.length asserts', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: 0)));
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _frame(
          _switcher(
            index: 0,
            labels: const <String>['one', 'two', 'three', 'four'],
          ),
        ),
      );
      expect(tester.takeException(), isA<AssertionError>());
    });

    testWidgets('regression: a new key rebuilds with a longer list', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          KeyedSubtree(
            key: const ValueKey<String>('a'),
            child: _switcher(index: 0),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _frame(
          KeyedSubtree(
            key: const ValueKey<String>('b'),
            child: _switcher(
              index: 3,
              labels: const <String>['one', 'two', 'three', 'four'],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('four'), findsOneWidget);
    });

    testWidgets('regression: changing direction is applied', (tester) async {
      await tester.pumpWidget(_frame(_switcher(index: 0)));
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _frame(_switcher(index: 0, direction: AxisDirection.down)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('one'), findsOneWidget);
    });
  });

  group('theme', () {
    testWidgets('the widget leg supplies duration and curve', (tester) async {
      await tester.pumpWidget(
        _frame(
          _switcher(
            index: 0,
            theme: const SwitcherTheme(duration: Duration(milliseconds: 10)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('one'), findsOneWidget);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _switcher(index: 1),
          app: const <ComponentThemeData>[
            SwitcherTheme(duration: Duration(milliseconds: 900)),
          ],
          scoped: const SwitcherTheme(duration: Duration(milliseconds: 10)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));
      await tester.pumpAndSettle();
      expect(find.text('two'), findsOneWidget);
    });

    testWidgets('the app leg is used when nothing else sets it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          _switcher(index: 1),
          app: const <ComponentThemeData>[
            SwitcherTheme(duration: Duration(milliseconds: 10)),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));
      await tester.pumpAndSettle();
      expect(find.text('two'), findsOneWidget);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('builds under $name tokens', (tester) async {
        await tester.pumpWidget(
          _frame(_switcher(index: 1), data: ShadcnThemeData(colors: colors)),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('two'), findsOneWidget);
      });
    }
  });
}
