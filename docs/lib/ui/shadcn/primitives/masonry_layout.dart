// `MasonryLayout`: a staggered grid. Children are laid out one by one into the
// currently **shortest** column, so cards of different heights pack tightly and
// no row ever forces its members to a shared height.
//
// The alternatives fall short: a `Wrap` (or `GridView`) sizes every child of a
// row to the tallest one and leaves uneven gaps, while a `Column`-per-column
// `Row` answers no intrinsic queries, does not mirror itself in RTL, and makes
// the caller distribute the children by hand. This render box packs the children
// itself, answers intrinsics, mirrors the column order under `rtl`, and works
// inside a scroll view (it never assumes a bounded height).

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A staggered grid: each child is placed in the shortest column.
///
/// ```dart
/// MasonryLayout.fixed(
///   crossAxisCount: 3,
///   mainAxisSpacing: 16,
///   crossAxisSpacing: 16,
///   children: <Widget>[cardA, cardB, cardC],
/// )
/// ```
///
/// [MasonryLayout.fixed] pins the column count; [MasonryLayout.responsive]
/// derives it from the incoming width with the same rule as
/// `SliverGridDelegateWithMaxCrossAxisExtent`.
class MasonryLayout extends MultiChildRenderObjectWidget {
  /// Creates a staggered grid with exactly [crossAxisCount] columns.
  const MasonryLayout.fixed({
    super.key,
    required super.children,
    required int crossAxisCount,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.textDirection,
  }) : assert(crossAxisCount >= 1, 'crossAxisCount must be at least 1'),
       crossAxisCount = crossAxisCount,
       maxCrossAxisExtent = null;

  /// Creates a staggered grid whose column count follows the incoming width,
  /// targeting columns of at most [maxCrossAxisExtent] logical pixels.
  const MasonryLayout.responsive({
    super.key,
    required super.children,
    required double maxCrossAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.textDirection,
  }) : assert(
         maxCrossAxisExtent >= 0,
         'maxCrossAxisExtent must not be negative',
       ),
       crossAxisCount = null,
       maxCrossAxisExtent = maxCrossAxisExtent;

  /// Fixed column count; null in the [MasonryLayout.responsive] form.
  final int? crossAxisCount;

  /// Target column width; null in the [MasonryLayout.fixed] form.
  final double? maxCrossAxisExtent;

  /// Space kept between two children stacked in one column.
  final double mainAxisSpacing;

  /// Space kept between two neighbouring columns.
  final double crossAxisSpacing;

  /// Direction the columns run in; null resolves `Directionality.of(context)`.
  final TextDirection? textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MasonryLayoutRender(
      crossAxisCount: crossAxisCount,
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      textDirection: textDirection ?? Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    MasonryLayoutRender renderObject,
  ) {
    // One batched write plus one relayout flag: the render box's configuration
    // only moves when the widget does, so per-field change detection would
    // only add bookkeeping.
    renderObject
      ..crossAxisCount = crossAxisCount
      ..maxCrossAxisExtent = maxCrossAxisExtent
      ..mainAxisSpacing = mainAxisSpacing
      ..crossAxisSpacing = crossAxisSpacing
      ..textDirection = textDirection ?? Directionality.maybeOf(context)
      ..markNeedsLayout();
  }
}

/// Parent data of a masonry child: the sibling link plus the chosen column.
class MasonryParentData extends ContainerBoxParentData<RenderBox> {
  /// Zero-based column this child was placed in.
  int column = 0;
}

/// The render box behind [MasonryLayout].
///
/// Pick the column count from [crossAxisCount] or the incoming width, lay every
/// child out at exactly the column width (its height is whatever the child
/// wants — nothing is stretched), then drop it into the shortest column. The
/// box is as tall as its tallest column, minus one row gap.
class MasonryLayoutRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MasonryParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MasonryParentData> {
  /// Creates the render box.
  MasonryLayoutRender({
    required this.crossAxisCount,
    required this.maxCrossAxisExtent,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.textDirection,
  });

  /// Fixed column count; null means "derive it from the incoming width".
  int? crossAxisCount;

  /// Target column width when the count is derived; null means "use the count".
  double? maxCrossAxisExtent;

  /// Space kept between two children stacked in one column.
  double mainAxisSpacing;

  /// Space kept between two neighbouring columns.
  double crossAxisSpacing;

