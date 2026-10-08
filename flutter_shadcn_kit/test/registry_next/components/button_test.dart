// Widget and unit tests for the `button` component.
//
// Covers design §1.9: the variant x state token matrix, the four-leg
// precedence, keyboard activation, focus ring behaviour, disabled semantics,
// group radii, RTL and dark tokens.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);
const Color _yellow = Color(0xFFFFFF00);

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: textDirection,
        child: Center(child: child),
      ),
    ),
  );
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
}) {
  return tester.pumpWidget(
    _frame(data: data, app: app, textDirection: textDirection, child: child),
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

  IconThemeData? icon(Set<WidgetState> states) =>
      clickable.iconTheme?.resolve(states);

  EdgeInsetsGeometry? padding() => clickable.padding?.resolve(<WidgetState>{});
}

_Probe _probe(WidgetTester tester, [Finder? root]) {
  final Finder button = root ?? find.byType(Button);
  return _Probe(
    tester.widget<Clickable>(
      find.descendant(of: button, matching: find.byType(Clickable)),
    ),
    tester
        .widget<Opacity>(
          find.descendant(of: button, matching: find.byType(Opacity)),
        )
        .opacity,
  );
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;
  const rest = <WidgetState>{};
  const hovered = <WidgetState>{WidgetState.hovered};
  const pressed = <WidgetState>{WidgetState.pressed};
  const disabled = <WidgetState>{WidgetState.disabled};
  const focused = <WidgetState>{WidgetState.focused};
  const List<Set<WidgetState>> states = <Set<WidgetState>>[
    rest,
    hovered,
    pressed,
    disabled,
    focused,
  ];

  test('variant x state token matrix (design §1.4)', () {
    ButtonVariantStyle row(ButtonVariant variant) =>
        buttonDefaults.forVariant(variant)!;
    Color? bg(ButtonVariant v, Set<WidgetState> s) =>
        row(v).background?.resolve(s)?.resolve(colors);
    Color? fg(ButtonVariant v, Set<WidgetState> s) =>
        row(v).foreground?.resolve(s)?.resolve(colors);

    List<Color?> fillRow(Color? base, double restAlpha, double hoverAlpha) {
      Color? at(double alpha) => base == null ? null : _alpha(base, alpha);
      return <Color?>[
        at(restAlpha),
        at(hoverAlpha),
        at(hoverAlpha),
        at(restAlpha),
        at(restAlpha),
      ];
    }

    final fills = <ButtonVariant, List<Color?>>{
      ButtonVariant.primary: fillRow(colors.primary, 1, 0.9),
      ButtonVariant.secondary: fillRow(colors.secondary, 1, 0.8),
      ButtonVariant.outline: fillRow(colors.input, 0.3, 0.5),
      ButtonVariant.ghost: fillRow(colors.muted, 0, 0.8),
      ButtonVariant.link: fillRow(null, 1, 1),
      ButtonVariant.text: fillRow(null, 1, 1),
      ButtonVariant.destructive: fillRow(colors.destructive, 1, 0.9),
    };
    final foregrounds = <ButtonVariant, Color>{
      ButtonVariant.primary: colors.primaryForeground,
      ButtonVariant.secondary: colors.secondaryForeground,
      ButtonVariant.outline: colors.foreground,
      ButtonVariant.ghost: colors.foreground,
      ButtonVariant.link: colors.foreground,
      ButtonVariant.destructive: colors.destructiveForeground,
    };

    for (final variant in ButtonVariant.values) {
      for (var i = 0; i < states.length; i++) {
        expect(
          bg(variant, states[i]),
          fills[variant]![i],
          reason: '$variant fill in ${states[i]}',
        );
      }
      if (variant != ButtonVariant.text) {
        for (final state in states) {
          expect(
            fg(variant, state),
            foregrounds[variant],
            reason: '$variant label in $state',
          );
        }
      }
      final fill = bg(variant, disabled);
      final label = fg(variant, disabled);
      expect(label, isNotNull, reason: '$variant disabled label');
      if (fill != null) {
        expect(label, isNot(fill), reason: '$variant disabled label');
      }
    }

    expect(fg(ButtonVariant.text, rest), colors.mutedForeground);
    expect(fg(ButtonVariant.text, hovered), colors.primary);
    expect(fg(ButtonVariant.text, pressed), colors.primary);
    expect(fg(ButtonVariant.text, disabled), colors.mutedForeground);
    expect(
      row(ButtonVariant.outline).borderColor!.resolve(rest)!.resolve(colors),
      colors.input,
    );
    expect(row(ButtonVariant.outline).borderWidth, 1);
    expect(row(ButtonVariant.link).decoration!.resolve(rest), isNull);
    expect(
      row(ButtonVariant.link).decoration!.resolve(hovered),
      TextDecoration.underline,
    );
    expect(
      row(ButtonVariant.link).decoration!.resolve(pressed),
      TextDecoration.underline,
    );
  });

  testWidgets('rest colours, padding, icon size and dark tokens', (
    tester,
  ) async {
    await _pump(tester, Button(onPressed: () {}, child: const Text('Save')));
    var probe = _probe(tester);
    expect(probe.clickable.enabled, isTrue);
    expect(probe.decoration(rest)!.color, colors.primary);
    expect(probe.text(rest)!.color, colors.primaryForeground);
    expect(probe.icon(rest)!.color, colors.primaryForeground);
    expect(probe.padding(), const EdgeInsets.symmetric(horizontal: 16));

    await _pump(
      tester,
      Button(
        size: ButtonSize.icon,
        onPressed: () {},
        child: const SizedBox(width: 16, height: 16),
      ),
    );
    // Let the AnimatedContainer finish moving from the previous padding.
    await tester.pump(const Duration(milliseconds: 200));
    probe = _probe(tester);
    expect(probe.padding(), EdgeInsets.zero);
    expect(tester.getSize(find.byType(Button)), const Size(36, 36));

    const ShadcnColors dark = ShadcnColors.darkFallback;
    await _pump(
      tester,
      Button(onPressed: () {}, child: const Text('Dark')),
      data: const ShadcnThemeData(colors: dark),
    );
    probe = _probe(tester);
    expect(probe.decoration(rest)!.color, dark.primary);
    expect(probe.text(rest)!.color, dark.primaryForeground);
  });

  testWidgets('hover drives the hovered fill, press the pressed fill', (
    tester,
  ) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(
      () => FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic,
    );
    // Distinct rest/hovered/pressed fills: the old defaults shared hovered
    // and pressed (both alpha 0.9), so the assertion passed for the wrong
    // reason when a press delivered the same colour as a hover.
    var hovered = false;
    await _pump(
      tester,
      Button(
        onPressed: () {},
        onHover: (value) => hovered = value,
        theme: const ButtonVariantStyle(
          background: StateValue(
            rest: ThemedColor.value(_yellow),
            hovered: ThemedColor.value(_green),
            pressed: ThemedColor.value(_red),
          ),
        ),
        child: const Text('Go'),
      ),
    );
    final Finder animated = find.descendant(
      of: find.byType(Button),
      matching: find.byType(AnimatedContainer),
    );
    BoxDecoration current() =>
        tester.widget<AnimatedContainer>(animated).decoration! as BoxDecoration;

    expect(current().color, _yellow);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.byType(Button)));
    await tester.pump();
    expect(hovered, isTrue, reason: 'mouse move must deliver hover');
    expect(current().color, _green);

    final press = await tester.startGesture(
      tester.getCenter(find.byType(Button)),
    );
    await tester.pump();
    expect(current().color, _red);
    await press.up();
    await tester.pump();
  });

  testWidgets('disabled: both switches, opacity 0.5 and readable label', (
    tester,
  ) async {
    await _pump(tester, const Button(onPressed: null, child: Text('None')));
    var probe = _probe(tester);
    expect(probe.opacity, 0.5);
    expect(probe.clickable.enabled, isFalse);
    final fill = probe.decoration(disabled)!;
    expect(fill.color, colors.primary);
    final label = probe.text(disabled)!;
    expect(label.color, colors.primaryForeground);
    expect(label.color, isNot(fill.color));

    await _pump(
      tester,
      Button(enabled: false, onPressed: () {}, child: const Text('Off')),
    );
    probe = _probe(tester);
    expect(probe.opacity, 0.5);
    expect(probe.clickable.enabled, isFalse);

    await _pump(
      tester,
      Button(enabled: true, onPressed: null, child: const Text('Inert')),
    );
    probe = _probe(tester);
    expect(probe.opacity, 1);
    expect(probe.clickable.enabled, isTrue);
  });

  testWidgets('Enter/Space activate; focus ring follows keyboard focus', (
    tester,
  ) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(
      () => FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic,
    );
    var taps = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await _pump(
      tester,
      Button(focusNode: node, onPressed: () => taps++, child: const Text('Go')),
    );
    FocusOutline ring() => tester.widget<FocusOutline>(
      find.descendant(
        of: find.byType(Button),
        matching: find.byType(FocusOutline),
      ),
    );
    expect(ring().focused, isFalse);
    node.requestFocus();
    await tester.pump();
    expect(ring().focused, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(taps, 2);

    node.unfocus();
    await tester.pump();
    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(taps, 3);
    expect(ring().focused, isFalse, reason: 'pointer tap must not focus');

    final disabledNode = FocusNode();
    addTearDown(disabledNode.dispose);
    await _pump(
      tester,
      Button(
        focusNode: disabledNode,
        enabled: false,
        onPressed: () => taps++,
        child: const Text('Go'),
      ),
    );
    disabledNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(taps, 3);
  });

  testWidgets('four legs resolve per field, stacked overrides keep rest', (
    tester,
  ) async {
    await _pump(
      tester,
      ComponentTheme<ButtonTheme>(
        data: const ButtonTheme(
          primary: ButtonVariantStyle(
            foreground: StateValue(rest: ThemedColor.value(_blue)),
          ),
        ),
        child: Button(
          theme: const ButtonVariantStyle(
            background: StateValue(rest: ThemedColor.value(_yellow)),
          ),
          onPressed: () {},
          child: const Text('Legs'),
        ),
      ),
      app: const <ComponentThemeData>[
        ButtonTheme(
          primary: ButtonVariantStyle(
            background: StateValue(hovered: ThemedColor.value(_green)),
          ),
        ),
      ],
    );
    var probe = _probe(tester);
    expect(probe.decoration(rest)!.color, _yellow);
    expect(probe.text(rest)!.color, _blue);
    expect(probe.decoration(hovered)!.color, _green);
    expect(probe.padding(), const EdgeInsets.symmetric(horizontal: 16));

    await _pump(
      tester,
      Button(
        theme: const ButtonVariantStyle(
          background: StateValue(hovered: ThemedColor.value(_red)),
        ),
        onPressed: () {},
        child: const Text('Stacked'),
      ),
      app: const <ComponentThemeData>[
        ButtonTheme(
          primary: ButtonVariantStyle(
            background: StateValue(rest: ThemedColor.value(_blue)),
          ),
        ),
      ],
    );
    probe = _probe(tester);
    expect(probe.decoration(rest)!.color, _blue);
    expect(probe.decoration(hovered)!.color, _red);
  });

  testWidgets('group radii flatten inner corners and follow RTL', (
    tester,
  ) async {
    Button keyed(String key, String label) => Button(
      key: ValueKey<String>(key),
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: Text(label),
    );
    BorderRadiusGeometry radius(WidgetTester t, String key) => _probe(
      t,
      find.byKey(ValueKey<String>(key)),
    ).decoration(rest)!.borderRadius!;

    await _pump(
      tester,
      ButtonGroup(
        children: <Widget>[keyed('a', 'A'), keyed('b', 'B'), keyed('c', 'C')],
      ),
    );
    final Radius full = Radius.circular(6);
    expect(
      radius(tester, 'a'),
      BorderRadius.only(
        topLeft: full,
        topRight: Radius.zero,
        bottomLeft: full,
        bottomRight: Radius.zero,
      ),
    );
    expect(radius(tester, 'b'), BorderRadius.zero);
    expect(
      radius(tester, 'c'),
      BorderRadius.only(
        topLeft: Radius.zero,
        topRight: full,
        bottomLeft: Radius.zero,
        bottomRight: full,
      ),
    );

    await _pump(tester, ButtonGroup(children: <Widget>[keyed('solo', 'Solo')]));
    expect(radius(tester, 'solo'), BorderRadius.all(full));

    await _pump(
      tester,
      ButtonGroup(children: <Widget>[keyed('a', 'A'), keyed('b', 'B')]),
      textDirection: TextDirection.rtl,
    );
    expect(
      radius(tester, 'a'),
      BorderRadius.only(
        topLeft: Radius.zero,
        topRight: full,
        bottomLeft: Radius.zero,
        bottomRight: full,
      ),
    );
  });

  test('ButtonTheme covers every variant, merges and lerps', () {
    for (final variant in ButtonVariant.values) {
      expect(buttonDefaults.forVariant(variant), isNotNull);
    }
    const receiver = ButtonTheme(
      primary: ButtonVariantStyle(
        background: StateValue(hovered: ThemedColor.value(_red)),
        borderWidth: 2,
      ),
    );
    const fallback = ButtonTheme(
      primary: ButtonVariantStyle(
        background: StateValue(rest: ThemedColor.value(_green)),
        padding: EdgeInsets.all(4),
      ),
    );
    final merged = receiver.merge(fallback).primary!;
    expect(merged.background!.resolve(rest)!.resolve(colors), _green);
    expect(merged.background!.resolve(hovered)!.resolve(colors), _red);
    expect(merged.padding, const EdgeInsets.all(4));
    expect(merged.borderWidth, 2);

    const a = ButtonTheme(
      primary: ButtonVariantStyle(
        background: StateValue(rest: ThemedColor.value(_red)),
        borderWidth: 2,
      ),
    );
    const b = ButtonTheme(
      primary: ButtonVariantStyle(
        background: StateValue(rest: ThemedColor.value(_blue)),
        borderWidth: 4,
      ),
    );
    expect(
      ButtonTheme.lerp(
        a,
        b,
        0.25,
      ).primary!.background!.resolve(rest)!.resolve(colors),
      _red,
    );
    expect(
      ButtonTheme.lerp(
        a,
        b,
        0.75,
      ).primary!.background!.resolve(rest)!.resolve(colors),
      _blue,
    );
    expect(ButtonTheme.lerp(a, b, 0.25).primary!.borderWidth, 2.5);
    expect(ButtonTheme.lerp(a, b, 0.75).primary!.borderWidth, 3.5);
  });
}
