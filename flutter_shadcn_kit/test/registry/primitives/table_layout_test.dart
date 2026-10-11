import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/table_layout/table_cells.dart';
import 'package:flutter_shadcn_kit/registry/primitives/table_layout/table_layout.dart';
import 'package:flutter_shadcn_kit/registry/primitives/table_layout/table_resize_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _Cell implements TableCellPosition {
  const _Cell(this.column, this.row, this.columnSpan, this.rowSpan);

  @override
  final int column;
  @override
  final int row;
  @override
  final int columnSpan;
  @override
  final int rowSpan;

  @override
  _Cell shift(int column, int row) =>
      _Cell(this.column + column, this.row + row, columnSpan, rowSpan);
}

bool _overlaps(TableCellPosition a, TableCellPosition b) {
  final bool x =
      a.column < b.column + b.columnSpan && a.column + a.columnSpan > b.column;
  final bool y = a.row < b.row + b.rowSpan && a.row + a.rowSpan > b.row;
  return x && y;
}

Future<RenderTableLayout> _layout(
  WidgetTester tester, {
  required TableSizeSupplier width,
  required TableSizeSupplier height,
  required List<Widget> children,
  double viewportWidth = 300,
  double viewportHeight = 200,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: viewportWidth,
          height: viewportHeight,
          child: RawTableLayout(
            width: width,
            height: height,
            clipBehavior: Clip.none,
            children: children,
          ),
        ),
      ),
    ),
  );
  return tester.renderObject<RenderTableLayout>(find.byType(RawTableLayout));
}

