// Widget tests for the `group` component.
//
// Covers absolute placement, edge pinning, `fill`, `fromRect`, hit-test order
// and the old regression: an unbounded group crashed because it sized itself
// from `constraints.biggest`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/group/group.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({required Widget child, Size size = const Size(200, 120)}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: SizedBox.fromSize(size: size, child: child),
    ),
  );
}

void main() {
  testWidgets('places a child at its explicit offset', (tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      _frame(
        child: Group(
          children: <Widget>[
            GroupPositioned(
              top: 10,
              left: 20,
              child: SizedBox(key: key, width: 30, height: 20),
            ),
          ],
        ),
      ),
    );
    final Offset origin = tester.getTopLeft(find.byType(Group));
    expect(tester.getTopLeft(find.byKey(key)) - origin, const Offset(20, 10));
  });

  testWidgets('pins children to the trailing and bottom edges', (tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      _frame(
        child: Group(
          children: <Widget>[
            GroupPositioned(
              right: 12,
              bottom: 8,
              child: SizedBox(key: key, width: 30, height: 20),
            ),
          ],
        ),
      ),
    );
    final Offset origin = tester.getTopLeft(find.byType(Group));
    expect(tester.getTopLeft(find.byKey(key)) - origin, const Offset(158, 92));
  });

  testWidgets('fill stretches a child across the group', (tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      _frame(
        child: Group(
          children: <Widget>[
            GroupPositioned.fill(child: SizedBox.expand(key: key)),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byKey(key)), const Size(200, 120));
  });

  testWidgets('fromRect places and sizes a child', (tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      _frame(
        child: Group(
          children: <Widget>[
            GroupPositioned.fromRect(
              rect: const Rect.fromLTWH(30, 40, 50, 25),
              child: SizedBox(key: key),
            ),
          ],
        ),
      ),
    );
    final Offset origin = tester.getTopLeft(find.byType(Group));
    expect(tester.getTopLeft(find.byKey(key)) - origin, const Offset(30, 40));
    expect(tester.getSize(find.byKey(key)), const Size(50, 25));
  });

  testWidgets('hit testing prefers the last (topmost) child', (tester) async {
    int backTaps = 0;
    int frontTaps = 0;
    await tester.pumpWidget(
      _frame(
        child: Group(
          children: <Widget>[
            GroupPositioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => backTaps++,
                child: const SizedBox.expand(),
              ),
            ),
            GroupPositioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => frontTaps++,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byType(Group));
    expect(frontTaps, 1);
    expect(backTaps, 0);
  });

  testWidgets('regression: an unbounded group does not crash', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          child: Group(
            children: <Widget>[
              GroupPositioned(
                left: 4,
                bottom: 4,
                child: const SizedBox(width: 40, height: 30),
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(Group), findsOneWidget);
  });
}
