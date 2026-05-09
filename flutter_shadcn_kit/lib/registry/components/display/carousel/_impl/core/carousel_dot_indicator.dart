// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// A dot indicator for the carousel.
class CarouselDotIndicator extends StatelessWidget {
  /// The item count of the carousel.
  final int itemCount;

  /// The carousel controller.
  final CarouselController controller;

  /// The speed of the value change.
  final Duration speed;

  /// The curve of the value change.
  final Curve curve;

  /// Creates a dot indicator for the carousel.
  const CarouselDotIndicator({
    super.key,
    required this.itemCount,
    required this.controller,
    this.speed = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  /// Builds the widget tree for carousel.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        int value = controller.value.round() % itemCount;
        if (value < 0) {
          value += itemCount;
        }
        return DotIndicator(
          index: value,
          length: itemCount,
          onChanged: (value) {
            controller.animateTo(value.toDouble(), speed, curve);
          },
        );
      },
    );
  }
}
