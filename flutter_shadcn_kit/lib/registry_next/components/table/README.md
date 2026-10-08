# Table

A themed data grid built on a custom layout render object: span-aware cells,
per-column/row sizing strategies, frozen rows and columns, optional two-axis
scrolling and optional interactive column/row resizing. Widgets-only.

The public widgets are prefixed `ShadcnTable*` because `Table`, `TableRow` and
`TableCell` are also names in `package:flutter/widgets.dart` (the `image`
component resolved the same clash by renaming `Image` to `ShadcnImage`). No
`hide` workaround is needed when importing both.

## When to use

- Presenting tabular data with headers/footers and column alignment.
- A grid that must resize columns or rows interactively.
- A scrollable grid with pinned header rows or key columns.

## Snippets

Basic grid:

```dart
ShadcnTable(
  columnWidths: const {0: FlexTableSize(flex: 2), 2: FixedTableSize(90)},
  rows: <ShadcnTableRow>[
    const ShadcnTableHeader(cells: <ShadcnTableCell>[
      ShadcnTableCell(child: Text('Name')),
      ShadcnTableCell(child: Text('Role')),
      ShadcnTableCell(child: Text('Status')),
    ]),
    const ShadcnTableRow(cells: <ShadcnTableCell>[
      ShadcnTableCell(child: Text('Avery')),
      ShadcnTableCell(child: Text('Designer')),
      ShadcnTableCell(child: Text('Active')),
    ]),
  ],
);
```

Spanning cell and a footer:

```dart
ShadcnTableFooter(cells: <ShadcnTableCell>[
  ShadcnTableCell(columnSpan: 2, child: const Text('2 people')),
  const ShadcnTableCell(child: Text('—')),
]);
```

Resizable + scrollable grid:

```dart
final controller = ResizableTableController(
  defaultColumnWidth: 120,
  defaultRowHeight: 40,
);
ShadcnTable(
  resizeController: controller,
  verticalController: scrollController,
  horizontalController: horizontalScrollController,
  rows: rows,
);
```

Frozen header row:

```dart
ShadcnTable(
  frozenCells: const FrozenTableData(frozenRows: <TableRef>[TableRef(0)]),
  verticalController: controller,
  rows: rows,
);
```

## API

| Member | Notes |
|---|---|
| `ShadcnTable.rows` | `List<ShadcnTableRow>` (headers, rows, footers) |
| `defaultColumnWidth` / `defaultRowHeight` | `TableSize`, default flex / intrinsic |
| `columnWidths` / `rowHeights` | per-index `TableSize` overrides |
| `frozenCells` | `FrozenTableData` of pinned rows/columns |
| `horizontalOffset` / `verticalOffset` / `viewportSize` | manual viewport |
| `verticalController` / `horizontalController` | own the scrolling |
| `textDirection` | direction columns run in |
| `resizeController` | `ResizableTableController?`; enables resizing |
| `cellWidthResizeMode` / `cellHeightResizeMode` | `TableCellResizeMode` |
| `clipBehavior` | boundary clipping |
| `theme` | `TableTheme?` widget leg |

`TableSize` strategies: `FlexTableSize`, `FixedTableSize`,
`IntrinsicTableSize`, `FractionalTableSize`.

## Theme resolution

`widget theme > ComponentTheme<TableTheme> in tree > app overrides
(table_theme.dart) > tableDefaults`, merged per field.

Per cell, `TableTheme.cellTheme` merges over the row default
(`ShadcnTableHeader` / `ShadcnTableFooter` / body). The row defaults follow
shadcn: body cells are `p-2` with a bottom border and a `muted/50` row-hover
fill; header cells are `h-10 px-2` with medium `muted-foreground` text;
footer cells are muted with no border.

## Differences from the old `layout/table`

- `ResizableTable` is folded into `ShadcnTable` behind `resizeController`; the
  old separate widget and its duplicated cell-flattening state are gone.
- Public widgets are renamed `ShadcnTable` / `ShadcnTableRow` /
  `ShadcnTableHeader` / `ShadcnTableFooter` / `ShadcnTableCell` to avoid the
  Flutter `widgets.dart` name clash (clean break; no aliases).
- The layout engine, cell helpers, resize controller/handles, cell view and
  models live in `primitives/table_layout/` so the component folder holds only
  `table.dart`, `table_style.dart` and `table_theme.dart` (the same split the
  `slider` component uses). The theme classes (`TableTheme` / `TableCellTheme`)
  stay in `table_style.dart`: a primitive must not own a component's theme.
- The public models (`ShadcnTableRow` / `ShadcnTableCell`) are theme-free so the
  primitive never imports a component; the old per-row `cellTheme` and per-cell
  `theme` override fields are dropped. Use `TableTheme.cellTheme` to theme the
  grid, or a `ComponentTheme<TableTheme>` subtree for a region.
- The old `_impl/themes/{config,tokens,defaults,schema}` files collapse into
  `table_style.dart` + `table_theme.dart`.
- **Bug fixed:** the old cell fill defaulted to hard-coded white
  (`0xFFFFFFFF`), so dark tables rendered white; the default is now the `card`
  token.
- **Bug fixed:** `TableTheme.cellTheme` was declared but never read; it is now
  merged under the row/cell themes.
- **Bug fixed:** `TableRow`/`TableHeader`/`TableFooter.buildDefaultTheme` built
  a fresh `WidgetStateProperty.resolveWith` closure on every row on every
  build; the defaults are now const token rows.
- **Bug fixed:** cells read the old `Theme.of(context).colorScheme`; they now
  resolve `ShadcnColors` through `ThemedColor` tokens, so presets and dark mode
  follow.
- **Bug fixed:** `TableTheme.copyWith` silently dropped `borderRadius`.
- `Data.inherit` (`package:data_widget`) is gone: the state builds the cells
  directly, so there is no hidden `Data` dependency.
- The `_impl/` `part` structure, `ignore_for_file` comments and
  `theme.schema.json` are gone.
- Resize handles carry a `Semantics` label from
  `ShadcnLocalizations.tableResizeColumn` / `.tableResizeRow` (English fallback;
  no Flutter ARB equivalent exists).
