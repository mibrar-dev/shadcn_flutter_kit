// Widget tests for the `chip` component.
//
// Covers the static / pressable split, the inner `ChipButton`, hover and
// keyboard behaviour, dark tokens and the four theme-precedence legs. The
// regression tests pin the old bugs: a read-only chip was wired to a no-op
// `onPressed` (so it swallowed taps and showed hover styling) and the padding
// theme leg was read inside a closure that ignored the widget value.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/button/button_style.dart';
import 'package:flutter_shadcn_kit/registry_next/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ChipTheme? scopedTheme,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<ChipTheme>(data: scopedTheme, child: body);
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

/// The `Clickable` of a pressable [Chip].
Clickable? _chipClickable(WidgetTester tester) {
  final Finder finder = find.descendant(
    of: find.byType(Chip),
    matching: find.byType(Clickable),
  );
  return finder.evaluate().isEmpty
      ? null
      : tester.widget<Clickable>(finder.first);
}

/// The `Clickable` of a pressable [ChipButton].
Clickable? _buttonClickable(WidgetTester tester) {
  final Finder finder = find.descendant(
    of: find.byType(ChipButton),
    matching: find.byType(Clickable),
  );
  return finder.evaluate().isEmpty
      ? null
      : tester.widget<Clickable>(finder.first);
}

/// Surface decoration of a static chip (no `Clickable` involved).
BoxDecoration _staticDecoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find.descendant(
                of: find.byType(Chip),
                matching: find.byType(DecoratedBox),
              ),
            )
            .decoration
        as BoxDecoration;

/// Padding of a static chip.
EdgeInsetsGeometry _staticPadding(WidgetTester tester) => tester
    .widget<Padding>(
      find.descendant(of: find.byType(Chip), matching: find.byType(Padding)),
    )
    .padding;

/// Text style a static chip applies to its label.
TextStyle _staticTextStyle(WidgetTester tester) => tester
    .widgetList<DefaultTextStyle>(
      find.descendant(
        of: find.byType(Chip),
        matching: find.byType(DefaultTextStyle),
      ),
    )
    .first
    .style;

BoxDecoration _row(WidgetTester tester, Set<WidgetState> states) =>
    _chipClickable(tester)!.decoration!.resolve(states) as BoxDecoration;

TextStyle _rowText(WidgetTester tester) =>
    _chipClickable(tester)!.textStyle!.resolve(const <WidgetState>{})!;

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

