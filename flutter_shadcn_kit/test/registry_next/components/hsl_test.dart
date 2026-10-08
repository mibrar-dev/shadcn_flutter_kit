// Tests for the `hsl` component.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/hsl/hsl.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required HSLColorSliderType type,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  HSLSliderStyle? style,
  ValueChanged<HSLColor>? onChanged,
  ValueChanged<HSLColor>? onChanging,
  bool enabled = true,
  bool reverse = false,
  bool autofocus = false,
  HSLColor color = const HSLColor.fromAHSL(1, 120, 0.5, 0.5),
}) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: data,
      child: ComponentThemes(
        themes: app,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: HSLColorSlider(
                color: color,
                sliderType: type,
                reverse: reverse,
                enabled: enabled,
                autofocus: autofocus,
                style: style,
                onChanged: onChanged ?? (_) {},
                onChanging: onChanging,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('rendering', () {
    for (final type in HSLColorSliderType.values) {
      testWidgets('renders every slider type ($type) in light and dark', (
        tester,
      ) async {
        for (final data in <ShadcnThemeData>[
          const ShadcnThemeData(),
          const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ]) {
          await _pump(tester, type: type, data: data);
          expect(find.byType(HSLColorSlider), findsOneWidget);
          expect(
            find.byWidgetPredicate(
              (w) => w is CustomPaint && w.painter is HSLColorSliderPainter,
            ),
            findsOneWidget,
          );
        }
      });
    }
  });

  group('interaction', () {
    testWidgets('tap on the hueSat pad sets hue (vertical) + sat (x)', (
      tester,
    ) async {
      HSLColor? committed;
      await _pump(
        tester,
        type: HSLColorSliderType.hueSat,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSLColorSlider));
      await tester.tapAt(topLeft + const Offset(0, 120));
      expect(committed, isNotNull);
      expect(committed!.hue, closeTo(180, 1));
      expect(committed!.saturation, closeTo(0, 0.01));
    });

    testWidgets('tap on a single-channel hue bar sets only hue', (
      tester,
    ) async {
      HSLColor? committed;
      await _pump(
        tester,
        type: HSLColorSliderType.hue,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSLColorSlider));
      await tester.tapAt(topLeft + const Offset(120, 230));
      expect(committed!.hue, closeTo(345, 1));
      expect(committed!.saturation, closeTo(0.5, 0.01));
    });

    testWidgets('drag fires onChanging and onChanged on end', (tester) async {
      var changing = 0;
      HSLColor? committed;
      await _pump(
        tester,
        type: HSLColorSliderType.alpha,
        onChanging: (_) => changing++,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSLColorSlider));
      final gesture = await tester.startGesture(
        topLeft + const Offset(120, 120),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, 60));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.up();
      expect(changing, greaterThan(0));
      expect(committed, isNotNull);
      expect(committed!.alpha, closeTo(0.75, 0.02));
    });

    testWidgets('reverse swaps the tap axes', (tester) async {
      HSLColor? committed;
      await _pump(
        tester,
        type: HSLColorSliderType.hueSat,
        reverse: true,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSLColorSlider));
      await tester.tapAt(topLeft + const Offset(120, 0));
      // Reversed: x steers hue (y steers saturation).
      expect(committed!.hue, closeTo(180, 1));
      expect(committed!.saturation, closeTo(0, 0.01));
    });

    testWidgets('keyboard nudges the single channel', (tester) async {
      HSLColor? changing;
      await _pump(
        tester,
        type: HSLColorSliderType.hue,
        autofocus: true,
        onChanging: (c) => changing = c,
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(changing, isNotNull);
      expect(changing!.hue, closeTo(120 + 360 / 32, 0.6));
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      expect(changing!.hue, closeTo(0, 0.6));
    });

    testWidgets('disabled: gestures ignored, whole control dimmed', (
      tester,
    ) async {
      HSLColor? committed;
      await _pump(
        tester,
        type: HSLColorSliderType.hue,
        enabled: false,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSLColorSlider));
      await tester.tapAt(topLeft + const Offset(120, 120));
      expect(committed, isNull);
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(HSLColorSlider),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, 0.5);
    });
  });

  group('theme', () {
    HSLSliderStyle? cursorStyle(WidgetTester tester) {
      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final c in containers) {
        final d = c.decoration;
        if (d is BoxDecoration &&
            d.shape == BoxShape.circle &&
            d.border is Border) {
          return HSLSliderStyle(cursorWidth: (d.border as Border).top.width);
        }
      }
      return null;
    }

    testWidgets('widget > tree > app > defaults on cursor metrics', (
      tester,
    ) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[
              HSLSliderTheme(slider: HSLSliderStyle(cursorWidth: 9)),
            ],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ComponentTheme<HSLSliderTheme>(
                    data: const HSLSliderTheme(
                      slider: HSLSliderStyle(cursorWidth: 5),
                    ),
                    child: HSLColorSlider(
                      key: key,
                      color: const HSLColor.fromAHSL(1, 120, 0.5, 0.5),
                      sliderType: HSLColorSliderType.hueSat,
                      style: const HSLSliderStyle(cursorWidth: 2),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      // widget leg wins
      final w = cursorStyle(tester);
      expect(w?.cursorWidth, 2.0);
    });

    testWidgets('all four legs resolve receiver-wins', (tester) async {
      late HSLSliderStyle treeResolved;
      late HSLSliderStyle widgetResolved;
      late HSLSliderStyle appResolved;

      const app = <ComponentThemeData>[
        HSLSliderTheme(slider: HSLSliderStyle(cursorWidth: 9)),
      ];

      // tree leg beats the app leg; the widget leg beats both.
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: app,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ComponentTheme<HSLSliderTheme>(
                data: const HSLSliderTheme(
                  slider: HSLSliderStyle(cursorWidth: 5),
                ),
                child: Builder(
                  builder: (context) {
                    treeResolved =
                        resolveComponentStyle<HSLSliderTheme, HSLSliderStyle>(
                          context,
                          select: (t) => t.slider,
                          defaults: hslSliderDefaults.slider!,
                        );
                    widgetResolved =
                        resolveComponentStyle<HSLSliderTheme, HSLSliderStyle>(
                          context,
                          widget: const HSLSliderStyle(cursorWidth: 2),
                          select: (t) => t.slider,
                          defaults: hslSliderDefaults.slider!,
                        );
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(treeResolved.cursorWidth, 5);
      expect(widgetResolved.cursorWidth, 2);

      // app leg beats the defaults leg.
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: app,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (context) {
                  appResolved =
                      resolveComponentStyle<HSLSliderTheme, HSLSliderStyle>(
                        context,
                        select: (t) => t.slider,
                        defaults: hslSliderDefaults.slider!,
                      );
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
      expect(appResolved.cursorWidth, 9);
      expect(hslSliderDefaults.slider!.cursorWidth, 2);
    });
  });
}
