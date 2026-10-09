// Tests for the `hsv` component.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/hsv/hsv.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required HSVColorSliderType type,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  HSVSliderStyle? style,
  ValueChanged<HSVColor>? onChanged,
  ValueChanged<HSVColor>? onChanging,
  bool enabled = true,
  bool reverse = false,
  bool autofocus = false,
  HSVColor color = const HSVColor.fromAHSV(1, 120, 0.5, 0.5),
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
              child: HSVColorSlider(
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
    for (final type in HSVColorSliderType.values) {
      testWidgets('renders every slider type ($type) in light and dark', (
        tester,
      ) async {
        for (final data in <ShadcnThemeData>[
          const ShadcnThemeData(),
          const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ]) {
          await _pump(tester, type: type, data: data);
          expect(find.byType(HSVColorSlider), findsOneWidget);
          expect(
            find.byWidgetPredicate(
              (w) => w is CustomPaint && w.painter is HSVColorSliderPainter,
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
      HSVColor? committed;
      await _pump(
        tester,
        type: HSVColorSliderType.hueSat,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSVColorSlider));
      await tester.tapAt(topLeft + const Offset(0, 120));
      expect(committed, isNotNull);
      expect(committed!.hue, closeTo(180, 1));
      expect(committed!.saturation, closeTo(0, 0.01));
    });

    testWidgets('tap on a single-channel hue bar sets only hue', (
      tester,
    ) async {
      HSVColor? committed;
      await _pump(
        tester,
        type: HSVColorSliderType.hue,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSVColorSlider));
      await tester.tapAt(topLeft + const Offset(120, 230));
      expect(committed!.hue, closeTo(345, 1));
      expect(committed!.saturation, closeTo(0.5, 0.01));
    });

    testWidgets('drag fires onChanging and onChanged on end', (tester) async {
      var changing = 0;
      HSVColor? committed;
      await _pump(
        tester,
        type: HSVColorSliderType.alpha,
        onChanging: (_) => changing++,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSVColorSlider));
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
      HSVColor? committed;
      await _pump(
        tester,
        type: HSVColorSliderType.hueSat,
        reverse: true,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSVColorSlider));
      await tester.tapAt(topLeft + const Offset(120, 0));
      // Reversed: x steers hue (y steers saturation).
      expect(committed!.hue, closeTo(180, 1));
      expect(committed!.saturation, closeTo(0, 0.01));
    });

    testWidgets('keyboard nudges the single channel', (tester) async {
      HSVColor? changing;
      await _pump(
        tester,
        type: HSVColorSliderType.hue,
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
      HSVColor? committed;
      await _pump(
        tester,
        type: HSVColorSliderType.hue,
        enabled: false,
        onChanged: (c) => committed = c,
      );
      final topLeft = tester.getTopLeft(find.byType(HSVColorSlider));
      await tester.tapAt(topLeft + const Offset(120, 120));
      expect(committed, isNull);
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(HSVColorSlider),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, 0.5);
    });
  });

  group('theme', () {
    HSVSliderStyle? cursorStyle(WidgetTester tester) {
      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final c in containers) {
        final d = c.decoration;
        if (d is BoxDecoration &&
            d.shape == BoxShape.circle &&
            d.border is Border) {
          return HSVSliderStyle(cursorWidth: (d.border as Border).top.width);
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
              HSVSliderTheme(slider: HSVSliderStyle(cursorWidth: 9)),
            ],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ComponentTheme<HSVSliderTheme>(
                    data: const HSVSliderTheme(
                      slider: HSVSliderStyle(cursorWidth: 5),
                    ),
                    child: HSVColorSlider(
                      key: key,
                      color: const HSVColor.fromAHSV(1, 120, 0.5, 0.5),
                      sliderType: HSVColorSliderType.hueSat,
                      style: const HSVSliderStyle(cursorWidth: 2),
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
      late HSVSliderStyle treeResolved;
      late HSVSliderStyle widgetResolved;
      late HSVSliderStyle appResolved;

      const app = <ComponentThemeData>[
        HSVSliderTheme(slider: HSVSliderStyle(cursorWidth: 9)),
      ];

      // tree leg beats the app leg; the widget leg beats both.
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: app,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ComponentTheme<HSVSliderTheme>(
                data: const HSVSliderTheme(
                  slider: HSVSliderStyle(cursorWidth: 5),
                ),
                child: Builder(
                  builder: (context) {
                    treeResolved =
                        resolveComponentStyle<HSVSliderTheme, HSVSliderStyle>(
                          context,
                          select: (t) => t.slider,
                          defaults: hsvSliderDefaults.slider!,
                        );
                    widgetResolved =
                        resolveComponentStyle<HSVSliderTheme, HSVSliderStyle>(
                          context,
                          widget: const HSVSliderStyle(cursorWidth: 2),
                          select: (t) => t.slider,
                          defaults: hsvSliderDefaults.slider!,
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
                      resolveComponentStyle<HSVSliderTheme, HSVSliderStyle>(
                        context,
                        select: (t) => t.slider,
                        defaults: hsvSliderDefaults.slider!,
                      );
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
      expect(appResolved.cursorWidth, 9);
      expect(hsvSliderDefaults.slider!.cursorWidth, 2);
    });
  });
}
