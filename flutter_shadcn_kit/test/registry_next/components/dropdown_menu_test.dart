// Widget tests for the `dropdown_menu` component: the standalone surface,
// the showShadcnDropdown helper, dismissal, theme legs, sheet padding and
// real sizes (row 32, surface min width 192).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/dropdown_menu/dropdown_menu.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/sheet_overlay.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (context) =>
                  Align(alignment: Alignment.topLeft, child: child),
            ),
          ],
        ),
      ),
    ),
  );
}

DropdownMenu _menu({MenuPopupTheme? theme}) {
  return DropdownMenu(
    theme: theme,
    children: <Widget>[
      MenuButton(child: const Text('Profile'), onPressed: (_) {}),
      MenuButton(child: const Text('Settings'), onPressed: (_) {}),
      const MenuSeparator(),
      MenuButton(child: const Text('Sign out'), onPressed: (_) {}),
    ],
  );
}

void main() {
  testWidgets('renders the rows on a popup surface', (tester) async {
    const ShadcnThemeData theme = ShadcnThemeData();
    await tester.pumpWidget(_frame(_menu()));
    await tester.pump();
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.byType(MenuSeparator), findsOneWidget);
    final Size size = tester.getSize(find.byType(MenuPopup));
    expect(size.width, greaterThanOrEqualTo(192));
    final Container surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(MenuPopup),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((surface.decoration! as BoxDecoration).color, theme.colors.popover);
  });

  testWidgets('rows are 32 high (shadcn h-8)', (tester) async {
    await tester.pumpWidget(_frame(_menu()));
    await tester.pump();
    expect(tester.getSize(find.byType(RovingRow).first).height, 32);
  });

  testWidgets('dark tokens drive the surface', (tester) async {
    const ShadcnThemeData theme = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(_frame(_menu(), data: theme));
    await tester.pump();
    final Container surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(MenuPopup),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((surface.decoration! as BoxDecoration).color, theme.colors.popover);
  });

  group('theme legs', () {
    testWidgets('widget leg beats the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _menu(
            theme: const MenuPopupTheme(background: ThemedColor.value(_green)),
          ),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
        ),
      );
      await tester.pump();
      final Container surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MenuPopup),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((surface.decoration! as BoxDecoration).color, _green);
    });

    testWidgets('scoped leg beats the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          ComponentTheme<MenuPopupTheme>(
            data: const MenuPopupTheme(background: ThemedColor.value(_green)),
            child: _menu(),
          ),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
        ),
      );
      await tester.pump();
      final Container surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MenuPopup),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((surface.decoration! as BoxDecoration).color, _green);
    });

    testWidgets('app leg beats the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          _menu(),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      await tester.pump();
      final Container surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MenuPopup),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((surface.decoration! as BoxDecoration).color, _green);
    });
  });

  testWidgets('inside a sheet overlay the rows keep the sheet gutter', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        Data<SheetOverlayMarker>.inherit(
          data: const SheetOverlayMarker(),
          child: DropdownMenu(children: const <Widget>[Text('x')]),
        ),
      ),
    );
    await tester.pump();
    final MenuGroup group = tester.widget<MenuGroup>(
      find.byType(MenuGroup).first,
    );
    expect(group.itemPadding, const EdgeInsets.symmetric(horizontal: 8));
  });

  testWidgets('the arrow keys walk the rows and Enter activates', (
    tester,
  ) async {
    bool pressed = false;
    await tester.pumpWidget(
      _frame(
        DropdownMenu(
          children: <Widget>[
            MenuButton(child: const Text('Profile'), onPressed: (_) {}),
            MenuButton(
              child: const Text('Settings'),
              onPressed: (_) => pressed = true,
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    final Focus scope = tester.widget<Focus>(
      find
          .descendant(of: find.byType(MenuGroup), matching: find.byType(Focus))
          .first,
    );
    scope.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(pressed, isTrue);
  });

  group('showShadcnDropdown', () {
    testWidgets('opens anchored and closes on Escape', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (context) {
              host = context;
              return const SizedBox(width: 120, height: 36);
            },
          ),
        ),
      );
      await tester.pump();
      final opened = showShadcnDropdown<void>(
        context: host,
        children: <Widget>[
          MenuButton(child: const Text('Profile'), onPressed: (_) {}),
        ],
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Profile'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsNothing);
      await opened;
    });

    testWidgets('pressing a row runs it and closes the menu', (tester) async {
      bool picked = false;
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (context) {
              host = context;
              return const SizedBox(width: 120, height: 36);
            },
          ),
        ),
      );
      await tester.pump();
      final opened = showShadcnDropdown<void>(
        context: host,
        children: <Widget>[
          MenuButton(
            child: const Text('Profile'),
            onPressed: (_) => picked = true,
          ),
        ],
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(picked, isTrue);
      expect(find.text('Profile'), findsNothing);
      await opened;
    });
  });
}
