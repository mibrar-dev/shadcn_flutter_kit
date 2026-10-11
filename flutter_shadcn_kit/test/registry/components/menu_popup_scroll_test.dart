// Widget tests for the popup surface bounds: capped height with its own
// scroll area, no intrinsic queries (a `LayoutBuilder` child such as the
// registry `Slider` must not throw), and keyboard focus scrolling.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/components/slider/slider.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

Widget _frame(Widget child) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: TapRegionSurface(
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (context) => Center(child: child)),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('a LayoutBuilder child records no framework errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        MenuPopup(
          children: <Widget>[
            const Text('Pick a radius'),
            Slider(value: 8, min: 0, max: 16, onChanged: (_) {}),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Slider), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tall content caps at maxHeight and scrolls', (tester) async {
    await tester.pumpWidget(
      _frame(
        MenuPopup(
          children: <Widget>[
            for (var i = 0; i < 40; i++)
              SizedBox(height: 30, child: Text('row $i')),
          ],
        ),
      ),
    );
    await tester.pump();
    final double height = tester.getSize(find.byType(MenuPopup)).height;
    expect(height, lessThanOrEqualTo(360));
    expect(height, greaterThan(300));
    final SingleChildScrollView scroll = tester.widget<SingleChildScrollView>(
      find.descendant(
        of: find.byType(MenuPopup),
        matching: find.byType(SingleChildScrollView),
      ),
    );
    expect(scroll.controller, isNull);
    await tester.drag(
      find
          .descendant(
            of: find.byType(MenuPopup),
            matching: find.byType(SingleChildScrollView),
          )
          .first,
      const Offset(0, -200),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard focus scrolls the focused row into view', (
    tester,
  ) async {
    final List<FocusNode> nodes = <FocusNode>[
      for (var i = 0; i < 30; i++) FocusNode(debugLabel: 'row $i'),
    ];
    addTearDown(() {
      for (final node in nodes) {
        node.dispose();
      }
    });
    await tester.pumpWidget(
      _frame(
        MenuPopup(
          children: <Widget>[
            MenuGroup(
              autofocus: false,
              children: <Widget>[
                for (var i = 0; i < 30; i++)
                  MenuButton(
                    focusNode: nodes[i],
                    onPressed: (_) {},
                    child: Text('row $i'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    nodes.last.requestFocus();
    // The row reveals itself through two chained post-frame callbacks
    // (focus notification, then the scrollable's own reveal), so settle.
    await tester.pumpAndSettle();
    final Rect surface = tester.getRect(find.byType(MenuPopup));
    final Rect last = tester.getRect(find.text('row 29'));
    expect(last.bottom, lessThanOrEqualTo(surface.bottom + 1));
    expect(last.top, greaterThanOrEqualTo(surface.top - 1));
    expect(tester.takeException(), isNull);
  });
}
