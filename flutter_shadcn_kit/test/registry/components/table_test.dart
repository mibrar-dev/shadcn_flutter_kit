// Widget tests for the `table` component.
//
// Covers the token defaults, fixed sizing, spanning, header/footer styling,
// dark tokens (the old hard-coded white fill regression), hover highlighting,
// disabled foreground, the four theme-precedence legs, cell-theme merging and
// interactive resizing.

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/table/table.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

List<ShadcnTableRow> _rows() {
  return <ShadcnTableRow>[
    const ShadcnTableHeader(
      cells: <ShadcnTableCell>[
        ShadcnTableCell(child: Text('Name')),
        ShadcnTableCell(child: Text('Role')),
      ],
    ),
    const ShadcnTableRow(
      cells: <ShadcnTableCell>[
        ShadcnTableCell(child: Text('Avery')),
        ShadcnTableCell(child: Text('Designer')),
      ],
    ),
    const ShadcnTableRow(
      cells: <ShadcnTableCell>[
        ShadcnTableCell(child: Text('Jordan')),
        ShadcnTableCell(child: Text('Engineer'), enabled: false),
      ],
    ),
    const ShadcnTableFooter(
      cells: <ShadcnTableCell>[
        ShadcnTableCell(child: Text('Total')),
        ShadcnTableCell(child: Text('2')),
      ],
    ),
  ];
}

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TableTheme? scoped,
  Size size = const Size(400, 300),
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<TableTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox.fromSize(size: size, child: body),
        ),
      ),
    ),
  );
}

Widget _table({
  List<ShadcnTableRow>? rows,
  Map<int, TableSize>? columnWidths,
  ResizableTableController? resizeController,
  TableTheme? theme,
}) {
  return ShadcnTable(
    rows: rows ?? _rows(),
    columnWidths: columnWidths,
    resizeController: resizeController,
    theme: theme,
  );
}

BoxDecoration _cellDecoration(WidgetTester tester, String text) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .ancestor(of: find.text(text), matching: find.byType(DecoratedBox))
        .first,
  );
  return box.decoration as BoxDecoration;
}

TextStyle _cellTextStyle(WidgetTester tester, String text) {
  return tester
      .widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text(text),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      )
      .style;
}

