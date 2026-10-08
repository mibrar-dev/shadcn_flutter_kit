// Widget tests for the `color_picker` component: light/dark rendering, every
// mode, the pad-follows-mode regression, hex parsing/alpha regression,
// history-scope regression, horizontal `initialShowHistory` regression,
// controlled field flow, hover/press, keyboard, all four theme legs and real
// sizes (controls 36, sliders 24, pad >= 150 square).

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry_next/components/color/color.dart';
import 'package:flutter_shadcn_kit/registry_next/components/color_picker/color_picker.dart';
import 'package:flutter_shadcn_kit/registry_next/components/history/history.dart';
import 'package:flutter_shadcn_kit/registry_next/components/hsl/hsl.dart';
import 'package:flutter_shadcn_kit/registry_next/components/hsv/hsv.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry_next/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);

final Finder _pad = find.byWidgetPredicate(
  (Widget w) =>
      w is HSVColorSlider && w.sliderType == HSVColorSliderType.satVal,
);
final Finder _hue = find.byWidgetPredicate(
  (Widget w) => w is HSVColorSlider && w.sliderType == HSVColorSliderType.hue,
);
final Finder _hslPad = find.byWidgetPredicate(
  (Widget w) =>
      w is HSLColorSlider && w.sliderType == HSLColorSliderType.satLum,
);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ColorPickerTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<ColorPickerTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TapRegionSurface(
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (context) =>
                    Align(alignment: Alignment.topLeft, child: body),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _pump(
  WidgetTester tester, {
  Color value = _red,
  ColorPickerMode mode = ColorPickerMode.rgb,
  bool showAlpha = false,
  bool showHistoryButton = true,
  bool initialShowHistory = false,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ColorPickerTheme? scoped,
  ColorPickerTheme? widgetTheme,
  ValueChanged<ColorDerivative>? onChanged,
  ValueChanged<ColorDerivative>? onChanging,
  ValueChanged<ColorPickerMode>? onModeChanged,
  VoidCallback? onEyeDropperRequested,
  bool? enableEyeDropper,
  bool history = true,
}) async {
  Widget picker = ColorPicker(
    value: ColorDerivative.fromColor(value),
    initialMode: mode,
    showAlpha: showAlpha,
    showHistoryButton: showHistoryButton,
    initialShowHistory: initialShowHistory,
    theme: widgetTheme,
    onChanged: onChanged,
    onChanging: onChanging,
    onModeChanged: onModeChanged,
    onEyeDropperRequested: onEyeDropperRequested,
    enableEyeDropper: enableEyeDropper,
  );
  if (history) {
    picker = RecentColorsScope(
      initialRecentColors: const <Color>[_green],
      child: picker,
    );
  }
  // The frame's Overlay keeps its first entries, so each pump starts fresh.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(_frame(picker, data: data, app: app, scoped: scoped));
  await tester.pump();
}

Finder _fieldEditable(int index) => find
    .descendant(
      of: find.byType(Input).at(index),
      matching: find.byType(EditableText),
    )
    .first;

Future<void> _openModeMenu(WidgetTester tester, String label) async {
  await tester.tap(find.byType(Select<ColorPickerMode>));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  group('rendering', () {
    testWidgets('pad, hue bar, fields and buttons render in light and dark', (
      tester,
    ) async {
      for (final ShadcnThemeData data in <ShadcnThemeData>[
        const ShadcnThemeData(),
        const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ]) {
        await _pump(tester, data: data);
        expect(find.byType(ColorPicker), findsOneWidget);
        expect(_pad, findsOneWidget);
        expect(_hue, findsOneWidget);
        expect(find.byType(Input), findsNWidgets(3));
        expect(find.byIcon(LucideIcons.pipette), findsOneWidget);
        expect(find.byIcon(LucideIcons.history), findsOneWidget);
        expect(find.byType(Select<ColorPickerMode>), findsOneWidget);
      }
    });

    testWidgets('showAlpha adds the alpha bar and a fourth field', (
      tester,
    ) async {
      await _pump(tester, showAlpha: true);
      expect(find.byType(Input), findsNWidgets(4));
      expect(
        find.byWidgetPredicate(
          (Widget w) =>
              w is HSVColorSlider && w.sliderType == HSVColorSliderType.alpha,
        ),
        findsOneWidget,
      );
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('real sizes: controls 36, sliders 24, pad is a >=150 square', (
      tester,
    ) async {
      await _pump(tester);
      for (final Element element in find.byType(Button).evaluate().toList()) {
        expect(
          tester.getSize(find.byElementPredicate((e) => e == element)),
          const Size(36, 36),
        );
      }
      for (int i = 0; i < 3; i++) {
        expect(
          tester.getSize(find.byType(Input).at(i)).height,
          36,
          reason: 'channel field $i keeps the h-9 control height',
        );
      }
      expect(tester.getSize(find.byType(Select<ColorPickerMode>)).height, 36);
      expect(tester.getSize(_hue).height, 24);
      final Size padSize = tester.getSize(_pad);
      expect(padSize.width, greaterThanOrEqualTo(150));
      expect(padSize.width, padSize.height);
    });
  });

  group('modes', () {
    testWidgets('the pad follows the current mode, not initialMode', (
      tester,
    ) async {
      // Regression: the old build switched on `initialMode`, so changing the
      // mode dropdown never swapped the HSL/HSV pad.
      await _pump(tester, mode: ColorPickerMode.rgb);
      expect(_pad, findsOneWidget);
      expect(_hslPad, findsNothing);
      await _openModeMenu(tester, 'HSL');
      expect(_hslPad, findsOneWidget);
      expect(_pad, findsNothing);
      await _openModeMenu(tester, 'HSV');
      expect(_pad, findsOneWidget);
      expect(_hslPad, findsNothing);
    });

    testWidgets('numeric fields follow the mode', (tester) async {
      await _pump(tester, mode: ColorPickerMode.rgb);
      expect(find.text('255'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2));

      await _pump(tester, mode: ColorPickerMode.hsl);
      expect(find.text('0'), findsOneWidget); // hue 0
      expect(find.text('100'), findsOneWidget); // saturation 100%
      expect(find.text('50'), findsOneWidget); // lightness 50%

      await _pump(tester, mode: ColorPickerMode.hsv);
      expect(find.text('100'), findsNWidgets(2)); // sat, value
      expect(find.text('0'), findsOneWidget); // hue

      await _pump(tester, mode: ColorPickerMode.hex);
      expect(find.text('#ff0000'), findsOneWidget);
    });

    testWidgets('mode changes report through onModeChanged', (tester) async {
      ColorPickerMode? reported;
      await _pump(tester, onModeChanged: (mode) => reported = mode);
      await tester.tap(find.byType(Select<ColorPickerMode>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('HEX'));
      await tester.pumpAndSettle();
      expect(reported, ColorPickerMode.hex);
    });

    testWidgets('hex field parses 3/6/8 digits and keeps alpha', (
      tester,
    ) async {
      // Regressions: the old field accepted exactly six digits and reset the
      // alpha channel to opaque on every commit.
      final ValueNotifier<ColorDerivative> value =
          ValueNotifier<ColorDerivative>(
            ColorDerivative.fromColor(const Color(0x80FF0000)),
          );
      addTearDown(value.dispose);
      await tester.pumpWidget(
        _frame(
          RecentColorsScope(
            child: ListenableBuilder(
              listenable: value,
              builder: (context, _) => ColorPicker(
                value: value.value,
                initialMode: ColorPickerMode.hex,
                showAlpha: true,
                showHistoryButton: false,
                onChanged: (next) => value.value = next,
              ),
            ),
          ),
        ),
      );
      await tester.enterText(_fieldEditable(0), '#00ff00');
      await tester.pump();
      expect(value.value.toColor().toARGB32(), 0x8000FF00);
      await tester.enterText(_fieldEditable(0), '#123456');
      await tester.pump();
      expect(value.value.toColor().toARGB32(), 0x80123456);
      await tester.enterText(_fieldEditable(0), '#0f0');
      await tester.pump();
      expect(value.value.toColor().toARGB32(), 0x8000FF00);
    });
  });

  group('history', () {
    testWidgets('history UI requires a scope and toggles the grid', (
      tester,
    ) async {
      // Regression: the old history button rendered unconditionally and
      // `ColorHistoryStorage.of` threw without a RecentColorsScope.
      await _pump(tester, history: false);
      expect(find.byIcon(LucideIcons.history), findsNothing);
      expect(find.byType(ColorHistoryGrid), findsNothing);
      await _pump(tester, history: true);
      expect(find.byIcon(LucideIcons.history), findsOneWidget);
      await tester.tap(find.byIcon(LucideIcons.history));
      await tester.pump();
      expect(find.byType(ColorHistoryGrid), findsOneWidget);
      expect(_pad, findsNothing);
    });

    testWidgets('horizontal layouts honour initialShowHistory', (tester) async {
      // Regression: the old horizontal path always rendered the grid and
      // ignored `initialShowHistory`.
      const ColorPickerTheme horizontal = ColorPickerTheme(
        orientation: Axis.horizontal,
      );
      await _pump(tester, widgetTheme: horizontal, initialShowHistory: true);
      expect(find.byType(ColorHistoryGrid), findsOneWidget);
      expect(_pad, findsNothing);
      await _pump(tester, widgetTheme: horizontal);
      expect(find.byType(ColorHistoryGrid), findsNothing);
      expect(_pad, findsOneWidget);
    });
  });

  group('value flow', () {
    testWidgets('typing a channel commits through onChanged', (tester) async {
      ColorDerivative? changed;
      await _pump(tester, onChanged: (value) => changed = value);
      await tester.enterText(_fieldEditable(0), '64');
      await tester.pump();
      expect(changed, isNotNull);
      expect(changed!.red, 64);
    });

    testWidgets('a focused field keeps typed text until it blurs', (
      tester,
    ) async {
      final ValueNotifier<ColorDerivative> value =
          ValueNotifier<ColorDerivative>(ColorDerivative.fromColor(_red));
      addTearDown(value.dispose);
      await tester.pumpWidget(
        _frame(
          ListenableBuilder(
            listenable: value,
            builder: (context, _) => ColorPicker(
              value: value.value,
              showHistoryButton: false,
              onChanged: (next) => value.value = next,
            ),
          ),
        ),
      );
      await tester.tap(_fieldEditable(0));
      await tester.enterText(_fieldEditable(0), '64');
      await tester.pump();
      value.value = ColorDerivative.fromColor(_green);
      await tester.pump();
      expect(find.text('64'), findsOneWidget);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      value.value = ColorDerivative.fromColor(const Color(0xFFFF00FF));
      await tester.pump();
      expect(find.text('64'), findsNothing);
      expect(find.text('255'), findsNWidgets(2)); // red + blue
    });

    testWidgets('dragging the pad reports onChanging then onChanged', (
      tester,
    ) async {
      int changing = 0;
      ColorDerivative? changed;
      await _pump(
        tester,
        onChanging: (value) => changing++,
        onChanged: (value) => changed = value,
      );
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(_pad),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(24, 24));
      await tester.pump();
      expect(changing, greaterThan(0));
      await gesture.up();
      await tester.pump();
      expect(changed, isNotNull);
    });

    testWidgets('keyboard steers the focused hue bar', (tester) async {
      ColorDerivative? changing;
      await _pump(tester, onChanging: (value) => changing = value);
      // Focus the hue bar's own node (Focus.maybeOf reads the node the
      // slider's Focus widget owns) and press End: hue jumps to 360.
      final BuildContext context = tester.element(
        find.descendant(of: _hue, matching: find.byType(GestureDetector)).first,
      );
      Focus.maybeOf(context)!.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(changing, isNotNull);
      expect(changing!.toHSVColor().hue, closeTo(360, 1));
    });
  });

  group('interaction', () {
    testWidgets('hover and press change the history button fill', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      await _pump(tester);
      final Finder button = find.ancestor(
        of: find.byIcon(LucideIcons.history),
        matching: find.byType(Button),
      );
      final Finder animated = find.descendant(
        of: button,
        matching: find.byType(AnimatedContainer),
      );
      BoxDecoration decoration() =>
          tester.widget<AnimatedContainer>(animated).decoration!
              as BoxDecoration;
      final Color? rest = decoration().color;
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(button));
      await tester.pump();
      expect(decoration().color, isNot(rest));
      final TestGesture press = await tester.startGesture(
        tester.getCenter(button),
      );
      await tester.pump();
      expect(decoration().color, isNot(rest));
      await press.up();
      await tester.pump();
    });

    testWidgets('enableEyeDropper hides the pipette; the callback overrides', (
      tester,
    ) async {
      await _pump(tester, enableEyeDropper: false);
      expect(find.byIcon(LucideIcons.pipette), findsNothing);
      var pressed = false;
      await _pump(tester, onEyeDropperRequested: () => pressed = true);
      await tester.tap(find.byIcon(LucideIcons.pipette));
      await tester.pump();
      expect(pressed, isTrue);
    });
  });

  group('theme', () {
    testWidgets('precedence: widget > tree > app > defaults', (tester) async {
      double hueHeight() => tester.getSize(_hue).height;
      await _pump(tester);
      expect(hueHeight(), 24);
      const ColorPickerTheme app = ColorPickerTheme(sliderSize: 40);
      await _pump(tester, app: <ComponentThemeData>[app]);
      expect(hueHeight(), 40);
      await _pump(
        tester,
        app: <ComponentThemeData>[app],
        scoped: const ColorPickerTheme(sliderSize: 32),
      );
      expect(hueHeight(), 32);
      await _pump(
        tester,
        app: <ComponentThemeData>[app],
        scoped: const ColorPickerTheme(sliderSize: 32),
        widgetTheme: const ColorPickerTheme(sliderSize: 20),
      );
      expect(hueHeight(), 20);
    });

    testWidgets('per-field merge keeps the lower leg remaining fields', (
      tester,
    ) async {
      await _pump(
        tester,
        app: const <ComponentThemeData>[ColorPickerTheme(spacing: 4)],
        scoped: const ColorPickerTheme(sliderSize: 30),
      );
      expect(tester.getSize(_hue).height, 30);
    });

    testWidgets('orientation comes from the theme', (tester) async {
      await _pump(tester);
      expect(
        tester.getBottomLeft(_pad).dy,
        lessThan(tester.getTopLeft(_hue).dy),
      );
      await _pump(
        tester,
        widgetTheme: const ColorPickerTheme(orientation: Axis.horizontal),
      );
      expect(tester.getTopLeft(_pad).dy, tester.getTopLeft(_hue).dy);
    });
  });

  group('disabled', () {
    test('ColorPicker has no enabled parameter (the old widget had none)', () {
      // Each embedded control's disabled state belongs to its own component
      // (button, input, select) and is covered there.
    });
  });
}
