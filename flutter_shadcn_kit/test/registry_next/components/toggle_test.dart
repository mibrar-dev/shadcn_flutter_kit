// Widget and unit tests for the `toggle` component.
//
// Covers design §1.9: controlled flipping, controller mode, null-onChanged
// disabling, plus theme precedence, keyboard activation, form participation
// and dark tokens.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/toggle/toggle.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);
const Color _red = Color(0xFFFF0000);
const Color _yellow = Color(0xFFFFFF00);

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

class _Probe {
  _Probe(this.clickable, this.opacity);

  final Clickable clickable;
  final double opacity;

  BoxDecoration? decoration(Set<WidgetState> states) =>
      clickable.decoration?.resolve(states) as BoxDecoration?;

  TextStyle? text(Set<WidgetState> states) =>
      clickable.textStyle?.resolve(states);
}

_Probe _probe(WidgetTester tester) {
  return _Probe(
    tester.widget<Clickable>(
      find.descendant(
        of: find.byType(Toggle),
        matching: find.byType(Clickable),
      ),
    ),
    tester
        .widget<Opacity>(
          find.descendant(
            of: find.byType(Toggle),
            matching: find.byType(Opacity),
          ),
        )
        .opacity,
  );
}

class _FakeFormHandle with FormFieldHandle {
  final List<bool?> reported = <bool?>[];

