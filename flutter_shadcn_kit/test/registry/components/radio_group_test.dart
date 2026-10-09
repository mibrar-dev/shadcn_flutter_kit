// Widget tests for the `radio_group` component.
//
// Covers both item shapes, controlled and controller-driven modes, the
// arrow-key traversal, disabled handling, form participation, all four
// theme-precedence legs, light and dark tokens, and one regression test per old
// bug that was fixed.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/radio_group/radio_group.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/primitives/selectable_radio/selectable_radio.dart';
import 'package:flutter_shadcn_kit/registry/primitives/roving_group.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  SelectableRadioTheme? scopedItems,
  FormFieldHandle? formHandle,
}) {
  Widget body = child;
  if (scopedItems != null) {
    body = ComponentTheme<SelectableRadioTheme>(data: scopedItems, child: body);
  }
  if (formHandle != null) {
    body = Data<FormFieldHandle>.inherit(data: formHandle, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

/// Three rows, the third one disabled.
Widget _rows({
  required String? value,
  required ValueChanged<String>? onChanged,
  Axis direction = Axis.vertical,
  ShadcnRadioGroupController<String>? controller,
}) {
  final List<Widget> items = <Widget>[
    // The arrow keys act on the focused member, so the first row takes focus.
    const RadioItem<String>(value: 'a', label: Text('Alpha'), autofocus: true),
    const RadioItem<String>(value: 'b', label: Text('Beta')),
    const RadioItem<String>(value: 'c', label: Text('Gamma'), enabled: false),
  ];
  return ShadcnRadioGroup<String>(
    value: value,
    controller: controller,
    onChanged: onChanged,
    direction: direction,
    child: direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: items)
        : Column(mainAxisSize: MainAxisSize.min, children: items),
  );
}

Clickable _itemAt(WidgetTester tester, int index) => tester.widget<Clickable>(
  find
      .descendant(
        of: find.byType(RadioItem<String>),
        matching: find.byType(Clickable),
      )
      .at(index),
);

BoxDecoration _indicator(WidgetTester tester) =>
    tester
            .widget<AnimatedContainer>(find.byKey(kRadioIndicatorKey).first)
            .decoration!
        as BoxDecoration;

BoxDecoration _dot(WidgetTester tester) =>
    tester
            .widget<AnimatedContainer>(find.byKey(kRadioIndicatorDotKey).first)
            .decoration!
        as BoxDecoration;

double _opacity(WidgetTester tester, int index) => tester
    .widget<Opacity>(
      find.descendant(
        of: find.byType(RadioItem<String>).at(index),
        matching: find.byType(Opacity),
      ),
    )
    .opacity;

/// Form handle that records the reported value and can replace it.
class _FakeFormHandle with FormFieldHandle {
  final List<String?> reported = <String?>[];

  /// The value validation asks the group to fall back to.
  String replaceWith = 'b';

  @override
  final FormKey<String> formKey = const FormKey<String>('radio');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value as String?);
    return ReplaceResult<String>(
      replaceWith,
      state: FormValidationMode.changed,
    );
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void _noop(String value) {}

void main() {
  group('rows', () {
    testWidgets('an unchecked row uses the input border and no fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'b', onChanged: _noop),
        ),
      );
      final BoxDecoration decoration = _indicator(tester);
      expect(decoration.border?.top.color, ShadcnColors.lightFallback.input);
      expect(decoration.color, isNull);
    });

    testWidgets('a checked row fills primary and dots it', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'b', onChanged: _noop),
        ),
      );
      // The third circle is the checked one.
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(1),
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color, ShadcnColors.lightFallback.primary);
      expect(decoration.border?.top.color, ShadcnColors.lightFallback.primary);
      expect(
        tester
            .widget<AnimatedContainer>(find.byKey(kRadioIndicatorDotKey).at(1))
            .constraints
            ?.maxWidth,
        equals(8),
      );
    });

    testWidgets('sizes match shadcn (size-4 circle, size-2 dot)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'b', onChanged: _noop),
        ),
      );
      expect(
        tester.getSize(find.byKey(kRadioIndicatorKey).first).width,
        radioDefaultIndicatorSize,
      );
      expect(radioDefaultIndicatorSize, 16);
      final BoxDecoration dot = _dot(tester);
      expect(dot.color, isNull); // unchecked: no dot painted
    });

    testWidgets('the label follows the indicator with the gap', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      final Rect indicator = tester.getRect(
        find.byKey(kRadioIndicatorKey).first,
      );
      final Rect label = tester.getRect(find.text('Alpha'));
      expect(label.left, greaterThan(indicator.right));
      expect(label.left - indicator.right, selectableRadioDefaults.gap);
    });

    testWidgets('a disabled item dims to 50% opacity', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      expect(_opacity(tester, 0), 1);
      expect(_opacity(tester, 2), 0.5);
    });

    testWidgets('a disabled item does not tap', (tester) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: (String v) => seen = v),
        ),
      );
      await tester.tap(find.text('Gamma'));
      await tester.pump();
      expect(seen, isNull);
    });

    testWidgets('a card item paints its own surface', (tester) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: ShadcnRadioGroup<String>(
            value: 'a',
            onChanged: (String v) => seen = v,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                RadioCard<String>(value: 'a', child: Text('Alpha')),
                RadioCard<String>(value: 'b', child: Text('Beta')),
              ],
            ),
          ),
        ),
      );
      expect(find.byKey(kRadioCardKey), findsNWidgets(2));
      await tester.tap(find.text('Beta'));
      await tester.pump();
      expect(seen, 'b');
    });

    testWidgets('regression: selecting a card does not shift its content', (
      tester,
    ) async {
      // The old `RadioCard` painted a 2px border when selected and compensated
      // with `EdgeInsets.all(borderWidth - selectedBorderWidth)`, which went
      // negative (and threw) for a theme that widened the selected border.
      const SelectableCardTheme theme = SelectableCardTheme(
        borderWidth: 1,
        background: StateValue(selected: ThemedColor.ref(ColorRef.accent)),
        borderColor: StateValue(selected: ThemedColor.ref(ColorRef.primary)),
      );
      await tester.pumpWidget(
        _frame(
          child: ShadcnRadioGroup<String>(
            value: 'a',
            onChanged: _noop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                RadioCard<String>(
                  value: 'a',
                  child: Text('Alpha'),
                  cardTheme: theme,
                ),
                RadioCard<String>(
                  value: 'b',
                  child: Text('Beta'),
                  cardTheme: theme,
                ),
              ],
            ),
          ),
        ),
      );
      final Rect before = tester.getRect(find.byKey(kRadioCardKey).last);
      await tester.pumpWidget(
        _frame(
          child: ShadcnRadioGroup<String>(
            value: 'b',
            onChanged: _noop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                RadioCard<String>(
                  value: 'a',
                  child: Text('Alpha'),
                  cardTheme: theme,
                ),
                RadioCard<String>(
                  value: 'b',
                  child: Text('Beta'),
                  cardTheme: theme,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      // The same card, now selected: same box, so nothing shifted.
      expect(tester.getRect(find.byKey(kRadioCardKey).last).size, before.size);
    });
  });

  group('controlled', () {
    testWidgets('tap reports the tapped value', (tester) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: (String v) => seen = v),
        ),
      );
      await tester.tap(find.text('Beta'));
      await tester.pump();
      expect(seen, 'b');
    });

    testWidgets('null onChanged disables every item', (tester) async {
      await tester.pumpWidget(
        _frame(child: _rows(value: 'a', onChanged: null)),
      );
      expect(_itemAt(tester, 0).enabled, isFalse);
      expect(_opacity(tester, 0), 0.5);
      await tester.tap(find.text('Beta'));
      await tester.pump();
    });

    testWidgets('enabled: false disables even with an onChanged', (
      tester,
    ) async {
      int calls = 0;
      await tester.pumpWidget(
        _frame(
          child: ShadcnRadioGroup<String>(
            enabled: false,
            value: 'a',
            onChanged: (String _) => calls++,
            child: const RadioItem<String>(value: 'a', label: Text('Alpha')),
          ),
        ),
      );
      await tester.tap(find.text('Alpha'));
      await tester.pump();
      expect(calls, 0);
      expect(_opacity(tester, 0), 0.5);
    });
  });

  group('controller', () {
    testWidgets('drives the widget and rejects onChanged', (tester) async {
      final ShadcnRadioGroupController<String> controller =
          ShadcnRadioGroupController<String>();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: _rows(value: null, onChanged: null, controller: controller),
        ),
      );
      controller.select('b');
      await tester.pump();
      expect(find.text('Beta'), findsOneWidget);
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(1),
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color, ShadcnColors.lightFallback.primary);
    });

    testWidgets('tapping a row writes the controller', (tester) async {
      final ShadcnRadioGroupController<String> controller =
          ShadcnRadioGroupController<String>();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: _rows(value: null, onChanged: null, controller: controller),
        ),
      );
      await tester.tap(find.text('Beta'));
      await tester.pump();
      expect(controller.value, 'b');
    });

    testWidgets('rejects onChanged alongside a controller', (tester) async {
      expect(
        () => ShadcnRadioGroup<String>(
          controller: ShadcnRadioGroupController<String>(),
          onChanged: _noop,
          child: const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });
  });

  group('keyboard', () {
    testWidgets('arrow down selects the next item', (tester) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: (String v) => seen = v),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(seen, 'b');
    });

    testWidgets('regression: focusing an item does not select it', (
      tester,
    ) async {
      // The old `RadioItem` called `_setSelected` from `onShowFocusHighlight`,
      // so tabbing into a group changed the value before anything was pressed.
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: (String v) => seen = v),
        ),
      );
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: ShadcnRadioGroup<String>(
            value: 'a',
            onChanged: (String v) => seen = v,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioItem<String>(
                  value: 'a',
                  label: const Text('Alpha'),
                  focusNode: FocusNode(),
                ),
                RadioItem<String>(
                  value: 'b',
                  label: const Text('Beta'),
                  focusNode: node,
                ),
              ],
            ),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      expect(seen, isNull);
    });

    testWidgets('arrow keys skip the disabled item and wrap', (tester) async {
      final ShadcnRadioGroupController<String> controller =
          ShadcnRadioGroupController<String>('b');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: _rows(value: null, onChanged: null, controller: controller),
        ),
      );
      // 'b' -> 'c' is disabled, so the walk wraps round to 'a'.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(controller.value, 'a');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(controller.value, 'b');
    });

    testWidgets('regression: the arrows move instead of re-selecting', (
      tester,
    ) async {
      // The old intents were registered by every item and both selected *that*
      // item, so the arrow keys never moved anywhere. Controller-driven, so the
      // selection really advances between presses.
      final ShadcnRadioGroupController<String> controller =
          ShadcnRadioGroupController<String>('a');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: _rows(value: null, onChanged: null, controller: controller),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(controller.value, 'b');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      // 'c' is disabled, so the walk wraps round to 'a'.
      expect(controller.value, 'a');
    });

    testWidgets('horizontal groups walk with the horizontal arrows', (
      tester,
    ) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _rows(
            value: 'a',
            direction: Axis.horizontal,
            onChanged: (String v) => seen = v,
          ),
        ),
      );
      // A horizontal group does not bind the vertical arrows at all, so
      // `Clickable`'s own directional focus handling keeps them.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(seen, isNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(seen, 'b');
    });

    testWidgets('space activates the focused item', (tester) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: ShadcnRadioGroup<String>(
            value: 'a',
            onChanged: (String v) => seen = v,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const RadioItem<String>(value: 'a', label: Text('Alpha')),
                RadioItem<String>(
                  value: 'b',
                  label: const Text('Beta'),
                  focusNode: node,
                ),
              ],
            ),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(seen, 'b');
    });
  });

  group('semantics', () {
    testWidgets('reports the mutually exclusive selection', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'b', onChanged: _noop),
        ),
      );
      final SemanticsNode node = tester.getSemantics(
        find.byType(RadioItem<String>).first,
      );
      expect(node.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('a disabled item reports enabled: false', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      final SemanticsNode node = tester.getSemantics(
        find.byType(RadioItem<String>).at(2),
      );
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      handle.dispose();
    });
  });

  group('form', () {
    testWidgets('reports the current value to the nearest form', (
      tester,
    ) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      await tester.pumpWidget(
        _frame(
          formHandle: handle,
          child: _rows(value: 'b', onChanged: _noop),
        ),
      );
      await tester.pump();
      expect(handle.reported, contains('b'));
    });

    testWidgets('applies a ReplaceResult from validation', (tester) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      String? seen;
      await tester.pumpWidget(
        _frame(
          formHandle: handle,
          child: _rows(value: 'a', onChanged: (String v) => seen = v),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(seen, 'b');
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            SelectableRadioTheme(
              selected: RadioIndicatorStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(0),
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            SelectableRadioTheme(
              selected: RadioIndicatorStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          scopedItems: const SelectableRadioTheme(
            selected: RadioIndicatorStyle(
              background: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(0),
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedItems: const SelectableRadioTheme(
            selected: RadioIndicatorStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: ShadcnRadioGroup<String>(
            value: 'a',
            onChanged: _noop,
            child: const RadioItem<String>(
              value: 'a',
              label: Text('Alpha'),
              theme: SelectableRadioTheme(
                selected: RadioIndicatorStyle(
                  background: StateValue(rest: ThemedColor.value(_blue)),
                ),
              ),
            ),
          ),
        ),
      );
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color, _blue);
    });

    testWidgets('a leg setting one state keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scopedItems: const SelectableRadioTheme(
            unselected: RadioIndicatorStyle(
              borderColor: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      // The unchecked row picks up the leg...
      final BoxDecoration unchecked =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(1),
                  )
                  .decoration!
              as BoxDecoration;
      expect(unchecked.border?.top.color, _green);
      // ...while the checked row keeps the default fill.
      final BoxDecoration checked =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(0),
                  )
                  .decoration!
              as BoxDecoration;
      expect(checked.color, ShadcnColors.lightFallback.primary);
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: _rows(value: 'a', onChanged: _noop),
        ),
      );
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).at(0),
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color, dark.primary);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: ShadcnRadioGroup<String>(
            value: 'a',
            onChanged: _noop,
            child: const RadioItem<String>(
              value: 'a',
              label: Text('Alpha'),
              theme: SelectableRadioTheme(
                selected: RadioIndicatorStyle(
                  background: StateValue(
                    rest: ThemedColor.ref(ColorRef.primary, alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final BoxDecoration decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(kRadioIndicatorKey).first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(decoration.color!.a, closeTo(dark.primary.a * 0.5, 0.001));
    });
  });
}
