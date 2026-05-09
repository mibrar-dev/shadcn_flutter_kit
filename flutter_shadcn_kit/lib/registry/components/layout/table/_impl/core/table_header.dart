// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// TableHeader defines a reusable type for this registry module.
class TableHeader extends TableRow {
  /// Creates a [TableHeader].
  const TableHeader({required super.cells, super.cellTheme});

  @override
  /// Executes `buildDefaultTheme` behavior for this component/composite.
  TableCellTheme buildDefaultTheme(BuildContext context) {
    if (cellTheme != null) {
      return cellTheme!;
    }
    final theme = Theme.of(context);
    return TableCellTheme(
      border: WidgetStateProperty.resolveWith((states) {
        return Border(
          bottom: BorderSide(color: theme.colorScheme.border, width: 1),
        );
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered)
            ? theme.colorScheme.muted
            : theme.colorScheme.muted.withValues(alpha: 0.5);
      }),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return theme.typography.semiBold.merge(
          /// Creates a `TextStyle` instance.
          TextStyle(
            color: states.contains(WidgetState.disabled)
                ? theme.colorScheme.muted
                : null,
          ),
        );
      }),
    );
  }
}
