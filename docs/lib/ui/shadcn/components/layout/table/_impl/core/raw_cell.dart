// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// RawCell defines a reusable type for this registry module.
class RawCell extends ParentDataWidget<TableParentData> {
  /// Column index for this cell.
  final int column;

  /// Row index for this cell.
  final int row;

  /// Number of columns spanned. Defaults to 1.
  final int? columnSpan;

  /// Number of rows spanned. Defaults to 1.
  final int? rowSpan;

  /// Whether to compute size for this cell.
  final bool computeSize;

  /// Creates a [RawCell].
  const RawCell({
    super.key,
    required this.column,
    required this.row,
    this.columnSpan,
    this.rowSpan,
    this.computeSize = true,
    required super.child,
  });

  @override
  /// Executes `applyParentData` behavior for this component/composite.
  void applyParentData(RenderObject renderObject) {
    /// Stores `parentData` state/configuration for this implementation.
    final parentData = renderObject.parentData as TableParentData;

    /// Stores `needsLayout` state/configuration for this implementation.
    bool needsLayout = false;
    if (parentData.column != column) {
      parentData.column = column;
      needsLayout = true;
    }
    if (parentData.row != row) {
      parentData.row = row;
      needsLayout = true;
    }
    if (parentData.columnSpan != columnSpan) {
      parentData.columnSpan = columnSpan;
      needsLayout = true;
    }
    if (parentData.rowSpan != rowSpan) {
      parentData.rowSpan = rowSpan;
      needsLayout = true;
    }
    if (parentData.computeSize != computeSize) {
      parentData.computeSize = computeSize;
      needsLayout = true;
    }
    if (needsLayout) {
      /// Stores `table` state/configuration for this implementation.
      final table = renderObject.parent as RenderTableLayout;
      table.markNeedsLayout();
    }
  }

  @override
  /// Stores `debugTypicalAncestorWidgetClass` state/configuration for this implementation.
  Type get debugTypicalAncestorWidgetClass => RawTableLayout;
}

/// Base class for table sizing strategies.
///
/// Abstract class that defines how table columns and rows should be sized.
/// Implementations include fixed, flexible, and intrinsic sizing modes.
abstract base class TableSize {
  /// Creates a [TableSize].
  const TableSize();
}

/// Table size mode that distributes available space using flex factors.
///
/// Similar to Flutter's [Flexible] widget, allocates space proportionally
/// based on the flex value. Used for responsive column/row sizing.
///
/// Example:
/// ```dart
/// FlexTableSize(flex: 2.0, fit: FlexFit.tight)
/// ```
final class FlexTableSize extends TableSize {
  /// Flex factor for space distribution. Defaults to 1.
  final double flex;

  /// How the space should be allocated. Defaults to tight.
  final FlexFit fit;

  /// Creates a [FlexTableSize].
  const FlexTableSize({this.flex = 1, this.fit = FlexFit.tight});
}

/// Table size mode with a fixed pixel value.
///
/// Allocates a specific fixed size regardless of available space.
/// Used for columns/rows that should maintain a constant size.
///
/// Example:
/// ```dart
/// FixedTableSize(150.0) // 150 pixels
/// ```
final class FixedTableSize extends TableSize {
  /// The fixed size value in pixels.
  final double value;

  /// Creates a [FixedTableSize] with the specified pixel value.
  const FixedTableSize(this.value);
}

/// Table size mode that uses the intrinsic size of cell content.
///
/// Sizes the column/row based on the natural size of its content.
/// May be expensive for large tables as it requires measuring content.
///
/// Example:
/// ```dart
/// IntrinsicTableSize() // Size based on content
/// ```
final class IntrinsicTableSize extends TableSize {
  /// Creates an [IntrinsicTableSize].
  const IntrinsicTableSize();
}

/// Table size mode that uses a fractional value of the table's size.
///
/// Sizes the column/row based on a fractional value of the table's size.
///
/// Example:
/// ```dart
/// FractionalTableSize(0.5) // 50% of table size
/// ```
final class FractionalTableSize extends TableSize {
  /// The fractional value of the table's size.
  final double fraction;

  /// Creates a [FractionalTableSize] with the specified fractional value.
  const FractionalTableSize(this.fraction);
}

/// Predicate function to test if a cell matches certain criteria.
///
/// Used internally for filtering and testing cells based on their
/// index and span values.
