// Sheet snap stages: the position math behind [PinnedSheet] snap points.
//
// Lives in `primitives/` (like `drag_sort` position math) so the stage model
// stays yours-free of widget code: pure extents, fractions and arithmetic.

import 'package:flutter/widgets.dart';

import 'drawer_route/drawer_route.dart' show OverlayPosition;

/// Snap position for a [PinnedSheet]: a visible extent along the sheet's
/// axis plus, independently, a backdrop-transform value in `0..1`.
///
/// ```dart
/// SheetStage.expanded() - SheetStage.fixed(100); // 100px short of full
/// SheetStage.expanded() * 0.9; // 90% of full
/// ```
abstract class SheetStage {
  /// Const constructor for subclasses.
  const SheetStage();

  /// Fully hidden (offset 0).
  const factory SheetStage.closed({double? backdropTransform}) =
      ClosedSheetStage;

  /// Fully shown (offset == the full axis extent).
  const factory SheetStage.expanded({double? backdropTransform}) =
      ExpandedSheetStage;

  /// Pinned at [offset] logical pixels from the edge.
  const factory SheetStage.fixed(double offset, {double? backdropTransform}) =
      FixedSheetStage;

  /// Pinned at [fraction] (0..1) of the axis extent.
  const factory SheetStage.fraction(
    double fraction, {
    double? backdropTransform,
  }) = FractionSheetStage;

  /// Peeks only the drag handle; behaves like closed without a handle.
  const factory SheetStage.peekDragHandle({double? backdropTransform}) =
      PeekDragHandleSheetStage;

  /// Live stage bound to a sheet's current position (built by controllers).
  factory SheetStage.live({
    required double Function() offset,
    required SheetStageResolution Function() resolution,
    required double Function() backdrop,
  }) => _LiveSheetStage(
    offset: offset,
    resolution: resolution,
    backdrop: backdrop,
  );

  /// Visible extent in logical pixels this stage resolves to.
  double resolveDragOffset(SheetStageResolution resolution);

  /// Backdrop-transform value (0..1) this stage resolves to.
  double resolveBackdropTransform(SheetStageResolution resolution);

  /// Sum of two stages.
  SheetStage operator +(SheetStage other) => AdditiveSheetStage(this, other);

  /// Difference of two stages.
  SheetStage operator -(SheetStage other) => SubtractedSheetStage(this, other);

  /// Scales offset and backdrop transform by [factor].
  SheetStage operator *(double factor) => MultipliedSheetStage(this, factor);

  /// Divides offset and backdrop transform by [factor].
  SheetStage operator /(double factor) => DividedSheetStage(this, factor);

  @override
  bool operator ==(Object other) {
    if (other is _LiveSheetStage) return other == this;
    return identical(this, other);
  }

  @override
  int get hashCode => identityHashCode(this);
}

/// The context a [SheetStage] resolves against.
class SheetStageResolution {
  /// Creates a resolution context.
  const SheetStageResolution({
    required this.size,
    required this.position,
    this.dragHandleExtent = 0,
  });

  /// Measured sheet content size.
  final Size size;

  /// Resolved edge position (never start/end).
  final OverlayPosition position;

  /// Main-axis pixels of the drag handle (+ gaps); 0 without a handle.
  final double dragHandleExtent;

  /// Sheet extent along its drag axis.
  double get axisExtent {
    switch (position) {
      case OverlayPosition.top:
      case OverlayPosition.bottom:
        return size.height;
      default:
        return size.width;
    }
  }
}

double _fallbackBackdrop(SheetStage stage, SheetStageResolution res) {
  final axis = res.axisExtent;
  if (axis <= 0) return 0;
  return (stage.resolveDragOffset(res) / axis).clamp(0.0, 1.0);
}

/// Fully hidden stage.
class ClosedSheetStage extends SheetStage {
  /// Creates a closed stage.
  const ClosedSheetStage({this.backdropTransform});

  /// Explicit backdrop value; null falls back to normalized expansion.
  final double? backdropTransform;

  @override
  double resolveDragOffset(SheetStageResolution resolution) => 0;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdrop(this, resolution);
}

