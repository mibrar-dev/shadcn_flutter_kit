// Widget tests for the `switch` component.
//
// Covers the on/off rows, controlled and controller-driven modes, keyboard
// activation, semantics, form participation, dark tokens and the four
// theme-precedence legs. The regression tests pin the old bugs: `enabled` was
// inconsistent between the visual state and the tap target, the disabled rows
// came from hard-coded tokens instead of the rest style, and the app theme leg
// was never read.

import 'dart:async';
import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/switch/switch.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  SwitchTheme? scopedTheme,
  FormFieldHandle? formHandle,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<SwitchTheme>(data: scopedTheme, child: body);
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

Clickable _clickable(WidgetTester tester) => tester.widget<Clickable>(
  find.descendant(of: find.byType(Switch), matching: find.byType(Clickable)),
);

/// Track decoration of the switch under test.
BoxDecoration _track(WidgetTester tester) =>
    tester.widget<AnimatedContainer>(find.byKey(kSwitchTrackKey)).decoration!
        as BoxDecoration;

/// Thumb decoration of the switch under test.
BoxDecoration _thumb(WidgetTester tester) =>
    tester.widget<DecoratedBox>(find.byKey(kSwitchThumbKey)).decoration
        as BoxDecoration;

double _opacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find.descendant(of: find.byType(Switch), matching: find.byType(Opacity)),
    )
    .opacity;

/// The x offset of the sliding thumb.
double _thumbLeft(WidgetTester tester) =>
    tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned)).left!;

({bool toggled, bool enabled}) _semantics(WidgetTester tester) {
  final SemanticsData data = tester
      .getSemantics(find.byType(Semantics).last)
      .getSemanticsData();
  return (
    toggled: data.flagsCollection.isToggled == Tristate.isTrue,
    enabled: data.flagsCollection.isEnabled == Tristate.isTrue,
  );
}

/// Form handle that records the reported value and can replace it.
class _FakeFormHandle with FormFieldHandle {
  final List<bool?> reported = <bool?>[];
  bool replaceWith = true;

  @override
  final FormKey<bool> formKey = const FormKey<bool>('switch');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value as bool?);
    return ReplaceResult<bool>(replaceWith, state: FormValidationMode.changed);
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void _noop(bool value) {}

