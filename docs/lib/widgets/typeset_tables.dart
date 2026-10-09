// Typeset tables for the docs site (spec §2.3): border-collapse separate,
// 15/1.5 tabular-nums cells, 500-weight header, 1 px row rules, wrapped in a
// horizontal scroll area. D4 uses these for the API Reference, Theme and
// Accessibility tables on component pages and the CLI flags tables.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// One cell of a [TypesetTable].
class TypesetCell {
  /// Creates a cell.
  const TypesetCell({required this.text, this.mono = false});

  /// Cell content.
  final String text;

  /// Whether the cell renders in the mono face (parameter/field names).
  final bool mono;
}

/// One row of a [TypesetTable].
class TypesetRow {
  /// Creates a row.
  const TypesetRow(this.cells);

  /// The cells, in column order.
  final List<TypesetCell> cells;
}

/// A typeset-styled data table (spec §2.3).
///
/// Header cells are 500 weight; body cells are 400. Both use 15/1.5
/// tabular-nums. Rows are separated by 1 px rules and the whole table
/// scrolls horizontally on narrow columns.
class TypesetTable extends StatelessWidget {
  /// Creates a table.
  const TypesetTable({super.key, required this.headers, required this.rows});

  /// Header cell text, in column order.
  final List<String> headers;

  /// Body rows.
  final List<TypesetRow> rows;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final TextStyle headerStyle = docsText(
      context,
      size: 15,
      weight: FontWeight.w500,
      height: 1.5,
    );
    final TextStyle bodyStyle = docsText(
      context,
      size: 15,
      height: 1.5,
      color: theme.colors.foreground,
    );
    final TextStyle monoStyle = theme.typography.mono.copyWith(
      fontSize: 15,
      height: 1.5,
      color: theme.colors.foreground,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row.
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.colors.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: <Widget>[
                for (final String header in headers)
                  SizedBox(
                    width: _columnWidth(headers.indexOf(header)),
                    child: Text(header, style: headerStyle),
                  ),
              ],
            ),
          ),
          // Body rows.
          for (final TypesetRow row in rows)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colors.border.withValues(alpha: 0.5),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (int i = 0; i < row.cells.length; i++)
                    SizedBox(
                      width: _columnWidth(i),
                      child: Text(
                        row.cells[i].text,
                        style: row.cells[i].mono ? monoStyle : bodyStyle,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static double _columnWidth(int index) {
    // Fixed column widths keep the table readable: name column wider.
    switch (index) {
      case 0:
        return 160;
      case 1:
        return 180;
      default:
        return 200;
    }
  }
}

/// A key/value table for CLI flags (name, alias, description).
class TypesetFlagTable extends StatelessWidget {
  /// Creates a flag table.
  const TypesetFlagTable({super.key, required this.flags});

  /// The flags to display.
  final List<({String name, String? alias, String description})> flags;

  @override
  Widget build(BuildContext context) {
    return TypesetTable(
      headers: const <String>['Flag', 'Alias', 'Description'],
      rows: <TypesetRow>[
        for (final flag in flags)
          TypesetRow(<TypesetCell>[
            TypesetCell(text: flag.name, mono: true),
            TypesetCell(text: flag.alias ?? '—'),
            TypesetCell(text: flag.description),
          ]),
      ],
    );
  }
}

/// A two-column key/value table (used for theme fields).
class TypesetKeyValueTable extends StatelessWidget {
  /// Creates a key/value table.
  const TypesetKeyValueTable({super.key, required this.rows});

  /// The key/value pairs.
  final List<({String key, String value})> rows;

  @override
  Widget build(BuildContext context) {
    return TypesetTable(
      headers: const <String>['Property', 'Value'],
      rows: <TypesetRow>[
        for (final row in rows)
          TypesetRow(<TypesetCell>[
            TypesetCell(text: row.key, mono: true),
            TypesetCell(text: row.value),
          ]),
      ],
    );
  }
}

/// A simple labelled value row (used in the themes rail).
class TypesetLabelledRow extends StatelessWidget {
  /// Creates a labelled row.
  const TypesetLabelledRow({
    super.key,
    required this.label,
    required this.value,
  });

  /// The label (12 px muted).
  final String label;

  /// The value (14 px).
  final String value;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: docsText(
            context,
            size: 12,
            weight: FontWeight.w500,
            color: theme.colors.mutedForeground,
          ),
        ),
        const Gap(4),
        Text(value, style: docsText(context, size: 14)),
      ],
    );
  }
}
