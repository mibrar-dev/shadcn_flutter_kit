// Widget tests for the `color_input` component: the trigger (well + hex
// field), light/dark rendering, real sizes (h-9), hex parsing (3/6/8 digits,
// alpha kept or carried), prompt resolution (popover on desktop widths, dialog
// below; widget and theme overrides), live popover commits, dialog save/cancel,
// history writes (and the no-scope regression), disabled/keyboard/focus-ring
// behaviour, all four theme legs, form participation and the eye-dropper
// toggle.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/color/color.dart';
import 'package:flutter_shadcn_kit/registry/components/color_input/color_input.dart';
import 'package:flutter_shadcn_kit/registry/components/color_picker/color_picker.dart';
import 'package:flutter_shadcn_kit/registry/components/form/form.dart';
import 'package:flutter_shadcn_kit/registry/components/history/history.dart';
import 'package:flutter_shadcn_kit/registry/components/hsv/hsv.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/object_form_field.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Size _wide = Size(1200, 800);
const Size _narrow = Size(320, 640);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ColorInputTheme? scoped,
  Size size = _wide,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<ColorInputTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: OverlayManagerLayer(
            popoverHandler: OverlayHandler.popover,
            tooltipHandler: OverlayHandler.popover,
            menuHandler: OverlayHandler.popover,
            child: Navigator(
              onGenerateRoute: (RouteSettings settings) =>
                  PageRouteBuilder<void>(
                    settings: settings,
                    pageBuilder: (context, _, _) =>
                        Center(child: SizedBox(width: 320, child: body)),
                  ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Controlled echo harness: reports commits and feeds them back as `value`.
class _Harness extends StatefulWidget {
  const _Harness({
    this.initial,
    this.onChanged,
    this.onChanging,
    this.showAlpha = true,
    this.showHistory,
    this.enableEyeDropper,
    this.mode,
    this.dialogTitle,
    this.enabled = true,
    this.theme,
  });

  final ColorDerivative? initial;
  final ValueChanged<ColorDerivative>? onChanged;
  final ValueChanged<ColorDerivative>? onChanging;
  final bool showAlpha;
  final bool? showHistory;
  final bool? enableEyeDropper;
  final PromptMode? mode;
  final Widget? dialogTitle;
  final bool enabled;
  final ColorInputTheme? theme;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late ColorDerivative value =
      widget.initial ?? ColorDerivative.fromColor(_red);

  @override
  Widget build(BuildContext context) {
    return ColorInput(
      value: value,
      enabled: widget.enabled,
      showAlpha: widget.showAlpha,
      showHistory: widget.showHistory,
      enableEyeDropper: widget.enableEyeDropper,
      mode: widget.mode,
      dialogTitle: widget.dialogTitle,
      theme: widget.theme,
      onChanging: widget.onChanging,
      onChanged: widget.enabled
          ? (ColorDerivative next) {
              widget.onChanged?.call(next);
              setState(() => value = next);
            }
          : null,
    );
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ColorInputTheme? scoped,
  Size size = _wide,
}) async {
  // The dialog route lays out against the real view, not the frame's
  // MediaQuery: keep both in sync.
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    _frame(child, data: data, app: app, scoped: scoped, size: size),
  );
  await tester.pump();
}

/// The trigger's hex field editable.
Finder _hexEditable() => find
    .descendant(
      of: find.byType(ColorInput),
      matching: find.byType(EditableText),
    )
    .first;

/// The well (the only [Clickable] before a prompt opens).
Finder _well() => find.byType(Clickable);

/// Opens the prompt through the well and settles its transition.
///
/// Explicit pumps: an open popover keeps scheduling follow frames, so
/// `pumpAndSettle` never settles.
Future<void> _openPrompt(WidgetTester tester) async {
  await tester.tap(_well());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

/// One channel field of the picker behind the prompt.
Finder _channelField(int index) => find
    .descendant(of: find.byType(ColorPicker), matching: find.byType(Input))
    .at(index);

Future<void> _typeChannel(WidgetTester tester, int index, String text) async {
  await tester.enterText(
    find
        .descendant(
          of: _channelField(index),
          matching: find.byType(EditableText),
        )
        .first,
    text,
  );
  await tester.pump();
}

BoxDecoration _wellDecoration(WidgetTester tester, Set<WidgetState> states) {
  final Clickable well = tester.widget<Clickable>(_well());
  return well.decoration!.resolve(states)! as BoxDecoration;
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  group('rendering', () {
    testWidgets('well and hex field render in light and dark', (tester) async {
      for (final ShadcnThemeData data in <ShadcnThemeData>[
        const ShadcnThemeData(),
        const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ]) {
        await _pump(tester, const _Harness(), data: data);
        expect(_well(), findsOneWidget);
        expect(find.byType(Input), findsOneWidget);
        expect(find.text('#ffff0000'), findsOneWidget);
        final Border border =
            _wellDecoration(tester, const <WidgetState>{}).border! as Border;
        expect(border.top.color, data.colors.border);
        expect(_wellDecoration(tester, const <WidgetState>{}).color, _red);
      }
    });

    testWidgets('the well exposes a labelled button', (tester) async {
      await _pump(tester, const _Harness());
      expect(tester.getSemantics(_well()).label, 'Pick a color');
    });

    testWidgets('real sizes: well 36x36 and hex field h-9', (tester) async {
      await _pump(tester, const _Harness());
      expect(tester.getSize(_well()), const Size(36, 36));
      expect(tester.getSize(find.byType(Input)).height, 36);
    });

    testWidgets('the default gap between well and field is 8', (tester) async {
      await _pump(tester, const _Harness());
      final double gap =
          tester.getTopLeft(find.byType(Input)).dx -
          tester.getTopRight(_well()).dx;
      expect(gap, 8);
    });

    testWidgets('hover and press switch the well border to the ring token', (
      tester,
    ) async {
      await _pump(tester, const _Harness());
      final Border rest =
          _wellDecoration(tester, const <WidgetState>{}).border! as Border;
      final Border hovered =
          _wellDecoration(tester, const <WidgetState>{
                WidgetState.hovered,
              }).border!
              as Border;
      final Border pressed =
          _wellDecoration(tester, const <WidgetState>{
                WidgetState.pressed,
              }).border!
              as Border;
      expect(rest.top.color, colors.border);
      expect(hovered.top.color, colors.ring);
      expect(pressed.top.color, colors.ring);
    });
  });

  group('hex field', () {
    testWidgets('typing a full hex commits through onChanged', (tester) async {
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add));
      await tester.enterText(_hexEditable(), '#00ff00');
      await tester.pump();
      expect(commits.single.toColor().toARGB32(), _green.toARGB32());
    });

    testWidgets('3-digit shorthand expands', (tester) async {
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add));
      await tester.enterText(_hexEditable(), '#0f0');
      await tester.pump();
      expect(commits.single.toColor().toARGB32(), _green.toARGB32());
    });

    testWidgets('8 digits carry their own alpha', (tester) async {
      // The old picker hex field always kept the current alpha and could never
      // set one; an 8-digit value now applies its own.
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add));
      await tester.enterText(_hexEditable(), '#80123456');
      await tester.pump();
      expect(commits.single.toColor().toARGB32(), 0x80123456);
    });

    testWidgets('6 digits keep the current alpha', (tester) async {
      // Regression: the old picker hex field reset alpha to opaque.
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(
        tester,
        _Harness(
          initial: ColorDerivative.fromColor(const Color(0x80FF0000)),
          onChanged: commits.add,
        ),
      );
      await tester.enterText(_hexEditable(), '#00ff00');
      await tester.pump();
      expect(commits.single.toColor().toARGB32(), 0x8000FF00);
    });

    testWidgets('incomplete or invalid text commits nothing', (tester) async {
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add));
      await tester.enterText(_hexEditable(), '#12');
      await tester.pump();
      await tester.enterText(_hexEditable(), '12345');
      await tester.pump();
      expect(commits, isEmpty);
    });

    testWidgets('the formatter drops non-hex characters', (tester) async {
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add));
      await tester.enterText(_hexEditable(), 'zz#0f0zz');
      await tester.pump();
      expect(commits.single.toColor().toARGB32(), _green.toARGB32());
    });

    testWidgets('showAlpha false shows a 6-digit hex and no alpha field', (
      tester,
    ) async {
      await _pump(tester, const _Harness(showAlpha: false), size: _wide);
      expect(find.text('#ff0000'), findsOneWidget);
      await _openPrompt(tester);
      expect(
        find.descendant(
          of: find.byType(ColorPicker),
          matching: find.byType(Input),
        ),
        findsNWidgets(3),
      );
      expect(
        find.byWidgetPredicate(
          (Widget w) =>
              w is HSVColorSlider && w.sliderType == HSVColorSliderType.alpha,
        ),
        findsNothing,
      );
    });

    testWidgets('external updates apply only while unfocused', (tester) async {
      final ValueNotifier<ColorDerivative> value =
          ValueNotifier<ColorDerivative>(ColorDerivative.fromColor(_red));
      addTearDown(value.dispose);
      await tester.pumpWidget(
        _frame(
          ListenableBuilder(
            listenable: value,
            builder: (context, _) => ColorInput(
              value: value.value,
              onChanged: (ColorDerivative next) => value.value = next,
            ),
          ),
        ),
      );
      expect(find.text('#ffff0000'), findsOneWidget);
      value.value = ColorDerivative.fromColor(_green);
      await tester.pump();
      expect(find.text('#ff00ff00'), findsOneWidget);

      await tester.tap(_hexEditable());
      await tester.enterText(_hexEditable(), '#123456');
      await tester.pump();
      value.value = ColorDerivative.fromColor(_red);
      await tester.pump();
      expect(
        find.text('#123456'),
        findsOneWidget,
        reason: 'focused typing wins',
      );
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(find.text('#ffff0000'), findsOneWidget, reason: 'blur snaps back');
    });
  });

  group('prompt', () {
    testWidgets('desktop widths open the picker in a popover', (tester) async {
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add), size: _wide);
      await _openPrompt(tester);
      expect(find.byType(ColorPicker), findsOneWidget);
      expect(find.text('Save'), findsNothing);
      // Popover commits are live: editing the red channel reports immediately.
      await _typeChannel(tester, 0, '64');
      expect(commits.single.red, 64);
      // Alpha shows the 0-100 scale.
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('narrow widths open a dialog; Save commits, Cancel discards', (
      tester,
    ) async {
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add), size: _narrow);
      await _openPrompt(tester);
      expect(tester.takeException(), isNull, reason: 'no overflow at 320 px');
      expect(find.byType(ColorPicker), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      await _typeChannel(tester, 0, '64');
      expect(commits, isEmpty, reason: 'dialog edits commit on Save');
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(commits.single.red, 64);

      // Cancel discards the edit.
      await _openPrompt(tester);
      await _typeChannel(tester, 0, '128');
      await tester.tap(find.text('Cancel'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(commits.single.red, 64);
      expect(find.byType(ColorPicker), findsNothing);
    });

    testWidgets('a dialog title renders above the picker', (tester) async {
      await _pump(
        tester,
        const _Harness(
          mode: PromptMode.dialog,
          dialogTitle: Text('Select a colour'),
        ),
        size: _wide,
      );
      await _openPrompt(tester);
      expect(find.text('Select a colour'), findsOneWidget);
    });

    testWidgets('widget mode wins over the responsive default', (tester) async {
      await _pump(
        tester,
        const _Harness(mode: PromptMode.popover),
        size: _narrow,
      );
      await _openPrompt(tester);
      expect(find.byType(ColorPicker), findsOneWidget);
      expect(find.text('Save'), findsNothing);

      await _pump(tester, const _Harness(mode: PromptMode.dialog), size: _wide);
      await _openPrompt(tester);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('enableEyeDropper toggles the pipette', (tester) async {
      await _pump(tester, const _Harness(enableEyeDropper: false), size: _wide);
      await _openPrompt(tester);
      expect(find.byIcon(LucideIcons.pipette), findsNothing);

      await _pump(tester, const _Harness(), size: _wide);
      await _openPrompt(tester);
      expect(find.byIcon(LucideIcons.pipette), findsOneWidget);
    });

    testWidgets('picking a history colour commits it', (tester) async {
      await _pump(
        tester,
        RecentColorsScope(
          initialRecentColors: const <Color>[_green],
          child: _Harness(),
        ),
        size: _wide,
      );
      await _openPrompt(tester);
      await tester.tap(find.byIcon(LucideIcons.history));
      await tester.pump();
      final Finder tile = find.descendant(
        of: find.byType(ColorHistoryGrid),
        matching: find.byType(Clickable),
      );
      await tester.tap(tile.first);
      await tester.pump();
      expect(find.text('#ff00ff00'), findsOneWidget);
    });

    testWidgets('showHistory false hides the picker history button', (
      tester,
    ) async {
      await _pump(
        tester,
        RecentColorsScope(
          initialRecentColors: const <Color>[_green],
          child: const _Harness(showHistory: false),
        ),
        size: _wide,
      );
      await _openPrompt(tester);
      expect(find.byIcon(LucideIcons.history), findsNothing);
    });

    testWidgets('dragging the picker pad reports onChanging live', (
      tester,
    ) async {
      final List<ColorDerivative> changing = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanging: changing.add), size: _wide);
      await _openPrompt(tester);
      final Finder pad = find.byWidgetPredicate(
        (Widget w) =>
            w is HSVColorSlider && w.sliderType == HSVColorSliderType.satVal,
      );
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(pad),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(20, 20));
      await tester.pump();
      expect(changing, isNotEmpty);
      await gesture.up();
      await tester.pump();
    });
  });

  group('history', () {
    testWidgets('commits are written to the nearest scope', (tester) async {
      final GlobalKey<RecentColorsScopeState> scope =
          GlobalKey<RecentColorsScopeState>();
      await _pump(tester, RecentColorsScope(key: scope, child: _Harness()));
      await tester.enterText(_hexEditable(), '#00ff00');
      await tester.pump();
      expect(
        scope.currentState!.recentColors.single.toARGB32(),
        _green.toARGB32(),
      );
    });

    testWidgets('committing without a scope does not throw', (tester) async {
      // Regression: the old widget used `ColorHistoryStorage.of` and threw
      // without a `RecentColorsScope`.
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(tester, _Harness(onChanged: commits.add));
      await tester.enterText(_hexEditable(), '#00ff00');
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(commits.single.toColor().toARGB32(), _green.toARGB32());
    });
  });

  group('interaction', () {
    testWidgets('Enter opens the prompt from the focused well', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      await _pump(tester, _Harness(), size: _wide);
      final BuildContext inner = tester.element(
        find.descendant(of: _well(), matching: find.byType(SizedBox)).first,
      );
      Focus.maybeOf(inner)!.requestFocus();
      await tester.pump();
      expect(
        tester
            .widget<FocusOutline>(
              find.descendant(of: _well(), matching: find.byType(FocusOutline)),
            )
            .focused,
        isTrue,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ColorPicker), findsOneWidget);
    });

    testWidgets('disabled dims to 50% and blocks the prompt', (tester) async {
      await _pump(tester, const _Harness(enabled: false), size: _wide);
      expect(
        tester
            .widget<Opacity>(
              find.ancestor(of: _well(), matching: find.byType(Opacity)).first,
            )
            .opacity,
        0.5,
      );
      expect(tester.widget<Clickable>(_well()).enabled, isFalse);
      expect(tester.widget<Input>(find.byType(Input)).enabled, isFalse);
      await tester.tap(_well());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ColorPicker), findsNothing);
    });
  });

  group('theme legs', () {
    testWidgets('precedence: widget > tree > app > defaults', (tester) async {
      double wellSize() => tester.getSize(_well()).width;
      await _pump(tester, const _Harness());
      expect(wellSize(), 36);
      const ColorInputTheme app = ColorInputTheme(swatchSize: 40);
      await _pump(tester, const _Harness(), app: <ComponentThemeData>[app]);
      expect(wellSize(), 40);
      await _pump(
        tester,
        const _Harness(),
        app: <ComponentThemeData>[app],
        scoped: const ColorInputTheme(swatchSize: 32),
      );
      expect(wellSize(), 32);
      await _pump(
        tester,
        const _Harness(theme: ColorInputTheme(swatchSize: 28)),
        app: <ComponentThemeData>[app],
        scoped: const ColorInputTheme(swatchSize: 32),
      );
      expect(wellSize(), 28);
    });

    testWidgets('per-field merge keeps the lower leg remaining fields', (
      tester,
    ) async {
      await _pump(
        tester,
        const _Harness(),
        app: const <ComponentThemeData>[ColorInputTheme(gap: 4)],
        scoped: const ColorInputTheme(swatchSize: 30),
      );
      expect(tester.getSize(_well()).width, 30);
      expect(
        tester.getTopLeft(find.byType(Input)).dx -
            tester.getTopRight(_well()).dx,
        4,
      );
    });

    testWidgets('mode resolves through the theme legs', (tester) async {
      await _pump(
        tester,
        const _Harness(),
        scoped: const ColorInputTheme(mode: PromptMode.popover),
        size: _narrow,
      );
      await _openPrompt(tester);
      expect(find.text('Save'), findsNothing);

      await _pump(
        tester,
        const _Harness(),
        app: const <ComponentThemeData>[
          ColorInputTheme(mode: PromptMode.dialog),
        ],
        size: _wide,
      );
      await _openPrompt(tester);
      expect(find.text('Save'), findsOneWidget);
    });
  });

  group('form', () {
    testWidgets('participates in a form as a ColorDerivative field', (
      tester,
    ) async {
      final FormController controller = FormController();
      addTearDown(controller.dispose);
      const FormKey<ColorDerivative> key = FormKey<ColorDerivative>('color');
      final List<ColorDerivative> commits = <ColorDerivative>[];
      await _pump(
        tester,
        ShadcnForm(
          controller: controller,
          child: ShadcnFormField<ColorDerivative>(
            key: key,
            label: const Text('Color'),
            child: _Harness(onChanged: commits.add),
          ),
        ),
      );
      await tester.enterText(_hexEditable(), '#00ff00');
      await tester.pump();
      expect(controller.getValue(key)?.toColor().toARGB32(), _green.toARGB32());
      expect(commits.single.toColor().toARGB32(), _green.toARGB32());
    });
  });
}