void main() {
  group('rows', () {
    testWidgets('off uses the input track and the foreground thumb', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(child: const Switch(value: false, onChanged: _noop)),
      );
      expect(_track(tester).color, colors.input);
      expect(_thumb(tester).color, colors.foreground);
      expect(_thumbLeft(tester), 0);
    });

    testWidgets('on uses the primary track and the background thumb', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(child: const Switch(value: true, onChanged: _noop)),
      );
      expect(_track(tester).color, colors.primary);
      expect(_thumb(tester).color, colors.background);
      // shadcn `translate-x-[calc(100%-2px)]`: 32 - 16 - 2 = 14.
      expect(
        _thumbLeft(tester),
        switchDefaultTrackSize.width - switchDefaultThumbSize - 2,
      );
    });

    testWidgets('track and thumb use the shadcn sizes', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Switch(value: false, onChanged: _noop)),
      );
      final AnimatedContainer track = tester.widget<AnimatedContainer>(
        find.byKey(kSwitchTrackKey),
      );
      expect(track.constraints?.maxWidth, switchDefaultTrackSize.width);
      expect(track.constraints?.maxHeight, switchDefaultTrackSize.height);
      final AnimatedPositioned thumb = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(thumb.width, switchDefaultThumbSize);
    });

    testWidgets('label sits next to the track with the gap', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Switch(
            value: false,
            onChanged: _noop,
            label: Text('Wi-Fi'),
          ),
        ),
      );
      expect(find.text('Wi-Fi'), findsOneWidget);
      // `Clickable` wraps its child in an outer `DefaultTextStyle.merge` with a
      // null style; the label's own style is the innermost one.
      final TextStyle style = tester
          .widgetList<DefaultTextStyle>(
            find.descendant(
              of: find.byType(Switch),
              matching: find.byType(DefaultTextStyle),
            ),
          )
          .last
          .style;
      expect(style.color, ShadcnColors.lightFallback.foreground);
      expect(style.fontSize, switchDefaultLabelStyle.fontSize);
    });

    testWidgets('a border is drawn when the theme asks for one', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const Switch(
            value: false,
            onChanged: _noop,
            theme: SwitchStyle(
              borderColor: StateValue(rest: ThemedColor.ref(ColorRef.border)),
              borderWidth: 2,
            ),
          ),
        ),
      );
      expect(
        _track(tester).border,
        Border.all(color: ShadcnColors.lightFallback.border, width: 2),
      );
    });
  });

  group('controlled', () {
    testWidgets('tap reports the flipped value', (tester) async {
      bool value = false;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Switch(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
      expect(_thumbLeft(tester), greaterThan(0));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(value, isFalse);
    });

    testWidgets('null onChanged disables the control', (tester) async {
      await tester.pumpWidget(_frame(child: const Switch(value: false)));
      expect(_clickable(tester).enabled, isFalse);
      expect(_opacity(tester), 0.5);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(_opacity(tester), 0.5);
    });

    testWidgets('enabled: false disables even with an onChanged', (
      tester,
    ) async {
      int calls = 0;
      await tester.pumpWidget(
        _frame(
          child: Switch(
            enabled: false,
            value: false,
            onChanged: (_) => calls++,
          ),
        ),
      );
      expect(_clickable(tester).enabled, isFalse);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(calls, 0);
    });

    testWidgets('enabled: true enables a read-only value', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Switch(enabled: true, value: true)),
      );
      expect(_clickable(tester).enabled, isTrue);
      expect(_opacity(tester), 1);
    });
  });

  group('controller', () {
    testWidgets('drives the widget; value/onChanged are rejected', (
      tester,
    ) async {
      final SwitchController controller = SwitchController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: Switch(controller: controller)));
      expect(controller.value, isFalse);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(controller.value, isTrue);
      controller.toggle();
      await tester.pumpAndSettle();
      expect(_thumbLeft(tester), 0);
    });

    testWidgets('rejects value/onChanged alongside a controller', (
      tester,
    ) async {
      expect(
        () => Switch(
          controller: SwitchController(),
          value: true,
          onChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });

  group('keyboard and focus', () {
    testWidgets('space and enter activate the focused switch', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      bool value = false;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Switch(
              focusNode: node,
              value: value,
              onChanged: (next) => setState(() => value = next),
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
      await tester.pumpAndSettle();
      expect(value, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(value, isFalse);
    });

    testWidgets('autofocus creates an internal node', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Switch(autofocus: true, onChanged: _noop)),
      );
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, isNotNull);
    });
  });

  group('hover', () {
    testWidgets('hover resolves the hovered track row', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(child: const Switch(value: false, onChanged: _noop)),
      );
      expect(_track(tester).color, colors.input);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Switch)));
      await tester.pumpAndSettle();
      expect(_track(tester).color, _alpha(colors.input, 0.8));
    });
  });

  group('semantics', () {
    testWidgets('reports the toggled and enabled state', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          child: const Switch(value: true, onChanged: _noop, label: Text('On')),
        ),
      );
      final ({bool toggled, bool enabled}) flags = _semantics(tester);
      expect(flags.toggled, isTrue);
      expect(flags.enabled, isTrue);
      await tester.pumpWidget(
        _frame(child: const Switch(value: false, onChanged: _noop)),
      );
      expect(_semantics(tester).toggled, isFalse);
      handle.dispose();
    });

    testWidgets('a disabled switch reports enabled: false', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_frame(child: const Switch(value: false)));
      expect(_semantics(tester).enabled, isFalse);
      handle.dispose();
    });

    testWidgets('a checkbox state is never used', (tester) async {
      // Guards against the semantics being confused with a checkbox: a switch
      // is `toggled`, not `checked`.
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(child: const Switch(value: true, onChanged: _noop)),
      );
      final SemanticsNode node = tester.getSemantics(
        find.byType(Semantics).last,
      );
      expect(node.flagsCollection.isChecked, CheckedState.none);
      handle.dispose();
    });
  });

  group('form', () {
    testWidgets('reports the current value to the nearest form', (
      tester,
    ) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      await tester.pumpWidget(
        _frame(formHandle: handle, child: const Switch(value: true)),
      );
      await tester.pump();
      expect(handle.reported, contains(true));
    });

    testWidgets('applies a ReplaceResult from validation', (tester) async {
      final _FakeFormHandle handle = _FakeFormHandle()..replaceWith = true;
      bool? seen;
      await tester.pumpWidget(
        _frame(
          formHandle: handle,
          child: Switch(value: false, onChanged: (value) => seen = value),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(seen, isTrue);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            SwitchTheme(
              on: SwitchStyle(
                trackColor: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          child: const Switch(value: true, onChanged: _noop),
        ),
      );
      expect(_track(tester).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            SwitchTheme(
              on: SwitchStyle(
                trackColor: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          scopedTheme: const SwitchTheme(
            on: SwitchStyle(
              trackColor: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
          child: const Switch(value: true, onChanged: _noop),
        ),
      );
      expect(_track(tester).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const SwitchTheme(
            on: SwitchStyle(
              trackColor: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: const Switch(
            value: true,
            onChanged: _noop,
            theme: SwitchStyle(
              trackColor: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
        ),
      );
      expect(_track(tester).color, _blue);
    });

    testWidgets('a leg setting one state keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const SwitchTheme(
            on: SwitchStyle(
              trackColor: StateValue(hovered: ThemedColor.value(_green)),
            ),
          ),
          child: const Switch(value: true, onChanged: _noop),
        ),
      );
      expect(_track(tester).color, ShadcnColors.lightFallback.primary);
      expect(_thumb(tester).color, ShadcnColors.lightFallback.background);
    });

    testWidgets('the value row is re-resolved when the value changes', (
      tester,
    ) async {
      bool value = false;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (context, setState) => Switch(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );
      final ShadcnColors colors = ShadcnColors.lightFallback;
      expect(_track(tester).color, colors.input);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(_track(tester).color, colors.primary);
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Switch(value: true, onChanged: _noop),
        ),
      );
      expect(_track(tester).color, dark.primary);
      expect(_thumb(tester).color, dark.background);
    });

    testWidgets('regression: disabled keeps the rest colours at 50% opacity', (
      tester,
    ) async {
      // The old table painted `muted` for the track and `mutedForeground`
      // for the thumb while disabled, so the control changed identity.
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(_frame(child: const Switch(value: true)));
      expect(_track(tester).color, colors.primary);
      expect(_thumb(tester).color, colors.background);
      expect(_opacity(tester), 0.5);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Switch(
            value: false,
            onChanged: _noop,
            theme: SwitchStyle(
              trackColor: StateValue(
                rest: ThemedColor.ref(ColorRef.input, alpha: 0.5),
              ),
            ),
          ),
        ),
      );
      expect(_track(tester).color!.a, closeTo(dark.input.a * 0.5, 0.001));
    });
  });
}
