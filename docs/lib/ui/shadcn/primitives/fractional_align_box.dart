// @dart=3.13
// `FractionalAlignBox`: lays its child out at most `[factor]` of the
// available width, then aligns the (naturally sized) child inside its own
// box.
//
// The widget-tree equivalent would be `LayoutBuilder` + `Align` +
// `ConstrainedBox`, but a `LayoutBuilder` refuses intrinsic queries, so a
// tree containing one cannot sit inside `IntrinsicHeight`/`IntrinsicWidth`
// (or any `Row`/`Column` that asks). This render box answers intrinsics by
// forwarding them to the child, like a plain box would.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Constrains the child to a share of the available width and aligns it.
///
/// ```dart
/// FractionalAlignBox(
///   factor: 0.5,
///   alignment: AlignmentDirectional.centerEnd.resolve(textDirection),
///   child: const Text('at most half as wide as the row'),
/// )
/// ```
class FractionalAlignBox extends SingleChildRenderObjectWidget {
  /// Creates a fraction-limited, aligned box.
  const FractionalAlignBox({
    super.key,
    required this.factor,
    required this.alignment,
    required super.child,
  });

  /// Share of the incoming width the child may use (`0..1`). A non-finite
  /// incoming width (unbounded rows) ignores the factor.
  final double factor;

  /// Where the child sits inside the box; resolved against the ambient
  /// direction.
  final AlignmentGeometry alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return FractionalAlignBoxRender(
      factor: factor,
      alignment: alignment.resolve(Directionality.of(context)),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    FractionalAlignBoxRender renderObject,
  ) {
    renderObject
      ..factor = factor
      ..alignment = alignment.resolve(Directionality.of(context));
  }
}

/// The render box behind [FractionalAlignBox]: lays the child out under
/// `maxWidth * factor`, sizes itself from the constraints and positions the
/// child with the resolved alignment.
class FractionalAlignBoxRender extends RenderShiftedBox {
  /// Creates the render box.
  FractionalAlignBoxRender({
    required this._factor,
    required this._alignment,
    RenderBox? child,
  }) : super(child);

  double _factor;
  Alignment _alignment;

  /// Share of the incoming width the child may use.
  double get factor => _factor;
  set factor(double value) {
    if (value == _factor) return;
    _factor = value;
    markNeedsLayout();
  }

  /// Position of the child inside this box.
  Alignment get alignment => _alignment;
  set alignment(Alignment value) {
    if (value == _alignment) return;
    _alignment = value;
    markNeedsLayout();
  }

  BoxConstraints _childConstraints(BoxConstraints constraints) {
    final double maxWidth = constraints.maxWidth;
    return constraints.copyWith(
      minWidth: 0,
      maxWidth: maxWidth.isFinite ? maxWidth * _factor : double.infinity,
    );
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(child.size);
    final Offset delta = Offset(
      size.width - child.size.width,
      size.height - child.size.height,
    );
    (child.parentData! as BoxParentData).offset = _alignment.alongOffset(delta);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final RenderBox? child = this.child;
    if (child == null) {
      return constraints.smallest;
    }
    return constraints.constrain(
      child.getDryLayout(_childConstraints(constraints)),
    );
  }

  // Intrinsics forward to the child (uncapped): a fraction of the *available*
  // width is not knowable from an intrinsic query alone.
}
