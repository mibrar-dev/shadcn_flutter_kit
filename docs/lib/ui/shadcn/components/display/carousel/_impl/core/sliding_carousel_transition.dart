// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// A sliding carousel transition.
class SlidingCarouselTransition extends CarouselTransition {
  /// The gap between the carousel items.
  final double gap;

  /// Creates a sliding carousel transition.
  const SlidingCarouselTransition({this.gap = 0});

  @override
  List<Widget> layout(
    BuildContext context, {
    required double progress,
    required BoxConstraints constraints,
    required CarouselAlignment alignment,
    required Axis direction,
    required CarouselSizeConstraint sizeConstraint,
    required double progressedIndex,
    required int? itemCount,
    required CarouselItemBuilder itemBuilder,
    required bool wrap,
    required bool reverse,
  }) {
    int additionalPreviousItems = 1;

    int additionalNextItems = 1;
    double originalSize = direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    double size;
    if (sizeConstraint is CarouselFixedConstraint) {
      size = sizeConstraint.size;
    } else if (sizeConstraint is CarouselFractionalConstraint) {
      size = originalSize * sizeConstraint.fraction;
    } else {
      size = originalSize;
    }

    double snapOffsetAlignment = (originalSize - size) * alignment.alignment;

    double gapBeforeItem = snapOffsetAlignment;

    double gapAfterItem = originalSize - size - gapBeforeItem;
    additionalPreviousItems += max(0, (gapBeforeItem / size).ceil());
    additionalNextItems += max(0, (gapAfterItem / size).ceil());

    List<_PlacedCarouselItem> items = [];

    int start = progressedIndex.floor() - additionalPreviousItems;

    int end = progressedIndex.floor() + additionalNextItems;
    if (!wrap && itemCount != null) {
      start = start.clamp(0, itemCount - 1);
      end = end.clamp(0, itemCount - 1);
    }

    double currentIndex = progressedIndex + (gap / size) * progressedIndex;
    for (int i = start; i <= end; i++) {
      double index;
      if (itemCount != null) {
        index = wrapDouble(i.toDouble(), 0.0, itemCount.toDouble());
      } else {
        index = i.toDouble();
      }

      var itemIndex = reverse ? (-index).toInt() : index.toInt();

      final item = itemBuilder(context, itemIndex);

      double position = i.toDouble();

      items.add(
        _PlacedCarouselItem._(
          relativeIndex: i,
          child: item,
          position: position,
        ),
      );
    }
    if (direction == Axis.horizontal) {
      return [
        for (var item in items)
          Positioned(
            left:
                snapOffsetAlignment +
                (item.position - currentIndex) * size +
                (gap * item.relativeIndex),
            width: size,
            height: constraints.maxHeight,
            child: item.child,
          ),
      ];
    } else {
      return [
        for (var item in items)
          Positioned(
            top:
                snapOffsetAlignment +
                (item.position - currentIndex) * size +
                (gap * item.relativeIndex),
            width: constraints.maxWidth,
            height: size,
            child: item.child,
          ),
      ];
    }
  }
}
