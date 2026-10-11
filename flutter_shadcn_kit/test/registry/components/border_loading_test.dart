// Widget and unit tests for the `border_loading` component.
//
// Covers: resolved style defaults, the four theme legs, the token-driven
// gradient palette in light + dark, every mode, determinate progress through
// both the widget argument and the stream, the zero-progress/zero-stroke
// guards and RTL.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/border_loading/border_loading.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: textDirection,
        child: Center(child: child),
      ),
    ),
  );
}

BorderLoadingTheme _style(WidgetTester tester) {
  final BorderLoading border = tester.widget<BorderLoading>(
    find.byType(BorderLoading),
  );
  return resolveBorderLoadingStyle(
    tester.element(find.byType(BorderLoading)),
    widgetTheme: border.theme,
    mode: border.mode,
    strokeWidth: border.strokeWidth,
    padding: border.padding,
    borderRadius: border.borderRadius,
    backgroundColor: border.backgroundColor,
    duration: border.duration,
    curve: border.curve,
    opacity: border.opacity,
  );
}

Finder _painter() => find.byWidgetPredicate(
  (Widget widget) => widget is CustomPaint && widget.painter != null,
);

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  testWidgets('style defaults: 2px stroke, radius 12, 1200ms, linear', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const BorderLoading(child: Text('x'))),
    );
    final BorderLoadingTheme style = _style(tester);
    expect(style.mode, BorderLoadingMode.sweepGradient);
    expect(style.strokeWidth, 2);
    expect(style.padding, const EdgeInsets.all(2));
    expect(style.borderRadius, const BorderRadius.all(Radius.circular(12)));
    expect(style.duration, const Duration(milliseconds: 1200));
    expect(style.curve, Curves.linear);
    expect(style.opacity, 1);
    expect(style.backgroundColor, isNull);
  });

  test('gradient palette follows the tokens in light and dark', () {
    final List<Color> lightColors = borderLoadingGradientColors
        .map((ThemedColor color) => color.resolve(light))
        .toList();
    expect(lightColors[1], light.primary);
    expect(lightColors[2], light.chart2);
    expect(lightColors[3], light.chart3);

    final List<Color> darkColors = borderLoadingGradientColors
        .map((ThemedColor color) => color.resolve(dark))
        .toList();
    expect(darkColors[1], dark.primary);
    expect(darkColors[2], dark.chart2);
    expect(darkColors, isNot(lightColors));
    // Transparent ends stay transparent in both modes.
    expect(lightColors.first.a, 0);
    expect(darkColors.last.a, 0);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          BorderLoadingTheme(
            strokeWidth: 4,
            duration: Duration(seconds: 3),
            mode: BorderLoadingMode.tracer,
          ),
        ],
        child: const BorderLoading(child: Text('x')),
      ),
    );
    BorderLoadingTheme style = _style(tester);
    expect(style.strokeWidth, 4);
    expect(style.duration, const Duration(seconds: 3));
    expect(style.mode, BorderLoadingMode.tracer);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[BorderLoadingTheme(strokeWidth: 4)],
        child: const ComponentTheme<BorderLoadingTheme>(
          data: BorderLoadingTheme(strokeWidth: 6),
          child: BorderLoading(child: Text('x')),
        ),
      ),
    );
    style = _style(tester);
    expect(style.strokeWidth, 6);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[BorderLoadingTheme(strokeWidth: 4)],
        child: const ComponentTheme<BorderLoadingTheme>(
          data: BorderLoadingTheme(strokeWidth: 6),
          child: BorderLoading(strokeWidth: 9, child: Text('x')),
        ),
      ),
    );
    style = _style(tester);
    expect(style.strokeWidth, 9);
  });

  testWidgets('every mode renders a painter', (tester) async {
    for (final BorderLoadingMode mode in BorderLoadingMode.values) {
      await tester.pumpWidget(
        _frame(
          child: BorderLoading(
            mode: mode,
            progress: 0.5,
            child: const Text('x'),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(_painter(), findsOneWidget);
    }
  });

  testWidgets('sweep mode draws the outline', (tester) async {
    await tester.pumpWidget(
      _frame(child: const BorderLoading(child: Text('x'))),
    );
    expect(_painter(), paints..path());
  });

  testWidgets('regression: zero progress draws nothing', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const BorderLoading(
          mode: BorderLoadingMode.progress,
          progress: 0,
          child: Text('x'),
        ),
      ),
    );
    expect(_painter(), paintsNothing);

    await tester.pumpWidget(
      _frame(
        child: const BorderLoading(
          mode: BorderLoadingMode.progress,
          progress: 1,
          child: Text('x'),
        ),
      ),
    );
    expect(_painter(), paints..path());
  });

  testWidgets('progressStream drives determinate progress', (tester) async {
    final StreamController<double> controller = StreamController<double>();
    addTearDown(controller.close);
    await tester.pumpWidget(
      _frame(
        child: BorderLoading(
          mode: BorderLoadingMode.progress,
          progress: 0,
          progressStream: controller.stream,
          child: const Text('x'),
        ),
      ),
    );
    expect(_painter(), paintsNothing);

    controller.add(0.75);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    expect(_painter(), paints..path());
  });

  testWidgets('tracer draws one path per dash', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const BorderLoading(
          mode: BorderLoadingMode.tracer,
          tracer: BorderTracerSpec(dashCount: 3),
          child: Text('x'),
        ),
      ),
    );
    expect(
      _painter(),
      paints
        ..path()
        ..path()
        ..path(),
    );
  });

  testWidgets('regression: zero stroke paints no border at all', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: const BorderLoading(
          strokeWidth: 0,
          backgroundColor: Color(0xFF00FF00),
          child: Text('x'),
        ),
      ),
    );
    expect(_painter(), findsNothing);
    expect(
      find.descendant(
        of: find.byType(BorderLoading),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is DecoratedBox && widget.decoration is ShapeDecoration,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('background fill follows the widget colour', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const BorderLoading(backgroundColor: _red, child: Text('x')),
      ),
    );
    final DecoratedBox box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(BorderLoading),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is DecoratedBox && widget.decoration is ShapeDecoration,
        ),
      ),
    );
    expect((box.decoration as ShapeDecoration).color, _red);
  });

  testWidgets('RTL renders', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: const BorderLoading(child: Text('x')),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('merge is receiver-wins per field', () {
    const BorderLoadingTheme base = BorderLoadingTheme(
      strokeWidth: 4,
      opacity: 0.5,
      mode: BorderLoadingMode.tracer,
    );
    const BorderLoadingTheme over = BorderLoadingTheme(strokeWidth: 8);
    final BorderLoadingTheme merged = over.merge(base);
    expect(merged.strokeWidth, 8);
    expect(merged.opacity, 0.5);
    expect(merged.mode, BorderLoadingMode.tracer);
  });
}
