// Widget tests for the `dot_indicator` component.
//
// Covers both axes, the interactive and read-only forms, tap reporting, the
// theme rows and all four precedence legs, plus five regressions from the old
// module: the dead `DotItem` (so no animation), the click cursor on a
// read-only run, the double-scaled padding, the `IntrinsicHeight`/`Flexible`
// layout and the missing token defaults.
//
// Painting is asserted on read-only runs: `Clickable` builds its own
// `AnimatedContainer` around its child, so an interactive run has two
// animated containers per dot.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/dot_indicator/dot_indicator.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  DotIndicatorTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<DotIndicatorTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

List<AnimatedContainer> _dots(WidgetTester tester) => tester
    .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
    .toList();

BoxDecoration _decorationAt(WidgetTester tester, int i) =>
    _dots(tester)[i].decoration! as BoxDecoration;

void main() {
  group('rendering', () {
    testWidgets('draws one dot per item', (tester) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 0, length: 4)));
      expect(_dots(tester), hasLength(4));
    });

    testWidgets('the active dot uses the primary token', (tester) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 1, length: 4)));
      expect(
        _decorationAt(tester, 1).color,
        ShadcnColors.lightFallback.primary,
      );
    });

    testWidgets('inactive dots use the muted token', (tester) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 1, length: 4)));
      expect(_decorationAt(tester, 0).color, ShadcnColors.lightFallback.muted);
      expect(_decorationAt(tester, 3).color, ShadcnColors.lightFallback.muted);
    });

    testWidgets('dots are full circles', (tester) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 0, length: 2)));
      expect(_decorationAt(tester, 0).borderRadius, BorderRadius.circular(6));
    });

    testWidgets('an out-of-range index leaves every dot inactive', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 99, length: 3)));
      for (final BoxDecoration box in _dots(
        tester,
      ).map((AnimatedContainer b) => b.decoration! as BoxDecoration)) {
        expect(box.color, ShadcnColors.lightFallback.muted);
      }
    });

    testWidgets('the vertical axis stacks the dots', (tester) async {
      await tester.pumpWidget(
        _frame(
          const DotIndicator(index: 0, length: 3, direction: Axis.vertical),
        ),
      );
      final Rect size = tester.getRect(find.byType(DotIndicator));
      expect(_dots(tester), hasLength(3));
      expect(size.height, greaterThan(size.width));
    });
  });

  group('interaction', () {
    testWidgets('reports the tapped index', (tester) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(DotIndicator(index: 0, length: 4, onChanged: reported.add)),
      );
      final List<Rect> targets = tester
          .widgetList<Clickable>(find.byType(Clickable))
          .map((Clickable c) => tester.getRect(find.byWidget(c)))
          .toList();
      expect(targets, hasLength(4));
      await tester.tapAt(targets[2].center);
      expect(reported, <int>[2]);
    });

    testWidgets('a read-only run builds no Clickable', (tester) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 0, length: 4)));
      expect(find.byType(Clickable), findsNothing);
    });

    testWidgets('regression: a read-only run answers no tap', (tester) async {
      // The old widget installed a click cursor and a live `Clickable` even
      // when `onChanged` was null, so a read-only run looked pressable.
      await tester.pumpWidget(_frame(const DotIndicator(index: 0, length: 4)));
      final Rect dot = tester.getRect(find.byType(AnimatedContainer).first);
      await tester.tapAt(dot.center);
      expect(tester.takeException(), isNull);
      expect(find.byType(Clickable), findsNothing);
    });

    testWidgets('regression: the run paints its own animated decoration', (
      tester,
    ) async {
      // `DotItem` was the only animated dot and had zero readers, so the two
      // dots the indicator built were plain Containers.
      await tester.pumpWidget(_frame(const DotIndicator(index: 0, length: 2)));
      expect(find.byType(AnimatedContainer), findsNWidgets(2));
    });
  });

  group('theme', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          const DotIndicator(
            index: 0,
            length: 2,
            theme: DotIndicatorTheme(
              active: DotStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
                size: 20,
              ),
            ),
          ),
          app: const <ComponentThemeData>[
            DotIndicatorTheme(
              active: DotStyle(
                background: StateValue(rest: ThemedColor.value(_blue)),
              ),
            ),
          ],
        ),
      );
      expect(_decorationAt(tester, 0).color, _green);
      expect(_dots(tester).first.constraints!.maxWidth, 20);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const DotIndicator(index: 0, length: 2),
          app: const <ComponentThemeData>[
            DotIndicatorTheme(
              active: DotStyle(
                background: StateValue(rest: ThemedColor.value(_blue)),
              ),
            ),
          ],
          scoped: const DotIndicatorTheme(
            active: DotStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
        ),
      );
      expect(_decorationAt(tester, 0).color, _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const DotIndicator(index: 0, length: 2),
          app: const <ComponentThemeData>[
            DotIndicatorTheme(
              active: DotStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
        ),
      );
      expect(_decorationAt(tester, 0).color, _green);
    });

    testWidgets('a leg that sets only the fill keeps the default size', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const DotIndicator(index: 0, length: 2),
          app: const <ComponentThemeData>[
            DotIndicatorTheme(
              active: DotStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
        ),
      );
      expect(_dots(tester).first.constraints!.maxWidth, 12);
    });

    testWidgets('regression: a caller padding is applied once, unscaled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const DotIndicator(index: 0, length: 2, padding: EdgeInsets.all(20)),
          data: const ShadcnThemeData(scaling: 4),
        ),
      );
      final Padding padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(DotIndicator),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('regression: no IntrinsicHeight around a fixed-size row', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const DotIndicator(index: 0, length: 5)));
      expect(find.byType(IntrinsicHeight), findsNothing);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Flexible), findsNothing);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens drive the rows', (tester) async {
        await tester.pumpWidget(
          _frame(
            const DotIndicator(index: 0, length: 2),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        expect(_decorationAt(tester, 0).color, colors.primary);
        expect(_decorationAt(tester, 1).color, colors.muted);
      });
    }
  });

  group('custom builder', () {
    testWidgets('the builder replaces the default fill', (tester) async {
      await tester.pumpWidget(
        _frame(
          DotIndicator(
            index: 1,
            length: 3,
            dotBuilder: (context, index, isActive) =>
                SizedBox(width: isActive ? 30 : 10, height: 10),
          ),
        ),
      );
      expect(
        _dots(tester).every((AnimatedContainer b) => b.decoration == null),
        isTrue,
      );
    });
  });
}
