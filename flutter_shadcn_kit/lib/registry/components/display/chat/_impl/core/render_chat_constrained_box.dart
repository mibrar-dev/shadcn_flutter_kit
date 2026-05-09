// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// A render object that constrains the width of its child and aligns it.
///
/// This render object implements the layout logic for [ChatConstrainedBox].
class RenderChatConstrainedBox extends RenderShiftedBox {
  /// Layout/size setting that affects chat rendering.
  double _widthFactor;

  /// Controls how chat content is aligned within available space.
  AxisAlignment _alignment;

  /// Creates a [RenderChatConstrainedBox].
  ///
  /// Parameters:
  /// - [widthFactor] (`double`, required): The fraction of the available width that the child should occupy.
  /// - [alignment] (`AxisAlignment`, required): The alignment of the child within the available space.
  /// - [child] (`RenderBox?`, optional): The child render object.
  RenderChatConstrainedBox({
    required double widthFactor,
    required AxisAlignment alignment,
    RenderBox? child,
  }) : _widthFactor = widthFactor,
       _alignment = alignment,
       super(child);

  /// The fraction of the available width that the child should occupy.
  double get widthFactor => _widthFactor;

  /// The alignment of the child within the available space.
  AxisAlignment get alignment => _alignment;

  /// Sets the width factor.
  set widthFactor(double value) {
    if (_widthFactor != value) {
      _widthFactor = value;
      markNeedsLayout();
    }
  }

  /// Sets the alignment.
  set alignment(AxisAlignment value) {
    if (_alignment != value) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  /// Implements `performLayout` behavior for chat.
  @override
  void performLayout() {
    if (child == null) {
      size = this.constraints.smallest;
      return;
    }

    var constraints = this.constraints;

    var newMaxWidth = constraints.maxWidth * _widthFactor;
    constraints = constraints.copyWith(maxWidth: newMaxWidth, minWidth: 0);
    child!.layout(constraints, parentUsesSize: true);
    size = this.constraints.constrain(
      Size(this.constraints.maxWidth, child!.size.height),
    );
    double x = _alignment.alongValue(
      Axis.horizontal,
      this.constraints.maxWidth - child!.size.width,
    );

    final data = child!.parentData as BoxParentData;
    data.offset = Offset(x, 0);
  }

  /// Implements `computeDryLayout` behavior for chat.
  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (child == null) {
      return constraints.smallest;
    }

    var newMaxWidth = constraints.maxWidth * _widthFactor;
    var newConstraints = constraints.copyWith(
      maxWidth: newMaxWidth,
      minWidth: 0,
    );
    Size childSize = child!.getDryLayout(newConstraints);
    return constraints.constrain(Size(constraints.maxWidth, childSize.height));
  }

  /// Implements `computeMaxIntrinsicHeight` behavior for chat.
  @override
  double computeMaxIntrinsicHeight(double width) {
    return super.computeMaxIntrinsicHeight(width * _widthFactor);
  }

  /// Implements `computeMinIntrinsicHeight` behavior for chat.
  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(width * _widthFactor);
  }
}
