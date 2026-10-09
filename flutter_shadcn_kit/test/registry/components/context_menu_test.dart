// Widget tests for the `context_menu` component: secondary-click and
// long-press opening, pointer positioning, item activation, Escape,
// disabled/theme legs, keyboard traversal and real sizes (row 32).

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/context_menu/context_menu.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
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
        child: TapRegionSurface(
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(builder: (context) => child),
            ],
          ),
        ),
      ),
    ),
  );
}

ContextMenu _wrapped({bool enabled = true, MenuPopupTheme? popupTheme}) {
  return ContextMenu(
    enabled: enabled,
    popupTheme: popupTheme,
    items: <Widget>[
      MenuButton(child: const Text('Copy link'), onPressed: (_) {}),
      MenuButton(child: const Text('Reload'), onPressed: (_) {}),
    ],
    child: const ColoredBox(
      color: Color(0xFFEEEEEE),
      child: SizedBox(width: 600, height: 400),
    ),
  );
}

Future<void> _openAt(WidgetTester tester, Offset at) async {
  await tester.tapAt(at, buttons: kSecondaryMouseButton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('a secondary click opens the menu at the pointer', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_wrapped()));
    await tester.pump();
    expect(find.text('Copy link'), findsNothing);
    const Offset at = Offset(150, 120);
    await _openAt(tester, at);
    expect(find.text('Copy link'), findsOneWidget);
    final Offset topLeft = tester.getTopLeft(find.byType(MenuPopup));
    expect(topLeft.dx, greaterThan(at.dx));
    expect(topLeft.dy, closeTo(at.dy, 1));
  });

  testWidgets('an item press runs it and closes the menu', (tester) async {
    bool picked = false;
    await tester.pumpWidget(
      _frame(
        ContextMenu(
          items: <Widget>[
            MenuButton(
              child: const Text('Reload'),
              onPressed: (_) => picked = true,
            ),
          ],
          child: const ColoredBox(
            color: Color(0xFFEEEEEE),
            child: SizedBox(width: 600, height: 400),
          ),
        ),
      ),
    );
    await tester.pump();
    await _openAt(tester, const Offset(100, 100));
    await tester.tap(find.text('Reload'));
    await tester.pumpAndSettle();
    expect(picked, isTrue);
    expect(find.text('Reload'), findsNothing);
  });

  testWidgets('Escape closes the menu', (tester) async {
    await tester.pumpWidget(_frame(_wrapped()));
    await tester.pump();
    await _openAt(tester, const Offset(100, 100));
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Copy link'), findsNothing);
  });

  testWidgets('a tap outside closes the menu', (tester) async {
    await tester.pumpWidget(_frame(_wrapped()));
    await tester.pump();
    await _openAt(tester, const Offset(100, 100));
    await tester.tapAt(const Offset(550, 380));
    await tester.pumpAndSettle();
    expect(find.text('Copy link'), findsNothing);
  });

  testWidgets('disabled menus never open', (tester) async {
    await tester.pumpWidget(_frame(_wrapped(enabled: false)));
    await tester.pump();
    await _openAt(tester, const Offset(100, 100));
    expect(find.text('Copy link'), findsNothing);
  });

  testWidgets('touch platforms open on long-press too', (tester) async {
    await tester.pumpWidget(
      _frame(
        _wrapped(),
        data: const ShadcnThemeData(platform: TargetPlatform.android),
      ),
    );
    await tester.pump();
    await tester.longPressAt(const Offset(120, 120));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Copy link'), findsOneWidget);
  });

  testWidgets('desktop platforms do not open on long-press', (tester) async {
    await tester.pumpWidget(
      _frame(
        _wrapped(),
        data: const ShadcnThemeData(platform: TargetPlatform.macOS),
      ),
    );
    await tester.pump();
    await tester.longPressAt(const Offset(120, 120));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Copy link'), findsNothing);
  });

  testWidgets('rows are 32 high and the surface uses the popover token', (
    tester,
  ) async {
    const ShadcnThemeData theme = ShadcnThemeData();
    await tester.pumpWidget(_frame(_wrapped(), data: theme));
    await tester.pump();
    await _openAt(tester, const Offset(100, 100));
    expect(tester.getSize(find.byType(RovingRow).first).height, 32);
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

  group('theme legs', () {
    testWidgets('popupTheme beats the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _wrapped(
            popupTheme: const MenuPopupTheme(
              background: ThemedColor.value(_green),
            ),
          ),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
        ),
      );
      await tester.pump();
      await _openAt(tester, const Offset(100, 100));
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
            child: _wrapped(),
          ),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
        ),
      );
      await tester.pump();
      await _openAt(tester, const Offset(100, 100));
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
          _wrapped(),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      await tester.pump();
      await _openAt(tester, const Offset(100, 100));
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

    testWidgets('a caller row theme still wins over the padding default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ContextMenu(
            theme: const MenuTheme(
              itemPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
            items: <Widget>[
              MenuButton(child: const Text('Reload'), onPressed: (_) {}),
            ],
            child: const ColoredBox(
              color: Color(0xFFEEEEEE),
              child: SizedBox(width: 600, height: 400),
            ),
          ),
        ),
      );
      await tester.pump();
      await _openAt(tester, const Offset(100, 100));
      // The caller's row theme reaches the primitive: the row resolves its
      // padding from it (the 32px minimum stays the floor until the padding
      // and content exceed it).
      final RovingRow row = tester.widget<RovingRow>(
        find.byType(RovingRow).first,
      );
      expect(
        row.padding,
        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      );
    });
  });

  testWidgets('the arrow keys walk the rows and Enter activates', (
    tester,
  ) async {
    bool picked = false;
    await tester.pumpWidget(
      _frame(
        ContextMenu(
          items: <Widget>[
            MenuButton(child: const Text('Back'), onPressed: (_) {}),
            MenuButton(
              child: const Text('Reload'),
              onPressed: (_) => picked = true,
            ),
          ],
          child: const ColoredBox(
            color: Color(0xFFEEEEEE),
            child: SizedBox(width: 600, height: 400),
          ),
        ),
      ),
    );
    await tester.pump();
    await _openAt(tester, const Offset(100, 100));
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
    await tester.pumpAndSettle();
    expect(picked, isTrue);
  });
}
