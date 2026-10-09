// Widget tests for the `scrollbar` component.
//
// Covers token defaults (light + dark), the four theme-precedence legs, alpha
// multiplication and the forwarded RawScrollbar flags. The regression test
// pins the old bug: the `theme:` widget-leg parameter was never read.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollbar/scrollbar.dart';
import 'package:flutter_shadcn_kit/registry/primitives/scroll_metrics.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required ScrollController controller,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ScrollbarTheme? scoped,
  ScrollbarTheme? widgetTheme,
  bool? thumbVisibility,
  bool? trackVisibility,
  bool? interactive,
}) {
  Widget bar = Scrollbar(
    controller: controller,
    thumbVisibility: thumbVisibility,
    trackVisibility: trackVisibility,
    interactive: interactive,
    theme: widgetTheme,
    child: ListView.builder(
      controller: controller,
      itemCount: 40,
      itemBuilder: (context, index) =>
          SizedBox(height: 24, child: Text('row $index')),
    ),
  );
  if (scoped != null) {
    bar = ComponentTheme<ScrollbarTheme>(data: scoped, child: bar);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 300, height: 200, child: bar)),
      ),
    ),
  );
}

RawScrollbar _raw(WidgetTester tester) =>
    tester.widget<RawScrollbar>(find.byType(RawScrollbar));

int _hex(Color color) => color.toARGB32();

void main() {
  testWidgets('uses the border token, 7px thickness and radiusSm by default', (
    tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller: controller));

    final RawScrollbar raw = _raw(tester);
    expect(_hex(raw.thumbColor!), _hex(ShadcnColors.lightFallback.border));
    expect(raw.thickness, scrollbarDefaultThickness);
    expect(raw.radius, const Radius.circular(4));
    expect(raw.minThumbLength, kMinScrollbarThumbExtent);
    expect(raw.interactive, isNull);
  });

  testWidgets('dark palette drives the same slots', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ),
    );

    final RawScrollbar raw = _raw(tester);
    expect(_hex(raw.thumbColor!), _hex(ShadcnColors.darkFallback.border));
  });

  testWidgets('app leg overrides the defaults', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        app: <ComponentThemeData>[const ScrollbarTheme(thickness: 11)],
      ),
    );

    expect(_raw(tester).thickness, 11);
  });

  testWidgets('scoped leg overrides the app leg', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        app: <ComponentThemeData>[const ScrollbarTheme(thickness: 11)],
        scoped: const ScrollbarTheme(thickness: 12),
      ),
    );

    expect(_raw(tester).thickness, 12);
  });

  testWidgets('widget leg overrides the scoped leg', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        app: <ComponentThemeData>[const ScrollbarTheme(thickness: 11)],
        scoped: const ScrollbarTheme(thickness: 12),
        widgetTheme: const ScrollbarTheme(thickness: 13),
      ),
    );

    expect(_raw(tester).thickness, 13);
  });

  testWidgets('regression: the widget leg reaches RawScrollbar', (
    tester,
  ) async {
    // The old wrapper accepted a `theme` parameter and dropped it before
    // building the scrollbar, so this override never painted.
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        widgetTheme: const ScrollbarTheme(
          color: ThemedColor.value(Color(0xFF00FF00)),
        ),
      ),
    );

    expect(_hex(_raw(tester).thumbColor!), 0xFF00FF00);
  });

  testWidgets('alpha multiplies the token alpha', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        scoped: const ScrollbarTheme(
          color: ThemedColor.ref(ColorRef.border, alpha: 0.5),
        ),
      ),
    );

    final double expected = ShadcnColors.lightFallback.border.a * 0.5;
    expect(_raw(tester).thumbColor!.a, closeTo(expected, 0.001));
  });

  testWidgets('a leg setting only thickness keeps the token colour', (
    tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        scoped: const ScrollbarTheme(thickness: 9),
      ),
    );

    final RawScrollbar raw = _raw(tester);
    expect(raw.thickness, 9);
    expect(_hex(raw.thumbColor!), _hex(ShadcnColors.lightFallback.border));
  });

  testWidgets('flags are forwarded to RawScrollbar', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        thumbVisibility: true,
        trackVisibility: true,
        interactive: false,
      ),
    );

    final RawScrollbar raw = _raw(tester);
    expect(raw.thumbVisibility, isTrue);
    expect(raw.trackVisibility, isTrue);
    expect(raw.interactive, isFalse);
  });

  testWidgets('minOverscrollLength and minThumbLength overrides apply', (
    tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        controller: controller,
        widgetTheme: const ScrollbarTheme(
          minThumbLength: 80,
          minOverscrollLength: 24,
        ),
      ),
    );

    final RawScrollbar raw = _raw(tester);
    expect(raw.minThumbLength, 80);
    expect(raw.minOverscrollLength, 24);
  });
}
