// Widget tests for the `color_field` component.
//
// Covers the HSV/HSL modes, the axis routes through the shared gradient
// engine, the transparency checkerboard, the four theme-precedence legs, dark
// tokens and the old-bug regression: the old preview painter's
// `shouldRepaint` compared a hand-picked subset and missed colour edits.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/alpha/alpha.dart';
import 'package:flutter_shadcn_kit/registry_next/components/color_field/color_field.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ColorFieldTheme? scopedTheme,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<ColorFieldTheme>(data: scopedTheme, child: body);
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

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ColorFieldTheme? scopedTheme,
}) {
  return tester.pumpWidget(
    _frame(data: data, app: app, scopedTheme: scopedTheme, child: child),
  );
}

/// The `CustomPaint` in the field that is not the alpha checkerboard.
CustomPaint _fieldPaint(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(
        find.descendant(
          of: find.byType(ColorField),
          matching: find.byType(CustomPaint),
        ),
      )
      .firstWhere((paint) => paint.painter is! AlphaPainter);
}

bool _hasCheckerboard(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(
        find.descendant(
          of: find.byType(ColorField),
          matching: find.byType(CustomPaint),
        ),
      )
      .any((paint) => paint.painter is AlphaPainter);
}

BoxDecoration _foregroundDecoration(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(ColorField),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;

  group('surface', () {
    testWidgets('fills the box it is given', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 240,
          height: 160,
          child: ColorField(color: _blue),
        ),
      );
      expect(tester.getSize(find.byType(ColorField)), const Size(240, 160));
    });

    testWidgets('draws the token ring with radiusMd by default', (
      tester,
    ) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
      );
      final BoxDecoration decoration = _foregroundDecoration(tester);
      expect(decoration.border!.top.color, light.border);
      expect(decoration.border!.top.width, 1);
      expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusMd);
    });
  });

  group('checkerboard', () {
    testWidgets('hidden for an opaque colour without an alpha axis', (
      tester,
    ) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
      );
      expect(_hasCheckerboard(tester), isFalse);
    });

    testWidgets('shown for a translucent colour', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(color: Color(0x8000FF00)),
        ),
      );
      expect(_hasCheckerboard(tester), isTrue);
    });

    testWidgets('shown for an alpha ramp on an opaque colour', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(color: _blue, alphaAxis: ColorFieldAxis.horizontal),
        ),
      );
      expect(_hasCheckerboard(tester), isTrue);
    });

    testWidgets('a theme can disable it', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(color: Color(0x8000FF00)),
        ),
        scopedTheme: const ColorFieldTheme(checkerboard: false),
      );
      expect(_hasCheckerboard(tester), isFalse);
    });
  });

  group('gradient engine', () {
    testWidgets('no axes paints the flat colour', (tester) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
      );
      final _Recorder recorder = _Recorder();
      _fieldPaint(tester).painter!.paint(recorder, const Size(40, 40));
      expect(recorder.fillColors, contains(_blue));
      expect(recorder.sawShader, isFalse);
    });

    testWidgets('an axis routes through the HSV engine as a gradient', (
      tester,
    ) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(
            color: _blue,
            saturationAxis: ColorFieldAxis.horizontal,
          ),
        ),
      );
      final _Recorder recorder = _Recorder();
      _fieldPaint(tester).painter!.paint(recorder, const Size(40, 40));
      expect(recorder.sawShader, isTrue);
    });

    testWidgets('the HSL mode paints a lightness ramp too', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(
            color: _green,
            mode: ColorFieldMode.hsl,
            lightnessAxis: ColorFieldAxis.vertical,
          ),
        ),
      );
      final _Recorder recorder = _Recorder();
      _fieldPaint(tester).painter!.paint(recorder, const Size(40, 40));
      expect(recorder.sawShader, isTrue);
    });

    testWidgets('regression: shouldRepaint sees a colour-only change', (
      tester,
    ) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
      );
      final CustomPainter before = _fieldPaint(tester).painter!;
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _green)),
      );
      final CustomPainter after = _fieldPaint(tester).painter!;
      expect(after.shouldRepaint(before), isTrue);
      expect(after.shouldRepaint(after), isFalse);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
        app: const <ComponentThemeData>[
          ColorFieldTheme(borderColor: ThemedColor.value(_green)),
        ],
      );
      expect(_foregroundDecoration(tester).border!.top.color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
        app: const <ComponentThemeData>[
          ColorFieldTheme(borderColor: ThemedColor.value(_green)),
        ],
        scopedTheme: const ColorFieldTheme(
          borderColor: ThemedColor.value(_blue),
        ),
      );
      expect(_foregroundDecoration(tester).border!.top.color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(
            color: _blue,
            theme: ColorFieldTheme(borderColor: ThemedColor.value(_blue)),
          ),
        ),
        scopedTheme: const ColorFieldTheme(
          borderColor: ThemedColor.value(_green),
        ),
      );
      expect(_foregroundDecoration(tester).border!.top.color, _blue);
    });

    testWidgets('a leg setting only width keeps the token colour', (
      tester,
    ) async {
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
        scopedTheme: const ColorFieldTheme(borderWidth: 3),
      );
      final BoxDecoration decoration = _foregroundDecoration(tester);
      expect(decoration.border!.top.width, 3);
      expect(decoration.border!.top.color, light.border);
    });

    testWidgets('borderWidth 0 hides the ring', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(
            color: _blue,
            theme: ColorFieldTheme(borderWidth: 0),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(ColorField),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the ring', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await _pump(
        tester,
        const SizedBox(width: 40, height: 40, child: ColorField(color: _blue)),
        data: const ShadcnThemeData(colors: dark),
      );
      expect(_foregroundDecoration(tester).border!.top.color, dark.border);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await _pump(
        tester,
        const SizedBox(
          width: 40,
          height: 40,
          child: ColorField(
            color: _blue,
            theme: ColorFieldTheme(
              borderColor: ThemedColor.ref(ColorRef.border, alpha: 0.5),
            ),
          ),
        ),
        data: const ShadcnThemeData(colors: dark),
      );
      expect(
        _foregroundDecoration(tester).border!.top.color.a,
        closeTo(dark.border.a * 0.5, 0.001),
      );
    });
  });

  group('defaults table', () {
    test('token-derived values match the field ring', () {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      expect(colorFieldDefaults.borderColor?.resolve(colors), colors.border);
      expect(colorFieldDefaults.borderWidth, 1);
      expect(colorFieldDefaults.checkerboard, isTrue);
      expect(colorFieldDefaults.borderRadius, isNull);
    });

    test('merge and lerp keep the receiver and step flags', () {
      const ColorFieldTheme receiver = ColorFieldTheme(borderWidth: 2);
      const ColorFieldTheme fallback = ColorFieldTheme(
        borderColor: ThemedColor.value(_green),
        borderWidth: 9,
      );
      final ColorFieldTheme merged = receiver.merge(fallback);
      expect(merged.borderWidth, 2);
      expect((merged.borderColor! as LiteralColor).color, _green);
      final ColorFieldTheme stepped = ColorFieldTheme.lerp(
        receiver,
        fallback,
        0.25,
      );
      expect(stepped.borderWidth, 3.75);
      expect(stepped.borderColor, isNull);
    });
  });
}

/// Canvas that records the first shader and every `drawRect` fill colour.
class _Recorder implements Canvas {
  final List<Color> fillColors = <Color>[];
  bool sawShader = false;

  @override
  void noSuchMethod(Invocation invocation) {
    if (invocation.memberName == const Symbol('drawRect')) {
      final Paint paint = invocation.positionalArguments[1] as Paint;
      if (paint.shader != null) {
        sawShader = true;
      } else {
        fillColors.add(paint.color);
      }
    }
  }
}
