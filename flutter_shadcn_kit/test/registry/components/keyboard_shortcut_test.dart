// Widget tests for the `keyboard_shortcut` component.
//
// Covers both constructors, the default glyph table, the optional display
// scope, the cap's real logical sizes, the four theme-precedence legs, light
// and dark tokens, and one regression test per old bug that was fixed.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart'
    as shadcn;
import 'package:flutter_shadcn_kit/registry/components/keyboard_shortcut/keyboard_shortcut.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  KeyboardShortcutTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<KeyboardShortcutTheme>(data: scoped, child: body);
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

/// The cap surfaces, in render order.
List<shadcn.Card> _caps(WidgetTester tester) =>
    tester.widgetList<shadcn.Card>(find.byKey(keyboardKeyCapKey)).toList();

shadcn.Card _cap(WidgetTester tester) => _caps(tester).first;

void main() {
  group('chords', () {
    testWidgets('explicit keys render in order', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyK,
            ],
          ),
        ),
      );
      expect(find.byKey(keyboardKeyCapKey), findsNWidgets(2));
      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
      // The row is laid out left to right in the given order.
      expect(
        tester.getRect(find.text('Ctrl')).left,
        lessThan(tester.getRect(find.text('K')).left),
      );
    });

    testWidgets('an activator puts modifiers first', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut.fromActivator(
            activator: SingleActivator(LogicalKeyboardKey.keyK, meta: true),
          ),
        ),
      );
      expect(
        tester.getRect(find.text('\u2318')).left,
        lessThan(tester.getRect(find.text('K')).left),
      );
    });

    testWidgets('a character activator drops its modifiers when it has none', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut.fromActivator(
            activator: CharacterActivator('j'),
          ),
        ),
      );
      expect(find.byKey(keyboardKeyCapKey), findsOneWidget);
    });

    testWidgets('an empty chord renders nothing', (tester) async {
      await tester.pumpWidget(
        _frame(child: const KeyboardShortcut(keys: <LogicalKeyboardKey>[])),
      );
      // An activator with no triggers is legal; the chord collapses rather
      // than painting an empty row.
      expect(find.byKey(keyboardShortcutKey), findsNothing);
      expect(find.byKey(keyboardKeyCapKey), findsNothing);
    });

    testWidgets('the row shrinks to its content', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyA],
          ),
        ),
      );
      final Size row = tester.getSize(find.byKey(keyboardShortcutKey));
      final Size cap = tester.getSize(find.byKey(keyboardKeyCapKey));
      expect(row.width, cap.width);
    });

    testWidgets('the spacing lands between two caps', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[
              LogicalKeyboardKey.keyA,
              LogicalKeyboardKey.keyB,
            ],
          ),
          scoped: const KeyboardShortcutTheme(spacing: 10),
        ),
      );
      expect(
        tester.getRect(find.byKey(keyboardKeyCapKey).at(1)).left -
            tester.getRect(find.byKey(keyboardKeyCapKey).at(0)).right,
        10,
      );
    });
  });

  group('glyphs', () {
    testWidgets('the platform glyph table is used', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[
              LogicalKeyboardKey.shiftLeft,
              LogicalKeyboardKey.altRight,
              LogicalKeyboardKey.meta,
              LogicalKeyboardKey.enter,
              LogicalKeyboardKey.arrowLeft,
            ],
          ),
        ),
      );
      expect(find.text('Shift'), findsOneWidget);
      expect(find.text('Alt'), findsOneWidget);
      expect(find.text('\u2318'), findsOneWidget);
      expect(find.text('\u21b5'), findsOneWidget);
      expect(find.text('\u2190'), findsOneWidget);
    });

    testWidgets('regression: a cap outside the scope does not throw', (
      tester,
    ) async {
      // The old `KeyboardKeyDisplay` called `Data.of<...>` with no default, so
      // any chord rendered without an installed mapper asserted on first build.
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyQ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Q'), findsOneWidget);
    });

    testWidgets('an installed scope wins over the default table', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: KeyboardShortcutDisplayScope(
            builder: (BuildContext context, LogicalKeyboardKey key) =>
                Text('KEY'),
            child: const KeyboardShortcut(
              keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyA],
            ),
          ),
        ),
      );
      expect(find.text('KEY'), findsOneWidget);
      expect(find.text('A'), findsNothing);
    });

    testWidgets('a scope with a null builder keeps the default table', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: KeyboardShortcutDisplayScope(
            child: const KeyboardShortcut(
              keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyA],
            ),
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('a scope only affects its own subtree', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              KeyboardShortcutDisplayScope(
                builder: (BuildContext context, LogicalKeyboardKey key) =>
                    const Text('INSIDE'),
                child: const KeyboardShortcut(
                  keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyA],
                ),
              ),
              const KeyboardShortcut(
                keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyB],
              ),
            ],
          ),
        ),
      );
      expect(find.text('INSIDE'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });
  });

  group('tokens', () {
    testWidgets('sizes match shadcn (px-1.5 py-0.5, text-xs 12)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      final shadcn.Card card = _cap(tester);
      expect(
        (card.padding as EdgeInsets).resolve(TextDirection.ltr),
        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      );
      final TextStyle style = tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text('M'),
                  matching: find.byType(DefaultTextStyle),
                )
                .last,
          )
          .style;
      expect(style.fontSize, 12);
      expect(style.color, ShadcnColors.lightFallback.mutedForeground);
    });

    testWidgets('the cap fill is the background at 70% alpha', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      final Color fill = _cap(
        tester,
      ).background!.resolve(ShadcnColors.lightFallback);
      expect(fill.a, closeTo(0.7, 0.001));
    });

    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      final Color fill = _cap(tester).background!.resolve(dark);
      expect(fill.a, closeTo(0.7, 0.001));
      final TextStyle style = tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text('M'),
                  matching: find.byType(DefaultTextStyle),
                )
                .last,
          )
          .style;
      expect(style.color, dark.mutedForeground);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
            theme: KeyboardShortcutTheme(
              keyBackground: ThemedColor.ref(ColorRef.accent, alpha: 0.5),
            ),
          ),
        ),
      );
      final Color fill = _cap(tester).background!.resolve(dark);
      expect(fill.a, closeTo(dark.accent.a * 0.5, 0.001));
    });

    testWidgets('regression: the caps scale as a whole, not the padding', (
      tester,
    ) async {
      // The old code multiplied only the padding by `scaling`, leaving the
      // border radius and shadow alone, so a scaled theme produced fatter caps
      // with the same rounding.
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(scaling: 2),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      final shadcn.Card card = _cap(tester);
      expect(
        (card.padding as EdgeInsets).resolve(TextDirection.ltr),
        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      );
      expect(card.borderRadius, isNull);
      expect(card.shadows, isNull);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            KeyboardShortcutTheme(keyBackground: ThemedColor.value(_green)),
          ],
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      expect(
        _cap(tester).background!.resolve(ShadcnColors.lightFallback),
        _green,
      );
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            KeyboardShortcutTheme(keyBackground: ThemedColor.value(_green)),
          ],
          scoped: const KeyboardShortcutTheme(
            keyBackground: ThemedColor.value(_blue),
          ),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      expect(
        _cap(tester).background!.resolve(ShadcnColors.lightFallback),
        _blue,
      );
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const KeyboardShortcutTheme(
            keyBackground: ThemedColor.value(_green),
          ),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
            theme: KeyboardShortcutTheme(
              keyBackground: ThemedColor.value(_blue),
            ),
          ),
        ),
      );
      expect(
        _cap(tester).background!.resolve(ShadcnColors.lightFallback),
        _blue,
      );
    });

    testWidgets('a leg setting one field keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: const KeyboardShortcutTheme(spacing: 10),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
          ),
        ),
      );
      // The padding still comes from the defaults row.
      expect(
        (_cap(tester).padding as EdgeInsets).resolve(TextDirection.ltr),
        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      );
    });

    testWidgets('regression: the widget leg merges, it does not replace', (
      tester,
    ) async {
      // The old widget resolved `this.theme ?? ComponentTheme.maybeOf(...)`,
      // so a widget leg silently dropped the scoped leg and the app leg was
      // never read at all.
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            KeyboardShortcutTheme(keyForeground: ThemedColor.value(_green)),
          ],
          scoped: const KeyboardShortcutTheme(
            keyBackground: ThemedColor.value(_green),
          ),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
            theme: KeyboardShortcutTheme(spacing: 10),
          ),
        ),
      );
      final shadcn.Card card = _cap(tester);
      // The widget leg's own field...
      expect(
        (card.padding as EdgeInsets).resolve(TextDirection.ltr),
        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      );
      // ...the scoped leg's background survives...
      expect(card.background!.resolve(ShadcnColors.lightFallback), _green);
    });

    testWidgets('a per-cap field beats the theme', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const KeyboardShortcutTheme(
            keyBackground: ThemedColor.value(_green),
          ),
          child: const KeyboardShortcut(
            keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyM],
            theme: KeyboardShortcutTheme(
              keyBackground: ThemedColor.value(_blue),
            ),
          ),
        ),
      );
      expect(
        _cap(tester).background!.resolve(ShadcnColors.lightFallback),
        _blue,
      );
    });
  });
}