void main() {
  testWidgets('fixed column widths and offsets', (tester) async {
    final RenderTableLayout layout = await _layout(
      tester,
      width: (i) => FixedTableSize(i == 0 ? 100 : 60),
      height: (i) => const FixedTableSize(30),
      children: const <Widget>[
        RawCell(column: 0, row: 0, child: SizedBox(width: 10, height: 10)),
        RawCell(column: 1, row: 0, child: SizedBox(width: 10, height: 10)),
      ],
    );
    expect(layout.columnWidths, <double>[100, 60]);
    expect(layout.rowHeights, <double>[30]);
    expect(layout.getOffset(1, 0), const Offset(100, 0));
  });

  testWidgets('flex columns share the bounded width', (tester) async {
    final RenderTableLayout layout = await _layout(
      tester,
      width: (i) =>
          i == 0 ? const FlexTableSize(flex: 2) : const FlexTableSize(),
      height: (i) => const FixedTableSize(20),
      children: const <Widget>[
        RawCell(column: 0, row: 0, child: SizedBox(width: 10, height: 10)),
        RawCell(column: 1, row: 0, child: SizedBox(width: 10, height: 10)),
      ],
    );
    expect(layout.columnWidths[0], closeTo(200, 0.01));
    expect(layout.columnWidths[1], closeTo(100, 0.01));
  });

  testWidgets('intrinsic rows take the content height', (tester) async {
    final RenderTableLayout layout = await _layout(
      tester,
      width: (i) => const FixedTableSize(100),
      height: (i) => const IntrinsicTableSize(),
      children: const <Widget>[
        RawCell(column: 0, row: 0, child: SizedBox(width: 10, height: 42)),
      ],
    );
    expect(layout.rowHeights[0], closeTo(42, 0.01));
  });

  testWidgets('frozen offsets do not affect the logical grid', (tester) async {
    final RenderTableLayout layout = await _layout(
      tester,
      width: (i) => const FixedTableSize(100),
      height: (i) => const FixedTableSize(30),
      children: const <Widget>[
        RawCell(column: 0, row: 0, child: SizedBox(width: 10, height: 10)),
        RawCell(column: 1, row: 1, child: SizedBox(width: 10, height: 10)),
      ],
    );
    expect(layout.getOffset(1, 1), const Offset(100, 30));
    expect(layout.remainingWidth, closeTo(100, 0.01));
  });

  test('reorganizeCells shifts a cell out of a spanning cell', () {
    final List<_Cell> out = reorganizeCells(<_Cell>[
      const _Cell(0, 0, 2, 1),
      const _Cell(1, 0, 1, 1),
    ]);
    expect(out.length, 2);
    // No two cells overlap after the pass.
    expect(_overlaps(out[0], out[1]), isFalse);
    // The colliding cell moved to column 2.
    expect(out.map((c) => c.column).toSet(), containsAll(<int>[0, 2]));
  });

  test('reorganizeCells leaves a non-overlapping grid unchanged', () {
    final List<_Cell> out = reorganizeCells(<_Cell>[
      const _Cell(0, 0, 1, 1),
      const _Cell(1, 0, 1, 1),
      const _Cell(0, 1, 1, 1),
    ]);
    expect(out.length, 3);
    for (int i = 0; i < out.length; i++) {
      for (int j = i + 1; j < out.length; j++) {
        expect(_overlaps(out[i], out[j]), isFalse);
      }
    }
  });

  group('ResizableTableController', () {
    test('resizeColumn clamps to the constraints', () {
      final ResizableTableController controller = ResizableTableController(
        defaultColumnWidth: 100,
        defaultRowHeight: 40,
        widthConstraints: const <int, ConstrainedTableSize>{
          0: ConstrainedTableSize(min: 50, max: 150),
        },
      );
      addTearDown(controller.dispose);
      expect(controller.resizeColumn(0, 500), isTrue);
      expect(controller.getColumnWidth(0), 150);
      expect(controller.resizeColumn(0, 10), isTrue);
      expect(controller.getColumnWidth(0), 50);
    });

    test('resizeColumn rejects negatives and no-ops on the same value', () {
      final ResizableTableController controller = ResizableTableController(
        defaultColumnWidth: 100,
        defaultRowHeight: 40,
      );
      addTearDown(controller.dispose);
      expect(controller.resizeColumn(-1, 100), isFalse);
      expect(controller.resizeColumn(0, -5), isFalse);
      expect(controller.resizeColumn(0, 120), isTrue);
      expect(controller.resizeColumn(0, 120), isFalse);
    });

    test('resizeColumnBorder moves width between neighbours', () {
      final ResizableTableController controller = ResizableTableController(
        defaultColumnWidth: 100,
        defaultRowHeight: 40,
      );
      addTearDown(controller.dispose);
      expect(controller.resizeColumnBorder(0, 1, 30), 30);
      expect(controller.getColumnWidth(0), 130);
      expect(controller.getColumnWidth(1), 70);
    });

    test('resizeRowBorder respects min constraints', () {
      final ResizableTableController controller = ResizableTableController(
        defaultColumnWidth: 100,
        defaultRowHeight: 60,
        heightConstraints: const <int, ConstrainedTableSize>{
          1: ConstrainedTableSize(min: 50),
        },
      );
      addTearDown(controller.dispose);
      // The next row can only give up 10 px before hitting its min.
      expect(controller.resizeRowBorder(0, 1, 40), 10);
      expect(controller.getRowHeight(1), 50);
    });
  });

  // -------------------------------------------------------------------------
  // Budget overflow regression (P4-T4).
  //
  // `remainingWidth`/`remainingHeight` were `maxWidth - fixedWidth` with no
  // zero clamp. As soon as the fixed tracks overflow the incoming constraints
  // (narrow constraints, resized columns, a zero-width viewport) the budget
  // went negative, and it reached two places that cannot have one:
  //
  //  * the "extent" argument of the children's intrinsic queries
  //    (`getMaxIntrinsicWidth(negative)` asserts);
  //  * `TableLayoutResult.remainingWidth` / `remainingHeight`, which are
  //    public and are fed into `BoxConstraints.tightFor` by `performLayout`.
  // -------------------------------------------------------------------------
  group('overflowed sizing budget', () {
    const Widget cell = Padding(
      padding: EdgeInsets.all(12),
      child: Text('cell content'),
    );

    testWidgets('an intrinsic row beside an overflowing fixed row', (
      tester,
    ) async {
      // Row 0 is intrinsic; row 1 is fixed and taller than the 100px viewport,
      // so `remainingHeight` went negative and was handed to the child's
      // `getMaxIntrinsicWidth` as the extent.
      await _layout(
        tester,
        width: (i) => const IntrinsicTableSize(),
        height: (i) =>
            i == 0 ? const IntrinsicTableSize() : const FixedTableSize(200),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: cell),
          RawCell(column: 0, row: 1, child: SizedBox(width: 30, height: 20)),
        ],
        viewportHeight: 100,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('an intrinsic column beside an overflowing fixed column', (
      tester,
    ) async {
      // Same trap on the other axis: column 1 is 200px inside a 100px viewport.
      await _layout(
        tester,
        width: (i) =>
            i == 0 ? const IntrinsicTableSize() : const FixedTableSize(200),
        height: (i) => const IntrinsicTableSize(),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: cell),
          RawCell(column: 1, row: 0, child: SizedBox(width: 30, height: 20)),
        ],
        viewportWidth: 100,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('intrinsic queries never see a negative budget', (
      tester,
    ) async {
      // The intrinsic-computer path (a parent asking for min/max intrinsic
      // sizes) recomputes the same budgets, so it must stay clamped too.
      await _layout(
        tester,
        width: (i) => const IntrinsicTableSize(),
        height: (i) =>
            i == 0 ? const FixedTableSize(400) : const IntrinsicTableSize(),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: cell),
          RawCell(column: 0, row: 1, child: cell),
        ],
        viewportHeight: 100,
      );
      final RenderTableLayout table = tester.renderObject<RenderTableLayout>(
        find.byType(RawTableLayout),
      );
      expect(table.computeMinIntrinsicWidth(100), greaterThanOrEqualTo(0));
      expect(table.computeMaxIntrinsicWidth(100), greaterThanOrEqualTo(0));
      expect(table.computeMinIntrinsicHeight(100), greaterThanOrEqualTo(0));
      expect(table.computeMaxIntrinsicHeight(100), greaterThanOrEqualTo(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a zero-width viewport keeps every track non-negative', (
      tester,
    ) async {
      final RenderTableLayout layout = await _layout(
        tester,
        width: (i) => i == 0 ? const FixedTableSize(80) : const FlexTableSize(),
        height: (i) =>
            i == 0 ? const FixedTableSize(60) : const FlexTableSize(),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: cell),
          RawCell(column: 1, row: 1, child: cell),
        ],
        viewportWidth: 0,
        viewportHeight: 0,
      );
      expect(layout.columnWidths.every((double v) => v >= 0), isTrue);
      expect(layout.rowHeights.every((double v) => v >= 0), isTrue);
      expect(layout.remainingWidth, greaterThanOrEqualTo(0));
      expect(layout.remainingHeight, greaterThanOrEqualTo(0));
      expect(layout.remainingLooseWidth, greaterThanOrEqualTo(0));
      expect(layout.remainingLooseHeight, greaterThanOrEqualTo(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('fixed columns wider than the viewport plus a flex column', (
      tester,
    ) async {
      final RenderTableLayout layout = await _layout(
        tester,
        width: (i) =>
            i == 0 ? const FixedTableSize(200) : const FlexTableSize(),
        height: (i) => const FixedTableSize(30),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: cell),
          RawCell(column: 1, row: 0, child: cell),
        ],
        viewportWidth: 100,
      );
      expect(layout.columnWidths[1], 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a viewport-shaped constraint (minWidth) stays clamped', (
      tester,
    ) async {
      // `ScrollableClient`'s viewport hands its child
      // `BoxConstraints(minWidth: maxWidth)`, i.e. a TIGHT width. That is the
      // shape the docs suite hit in the retained route stack.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: UnconstrainedBox(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 200, minHeight: 100),
              child: RawTableLayout(
                width: (i) =>
                    i == 0 ? const IntrinsicTableSize() : const FlexTableSize(),
                height: (i) => i == 0
                    ? const IntrinsicTableSize()
                    : const FixedTableSize(400),
                clipBehavior: Clip.none,
                children: const <Widget>[
                  RawCell(column: 0, row: 0, child: cell),
                  RawCell(column: 1, row: 1, child: cell),
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('frozen columns beyond the viewport', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 120,
            height: 100,
            child: RawTableLayout(
              width: (i) => const FixedTableSize(80),
              height: (i) => const FixedTableSize(30),
              clipBehavior: Clip.none,
              frozenColumn: (index, span) => index < 2,
              horizontalOffset: 500,
              viewportSize: const Size(120, 100),
              children: const <Widget>[
                RawCell(
                  column: 0,
                  row: 0,
                  child: SizedBox(width: 10, height: 10),
                ),
                RawCell(
                  column: 1,
                  row: 0,
                  child: SizedBox(width: 10, height: 10),
                ),
                RawCell(
                  column: 2,
                  row: 0,
                  child: SizedBox(width: 10, height: 10),
                ),
              ],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('cells spanning beyond the grid', (tester) async {
      await _layout(
        tester,
        width: (i) => const FixedTableSize(60),
        height: (i) => const FixedTableSize(30),
        children: const <Widget>[
          RawCell(column: 0, row: 0, columnSpan: 4, rowSpan: 3, child: cell),
        ],
        viewportWidth: 80,
        viewportHeight: 60,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('intrinsic columns with wide content plus flex', (
      tester,
    ) async {
      await _layout(
        tester,
        width: (i) =>
            i == 0 ? const IntrinsicTableSize() : const FlexTableSize(),
        height: (i) => const FixedTableSize(30),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: SizedBox(width: 900, height: 10)),
          RawCell(column: 1, row: 0, child: cell),
        ],
        viewportWidth: 60,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('fractional columns plus a flex column', (tester) async {
      await _layout(
        tester,
        width: (i) => i == 0
            ? const FractionalTableSize(2)
            : const FlexTableSize(flex: 3),
        height: (i) => const FixedTableSize(30),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: cell),
          RawCell(column: 1, row: 0, child: cell),
        ],
        viewportWidth: 100,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('intrinsic rows wider than the viewport', (tester) async {
      await _layout(
        tester,
        width: (i) => const FixedTableSize(50),
        height: (i) => const IntrinsicTableSize(),
        children: const <Widget>[
          RawCell(column: 0, row: 0, child: SizedBox(width: 10, height: 400)),
        ],
        viewportHeight: 100,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
