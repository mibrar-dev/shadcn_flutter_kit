// @dart=3.13
// `OverlapLayout`: hangs a secondary child (a badge, a row of chips) over
// one corner of a primary child, keeps the pair tight around their union and
// aligns that union to a side of the incoming width.
//
// Ported from the old chat component's `_ChatReactionRenderObject`, minus the
// chat-specific theme so any component can hang a badge off a surface. It
// answers intrinsic queries (unlike the `LayoutBuilder` trick), so it works
// inside `IntrinsicHeight`/`IntrinsicWidth`.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Which corner of the primary child the overlap hangs from.
enum OverlapCorner { topLeft, topRight, bottomLeft, bottomRight }

/// Lays out [child] and [overlap] so the overlap sits over [corner], then
/// aligns the whole union to [alignment] inside the incoming width.
///
/// ```dart
/// OverlapLayout(
///   corner: OverlapCorner.bottomRight,
///   alignment: Alignment.centerRight,
///   gap: 8,
///   extraWidth: 8,
///   child: bubble,
///   overlap: const Text('👍 3'),
/// )
/// ```
class OverlapLayout extends MultiChildRenderObjectWidget {
  /// Creates an overlap layout with [child] first and [overlap] second.
  OverlapLayout({
    super.key,
    required this.child,
    required this.overlap,
    required this.corner,
    required this.alignment,
    this.gap = 8,
    this.extraWidth = 8,
  }) : super(children: <Widget>[child, overlap]);

  /// The primary child (a bubble, a card).
  final Widget child;

  /// The badge/chips hung over the corner.
  final Widget overlap;

  /// Corner the overlap hangs from.
  final OverlapCorner corner;

  /// Side of the incoming width the union is aligned to.
  final Alignment alignment;

  /// Distance kept between the overlap and the bubble's edges.
  final double gap;

  /// Extra width the primary child keeps when the overlap is wider than it.
  final double extraWidth;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return OverlapLayoutRender(
      corner: corner,
      alignment: alignment,
      gap: gap,
      extraWidth: extraWidth,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    OverlapLayoutRender renderObject,
  ) {
    renderObject
      ..corner = corner
      ..alignment = alignment
      ..gap = gap
      ..extraWidth = extraWidth;
  }
}

/// Two-child render box: [firstChild] is the primary child, the next sibling
/// is the overlap.
/// Parent data of both children: a box parent data with a next sibling.
class OverlapParentData extends ContainerBoxParentData<RenderBox> {}

/// The two-child render box behind [OverlapLayout]: [firstChild] is the
/// primary child, the next sibling is the overlap.
class OverlapLayoutRender extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        > {
  /// Creates the overlap render box.
  OverlapLayoutRender({
    required this._corner,
    required this._alignment,
    required this._gap,
    required this._extraWidth,
  });

  OverlapCorner _corner;
  Alignment _alignment;
  double _gap;
  double _extraWidth;

  /// Corner the overlap hangs from.
  set corner(OverlapCorner value) {
    if (value == _corner) return;
    _corner = value;
    markNeedsLayout();
  }

  /// Side the union is aligned to.
  set alignment(Alignment value) {
    if (value == _alignment) return;
    _alignment = value;
    markNeedsLayout();
  }

  /// Distance between overlap and primary edges.
  set gap(double value) {
    if (value == _gap) return;
    _gap = value;
    markNeedsLayout();
  }

