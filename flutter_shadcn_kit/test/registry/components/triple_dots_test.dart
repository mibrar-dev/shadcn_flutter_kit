// Widget and unit tests for the `triple_dots` component.
//
// Covers: token rendering (light + dark), counts, directions, sizes, the
// four theme legs, per-field merge and the old default-colour crash.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/triple_dots/triple_dots.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

List<BoxDecoration> _dotDecorations(WidgetTester tester) {
  return tester
      .widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(TripleDots),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((box) => box.decoration as BoxDecoration)
      .toList();
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('renders three muted dots by default', (tester) async {
    await tester.pumpWidget(_frame(child: const TripleDots()));
    final dots = _dotDecorations(tester);
    expect(dots, hasLength(3));
    for (final dot in dots) {
      expect(dot.color, colors.mutedForeground);
      expect(dot.shape, BoxShape.circle);
    }
    final box = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byType(TripleDots),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(box.width, 4);
  });

  testWidgets('dark tokens drive the dots', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(_frame(data: dark, child: const TripleDots()));
    expect(_dotDecorations(tester).first.color, dark.colors.mutedForeground);
  });

  testWidgets('count and direction control the layout', (tester) async {
    await tester.pumpWidget(_frame(child: const TripleDots(count: 4)));
    expect(_dotDecorations(tester), hasLength(4));
    expect(
      find.descendant(of: find.byType(TripleDots), matching: find.byType(Row)),
      findsOneWidget,
    );

    await tester.pumpWidget(
      _frame(child: const TripleDots(direction: Axis.vertical)),
    );
    expect(
      find.descendant(
        of: find.byType(TripleDots),
        matching: find.byType(Column),
      ),
      findsOneWidget,
    );
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = TripleDotsTheme(color: ThemedColor.value(_red));
    const green = TripleDotsTheme(color: ThemedColor.value(_green));
    const blue = TripleDotsTheme(color: ThemedColor.value(_blue));

    await tester.pumpWidget(
      _frame(app: <ComponentThemeData>[red], child: const TripleDots()),
    );
    expect(_dotDecorations(tester).first.color, _red);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<TripleDotsTheme>(
          data: green,
          child: TripleDots(),
        ),
      ),
    );
    expect(_dotDecorations(tester).first.color, _green);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<TripleDotsTheme>(
          data: green,
          child: TripleDots(theme: blue),
        ),
      ),
    );
    expect(_dotDecorations(tester).first.color, _blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TripleDotsTheme(color: ThemedColor.value(_red)),
        ],
        child: const ComponentTheme<TripleDotsTheme>(
          data: TripleDotsTheme(size: 6),
          child: TripleDots(theme: TripleDotsTheme(spacing: 8)),
        ),
      ),
    );
    final dots = _dotDecorations(tester);
    expect(dots.first.color, _red);
    final box = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byType(TripleDots),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(box.width, 6);
  });

  testWidgets('widget arguments beat every theme leg', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TripleDotsTheme(
            color: ThemedColor.value(_red),
            size: 10,
            spacing: 10,
          ),
        ],
        child: const TripleDots(color: _blue, size: 2, spacing: 1),
      ),
    );
    expect(_dotDecorations(tester).first.color, _blue);
  });

  testWidgets('renders without any DefaultTextStyle colour (regression)', (
    tester,
  ) async {
    // The old component read `DefaultTextStyle.style.color!` and threw when
    // the ambient style had no colour. The token default removes the crash
    // and the ambient text colour no longer leaks into the dots.
    await tester.pumpWidget(
      _frame(
        child: DefaultTextStyle(
          style: const TextStyle(color: _green),
          child: const TripleDots(),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(_dotDecorations(tester).first.color, colors.mutedForeground);
  });

  test('count must be positive', () {
    final int count = 0;
    expect(() => TripleDots(count: count), throwsAssertionError);
  });
}
