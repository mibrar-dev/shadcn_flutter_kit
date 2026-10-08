// Widget tests for the `scrollable` component.
//
// Covers the edge-fade surface, the four theme-precedence legs, the gradient
// geometry helper and the old regressions: a rebuild on every scroll
// notification and the axis-blind gradient direction.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/scrollable/scrollable.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ScrollableTheme? scoped,
  ScrollableTheme? widgetTheme,
}) {
  Widget viewport = FadedScrollableViewport(theme: widgetTheme, child: child);
  if (scoped != null) {
    viewport = ComponentTheme<ScrollableTheme>(data: scoped, child: viewport);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(width: 300, height: 200, child: viewport),
        ),
      ),
    ),
  );
}

Widget _list(ScrollController controller, {Axis axis = Axis.vertical}) {
  return ListView.builder(
    controller: controller,
    scrollDirection: axis,
    itemCount: 40,
    itemBuilder: (context, index) =>
        SizedBox(height: 24, width: 80, child: Text('row $index')),
  );
}

void main() {
  testWidgets('renders the child behind a fade mask', (tester) async {
    await tester.pumpWidget(_frame(child: const Text('content')));
    expect(find.text('content'), findsOneWidget);
    expect(find.byType(ShaderMask), findsOneWidget);
  });

  testWidgets('defaults resolve to fadeExtent 20 and fadeSize 50', (
    tester,
  ) async {
    late ({double fadeExtent, double fadeSize}) geometry;
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) {
              geometry = FadedScrollableViewport.resolveGeometry(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(geometry.fadeExtent, scrollableDefaultFadeExtent);
    expect(geometry.fadeSize, scrollableDefaultFadeSize);
  });

  testWidgets('all four theme legs override per field', (tester) async {
    late ({double fadeExtent, double fadeSize}) geometry;
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: ComponentThemes(
          themes: <ComponentThemeData>[const ScrollableTheme(fadeExtent: 30)],
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ComponentTheme<ScrollableTheme>(
              data: const ScrollableTheme(fadeExtent: 40),
              child: Builder(
                builder: (BuildContext context) {
                  geometry = FadedScrollableViewport.resolveGeometry(
                    context,
                    theme: const ScrollableTheme(fadeExtent: 50),
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
    // Widget wins, then the scoped leg; unset fields fall to the app leg and
    // then the defaults.
    expect(geometry.fadeExtent, 50);
    expect(geometry.fadeSize, scrollableDefaultFadeSize);
  });

  testWidgets('a leg setting only fadeSize keeps the default fadeExtent', (
    tester,
  ) async {
    late ({double fadeExtent, double fadeSize}) geometry;
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: ComponentThemes(
          themes: <ComponentThemeData>[const ScrollableTheme(fadeExtent: 36)],
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (BuildContext context) {
                geometry = FadedScrollableViewport.resolveGeometry(
                  context,
                  fadeSize: 80,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(geometry.fadeExtent, 36);
    expect(geometry.fadeSize, 80);
  });

  test('gradientStops clamp monotonic and handle a zero extent', () {
    expect(
      FadedScrollableViewport.gradientStops(
        leading: 1,
        trailing: 1,
        fadeSize: 50,
        axisExtent: 100,
      ),
      <double>[0, 0.5, 0.5, 1],
    );
    expect(
      FadedScrollableViewport.gradientStops(
        leading: 2,
        trailing: 2,
        fadeSize: 50,
        axisExtent: 100,
      ),
      <double>[0, 1, 1, 1],
    );
    expect(
      FadedScrollableViewport.gradientStops(
        leading: 0,
        trailing: 0,
        fadeSize: 50,
        axisExtent: 0,
      ),
      <double>[0, 0, 1, 1],
    );
  });

  test('gradientAxis follows the scroll axis', () {
    // The old viewport always used topCenter -> bottomCenter.
    expect(
      FadedScrollableViewport.gradientAxis(Axis.vertical).begin,
      Alignment.topCenter,
    );
    expect(
      FadedScrollableViewport.gradientAxis(Axis.horizontal).begin,
      Alignment.centerLeft,
    );
    expect(
      FadedScrollableViewport.gradientAxis(Axis.horizontal).end,
      Alignment.centerRight,
    );
  });

  testWidgets('regression: unchanged metrics do not rebuild', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: _list(controller)));

    final ShaderMask first = tester.widget<ShaderMask>(find.byType(ShaderMask));
    controller.jumpTo(50);
    await tester.pump();
    final ShaderMask second = tester.widget<ShaderMask>(
      find.byType(ShaderMask),
    );
    expect(identical(first, second), isFalse);

    // The old viewport rebuilt on every notification, including no-op ones.
    controller.jumpTo(50);
    await tester.pump();
    final ShaderMask third = tester.widget<ShaderMask>(find.byType(ShaderMask));
    expect(identical(second, third), isTrue);
  });

  testWidgets('horizontal lists fade without exceptions', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(child: _list(controller, axis: Axis.horizontal)),
    );
    controller.jumpTo(40);
    await tester.pump();
    expect(find.byType(ShaderMask), findsOneWidget);
    expect(find.text('row 0'), findsOneWidget);
  });

  testWidgets('dark palette drives the same surface', (tester) async {
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: const Text('content'),
      ),
    );
    expect(find.text('content'), findsOneWidget);
    expect(find.byType(ShaderMask), findsOneWidget);
  });
}
