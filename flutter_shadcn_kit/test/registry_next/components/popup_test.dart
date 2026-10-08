// Widget tests for the `popup` component: the re-exported MenuPopup surface,
// showShadcnPopup anchoring/dismissal, theme legs, dark tokens and sizes.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/popup/popup.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
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
        child: TapRegionSurface(
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (context) =>
                    ColoredBox(color: const Color(0xFFEEEEEE), child: child),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _trigger(void Function(BuildContext) onHost) {
  return Center(
    child: Builder(
      builder: (context) {
        onHost(context);
        return const SizedBox(width: 120, height: 36);
      },
    ),
  );
}

void main() {
  testWidgets('MenuPopup is the re-exported surface with a 192 minimum', (
    tester,
  ) async {
    const ShadcnThemeData theme = ShadcnThemeData();
    await tester.pumpWidget(
      _frame(const MenuPopup(children: <Widget>[Text('Content')])),
    );
    await tester.pump();
    expect(find.text('Content'), findsOneWidget);
    expect(
      tester.getSize(find.byType(MenuPopup)).width,
      greaterThanOrEqualTo(192),
    );
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

  testWidgets('dark tokens drive the surface', (tester) async {
    const ShadcnThemeData theme = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(const MenuPopup(children: <Widget>[Text('Content')]), data: theme),
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
    expect((surface.decoration! as BoxDecoration).color, theme.colors.popover);
  });

  group('showShadcnPopup', () {
    testWidgets('anchors the content below the trigger', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(_frame(_trigger((c) => host = c)));
      await tester.pump();
      showShadcnPopup<void>(
        context: host,
        builder: (context) =>
            const Padding(padding: EdgeInsets.all(8), child: Text('Signed in')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Signed in'), findsOneWidget);
      final double anchorBottom = tester
          .getBottomLeft(find.byType(SizedBox).first)
          .dy;
      expect(
        tester.getTopLeft(find.byType(MenuPopup)).dy,
        greaterThanOrEqualTo(anchorBottom),
      );
    });

    testWidgets('Escape closes the popup', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(_frame(_trigger((c) => host = c)));
      await tester.pump();
      showShadcnPopup<void>(
        context: host,
        builder: (context) => const Text('Signed in'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Signed in'), findsNothing);
    });

    testWidgets('an outside tap closes the popup', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(_frame(_trigger((c) => host = c)));
      await tester.pump();
      showShadcnPopup<void>(
        context: host,
        builder: (context) => const Text('Signed in'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tapAt(const Offset(600, 500));
      await tester.pumpAndSettle();
      expect(find.text('Signed in'), findsNothing);
    });

    testWidgets('widget theme leg beats the app leg', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          _trigger((c) => host = c),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
        ),
      );
      await tester.pump();
      showShadcnPopup<void>(
        context: host,
        theme: const MenuPopupTheme(background: ThemedColor.value(_green)),
        builder: (context) => const Text('Signed in'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
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

    testWidgets('scoped theme leg beats the app leg', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          ComponentTheme<MenuPopupTheme>(
            data: const MenuPopupTheme(background: ThemedColor.value(_green)),
            child: _trigger((c) => host = c),
          ),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
        ),
      );
      await tester.pump();
      showShadcnPopup<void>(
        context: host,
        builder: (context) => const Text('Signed in'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
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

    testWidgets('app theme leg beats the defaults', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          _trigger((c) => host = c),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      await tester.pump();
      showShadcnPopup<void>(
        context: host,
        builder: (context) => const Text('Signed in'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
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
}
