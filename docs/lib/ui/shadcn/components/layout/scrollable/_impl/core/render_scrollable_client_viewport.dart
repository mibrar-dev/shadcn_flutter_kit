// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scrollable.dart';

/// Render object for [ScrollableClientViewport].
///
/// Manages the two-dimensional viewport rendering with overscroll support.
class RenderScrollableClientViewport extends RenderTwoDimensionalViewport {
  /// Whether overscroll effects are enabled.
  final bool overscroll;

  /// Creates a [RenderScrollableClientViewport].
  RenderScrollableClientViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
    required this.overscroll,
  });

  @override
  /// Executes `layoutChildSequence` behavior for this component/composite.
  void layoutChildSequence() {
    /// Stores `horizontalPixels` state/configuration for this implementation.
    var horizontalPixels = horizontalOffset.pixels;

    /// Stores `verticalPixels` state/configuration for this implementation.
    var verticalPixels = verticalOffset.pixels;

    /// Stores `viewportDimension` state/configuration for this implementation.
    final viewportDimension = this.viewportDimension;
    final vicinity = _ScrollableClientChildVicinity(
      viewportSize: viewportDimension,
      xIndex: 0,
      yIndex: 0,
    );
    final child = buildOrObtainChildFor(vicinity)!;

    /// Creates a `child.layout` instance.
    child.layout(
      /// Creates a `BoxConstraints` instance.
      BoxConstraints(
        minWidth: constraints.maxWidth,
        minHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );

    if (!overscroll) {
      horizontalPixels = max(0.0, horizontalPixels);
      verticalPixels = max(0.0, verticalPixels);

      /// Stores `maxHorizontalPixels` state/configuration for this implementation.
      final maxHorizontalPixels = child.size.width - viewportDimension.width;

      /// Stores `maxVerticalPixels` state/configuration for this implementation.
      final maxVerticalPixels = child.size.height - viewportDimension.height;
      horizontalPixels = min(horizontalPixels, maxHorizontalPixels);
      verticalPixels = min(verticalPixels, maxVerticalPixels);
    }

    /// Creates a `parentDataOf` instance.
    parentDataOf(child).layoutOffset = Offset(
      -horizontalPixels,
      -verticalPixels,
    );

    /// Creates a `horizontalOffset.applyContentDimensions` instance.
    horizontalOffset.applyContentDimensions(
      0,
      (child.size.width - viewportDimension.width).clamp(0.0, double.infinity),
    );

    /// Creates a `verticalOffset.applyContentDimensions` instance.
    verticalOffset.applyContentDimensions(
      0,
      (child.size.height - viewportDimension.height).clamp(
        0.0,
        double.infinity,
      ),
    );
    horizontalOffset.applyViewportDimension(viewportDimension.width);
    verticalOffset.applyViewportDimension(viewportDimension.height);
  }
}