/// Fully shown stage.
class ExpandedSheetStage extends SheetStage {
  /// Creates an expanded stage.
  const ExpandedSheetStage({this.backdropTransform});

  /// Explicit backdrop value; null falls back to normalized expansion.
  final double? backdropTransform;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      resolution.axisExtent;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdrop(this, resolution);
}

/// Stage pinned at a fixed pixel offset.
class FixedSheetStage extends SheetStage {
  /// Creates a fixed stage.
  const FixedSheetStage(this.offset, {this.backdropTransform});

  /// Pixels from the closed edge.
  final double offset;

  /// Explicit backdrop value; null falls back to normalized expansion.
  final double? backdropTransform;

  @override
  double resolveDragOffset(SheetStageResolution resolution) {
    final extent = resolution.axisExtent;
    return offset < extent ? offset : extent;
  }

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdrop(this, resolution);
}

/// Stage pinned at a fraction of the axis extent.
class FractionSheetStage extends SheetStage {
  /// Creates a fractional stage.
  const FractionSheetStage(this.fraction, {this.backdropTransform});

  /// Fraction (0..1) of the axis extent.
  final double fraction;

  /// Explicit backdrop value; null falls back to normalized expansion.
  final double? backdropTransform;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      resolution.axisExtent * fraction;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdrop(this, resolution);
}

/// Stage peeking only the drag handle.
class PeekDragHandleSheetStage extends SheetStage {
  /// Creates a peek stage.
  const PeekDragHandleSheetStage({this.backdropTransform});

  /// Explicit backdrop value; null falls back to normalized expansion.
  final double? backdropTransform;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      resolution.dragHandleExtent;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdrop(this, resolution);
}

/// Sum of two stages.
class AdditiveSheetStage extends SheetStage {
  /// Creates an additive stage.
  const AdditiveSheetStage(this.a, this.b);

  /// Left operand.
  final SheetStage a;

  /// Right operand.
  final SheetStage b;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      a.resolveDragOffset(resolution) + b.resolveDragOffset(resolution);

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      a.resolveBackdropTransform(resolution) +
      b.resolveBackdropTransform(resolution);
}

/// Difference of two stages.
class SubtractedSheetStage extends SheetStage {
  /// Creates a subtracted stage.
  const SubtractedSheetStage(this.a, this.b);

  /// Left operand.
  final SheetStage a;

  /// Right operand.
  final SheetStage b;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      a.resolveDragOffset(resolution) - b.resolveDragOffset(resolution);

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      a.resolveBackdropTransform(resolution) -
      b.resolveBackdropTransform(resolution);
}

/// Stage scaled by [factor].
class MultipliedSheetStage extends SheetStage {
  /// Creates a multiplied stage.
  const MultipliedSheetStage(this.stage, this.factor);

  /// Operand.
  final SheetStage stage;

  /// Scalar factor.
  final double factor;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      stage.resolveDragOffset(resolution) * factor;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      stage.resolveBackdropTransform(resolution) * factor;
}

/// Stage divided by [factor].
class DividedSheetStage extends SheetStage {
  /// Creates a divided stage.
  const DividedSheetStage(this.stage, this.factor);

  /// Operand.
  final SheetStage stage;

  /// Scalar divisor.
  final double factor;

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      stage.resolveDragOffset(resolution) / factor;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      stage.resolveBackdropTransform(resolution) / factor;
}

/// Live stage bound to a sheet; `controller.stage == derived` resolves both
/// against current geometry and compares pixel offsets (within 0.5px).
/// Built through [SheetStage.live] so no widget type leaks into the model.
class _LiveSheetStage extends SheetStage {
  _LiveSheetStage({
    required this.offset,
    required this.resolution,
    required this.backdrop,
  });

  final double Function() offset;
  final SheetStageResolution Function() resolution;
  final double Function() backdrop;

  @override
  double resolveDragOffset(SheetStageResolution resolution) => offset();

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdrop();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is SheetStage) {
      return (offset() - other.resolveDragOffset(resolution())).abs() < 0.5;
    }
    return false;
  }

  @override
  int get hashCode => offset().hashCode;
}
