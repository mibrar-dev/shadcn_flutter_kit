// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../pinned_sheet.dart';

/// Builder signature for pinned-sheet content (upstream parity).
typedef PinnedSheetBuilder = Widget Function(BuildContext context);

/// The context a [SheetStage] resolves against: the sheet's content [size],
/// the resolved edge [position], and the container's [dragHandleExtent]
/// (main-axis pixels occupied by the drag handle, including its gaps; 0
/// when there is no handle). Upstream parity.
class SheetStageResolution {
  /// The measured sheet content size.
  final Size size;

  /// The resolved edge position (never start/end).
  final OverlayPosition position;

  /// The main-axis extent of the drag handle (+ gaps); 0 when there is none.
  final double dragHandleExtent;

  /// Creates a resolution context.
  const SheetStageResolution({
    required this.size,
    required this.position,
    this.dragHandleExtent = 0,
  });

  /// The extent of the sheet along its drag axis.
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

double _fallbackBackdropTransform(SheetStage stage, SheetStageResolution res) {
  final axis = res.axisExtent;
  if (axis <= 0) return 0;
  return (stage.resolveDragOffset(res) / axis).clamp(0.0, 1.0);
}

/// A snap position for a [PinnedSheet] (upstream parity).
///
/// A stage resolves to a *visible extent* (logical pixels) along the sheet's
/// axis ([resolveDragOffset]) and, independently, to a *backdrop transform*
/// value in `0..1` ([resolveBackdropTransform]). When a stage's explicit
/// `backdropTransform` is null it falls back to the stage's normalized
/// expansion (offset / axis extent).
///
/// Stages support arithmetic so you can express derived snap points:
///
/// ```dart
/// SheetStage.expanded() - SheetStage.fixed(100); // 100px short of full
/// SheetStage.expanded() * 0.9;                    // 90% of full
/// SheetStage.fixed(100) + SheetStage.fraction(0.5);
/// ```
///
/// Built-in stages: [SheetStage.closed], [SheetStage.expanded],
/// [SheetStage.fixed], [SheetStage.fraction], [SheetStage.peekDragHandle].
abstract class SheetStage {
  /// Const constructor for subclasses.
  const SheetStage();

  /// A fully-hidden stage (offset 0).
  const factory SheetStage.closed({double? backdropTransform}) =
      ClosedSheetStage;

  /// A fully-shown stage (offset == the full axis extent).
  const factory SheetStage.expanded({double? backdropTransform}) =
      ExpandedSheetStage;

  /// A stage pinned at a fixed number of logical pixels from the edge.
  const factory SheetStage.fixed(double offset, {double? backdropTransform}) =
      FixedSheetStage;

  /// A stage pinned at a [fraction] (0..1) of the sheet's axis extent.
  const factory SheetStage.fraction(
    double fraction, {
    double? backdropTransform,
  }) = FractionSheetStage;

  /// A stage that peeks only the drag handle. For containers without a drag
  /// handle the handle extent is 0, so this behaves like [SheetStage.closed].
  const factory SheetStage.peekDragHandle({double? backdropTransform}) =
      PeekDragHandleSheetStage;

  /// The visible extent (logical pixels) this stage resolves to.
  double resolveDragOffset(SheetStageResolution resolution);

  /// The backdrop transform value (0..1) this stage resolves to.
  double resolveBackdropTransform(SheetStageResolution resolution);

  /// Sum of two stages (offsets and backdrop transforms are added).
  SheetStage operator +(SheetStage other) => AdditiveSheetStage(this, other);

  /// Difference of two stages (offsets and backdrop transforms subtracted).
  SheetStage operator -(SheetStage other) => SubtractedSheetStage(this, other);

  /// Scales this stage's offset and backdrop transform by [factor].
  SheetStage operator *(double factor) => MultipliedSheetStage(this, factor);

  /// Divides this stage's offset and backdrop transform by [factor].
  SheetStage operator /(double factor) => DividedSheetStage(this, factor);

  @override
  bool operator ==(Object other) {
    // When compared against a live controller stage, borrow its attached
    // state to resolve this stage and compare the actual pixel offsets.
    if (other is _AttachedSheetStage) {
      return other == this;
    }
    return identical(this, other);
  }

  @override
  int get hashCode => identityHashCode(this);
}

/// A [SheetStage] that is fully hidden (upstream parity).
class ClosedSheetStage extends SheetStage {
  /// Explicit backdrop transform for this stage; null falls back to expansion.
  final double? backdropTransform;

  /// Creates a closed stage.
  const ClosedSheetStage({this.backdropTransform});

