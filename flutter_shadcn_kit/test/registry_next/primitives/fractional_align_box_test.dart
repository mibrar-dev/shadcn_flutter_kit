// Widget tests for the `fractional_align_box` primitive.
//
// Covers: the width factor as a cap (not a fixed size), side alignment,
// unbounded incoming widths, and the reason this primitive exists — intrinsic
// queries (`IntrinsicWidth`/`IntrinsicHeight`) answer instead of throwing.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/fractional_align_box.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return Directionality(
    textDirection: textDirection,
    child: Center(child: child),
  );
}

void main() {
  testWidgets('caps the child at `factor` of the incoming width', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: const FractionalAlignBox(
            factor: 0.5,
            alignment: Alignment.centerLeft,
            child: SizedBox(width: 300, height: 20),
          ),
        ),
      ),
    );
    // The box is the row; the child inside is capped at 200.
    final Rect box = tester.getRect(find.byType(FractionalAlignBox));
    expect(box.width, 400);
    final Rect inner = tester.getRect(
      find.descendant(
        of: find.byType(FractionalAlignBox),
        matching: find.byType(SizedBox).last,
      ),
    );
    expect(inner.width, 200);
    expect(inner.left, box.left);
  });

  testWidgets('a child below the cap keeps its size and aligns to the side', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: const FractionalAlignBox(
            factor: 0.5,
            alignment: Alignment.centerRight,
            child: SizedBox(width: 120, height: 20),
          ),
        ),
      ),
    );
    final Rect box = tester.getRect(find.byType(FractionalAlignBox));
    final Rect inner = tester.getRect(
      find.descendant(
        of: find.byType(FractionalAlignBox),
        matching: find.byType(SizedBox).last,
      ),
    );
    expect(inner.width, 120);
    expect(inner.right, box.right);
  });

  testWidgets('a non-finite incoming width ignores the factor', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: UnconstrainedBox(
          child: const FractionalAlignBox(
            factor: 0.5,
            alignment: Alignment.centerLeft,
            child: SizedBox(width: 300, height: 20),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final Size inner = tester.getSize(
      find.descendant(
        of: find.byType(FractionalAlignBox),
        matching: find.byType(SizedBox).last,
      ),
    );
    expect(inner.width, 300);
  });

  testWidgets('answers intrinsic queries (IntrinsicWidth / IntrinsicHeight)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: const FractionalAlignBox(
              factor: 0.5,
              alignment: Alignment.centerLeft,
              child: SizedBox(width: 140, height: 30),
            ),
          ),
        ),
      ),
    );
    // A LayoutBuilder here would throw "does not support returning intrinsic
    // dimensions"; the render box forwards them instead.
    expect(tester.takeException(), isNull);
    final Size size = tester.getSize(find.byType(FractionalAlignBox));
    expect(size.width, 140);
    expect(size.height, 30);
  });

  testWidgets('RTL resolves the alignment against the direction', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 400,
          child: const FractionalAlignBox(
            factor: 0.5,
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(width: 100, height: 20),
          ),
        ),
      ),
    );
    final Rect box = tester.getRect(find.byType(FractionalAlignBox));
    final Rect inner = tester.getRect(
      find.descendant(
        of: find.byType(FractionalAlignBox),
        matching: find.byType(SizedBox).last,
      ),
    );
    // centerStart is the right edge in RTL.
    expect(inner.left, box.right - 100);
  });
}