  @override
  final FormKey<bool> formKey = const FormKey<bool>('toggle');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value as bool?);
    return null;
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  test('default on/off rows match the design', () {
    final on = toggleDefaults.forValue(true)!;
    final off = toggleDefaults.forValue(false)!;
    final rest = <WidgetState>{};
    final hovered = <WidgetState>{WidgetState.hovered};

    Color? bg(ToggleStyle row, Set<WidgetState> states) =>
        row.background?.resolve(states)?.resolve(colors);
    Color? fg(ToggleStyle row, Set<WidgetState> states) =>
        row.foreground?.resolve(states)?.resolve(colors);

    expect(bg(on, rest), colors.primary);
    expect(bg(on, hovered), _alpha(colors.primary, 0.9));
    expect(fg(on, rest), colors.primaryForeground);

    expect(bg(off, rest), _alpha(colors.muted, 0));
    expect(bg(off, hovered), _alpha(colors.muted, 0.8));
    expect(fg(off, rest), colors.foreground);
  });

  testWidgets('controlled toggle flips through onChanged', (tester) async {
    bool value = false;
    await tester.pumpWidget(
      _frame(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Toggle(
              value: value,
              onChanged: (next) => setState(() => value = next),
              child: const Text('Bold'),
            );
          },
        ),
      ),
    );
    expect(
      _probe(tester).decoration(<WidgetState>{})!.color,
      _alpha(colors.muted, 0),
    );

    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(value, isTrue);
    expect(_probe(tester).decoration(<WidgetState>{})!.color, colors.primary);

    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(value, isFalse);
    expect(
      _probe(tester).decoration(<WidgetState>{})!.color,
      _alpha(colors.muted, 0),
    );
  });

  testWidgets('controller mode reads and writes the controller', (
    tester,
  ) async {
    final controller = ToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        child: Toggle(controller: controller, child: const Text('Sidebar')),
      ),
    );
    expect(controller.value, isFalse);

    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(controller.value, isTrue);
    expect(_probe(tester).decoration(<WidgetState>{})!.color, colors.primary);

    controller.toggle();
    await tester.pump();
    expect(controller.value, isFalse);
    expect(
      _probe(tester).decoration(<WidgetState>{})!.color,
      _alpha(colors.muted, 0),
    );
  });

  testWidgets('null onChanged disables; enabled overrides it', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Toggle(value: false, child: Text('Off'))),
    );
    var probe = _probe(tester);
    expect(probe.opacity, 0.5);
    expect(probe.clickable.enabled, isFalse);
    final disabled = probe.decoration(<WidgetState>{WidgetState.disabled})!;
    final label = probe.text(<WidgetState>{WidgetState.disabled})!;
    expect(label.color, colors.foreground);
    expect(label.color, isNot(equals(disabled.color)));

    var taps = 0;
    await tester.pumpWidget(
      _frame(
        child: Toggle(
          value: false,
          enabled: true,
          onChanged: (_) => taps++,
          child: const Text('Forced on'),
        ),
      ),
    );
    expect(_probe(tester).opacity, 1);
    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(taps, 1);

    final controller = ToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        child: Toggle(
          controller: controller,
          enabled: false,
          child: const Text('Locked'),
        ),
      ),
    );
    probe = _probe(tester);
    expect(probe.opacity, 0.5);
    expect(probe.clickable.enabled, isFalse);
    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(controller.value, isFalse);
  });

  testWidgets('Enter and Space activate a focused toggle', (tester) async {
    final controller = ToggleController();
    addTearDown(controller.dispose);
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      _frame(
        child: Toggle(
          controller: controller,
          focusNode: node,
          child: const Text('Keys'),
        ),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(controller.value, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(controller.value, isFalse);
  });

  testWidgets('focus ring follows keyboard focus only', (tester) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(
      () => FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic,
    );
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      _frame(
        child: Toggle(
          value: false,
          onChanged: (_) {},
          focusNode: node,
          child: const Text('Focus'),
        ),
      ),
    );
    FocusOutline ring() => tester.widget<FocusOutline>(
      find.descendant(
        of: find.byType(Toggle),
        matching: find.byType(FocusOutline),
      ),
    );
    expect(ring().focused, isFalse);
    node.requestFocus();
    await tester.pump();
    expect(ring().focused, isTrue);
    node.unfocus();
    await tester.pump();
    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(ring().focused, isFalse);
  });

  testWidgets('theme legs resolve per field: widget > scoped > app', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          ToggleTheme(
            on: ToggleStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
        ],
        child: ComponentTheme<ToggleTheme>(
          data: const ToggleTheme(
            on: ToggleStyle(
              background: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
          child: Toggle(
            value: true,
            onChanged: (_) {},
            activeStyle: const ToggleStyle(
              background: StateValue(rest: ThemedColor.value(_red)),
            ),
            theme: const ToggleStyle(
              foreground: StateValue(rest: ThemedColor.value(_yellow)),
            ),
            child: const Text('Legs'),
          ),
        ),
      ),
    );
    final probe = _probe(tester);
    expect(probe.decoration(<WidgetState>{})!.color, _red);
    expect(probe.text(<WidgetState>{})!.color, _yellow);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          ToggleTheme(
            on: ToggleStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
        ],
        child: Toggle(
          value: true,
          onChanged: (_) {},
          child: const Text('App leg'),
        ),
      ),
    );
    expect(_probe(tester).decoration(<WidgetState>{})!.color, _green);
  });

  testWidgets('dark tokens drive the on/off fill', (tester) async {
    const ShadcnColors dark = ShadcnColors.darkFallback;
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: dark),
        child: Toggle(value: true, onChanged: (_) {}, child: const Text('On')),
      ),
    );
    final probe = _probe(tester);
    expect(probe.decoration(<WidgetState>{})!.color, dark.primary);
    expect(probe.text(<WidgetState>{})!.color, dark.primaryForeground);
  });

  testWidgets('reports its value to a form and accepts replacements', (
    tester,
  ) async {
    final handle = _FakeFormHandle();
    var value = false;
    await tester.pumpWidget(
      _frame(
        child: Data<FormFieldHandle>.inherit(
          data: handle,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Toggle(
                value: value,
                onChanged: (next) => setState(() => value = next),
                child: const Text('Form'),
              );
            },
          ),
        ),
      ),
    );
    expect(handle.reported.whereType<bool>(), contains(false));
    await tester.tap(find.byType(Toggle));
    await tester.pump();
    expect(handle.reported.last, isTrue);
  });
}
