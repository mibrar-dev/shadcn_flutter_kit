// Gallery preview for the `table` component: a data grid with a header, a
// spanning cell and a footer, a resizable table and the dark palette.
// Widgets-only; the docs app embeds [TablePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'table.dart';

/// Renders the table gallery.
class TablePreview extends StatelessWidget {
  /// Creates the preview.
  const TablePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(context, 'Data grid', _grid()),
                Gap(theme.spacing.xl),
                _section(context, 'Resizable', const _ResizableDemo()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    return SizedBox(
      width: 460,
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

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: Builder(builder: (context) => _grid()),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}

class _ResizableDemo extends StatefulWidget {
  const _ResizableDemo();

  @override
  State<_ResizableDemo> createState() => _ResizableDemoState();
}

class _ResizableDemoState extends State<_ResizableDemo> {
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
      width: 420,
      height: 170,
      child: ShadcnTable(
        resizeController: _controller,
        verticalController: _vertical,
        horizontalController: _horizontal,
        rows: <ShadcnTableRow>[
          const ShadcnTableHeader(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Drag a divider')),
              ShadcnTableCell(child: Text('Column')),
              ShadcnTableCell(child: Text('Row')),
            ],
          ),
          const ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('One')),
              ShadcnTableCell(child: Text('Two')),
              ShadcnTableCell(child: Text('Three')),
            ],
          ),
          const ShadcnTableRow(
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