  /// Extra width kept when the overlap is wider.
  set extraWidth(double value) {
    if (value == _extraWidth) return;
    _extraWidth = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! OverlapParentData) {
      child.parentData = OverlapParentData();
    }
  }

  RenderBox? get _base => firstChild;
  RenderBox? get _overlap =>
      firstChild == null ? null : childAfter(firstChild!);

  /// The primary child's own constraints: exactly [width] wide, keeping the
  /// incoming cross-axis bounds. (`constraints.tighten` would clamp [width]
  /// up to the parent's minimum — e.g. a tight row — so it is not used.)
  BoxConstraints _baseConstraints(BoxConstraints constraints, double width) {
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  /// Where the overlap sits relative to the primary child's top-left.
  Offset _overlapOffset(Size baseSize, Size overlapSize) {
    return switch (_corner) {
      OverlapCorner.topLeft => Offset(_gap, _gap - overlapSize.height),
      OverlapCorner.topRight => Offset(
        baseSize.width - overlapSize.width - _gap,
        _gap - overlapSize.height,
      ),
      OverlapCorner.bottomLeft => Offset(_gap, baseSize.height - _gap),
      OverlapCorner.bottomRight => Offset(
        baseSize.width - overlapSize.width - _gap,
        baseSize.height - _gap,
      ),
    };
  }

  @override
  void performLayout() {
    final RenderBox? base = _base;
    final RenderBox? overlap = _overlap;
    if (base == null || overlap == null) {
      size = constraints.smallest;
      return;
    }
    overlap.layout(constraints.loosen(), parentUsesSize: true);
    final Size overlapSize = overlap.size;
    final double baseWidth = math.max(
      base.getMaxIntrinsicWidth(double.infinity),
      overlapSize.width + _extraWidth,
    );
    base.layout(_baseConstraints(constraints, baseWidth), parentUsesSize: true);
    final Size baseSize = base.size;

    final Offset overlapOffset = _overlapOffset(baseSize, overlapSize);
    final Rect union = (Offset.zero & baseSize).expandToInclude(
      overlapOffset & overlapSize,
    );
    Offset shift = -union.topLeft;
    double width;
    if (constraints.hasBoundedWidth) {
      width = constraints.maxWidth;
      final double extent = width - union.width;
      shift += Offset((_alignment.x + 1) / 2 * extent, 0);
    } else {
      width = union.width;
    }
    (base.parentData! as ContainerBoxParentData<RenderBox>).offset = shift;
    (overlap.parentData! as ContainerBoxParentData<RenderBox>).offset =
        overlapOffset + shift;
    size = constraints.constrain(Size(width, union.height));
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final RenderBox? base = _base;
    final RenderBox? overlap = _overlap;
    if (base == null || overlap == null) {
      return constraints.smallest;
    }
    final Size overlapSize = overlap.getDryLayout(constraints.loosen());
    final double baseWidth = math.max(
      base.getMaxIntrinsicWidth(double.infinity),
      overlapSize.width + _extraWidth,
    );
    final Size baseSize = base.getDryLayout(
      _baseConstraints(constraints, baseWidth),
    );
    final Rect union = (Offset.zero & baseSize).expandToInclude(
      _overlapOffset(baseSize, overlapSize) & overlapSize,
    );
    final double width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : union.width;
    return constraints.constrain(Size(width, union.height));
  }

  // The union's horizontal extent is the wider of the two children (the
  // overlap widens the base when it sticks out); vertically the overlap
  // protrudes by its own extent minus the gap.
  @override
  double computeMinIntrinsicWidth(double height) {
    return math.max(
      _base?.getMinIntrinsicWidth(height) ?? 0,
      (_overlap?.getMinIntrinsicWidth(height) ?? 0) + _extraWidth,
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return math.max(
      _base?.getMaxIntrinsicWidth(height) ?? 0,
      (_overlap?.getMaxIntrinsicWidth(height) ?? 0) + _extraWidth,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return (_base?.getMinIntrinsicHeight(width) ?? 0) + _protrusion(false);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return (_base?.getMaxIntrinsicHeight(width) ?? 0) + _protrusion(true);
  }

  double _protrusion(bool max) {
    final RenderBox? overlap = _overlap;
    if (overlap == null) return 0;
    final double extent = max
        ? overlap.getMaxIntrinsicHeight(double.infinity)
        : overlap.getMinIntrinsicHeight(double.infinity);
    return math.max(0, extent - _gap);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
