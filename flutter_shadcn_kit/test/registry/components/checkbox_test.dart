// Widget tests for the `checkbox` component.
//
// Covers the three values, controlled and controller-driven modes, the
// tristate cycle, keyboard activation, semantics, form participation, dark
// tokens and the four theme-precedence legs. The regression tests cover the
// old bugs: `enabled` was ignored by the clickable, the focus border never
// lit up, a stray gap surrounded a label-less box, the disabled colours came
// from hard-coded tokens instead of the rest style, and the app theme leg was
// never read.

import 'dart:async';
import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/foundation/gap.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CheckboxTheme? scopedTheme,
  FormFieldHandle? formHandle,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<CheckboxTheme>(data: scopedTheme, child: body);
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

Clickable _clickable(WidgetTester tester) {
  return tester.widget<Clickable>(
    find.descendant(
      of: find.byType(Checkbox),
      matching: find.byType(Clickable),
    ),
  );
}

BoxDecoration _decoration(WidgetTester tester, Set<WidgetState> states) =>
    _clickable(tester).decoration!.resolve(states) as BoxDecoration;

double _opacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find.descendant(
        of: find.byType(Checkbox),
        matching: find.byType(Opacity),
      ),
    )
    .opacity;

/// Form handle that records the reported value and can replace it.
class _FakeFormHandle with FormFieldHandle {
  final List<CheckboxValue?> reported = <CheckboxValue?>[];
  CheckboxValue replaceWith = CheckboxValue.checked;

  @override
  final FormKey<CheckboxValue> formKey = const FormKey<CheckboxValue>(
    'checkbox',
  );

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value as CheckboxValue?);
    return ReplaceResult<CheckboxValue>(
      replaceWith,
      state: FormValidationMode.changed,
    );
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

/// Semantic flags of the checkbox wrapper.
({bool checked, bool mixed, bool enabled}) _semantics(WidgetTester tester) {
  final SemanticsNode node = tester.getSemantics(find.byType(Semantics).last);
  final CheckedState state = node.flagsCollection.isChecked;
  return (
    checked: state == CheckedState.isTrue,
    mixed: state == CheckedState.mixed,
    enabled: node.flagsCollection.isEnabled == Tristate.isTrue,
  );
}