  /// Direction the columns run in; null resolves `TextDirection.ltr`.
  TextDirection? textDirection;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! MasonryParentData) {
      child.parentData = MasonryParentData();
    }
  }

  /// Number of columns that fit [width].
  int columnsFor(double width) {
    final int? count = crossAxisCount;
    if (count != null) {
      return count;
    }
    // Same rule as `SliverGridDelegateWithMaxCrossAxisExtent`: round the
    // width up against one column *stride*, never below one column.
    return math.max(
      1,
      (width / (maxCrossAxisExtent! + crossAxisSpacing)).ceil(),
    );
  }

  /// Width of one column when [columnCount] of them share [width].
  double _columnWidthFor(double width, int columnCount) {
    return (width - crossAxisSpacing * (columnCount - 1)) / columnCount;
  }

  /// Leading-edge offset of [column] (index 0 is the leading edge).
  double _columnStart(int column, int columnCount, double columnWidth) {
    final int fromEdge = textDirection == TextDirection.rtl
        ? columnCount - 1 - column
        : column;
    return fromEdge * (columnWidth + crossAxisSpacing);
  }

  /// Index of the shortest column; the left-most one wins a tie.
  int _shortestColumn(List<double> heights) {
    int best = 0;
    for (int i = 1; i < heights.length; i++) {
      if (heights[i] < heights[best]) {
        best = i;
      }
    }
    return best;
  }

  /// Packs every child into the shortest column, writing the chosen column
  /// and the offset into each child's parent data. [heightOf] reads a child's
  /// height: `child.size.height` during layout, an intrinsic query during the
  /// intrinsic passes. Returns the tallest column, without the trailing gap.
  double _pack(
    int columnCount,
    double columnWidth,
    double Function(RenderBox) heightOf,
  ) {
    final List<double> columnHeights = List<double>.filled(columnCount, 0);
    RenderBox? child = firstChild;
    while (child != null) {
      final MasonryParentData data = child.parentData! as MasonryParentData;
      final int column = _shortestColumn(columnHeights);
      data.column = column;
      data.offset = Offset(
        _columnStart(column, columnCount, columnWidth),
        columnHeights[column],
      );
      columnHeights[column] += heightOf(child) + mainAxisSpacing;
      child = childAfter(child);
    }
    if (childCount == 0) {
      return 0;
    }
    return columnHeights.reduce(math.max) - mainAxisSpacing;
  }

  @override
  void performLayout() {
    if (!constraints.hasBoundedWidth) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('MasonryLayout was laid out with an unbounded width.'),
        ErrorDescription(
          'A masonry needs a finite width to size its columns. Give it one '
          'with a SizedBox, a ConstrainedBox, a scroll view, or by placing it '
          'in the page itself — not inside an unbounded Row.',
        ),
        DiagnosticsProperty<BoxConstraints>(
          'constraints',
          constraints,
          style: DiagnosticsTreeStyle.errorProperty,
        ),
      ]);
    }
    final double width = constraints.maxWidth;
    final int columnCount = math.min(
      columnsFor(width),
      math.max(1, childCount),
    );
    final double columnWidth = _columnWidthFor(width, columnCount);
    final BoxConstraints childConstraints = BoxConstraints(
      minWidth: columnWidth,
      maxWidth: columnWidth,
      minHeight: 0,
      maxHeight: constraints.maxHeight,
    );

    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      child = childAfter(child);
    }

    final double tallest = math.max(
      0,
      _pack(columnCount, columnWidth, (RenderBox c) => c.size.height),
    );
    size = constraints.constrain(Size(width, tallest));
  }

  // --- intrinsics -----------------------------------------------------------
  //
  // The masonry answers an intrinsic query by replaying the same packing with
  // intrinsic child sizes, so `IntrinsicHeight`/`IntrinsicWidth` (and any
  // `Row`/`Column` that asks) see the numbers a real layout would produce.
  // A height query needs a width to size the columns; when the caller passes
  // an infinite one, the masonry falls back to one column's worth of the
  // widest child, which is the narrowest layout that cannot overflow.

  @override
  double computeMinIntrinsicWidth(double height) =>
      _intrinsicWidth(height, true);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _intrinsicWidth(height, false);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _intrinsicHeight(width, true);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _intrinsicHeight(width, false);

  double _intrinsicWidth(double height, bool min) {
    if (childCount == 0) {
      return 0;
    }
    final double widest = _widestChild(
      (RenderBox c) =>
          min ? c.getMinIntrinsicWidth(height) : c.getMaxIntrinsicWidth(height),
    );
    final int? columnCount = crossAxisCount;
    if (columnCount == null) {
      // Responsive: the narrowest non-overflowing layout is one column.
      return widest;
    }
    return widest * columnCount + crossAxisSpacing * (columnCount - 1);
  }

  double _intrinsicHeight(double width, bool min) {
    if (childCount == 0) {
      return 0;
    }
    final double used = width.isFinite && width > 0
        ? width
        : _intrinsicWidth(double.infinity, min);
    final int columnCount = math.min(columnsFor(used), math.max(1, childCount));
    final double columnWidth = _columnWidthFor(used, columnCount);
    return math.max(
      0,
      _pack(columnCount, columnWidth, (RenderBox c) {
        return min
            ? c.getMinIntrinsicHeight(columnWidth)
            : c.getMaxIntrinsicHeight(columnWidth);
      }),
    );
  }

  /// The widest intrinsic width over all children.
  double _widestChild(double Function(RenderBox) widthOf) {
    double widest = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      widest = math.max(widest, widthOf(child));
      child = childAfter(child);
    }
    return widest;
  }

  // --- painting / hit testing / semantics -----------------------------------

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    // Reading order follows the packing — top to bottom, leading column
    // first. The framework's default walks the tree in child order, which is
    // the build order and not necessarily the visual one.
    for (final RenderBox child in _childrenInReadingOrder()) {
      visitor(child);
    }
  }

  List<RenderBox> _childrenInReadingOrder() {
    final List<(RenderBox, int, double)> placed = <(RenderBox, int, double)>[];
    RenderBox? child = firstChild;
    while (child != null) {
      final MasonryParentData data = child.parentData! as MasonryParentData;
      placed.add((child, data.column, data.offset.dy));
      child = childAfter(child);
    }
    placed.sort(
      ((RenderBox, int, double) a, (RenderBox, int, double) b) =>
          a.$2 != b.$2 ? a.$2 - b.$2 : a.$3.compareTo(b.$3),
    );
    return placed.map(((RenderBox, int, double) e) => e.$1).toList();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('crossAxisCount', crossAxisCount));
    properties.add(DoubleProperty('maxCrossAxisExtent', maxCrossAxisExtent));
    properties.add(DoubleProperty('mainAxisSpacing', mainAxisSpacing));
    properties.add(DoubleProperty('crossAxisSpacing', crossAxisSpacing));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
  }
}
