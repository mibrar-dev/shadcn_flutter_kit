// Widget tests for the `overlap_layout` primitive.
//
// Covers: corner geometry (badge hangs over the edge, kept `gap` from the
// corners), the side alignment of the union, widening the primary child when
// the overlap is wider, hit tests following the painted offsets, and
// intrinsic queries (IntrinsicHeight).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlap_layout.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: child),
  );
}

void main() {
  testWidgets('bottomRight: badge hangs off the bottom, union aligns right', (
    tester,
  ) async {
    final Key base = UniqueKey();
    final Key badge = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 200,
          child: OverlapLayout(
            corner: OverlapCorner.bottomRight,
            alignment: Alignment.centerRight,
            gap: 8,
            extraWidth: 8,
            child: SizedBox(key: base, width: 100, height: 40),
            overlap: SizedBox(key: badge, width: 60, height: 20),
          ),
        ),
      ),
    );
    final Rect baseRect = tester.getRect(find.byKey(base));
    final Rect badgeRect = tester.getRect(find.byKey(badge));
    expect(baseRect.width, 100);
    // The union is pushed against the right edge of the row.
    final Rect boxRect = tester.getRect(find.byType(OverlapLayout));
    expect(baseRect.right, boxRect.right);
    // The badge sits `gap` inside both right/bottom edges of the child…
    expect(badgeRect.right, closeTo(baseRect.right - 8, 0.01));
    expect(badgeRect.top, closeTo(baseRect.bottom - 8, 0.01));
    // …and protrudes below it, growing the box to the union height.
    expect(badgeRect.bottom, greaterThan(baseRect.bottom));
    expect(tester.getSize(find.byType(OverlapLayout)).height, 52);
  });

  testWidgets('topLeft: badge hangs above the child', (tester) async {
    final Key base = UniqueKey();
    final Key badge = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 200,
          child: OverlapLayout(
            corner: OverlapCorner.topLeft,
            alignment: Alignment.centerLeft,
            gap: 8,
            extraWidth: 8,
            child: SizedBox(key: base, width: 100, height: 40),
            overlap: SizedBox(key: badge, width: 60, height: 20),
          ),
        ),
      ),
    );
    final Rect baseRect = tester.getRect(find.byKey(base));
    final Rect badgeRect = tester.getRect(find.byKey(badge));
    final Rect boxRect = tester.getRect(find.byType(OverlapLayout));
    expect(baseRect.left, boxRect.left);
    expect(badgeRect.left, closeTo(baseRect.left + 8, 0.01));
    expect(badgeRect.bottom, closeTo(baseRect.top + 8, 0.01));
    expect(badgeRect.top, lessThan(baseRect.top));
  });

  testWidgets('widens the primary child when the overlap is wider', (
    tester,
  ) async {
    final Key base = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 200,
          child: OverlapLayout(
            corner: OverlapCorner.bottomRight,
            alignment: Alignment.centerRight,
            gap: 8,
            extraWidth: 10,
            child: SizedBox(key: base, width: 40, height: 40),
            overlap: const SizedBox(width: 80, height: 20),
          ),
        ),
      ),
    );
    // 80 + extraWidth 10 beats the natural 40.
    expect(tester.getRect(find.byKey(base)).width, 90);
  });

  testWidgets('hit tests follow the painted offsets', (tester) async {
    bool tapped = false;
    final Key badge = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 200,
          child: OverlapLayout(
            corner: OverlapCorner.bottomRight,
            alignment: Alignment.centerRight,
            gap: 8,
            extraWidth: 8,
            child: const SizedBox(width: 100, height: 40),
            overlap: GestureDetector(
              key: badge,
              behavior: HitTestBehavior.opaque,
              onTap: () => tapped = true,
              child: const SizedBox(width: 60, height: 20),
            ),
          ),
        ),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byKey(badge)));
    expect(tapped, isTrue);
  });

  testWidgets('answers intrinsic queries (IntrinsicHeight)', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: IntrinsicHeight(
          child: OverlapLayout(
            corner: OverlapCorner.bottomRight,
            alignment: Alignment.centerRight,
            gap: 8,
            extraWidth: 8,
            child: const SizedBox(width: 100, height: 40),
            overlap: const SizedBox(width: 60, height: 20),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    // 40 + (20 - 8) protrusion.
    expect(tester.getSize(find.byType(OverlapLayout)).height, 52);
  });
}
