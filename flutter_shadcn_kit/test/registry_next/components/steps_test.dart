// Widget tests for the `steps` component.
//
// Covers: numbered indicators, the connector count (regression: the old tree
// drew a trailing line under the last step), token rendering (light + dark),
// the four theme legs and `StepItem`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/steps/steps.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

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

List<BoxDecoration> _indicatorDecorations(WidgetTester tester) {
  return tester
      .widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(Steps),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((box) => box.decoration as BoxDecoration)
      .where((decoration) => decoration.shape == BoxShape.circle)
      .toList();
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  const List<Widget> threeSteps = <Widget>[
    StepItem(title: Text('One'), content: <Widget>[Text('first')]),
    StepItem(title: Text('Two'), content: <Widget>[Text('second')]),
    StepItem(title: Text('Three'), content: <Widget>[Text('third')]),
  ];

  testWidgets('numbers every step from one', (tester) async {
    await tester.pumpWidget(_frame(child: const Steps(children: threeSteps)));
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(_indicatorDecorations(tester), hasLength(3));
  });

  testWidgets('draws one connector fewer than the step count (regression)', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Steps(children: threeSteps)));
    // The old tree drew a connector under the last step too.
    expect(
      find.descendant(
        of: find.byType(Steps),
        matching: find.byType(ColoredBox),
      ),
      findsNWidgets(2),
    );
  });

  testWidgets('indicators use the muted token and foreground number', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Steps(children: threeSteps)));
    final BoxDecoration decoration = _indicatorDecorations(tester).first;
    expect(decoration.color, colors.muted);
    expect(decoration.shape, BoxShape.circle);
  });

  testWidgets('dark tokens drive the indicators', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: const Steps(children: threeSteps),
      ),
    );
    expect(_indicatorDecorations(tester).first.color, dark.colors.muted);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);
    const blue = Color(0xFF0000FF);

    Color? colorOf(WidgetTester tester) =>
        _indicatorDecorations(tester).first.color;

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          StepsTheme(indicatorColor: ThemedColor.value(red)),
        ],
        child: const Steps(children: threeSteps),
      ),
    );
    expect(colorOf(tester), red);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          StepsTheme(indicatorColor: ThemedColor.value(red)),
        ],
        child: const ComponentTheme<StepsTheme>(
          data: StepsTheme(indicatorColor: ThemedColor.value(green)),
          child: Steps(children: threeSteps),
        ),
      ),
    );
    expect(colorOf(tester), green);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          StepsTheme(indicatorColor: ThemedColor.value(red)),
        ],
        child: const ComponentTheme<StepsTheme>(
          data: StepsTheme(indicatorColor: ThemedColor.value(green)),
          child: Steps(
            theme: StepsTheme(indicatorColor: ThemedColor.value(blue)),
            children: threeSteps,
          ),
        ),
      ),
    );
    expect(colorOf(tester), blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          StepsTheme(
            indicatorColor: ThemedColor.value(Color(0xFFFF0000)),
            indicatorSize: 40,
          ),
        ],
        child: const ComponentTheme<StepsTheme>(
          data: StepsTheme(connectorThickness: 3),
          child: Steps(children: threeSteps),
        ),
      ),
    );
    final BoxDecoration decoration = _indicatorDecorations(tester).first;
    expect(decoration.color, const Color(0xFFFF0000));
    expect(
      tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(Steps),
              matching: find.byType(SizedBox),
            ),
          )
          .any((box) => box.width == 40 && box.height == 40),
      isTrue,
    );
  });

  testWidgets('StepItem renders the title as a heading', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Steps(
          children: <Widget>[
            StepItem(title: Text('Title'), content: <Widget>[Text('body')]),
          ],
        ),
      ),
    );
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('body'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
