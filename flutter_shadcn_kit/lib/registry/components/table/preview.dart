// Named examples for the `table` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'table.dart';

/// A data grid with a header, a selected row and a footer.
Widget _default(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 460),
    child: ShadcnTable(
      columnWidths: const <int, TableSize>{
        0: FlexTableSize(flex: 2),
        1: FlexTableSize(),
        2: FixedTableSize(90),
      },
      rows: <ShadcnTableRow>[
        const ShadcnTableHeader(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Name')),
            ShadcnTableCell(child: Text('Role')),
            ShadcnTableCell(child: Text('Status')),
          ],
        ),
        const ShadcnTableRow(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Avery')),
            ShadcnTableCell(child: Text('Designer')),
            ShadcnTableCell(child: Text('Active')),
          ],
        ),
        const ShadcnTableRow(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Jordan')),
            ShadcnTableCell(child: Text('Engineer')),
            ShadcnTableCell(child: Text('Active')),
          ],
        ),
        const ShadcnTableRow(
          selected: true,
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Casey')),
            ShadcnTableCell(child: Text('PM')),
            ShadcnTableCell(child: Text('Away')),
          ],
        ),
        ShadcnTableFooter(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(columnSpan: 2, child: const Text('3 people')),
            const ShadcnTableCell(child: Text('—')),
          ],
        ),
      ],
    ),
  );
}

/// A resizable table; owns its resize and scroll controllers. The fixed box
/// is inherent: the table scrolls internally.
class _ResizableTable extends StatefulWidget {
  const _ResizableTable();

  @override
  State<_ResizableTable> createState() => _ResizableTableState();
}

class _ResizableTableState extends State<_ResizableTable> {
  final ResizableTableController _controller = ResizableTableController(
    defaultColumnWidth: 120,
    defaultRowHeight: 40,
  );
  final ScrollController _vertical = ScrollController();
  final ScrollController _horizontal = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _vertical.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 170,
      child: ShadcnTable(
        resizeController: _controller,
        verticalController: _vertical,
        horizontalController: _horizontal,
        rows: const <ShadcnTableRow>[
          ShadcnTableHeader(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Drag a divider')),
              ShadcnTableCell(child: Text('Column')),
              ShadcnTableCell(child: Text('Row')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('One')),
              ShadcnTableCell(child: Text('Two')),
              ShadcnTableCell(child: Text('Three')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Four')),
              ShadcnTableCell(child: Text('Five')),
              ShadcnTableCell(child: Text('Six')),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _resizable(BuildContext context) => const _ResizableTable();

/// Named docs examples for `table`; the first entry is the default.
const List<ComponentPreview> tablePreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Resizable', _resizable),
];