void main() {
  group('static', () {
    testWidgets('renders its content with the secondary row by default', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const Chip(child: Text('static'))));
      expect(find.text('static'), findsOneWidget);
      final ShadcnColors colors = ShadcnColors.lightFallback;
      expect(_staticDecoration(tester).color, colors.secondary);
      expect(_staticTextStyle(tester).color, colors.secondaryForeground);
      expect(_staticPadding(tester), chipDefaultPadding);
      expect(_staticTextStyle(tester).fontSize, 12);
    });

    testWidgets(
      'regression: a read-only chip builds no tap target and is not dimmed',
      (tester) async {
        // The old widget passed `onPressed ?? () {}`, so every chip was an
        // enabled button that fired nothing and dimmed itself.
        await tester.pumpWidget(
          _frame(child: const Chip(child: Text('static'))),
        );
        expect(_chipClickable(tester), isNull);
        expect(
          find.descendant(
            of: find.byType(Chip),
            matching: find.byType(Opacity),
          ),
          findsNothing,
        );
        expect(
          _staticDecoration(tester).color,
          ShadcnColors.lightFallback.secondary,
        );
      },
    );

    testWidgets('leading and trailing widgets are rendered', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Chip(
            leading: Icon(IconData(0x1)),
            trailing: Icon(IconData(0x2)),
            child: Text('both'),
          ),
        ),
      );
      expect(find.byIcon(const IconData(0x1)), findsOneWidget);
      expect(find.byIcon(const IconData(0x2)), findsOneWidget);
    });
  });

  group('pressable', () {
    testWidgets('tap fires onPressed', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _frame(
          child: Chip(onPressed: () => taps++, child: const Text('tap')),
        ),
      );
      await tester.tap(find.byType(Chip));
      expect(taps, 1);
    });

    testWidgets('hover resolves the hovered button row', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          child: Chip(onPressed: () {}, child: const Text('hover')),
        ),
      );
      expect(_row(tester, const <WidgetState>{}).color, colors.secondary);

      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Chip)));
      await tester.pump();
      expect(
        _row(tester, const <WidgetState>{WidgetState.hovered}).color,
        _alpha(colors.secondary, 0.8),
      );
    });

    testWidgets('space and enter activate a focused chip', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      int taps = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: Chip(
            focusNode: node,
            onPressed: () => taps++,
            child: const Text('keys'),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('onHover and onFocusChange report state changes', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final List<bool> hovered = <bool>[];
      final List<bool> focused = <bool>[];
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: Chip(
            focusNode: node,
            onPressed: () {},
            onHover: hovered.add,
            onFocusChange: focused.add,
            child: const Text('observe'),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      expect(focused, <bool>[true]);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Chip)));
      await tester.pump();
      expect(hovered, contains(true));
    });
  });

  group('ChipButton', () {
    testWidgets('renders the ghost row with zero padding', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ChipButton(onPressed: () {}, child: const Icon(IconData(0x3))),
        ),
      );
      expect(
        tester
            .widgetList<Padding>(
              find.descendant(
                of: find.byType(ChipButton),
                matching: find.byType(Padding),
              ),
            )
            .first
            .padding,
        chipButtonDefaultPadding,
      );
      final ShadcnColors colors = ShadcnColors.lightFallback;
      BoxDecoration buttonRow(Set<WidgetState> states) =>
          _buttonClickable(tester)!.decoration!.resolve(states)
              as BoxDecoration;
      expect(buttonRow(const <WidgetState>{}).color!.a, 0);
      expect(
        buttonRow(const <WidgetState>{WidgetState.hovered}).color,
        _alpha(colors.muted, 0.8),
      );
    });

    testWidgets('a static ChipButton builds no tap target', (tester) async {
      await tester.pumpWidget(
        _frame(child: const ChipButton(child: Icon(IconData(0x3)))),
      );
      expect(_buttonClickable(tester), isNull);
    });

    testWidgets('sizes its icons at 12 by default', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ChipButton(onPressed: () {}, child: const Icon(IconData(0x3))),
        ),
      );
      expect(
        tester.widgetList<IconTheme>(find.byType(IconTheme)).last.data.size,
        chipButtonDefaultIconSize,
      );
    });

    testWidgets('honours an explicit iconSize', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ChipButton(
            iconSize: 20,
            onPressed: () {},
            child: const Icon(IconData(0x3)),
          ),
        ),
      );
      expect(
        tester.widgetList<IconTheme>(find.byType(IconTheme)).last.data.size,
        20,
      );
    });

    testWidgets('works as the trailing remove control of a chip', (
      tester,
    ) async {
      int removals = 0;
      await tester.pumpWidget(
        _frame(
          child: Chip(
            trailing: ChipButton(
              onPressed: () => removals++,
              child: const Icon(IconData(0x3)),
            ),
            child: const Text('tag'),
          ),
        ),
      );
      // Only the inner control is pressable: the chip itself stays a static
      // token even though it hosts a tap target.
      expect(find.byType(Clickable), findsOneWidget);
      expect(_buttonClickable(tester), isNotNull);
      await tester.tap(find.byType(ChipButton));
      expect(removals, 1);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            ChipTheme(variant: ButtonVariant.destructive),
          ],
          child: const Chip(child: Text('app')),
        ),
      );
      expect(
        _staticDecoration(tester).color,
        ShadcnColors.lightFallback.destructive,
      );
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            ChipTheme(variant: ButtonVariant.destructive),
          ],
          scopedTheme: const ChipTheme(variant: ButtonVariant.ghost),
          child: const Chip(child: Text('scoped')),
        ),
      );
      final ShadcnColors colors = ShadcnColors.lightFallback;
      expect(_staticDecoration(tester).color!.a, 0);
      expect(_staticTextStyle(tester).color, colors.foreground);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const ChipTheme(padding: EdgeInsets.all(4)),
          child: const Chip(
            theme: ChipTheme(padding: EdgeInsets.all(9)),
            child: Text('widget'),
          ),
        ),
      );
      expect(_staticPadding(tester), const EdgeInsets.all(9));
    });

    testWidgets(
      'regression: the padding leg reaches the chip that used to ignore it',
      (tester) async {
        // The old widget resolved the theme padding inside a closure that only
        // read the theme, so a widget style could never change it.
        await tester.pumpWidget(
          _frame(
            scopedTheme: const ChipTheme(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            ),
            child: const Chip(child: Text('padded')),
          ),
        );
        expect(
          _staticPadding(tester),
          const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        );
      },
    );

    testWidgets('the style leg adds rows without losing the metrics', (
      tester,
    ) async {
      const Color custom = Color(0xFF00FF00);
      await tester.pumpWidget(
        _frame(
          scopedTheme: const ChipTheme(
            style: ButtonVariantStyle(
              background: StateValue(rest: ThemedColor.value(custom)),
            ),
          ),
          child: const Chip(child: Text('styled')),
        ),
      );
      expect(_staticDecoration(tester).color, custom);
      expect(_staticPadding(tester), chipDefaultPadding);
      expect(_staticTextStyle(tester).fontSize, 12);
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Chip(child: Text('dark')),
        ),
      );
      expect(_staticDecoration(tester).color, dark.secondary);
      expect(_staticTextStyle(tester).color, dark.secondaryForeground);
    });

    testWidgets('the widget variant overrides the theme variant', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const Chip(
            variant: ButtonVariant.outline,
            child: Text('outline'),
          ),
        ),
      );
      final BoxDecoration box = _staticDecoration(tester);
      expect(box.color!.a, closeTo(0.3, 0.001));
      expect(box.border, Border.all(color: ShadcnColors.lightFallback.input));
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Chip(
            theme: ChipTheme(
              style: ButtonVariantStyle(
                background: StateValue(
                  rest: ThemedColor.ref(ColorRef.secondary, alpha: 0.5),
                ),
              ),
            ),
            child: Text('alpha'),
          ),
        ),
      );
      expect(
        _staticDecoration(tester).color!.a,
        closeTo(dark.secondary.a * 0.5, 0.001),
      );
    });
  });

  group('pressable rows', () {
    testWidgets('a pressable chip resolves the hovered label colour', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: Chip(onPressed: () {}, child: const Text('row')),
        ),
      );
      final ShadcnColors colors = ShadcnColors.lightFallback;
      expect(_rowText(tester).color, colors.secondaryForeground);
      expect(
        _row(tester, const <WidgetState>{WidgetState.hovered}).color,
        _alpha(colors.secondary, 0.8),
      );
    });
  });
}
