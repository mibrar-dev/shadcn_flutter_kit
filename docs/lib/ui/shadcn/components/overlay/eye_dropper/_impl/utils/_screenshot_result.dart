// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// _ScreenshotResult defines a reusable type for this registry module.
class _ScreenshotResult {
  /// Stores `colors` state/configuration for this implementation.
  final List<Color> colors;

  /// Stores `size` state/configuration for this implementation.
  final Size size;

  /// Stores `image` state/configuration for this implementation.
  final ImageProvider? image;

  _ScreenshotResult(this.colors, this.size, this.image);

  /// Executes `operator []` behavior for this component/composite.
  Color operator [](Offset position) {
    int index = (position.dy.floor() * size.width + position.dx.floor())
        .toInt();
    return colors[index];
  }
}
