// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// RawTableLayout defines a reusable type for this registry module.
class RawTableLayout extends MultiChildRenderObjectWidget {
  /// Creates a [RawTableLayout].
  ///
  /// Parameters:
  /// - [children] (`List<Widget>`, optional): Table cell widgets.
  /// - [width] (`TableSizeSupplier`, required): Column width supplier.
  /// - [height] (`TableSizeSupplier`, required): Row height supplier.
  /// - [clipBehavior] (`Clip`, required): Content clipping behavior.
  /// - [frozenColumn] (`CellPredicate?`, optional): Frozen column predicate.
  /// - [frozenRow] (`CellPredicate?`, optional): Frozen row predicate.
  /// - [verticalOffset] (`double?`, optional): Vertical scroll offset.
  /// - [horizontalOffset] (`double?`, optional): Horizontal scroll offset.
  /// - [viewportSize] (`Size?`, optional): Viewport size for scrolling.
  const RawTableLayout({
    super.key,
    super.children,
    required this.width,
    required this.height,
    required this.clipBehavior,
    this.frozenColumn,
    this.frozenRow,
    this.verticalOffset,
    this.horizontalOffset,
    this.viewportSize,
  });

  /// Supplier function for column widths.
  final TableSizeSupplier width;

  /// Supplier function for row heights.
  final TableSizeSupplier height;

  /// How content should be clipped.
  final Clip clipBehavior;

  /// Predicate for determining frozen columns.
  final CellPredicate? frozenColumn;

  /// Predicate for determining frozen rows.
  final CellPredicate? frozenRow;

  /// Vertical scroll offset.
  final double? verticalOffset;

  /// Horizontal scroll offset.
  final double? horizontalOffset;

  /// Size of the visible viewport.
  final Size? viewportSize;

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderTableLayout createRenderObject(BuildContext context) {
    return RenderTableLayout(
      width: width,
      height: height,
      clipBehavior: clipBehavior,
      frozenCell: frozenColumn,
      frozenRow: frozenRow,
      verticalOffset: verticalOffset,
      horizontalOffset: horizontalOffset,
      viewportSize: viewportSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTableLayout renderObject,
  ) {
    /// Stores `needsRelayout` state/configuration for this implementation.
    bool needsRelayout = false;
    if (renderObject._width != width) {
      renderObject._width = width;
      needsRelayout = true;
    }
    if (renderObject._height != height) {
      renderObject._height = height;
      needsRelayout = true;
    }
    if (renderObject._clipBehavior != clipBehavior) {
      renderObject._clipBehavior = clipBehavior;
      needsRelayout = true;
    }
    if (renderObject._frozenColumn != frozenColumn) {
      renderObject._frozenColumn = frozenColumn;
      needsRelayout = true;
    }
    if (renderObject._frozenRow != frozenRow) {
      renderObject._frozenRow = frozenRow;
      needsRelayout = true;
    }
    if (renderObject._verticalOffset != verticalOffset) {
      renderObject._verticalOffset = verticalOffset;
      needsRelayout = true;
    }
    if (renderObject._horizontalOffset != horizontalOffset) {
      renderObject._horizontalOffset = horizontalOffset;
      needsRelayout = true;
    }
    if (renderObject._viewportSize != viewportSize) {
      renderObject._viewportSize = viewportSize;
      needsRelayout = true;
    }
    if (needsRelayout) {
      renderObject.markNeedsLayout();
    }
  }
}

/// Function that provides a [TableSize] for a given index.
///
/// Used to dynamically determine column widths or row heights based
/// on the column/row index. Enables different sizing strategies for
/// different parts of the table.
///
/// Example:
/// ```dart
/// TableSizeSupplier widthSupplier = (index) {
///   if (index == 0) return FixedTableSize(50);
///   return FlexTableSize(flex: 1);
/// };
/// ```