void main() {
  group('values', () {
    testWidgets('renders a label for every value', (tester) async {
      for (final CheckboxValue value in CheckboxValue.values) {
        await tester.pumpWidget(
          _frame(
            child: Checkbox(
              value: value,
              onChanged: (_) {},
              label: Text(value.name),
            ),
          ),
        );
        expect(find.text(value.name), findsOneWidget);
        expect(
          _decoration(tester, const <WidgetState>{}).color,
          value == CheckboxValue.unchecked
              ? _alpha(ShadcnColors.lightFallback.input, 0)
              : ShadcnColors.lightFallback.primary,
        );
      }
    });

    testWidgets('checked uses primary fill and primaryForeground indicator', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.checked)),
      );
      final BoxDecoration box = _decoration(tester, const <WidgetState>{});
      expect(box.color, colors.primary);
      expect(box.border, Border.all(color: colors.primary, width: 1));
      expect(_indicatorColor(tester), colors.primaryForeground);
    });

    testWidgets('unchecked is unfilled with an input border', (tester) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.unchecked)),
      );
      final BoxDecoration box = _decoration(tester, const <WidgetState>{});
      // Unchecked is the `input` token at zero alpha: an explicit token row an
      // override can hook, not a hard-coded transparent colour.
      expect(box.color, _alpha(colors.input, 0));
      expect(box.border, Border.all(color: colors.input, width: 1));
      expect(
        find.descendant(of: find.byType(Checkbox), matching: find.byType(Icon)),
        findsNothing,
      );
    });

    testWidgets('indeterminate draws the dash indicator', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.indeterminate)),
      );
      final Icon icon = tester.widget<Icon>(
        find.descendant(of: find.byType(Checkbox), matching: find.byType(Icon)),
      );
      expect(icon.icon, isNot(const IconData(0x1234)));
    });

    testWidgets('the box is 16 logical pixels by default', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.unchecked)),
      );
      expect(
        tester.getSize(find.byType(SizedBox).first).width,
        checkboxDefaultSize,
      );
    });

    testWidgets('widget size and gap override the style row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Checkbox(
            value: CheckboxValue.unchecked,
            size: 28,
            gap: 20,
            label: Text('Sized'),
          ),
        ),
      );
      expect(find.byType(Row), findsOneWidget);
    });
  });

  group('controlled', () {
    testWidgets('tap reports the next value', (tester) async {
      CheckboxValue? seen;
      CheckboxValue value = CheckboxValue.unchecked;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Checkbox(
              value: value,
              onChanged: (next) => setState(() {
                seen = next;
                value = next;
              }),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(seen, CheckboxValue.checked);
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(seen, CheckboxValue.unchecked);
    });

    testWidgets('null onChanged disables the control', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Checkbox(
            value: CheckboxValue.unchecked,
            onChanged: null,
          ),
        ),
      );
      expect(_clickable(tester).enabled, isFalse);
      expect(_opacity(tester), 0.5);
      final Finder clickable = find.descendant(
        of: find.byType(Checkbox),
        matching: find.byType(Clickable),
      );
      await tester.tap(clickable);
      await tester.pump();
      expect(_opacity(tester), 0.5);
    });

    testWidgets('enabled: false disables even with an onChanged', (
      tester,
    ) async {
      int calls = 0;
      await tester.pumpWidget(
        _frame(
          child: Checkbox(
            enabled: false,
            value: CheckboxValue.unchecked,
            onChanged: (_) => calls++,
          ),
        ),
      );
      expect(_clickable(tester).enabled, isFalse);
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(calls, 0);
    });

    testWidgets('enabled: true enables a read-only value', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Checkbox(enabled: true, value: CheckboxValue.unchecked),
        ),
      );
      expect(_clickable(tester).enabled, isTrue);
      expect(_opacity(tester), 1);
    });
  });

  group('tristate', () {
    testWidgets('cycles unchecked -> checked -> indeterminate', (tester) async {
      final List<CheckboxValue> seen = <CheckboxValue>[];
      CheckboxValue value = CheckboxValue.unchecked;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Checkbox(
              tristate: true,
              value: value,
              onChanged: (next) => setState(() {
                seen.add(next);
                value = next;
              }),
            ),
          ),
        ),
      );
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(Checkbox));
        await tester.pump();
      }
      expect(seen, <CheckboxValue>[
        CheckboxValue.checked,
        CheckboxValue.indeterminate,
        CheckboxValue.unchecked,
      ]);
    });

    testWidgets('a binary checkbox never reports indeterminate', (
      tester,
    ) async {
      final List<CheckboxValue> seen = <CheckboxValue>[];
      CheckboxValue value = CheckboxValue.indeterminate;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Checkbox(
              value: value,
              onChanged: (next) => setState(() {
                seen.add(next);
                value = next;
              }),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(seen, <CheckboxValue>[CheckboxValue.checked]);
    });

    testWidgets('CheckboxController.cycle follows the same order', (
      tester,
    ) async {
      final CheckboxController controller = CheckboxController();
      addTearDown(controller.dispose);
      controller.cycle();
      expect(controller.value, CheckboxValue.checked);
      controller.cycle();
      expect(controller.value, CheckboxValue.indeterminate);
      controller.cycle();
      expect(controller.value, CheckboxValue.unchecked);
      controller.toggle();
      expect(controller.value, CheckboxValue.checked);
      controller.setIndeterminate();
      expect(controller.value, CheckboxValue.indeterminate);
      controller.uncheck();
      expect(controller.value, CheckboxValue.unchecked);
      controller.check();
      expect(controller.value, CheckboxValue.checked);
    });
  });

  group('controller', () {
    testWidgets('drives the widget and fires no onChanged', (tester) async {
      final CheckboxController controller = CheckboxController();
      addTearDown(controller.dispose);
      int calls = 0;
      await tester.pumpWidget(
        _frame(child: Checkbox(controller: controller, onChanged: null)),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(controller.value, CheckboxValue.checked);
      expect(calls, 0);
      controller.uncheck();
      await tester.pump();
      expect(
        _decoration(tester, const <WidgetState>{}).color,
        _alpha(ShadcnColors.lightFallback.input, 0),
      );
    });

    testWidgets('rejects value/onChanged alongside a controller', (
      tester,
    ) async {
      expect(
        () => Checkbox(
          controller: CheckboxController(),
          value: CheckboxValue.checked,
          onChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });

  group('keyboard and focus', () {
    testWidgets('space and enter activate the focused checkbox', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final List<CheckboxValue> seen = <CheckboxValue>[];
      CheckboxValue value = CheckboxValue.unchecked;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Checkbox(
              focusNode: node,
              value: value,
              onChanged: (next) => setState(() {
                seen.add(next);
                value = next;
              }),
            ),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      expect(
        tester.widget<FocusOutline>(find.byType(FocusOutline)).focused,
        isTrue,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(seen, <CheckboxValue>[CheckboxValue.checked]);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(seen, <CheckboxValue>[
        CheckboxValue.checked,
        CheckboxValue.unchecked,
      ]);
    });

    testWidgets(
      'regression: the focus ring is drawn instead of a hardcoded 2px border',
      (tester) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(
          () => FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.automatic,
        );
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await tester.pumpWidget(
          _frame(
            child: Checkbox(
              focusNode: node,
              value: CheckboxValue.unchecked,
              onChanged: _noop,
            ),
          ),
        );
        // The old widget held `final bool _focusing = false`, so the focused
        // border width could never become 2.
        expect(_decoration(tester, const <WidgetState>{}).border!.top.width, 1);
        node.requestFocus();
        await tester.pump();
        expect(_decoration(tester, const <WidgetState>{}).border!.top.width, 1);
        expect(
          tester.widget<FocusOutline>(find.byType(FocusOutline)).focused,
          isTrue,
        );
      },
    );

    testWidgets('autofocus creates an internal node', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Checkbox(
            autofocus: true,
            value: CheckboxValue.unchecked,
            onChanged: _noop,
          ),
        ),
      );
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, isNotNull);
    });
  });

  group('hover', () {
    testWidgets('hover resolves the hovered row', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      await tester.pumpWidget(
        _frame(
          child: const Checkbox(value: CheckboxValue.checked, onChanged: _noop),
        ),
      );
      final Color hovered = _decoration(tester, const <WidgetState>{
        WidgetState.hovered,
      }).color!;
      expect(hovered.a, lessThan(ShadcnColors.lightFallback.primary.a));
    });
  });

  group('semantics', () {
    testWidgets('reports the checked / mixed / enabled state', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          child: const Checkbox(
            value: CheckboxValue.checked,
            onChanged: _noop,
            label: Text('Accept'),
          ),
        ),
      );
      final ({bool checked, bool mixed, bool enabled}) flags = _semantics(
        tester,
      );
      expect(flags.checked, isTrue);
      expect(flags.mixed, isFalse);
      expect(flags.enabled, isTrue);

      await tester.pumpWidget(
        _frame(
          child: const Checkbox(
            value: CheckboxValue.indeterminate,
            onChanged: _noop,
            label: Text('Accept'),
          ),
        ),
      );
      expect(_semantics(tester).mixed, isTrue);
      handle.dispose();
    });

    testWidgets('a disabled checkbox reports enabled: false', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.unchecked)),
      );
      expect(_semantics(tester).enabled, isFalse);
      handle.dispose();
    });

    testWidgets('regression: no stray gap without a label', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.unchecked)),
      );
      // The old widget always inserted a `SizedBox(width: gap)` on both sides,
      // so a label-less checkbox was 2 * 8px wider than its box.
      expect(
        find.descendant(of: find.byType(Checkbox), matching: find.byType(Gap)),
        findsNothing,
      );
      // padding 2 per side + the 1px border the box decoration contributes.
      expect(
        tester.getSize(find.byType(Checkbox)).width,
        checkboxDefaultPadding.horizontal + checkboxDefaultSize + 2,
      );
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
          child: const Checkbox(
            value: CheckboxValue.indeterminate,
            onChanged: _noop,
          ),
        ),
      );
      await tester.pump();
      expect(handle.reported, contains(CheckboxValue.indeterminate));
    });

    testWidgets('applies a ReplaceResult from validation', (tester) async {
      final _FakeFormHandle handle = _FakeFormHandle()
        ..replaceWith = CheckboxValue.checked;

      CheckboxValue? seen;
      await tester.pumpWidget(
        _frame(
          formHandle: handle,
          child: Checkbox(
            value: CheckboxValue.unchecked,
            onChanged: (value) => seen = value,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(seen, CheckboxValue.checked);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            CheckboxTheme(
              checked: CheckboxStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          child: const Checkbox(value: CheckboxValue.checked, onChanged: _noop),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            CheckboxTheme(
              checked: CheckboxStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          scopedTheme: const CheckboxTheme(
            checked: CheckboxStyle(
              background: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
          child: const Checkbox(value: CheckboxValue.checked, onChanged: _noop),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const CheckboxTheme(
            checked: CheckboxStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: const Checkbox(
            value: CheckboxValue.checked,
            onChanged: _noop,
            theme: CheckboxStyle(
              background: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, _blue);
    });

    testWidgets('a leg setting one state keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const CheckboxTheme(
            checked: CheckboxStyle(
              background: StateValue(hovered: ThemedColor.value(_green)),
            ),
          ),
          child: const Checkbox(value: CheckboxValue.checked, onChanged: _noop),
        ),
      );
      expect(
        _decoration(tester, const <WidgetState>{}).color,
        ShadcnColors.lightFallback.primary,
      );
      expect(
        _decoration(tester, const <WidgetState>{WidgetState.hovered}).color,
        _green,
      );
    });

    testWidgets('the value row is re-resolved when the value changes', (
      tester,
    ) async {
      CheckboxValue value = CheckboxValue.checked;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Checkbox(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );
      expect(
        _decoration(tester, const <WidgetState>{}).color,
        ShadcnColors.lightFallback.primary,
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(
        _decoration(tester, const <WidgetState>{}).color,
        _alpha(ShadcnColors.lightFallback.input, 0),
      );
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Checkbox(value: CheckboxValue.checked, onChanged: _noop),
        ),
      );
      final BoxDecoration box = _decoration(tester, const <WidgetState>{});
      expect(box.color, dark.primary);
      expect(_indicatorColor(tester), dark.primaryForeground);
    });

    testWidgets('regression: disabled keeps the rest colours at 50% opacity', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.checked)),
      );
      // The old widget swapped in `muted` / `mutedForeground` instead of
      // dimming the rest style.
      expect(_decoration(tester, const <WidgetState>{}).color, colors.primary);
      expect(_opacity(tester), 0.5);
    });
  });
}

Color? _indicatorColor(WidgetTester tester) {
  final Icon icon = tester.widget<Icon>(
    find.descendant(of: find.byType(Checkbox), matching: find.byType(Icon)),
  );
  return icon.color;
}

void _noop(CheckboxValue value) {}