BoxDecoration _tableDecoration(WidgetTester tester) {
  final Container container = tester.widget<Container>(
    find.descendant(
      of: find.byType(ShadcnTable),
      matching: find.byType(Container),
    ),
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  testWidgets('renders headers, rows and footers', (tester) async {
    await tester.pumpWidget(_frame(child: _table()));
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Avery'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
  });

  testWidgets('uses card fill and border-token bottom border', (tester) async {
    final ShadcnColors colors = ShadcnColors.lightFallback;
    await tester.pumpWidget(_frame(child: _table()));
    expect(_tableDecoration(tester).color, colors.card);
    final BoxDecoration cell = _cellDecoration(tester, 'Avery');
    expect(
      cell.border,
      Border(bottom: BorderSide(color: colors.border, width: 1)),
    );
  });

  testWidgets('header cells are medium foreground, footer has no border', (
    tester,
  ) async {
    final ShadcnColors colors = ShadcnColors.lightFallback;
    await tester.pumpWidget(_frame(child: _table()));
    expect(_cellTextStyle(tester, 'Name').fontWeight, FontWeight.w500);
    expect(_cellTextStyle(tester, 'Name').color, colors.foreground);
    expect(_cellDecoration(tester, 'Total').border, isNull);
  });

  testWidgets('fixed column widths are respected', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _table(
          columnWidths: const <int, TableSize>{
            0: FixedTableSize(120),
            1: FixedTableSize(80),
          },
        ),
      ),
    );
    final Rect first = tester.getRect(
      find
          .ancestor(of: find.text('Avery'), matching: find.byType(RawCell))
          .first,
    );
    final Rect second = tester.getRect(
      find
          .ancestor(of: find.text('Designer'), matching: find.byType(RawCell))
          .first,
    );
    expect(first.width, 120);
    expect(second.width, 80);
    expect(second.left - first.left, 120);
  });

  testWidgets('a spanning cell occupies the spanned columns', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _table(
          rows: <ShadcnTableRow>[
            const ShadcnTableRow(
              cells: <ShadcnTableCell>[
                ShadcnTableCell(columnSpan: 2, child: Text('Wide')),
              ],
            ),
            const ShadcnTableRow(
              cells: <ShadcnTableCell>[
                ShadcnTableCell(child: Text('A')),
                ShadcnTableCell(child: Text('B')),
              ],
            ),
          ],
          columnWidths: const <int, TableSize>{
            0: FixedTableSize(100),
            1: FixedTableSize(60),
          },
        ),
      ),
    );
    final Rect wide = tester.getRect(
      find
          .ancestor(of: find.text('Wide'), matching: find.byType(RawCell))
          .first,
    );
    expect(wide.width, 160);
  });

  testWidgets('regression: dark tables use the card token, not white', (
    tester,
  ) async {
    const ShadcnColors dark = ShadcnColors.darkFallback;
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: dark),
        child: _table(),
      ),
    );
    expect(_tableDecoration(tester).color, dark.card);
    expect(_cellDecoration(tester, 'Avery').color, isNull);
  });

  testWidgets('hovering a cell highlights its row', (tester) async {
    final ShadcnColors colors = ShadcnColors.lightFallback;
    await tester.pumpWidget(_frame(child: _table()));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Avery')));
    await tester.pumpAndSettle();
    expect(
      _cellDecoration(tester, 'Designer').color,
      colors.muted.withValues(alpha: 0.5),
    );
  });

  testWidgets('a disabled cell uses the muted foreground', (tester) async {
    final ShadcnColors colors = ShadcnColors.lightFallback;
    await tester.pumpWidget(_frame(child: _table()));
    expect(_cellTextStyle(tester, 'Engineer').color, colors.mutedForeground);
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            TableTheme(background: ThemedColor.value(_green)),
          ],
          child: _table(),
        ),
      );
      expect(_tableDecoration(tester).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            TableTheme(background: ThemedColor.value(_green)),
          ],
          scoped: const TableTheme(background: ThemedColor.value(_blue)),
          child: _table(),
        ),
      );
      expect(_tableDecoration(tester).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const TableTheme(background: ThemedColor.value(_green)),
          child: _table(
            theme: const TableTheme(background: ThemedColor.value(_blue)),
          ),
        ),
      );
      expect(_tableDecoration(tester).color, _blue);
    });

    testWidgets('a leg setting only padding keeps the token fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: const TableTheme(padding: EdgeInsets.all(4)),
          child: _table(),
        ),
      );
      expect(_tableDecoration(tester).color, ShadcnColors.lightFallback.card);
    });
  });

  testWidgets('table-level cell theme merges under the header style', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: _table(
          theme: const TableTheme(
            cellTheme: TableCellTheme(
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_green),
              ),
            ),
          ),
        ),
      ),
    );
    expect(_cellDecoration(tester, 'Avery').color, _green);
    // The header's medium weight survives the table-level cell theme.
    expect(_cellTextStyle(tester, 'Name').fontWeight, FontWeight.w500);
    expect(_cellDecoration(tester, 'Name').color, _green);
  });

  testWidgets('a resize controller adds handles and a drag resizes', (
    tester,
  ) async {
    final ResizableTableController controller = ResizableTableController(
      defaultColumnWidth: 120,
      defaultRowHeight: 40,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(child: _table(resizeController: controller)),
    );
    final Finder handles = find.byWidgetPredicate(
      (Widget widget) =>
          widget is MouseRegion &&
          widget.cursor == SystemMouseCursors.resizeColumn,
    );
    expect(handles, findsWidgets);
    final double before = controller.getColumnWidth(0);
    await tester.dragFrom(tester.getCenter(handles.first), const Offset(30, 0));
    await tester.pumpAndSettle();
    expect(controller.getColumnWidth(0), greaterThan(before));
  });

  testWidgets('resize handles expose localized semantics labels', (
    tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    final ResizableTableController controller = ResizableTableController(
      defaultColumnWidth: 120,
      defaultRowHeight: 40,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(child: _table(resizeController: controller)),
    );
    expect(find.bySemanticsLabel('Resize column'), findsWidgets);
    expect(find.bySemanticsLabel('Resize row'), findsWidgets);
    semantics.dispose();
  });

  testWidgets('header is h-10 and body cells are p-2', (tester) async {
    await tester.pumpWidget(_frame(child: _table()));
    final Rect header = tester.getRect(
      find
          .ancestor(of: find.text('Name'), matching: find.byType(RawCell))
          .first,
    );
    expect(header.height, greaterThanOrEqualTo(40));
    final Padding bodyPadding = tester.widget<Padding>(
      find
          .ancestor(of: find.text('Avery'), matching: find.byType(Padding))
          .first,
    );
    expect(bodyPadding.padding, const EdgeInsets.all(8));
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

    test('resizeColumnBorder moves width between neighbours', () {
      final ResizableTableController controller = ResizableTableController(
        defaultColumnWidth: 100,
        defaultRowHeight: 40,
      );
      addTearDown(controller.dispose);
      final double moved = controller.resizeColumnBorder(0, 1, 30);
      expect(moved, 30);
      expect(controller.getColumnWidth(0), 130);
      expect(controller.getColumnWidth(1), 70);
    });
  });
}
