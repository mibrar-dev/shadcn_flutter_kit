import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/keyboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shortcutActivatorToKeySet expands single activators', () {
    final keys = shortcutActivatorToKeySet(
      const SingleActivator(
        LogicalKeyboardKey.keyS,
        control: true,
        shift: true,
      ),
    );
    expect(keys, [
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.shift,
      LogicalKeyboardKey.keyS,
    ]);
  });

  test('shortcutActivatorToKeySet expands character activators', () {
    final keys = shortcutActivatorToKeySet(
      const CharacterActivator('a', alt: true),
    );
    expect(keys, [LogicalKeyboardKey.alt, LogicalKeyboardKey.keyA]);
  });

  test('shortcutActivatorToKeySet expands logical key sets', () {
    final keys = shortcutActivatorToKeySet(
      LogicalKeySet(LogicalKeyboardKey.keyA, LogicalKeyboardKey.keyK),
    );
    expect(keys, [LogicalKeyboardKey.keyA, LogicalKeyboardKey.keyK]);
  });

  test('logical key set triggers keep Flutter modifier expansion', () {
    final keys = shortcutActivatorToKeySet(
      LogicalKeySet(LogicalKeyboardKey.meta),
    );
    expect(
      keys,
      containsAll([LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight]),
    );
  });

  testWidgets('KeyboardShortcutDisplayHandle builds through its builder', (
    tester,
  ) async {
    late Widget display;
    final handle = KeyboardShortcutDisplayHandle(
      (context, key) => Text(key.keyLabel),
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            display = handle.buildKeyboardDisplay(
              context,
              LogicalKeyboardKey.keyA,
            );
            return display;
          },
        ),
      ),
    );
    expect(find.text('A'), findsOneWidget);
  });
}
