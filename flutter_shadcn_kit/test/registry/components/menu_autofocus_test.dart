// MenuGroup autofocus: inline surfaces never steal focus; overlays opt in.
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/dropdown_menu/dropdown_menu.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(Widget child) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: ComponentThemes(
      themes: const <ComponentThemeData>[],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (BuildContext context) => child),
          ],
        ),
      ),
    ),
  );
}

Widget _rows({bool? autofocus}) {
  return MenuGroup(
    autofocus: autofocus ?? false,
    children: <Widget>[
      MenuButton(onPressed: (_) {}, child: const Text('Apple')),
      MenuButton(onPressed: (_) {}, child: const Text('Banana')),
    ],
  );
}

Widget _defaultRows() {
  return MenuGroup(
    children: <Widget>[
      MenuButton(onPressed: _noop, child: const Text('Apple')),
      MenuButton(onPressed: _noop, child: const Text('Banana')),
    ],
  );
}

void _noop(BuildContext context) {}

void main() {
  testWidgets('MenuGroup does not autofocus by default', (tester) async {
    await tester.pumpWidget(_frame(_defaultRows()));
    await tester.pump();
    expect(
      tester.binding.focusManager.primaryFocus?.debugLabel,
      isNot('RovingGroup'),
      reason: 'inline menu must not steal initial focus',
    );
    final MenuGroup group = tester.widget<MenuGroup>(find.byType(MenuGroup));
    expect(group.autofocus, isFalse);
  });

  testWidgets('MenuGroup with autofocus true takes focus', (tester) async {
    await tester.pumpWidget(_frame(_rows(autofocus: true)));
    await tester.pump();
    expect(tester.binding.focusManager.primaryFocus?.debugLabel, 'RovingGroup');
  });

  testWidgets('keyboard nav works once the group is focused', (tester) async {
    final FocusNode a = FocusNode(debugLabel: 'a');
    final FocusNode b = FocusNode(debugLabel: 'b');
    addTearDown(a.dispose);
    addTearDown(b.dispose);
    await tester.pumpWidget(
      _frame(
        MenuGroup(
          children: <Widget>[
            MenuButton(
              focusNode: a,
              onPressed: (_) {},
              child: const Text('Apple'),
            ),
            MenuButton(
              focusNode: b,
              onPressed: (_) {},
              child: const Text('Banana'),
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(a.hasFocus, isFalse);
    expect(b.hasFocus, isFalse);
    a.requestFocus();
    await tester.pump();
    expect(a.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(b.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(a.hasFocus, isTrue);
  });

  testWidgets('DropdownMenu does not autofocus by default', (tester) async {
    await tester.pumpWidget(
      _frame(
        const DropdownMenu(
          children: <Widget>[
            MenuButton(onPressed: _noop, child: Text('Profile')),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(
      tester.binding.focusManager.primaryFocus?.debugLabel,
      isNot('RovingGroup'),
    );
    final DropdownMenu menu = tester.widget<DropdownMenu>(
      find.byType(DropdownMenu),
    );
    expect(menu.autofocus, isFalse);
  });

  testWidgets('DropdownMenu with autofocus true takes focus', (tester) async {
    await tester.pumpWidget(
      _frame(
        const DropdownMenu(
          autofocus: true,
          children: <Widget>[
            MenuButton(onPressed: _noop, child: Text('Profile')),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(tester.binding.focusManager.primaryFocus?.debugLabel, 'RovingGroup');
  });
}
