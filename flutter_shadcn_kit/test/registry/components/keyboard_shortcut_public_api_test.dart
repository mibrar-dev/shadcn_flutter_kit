// Constructor-surface test for `keyboard_shortcut`, from OUTSIDE the library.
//
// The component's two constructors take private named field formals
// (`this._keys`, `this._activator`) but the *call sites* outside
// `keyboard_shortcut.dart` must use the public names `keys` / `activator`, and
// the private fields must stay unreachable. Both halves are proven here: every
// invocation below compiles against the exported names only, and the
// unreachability half is enforced by the compiler (an outside library cannot
// name `_keys` / `_activator`, so no runtime assertion could express it).
//
// The rest of the component's behaviour lives in `keyboard_shortcut_test.dart`.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/keyboard_shortcut/keyboard_shortcut.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in the theme the caps resolve their colours from.
Widget _frame(Widget child) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );
}

void main() {
  group('public constructor names', () {
    testWidgets('KeyboardShortcut(keys: …) constructs a chord', (tester) async {
      const KeyboardShortcut chord = KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyK,
        ],
      );
      await tester.pumpWidget(_frame(chord));
      expect(find.byKey(keyboardKeyCapKey), findsNWidgets(2));
      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
    });

    testWidgets('KeyboardShortcut.fromActivator(activator: …) constructs one', (
      tester,
    ) async {
      const KeyboardShortcut chord = KeyboardShortcut.fromActivator(
        activator: SingleActivator(LogicalKeyboardKey.keyK, meta: true),
      );
      await tester.pumpWidget(_frame(chord));
      // Modifiers come first, so ⌘ precedes K.
      expect(
        tester.getRect(find.text('\u2318')).left,
        lessThan(tester.getRect(find.text('K')).left),
      );
    });

    testWidgets('the other public named parameters still resolve', (
      tester,
    ) async {
      const KeyboardShortcut chord = KeyboardShortcut(
        keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyA],
        spacing: 12,
        theme: KeyboardShortcutTheme(spacing: 12),
      );
      await tester.pumpWidget(_frame(chord));
      expect(find.byKey(keyboardKeyCapKey), findsOneWidget);
    });

    testWidgets('KeyboardKeyCap(keyboardKey: …) constructs a cap', (
      tester,
    ) async {
      const KeyboardKeyCap cap = KeyboardKeyCap(
        keyboardKey: LogicalKeyboardKey.keyQ,
        padding: EdgeInsets.all(2),
        background: ThemedColor.value(Color(0xFF00FF00)),
        foreground: ThemedColor.value(Color(0xFF0000FF)),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      );
      await tester.pumpWidget(_frame(cap));
      expect(find.text('Q'), findsOneWidget);
    });

    testWidgets('const construction drives the shared lookup keys', (
      tester,
    ) async {
      // `keyboardShortcutKey` / `keyboardKeyCapKey` are part of the public
      // surface an outside test relies on to find the chord and its caps.
      const KeyboardShortcut chord = KeyboardShortcut(
        keys: <LogicalKeyboardKey>[LogicalKeyboardKey.keyA],
      );
      await tester.pumpWidget(_frame(chord));
      expect(find.byKey(keyboardShortcutKey), findsOneWidget);
    });
  });
}
