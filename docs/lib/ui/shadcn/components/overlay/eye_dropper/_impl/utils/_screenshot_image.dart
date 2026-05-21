// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// _ScreenshotImage defines a reusable type for this registry module.
class _ScreenshotImage extends ImageProvider<_ScreenshotImage> {
  _ScreenshotImage(this.bytes, this.width, this.height, this.format);

  /// Stores `bytes` state/configuration for this implementation.
  final Uint8List bytes;

  /// Stores `width` state/configuration for this implementation.
  final int width;

  /// Stores `height` state/configuration for this implementation.
  final int height;
  final ui.PixelFormat format;

  @override
  /// Executes `obtainKey` behavior for this component/composite.
  Future<_ScreenshotImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_ScreenshotImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _ScreenshotImage key,
    ImageDecoderCallback decode,
  ) {
    Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(bytes, width, height, format, completer.complete);
    return OneFrameImageStreamCompleter(
      completer.future.then((ui.Image image) => ImageInfo(image: image)),
    );
  }
}