  @override
  double resolveDragOffset(SheetStageResolution resolution) => 0;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdropTransform(this, resolution);
}

/// A [SheetStage] that is fully expanded (upstream parity).
class ExpandedSheetStage extends SheetStage {
  /// Explicit backdrop transform for this stage; null falls back to expansion.
  final double? backdropTransform;

  /// Creates an expanded stage.
  const ExpandedSheetStage({this.backdropTransform});

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      resolution.axisExtent;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdropTransform(this, resolution);
}

/// A [SheetStage] pinned at a fixed number of logical pixels (upstream parity).
class FixedSheetStage extends SheetStage {
  /// The pixel offset from the closed edge.
  final double offset;

  /// Explicit backdrop transform for this stage; null falls back to expansion.
  final double? backdropTransform;

  /// Creates a fixed-offset stage.
  const FixedSheetStage(this.offset, {this.backdropTransform});

  @override
  double resolveDragOffset(SheetStageResolution resolution) {
    final extent = resolution.axisExtent;
    return offset < extent ? offset : extent;
  }

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdropTransform(this, resolution);
}

/// A [SheetStage] pinned at a fraction of the sheet's axis extent
/// (upstream parity).
class FractionSheetStage extends SheetStage {
  /// The fraction (0..1) of the axis extent.
  final double fraction;

  /// Explicit backdrop transform for this stage; null falls back to expansion.
  final double? backdropTransform;

  /// Creates a fractional stage.
  const FractionSheetStage(this.fraction, {this.backdropTransform});

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      resolution.axisExtent * fraction;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdropTransform(this, resolution);
}

/// A [SheetStage] that peeks only the drag handle (upstream parity).
class PeekDragHandleSheetStage extends SheetStage {
  /// Explicit backdrop transform for this stage; null falls back to expansion.
  final double? backdropTransform;

  /// Creates a peek-drag-handle stage.
  const PeekDragHandleSheetStage({this.backdropTransform});

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      resolution.dragHandleExtent;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      backdropTransform ?? _fallbackBackdropTransform(this, resolution);
}

/// Sum of two stages (upstream parity).
class AdditiveSheetStage extends SheetStage {
  /// The left operand.
  final SheetStage a;

  /// The right operand.
  final SheetStage b;

  /// Creates an additive stage.
  const AdditiveSheetStage(this.a, this.b);

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      a.resolveDragOffset(resolution) + b.resolveDragOffset(resolution);

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      a.resolveBackdropTransform(resolution) +
      b.resolveBackdropTransform(resolution);
}

/// Difference of two stages (upstream parity).
class SubtractedSheetStage extends SheetStage {
  /// The left operand.
  final SheetStage a;

  /// The right operand.
  final SheetStage b;

  /// Creates a subtracted stage.
  const SubtractedSheetStage(this.a, this.b);

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      a.resolveDragOffset(resolution) - b.resolveDragOffset(resolution);

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      a.resolveBackdropTransform(resolution) -
      b.resolveBackdropTransform(resolution);
}

/// A stage scaled by a scalar [factor] (upstream parity).
class MultipliedSheetStage extends SheetStage {
  /// The operand.
  final SheetStage stage;

  /// The scalar factor.
  final double factor;

  /// Creates a multiplied stage.
  const MultipliedSheetStage(this.stage, this.factor);

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      stage.resolveDragOffset(resolution) * factor;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      stage.resolveBackdropTransform(resolution) * factor;
}

/// A stage divided by a scalar [factor] (upstream parity).
class DividedSheetStage extends SheetStage {
  /// The operand.
  final SheetStage stage;

  /// The scalar divisor.
  final double factor;

  /// Creates a divided stage.
  const DividedSheetStage(this.stage, this.factor);

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      stage.resolveDragOffset(resolution) / factor;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      stage.resolveBackdropTransform(resolution) / factor;
}

/// A live stage bound to a [PinnedSheet]'s state, returned by
/// [SheetController.stage] (upstream parity).
///
/// Comparing it to another [SheetStage] resolves both against the sheet's
/// current geometry and compares the pixel offsets, so
/// `controller.stage == (SheetStage.expanded() - SheetStage.fixed(100))`
/// works.
class _AttachedSheetStage extends SheetStage {
  final _PinnedSheetState _state;

  const _AttachedSheetStage(this._state);

  @override
  double resolveDragOffset(SheetStageResolution resolution) =>
      _state.currentOffset;

  @override
  double resolveBackdropTransform(SheetStageResolution resolution) =>
      _state.currentBackdropTransform;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is _AttachedSheetStage) {
      return identical(_state, other._state);
    }
    if (other is SheetStage) {
      final resolution = _state.resolution;
      final current = _state.currentOffset;
      final target = other.resolveDragOffset(resolution);
      return (current - target).abs() < 0.5;
    }
    return false;
  }

  @override
  int get hashCode => identityHashCode(_state);
}
