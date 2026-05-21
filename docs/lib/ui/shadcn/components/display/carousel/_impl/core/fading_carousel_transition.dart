// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// A fading carousel transition.
class FadingCarouselTransition extends CarouselTransition {
  /// Creates a fading carousel transition.
  const FadingCarouselTransition();

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

    List<_PlacedCarouselItem> items = [];

    int start = progressedIndex.floor() - 1;

    int end = progressedIndex.floor() + 1;
    if (!wrap && itemCount != null) {
      start = start.clamp(0, itemCount - 1);
      end = end.clamp(0, itemCount - 1);
    }
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
            left: snapOffsetAlignment,
            width: size,
            height: constraints.maxHeight,
            child: Opacity(
              opacity: (1 - (progress - item.position).abs()).clamp(0.0, 1.0),
              child: item.child,
            ),
          ),
      ];
    } else {
      return [
        for (var item in items)
          Positioned(
            top: snapOffsetAlignment,
            width: constraints.maxWidth,
            height: size,
            child: Opacity(
              opacity: (1 - (progress - item.position).abs()).clamp(0.0, 1.0),
              child: item.child,
            ),
          ),
      ];
    }
  }
}
