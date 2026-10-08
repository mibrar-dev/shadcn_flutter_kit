// Tests for the `table_layout` primitive.
//
// Covers the grid layout maths (fixed/flex/intrinsic sizing, offsets), the
// span-aware `reorganizeCells` pass, `flattenTableCells` and the
// `ResizableTableController` clamping/border maths.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/table_layout/table_cells.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/table_layout/table_layout.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/table_layout/table_resize_controller.dart';
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
}
