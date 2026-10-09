// The `image` component: a themed, rounded image slot with a placeholder while
// the bytes load and a caller-supplied error slot when they fail.
//
// The old `components/utility/image/` module had an **empty** entry file
// (`image.dart` held one suppress-all-lints pragma line and nothing else); the only
// thing it shipped was a Material preview. This is a real shadcn component:
// `aspect-square` + `rounded-lg` + `object-cover`, plus the loading/error slots
// the old preview hand-rolled with `CircularProgressIndicator` and
// `Icon(Icons.error)`.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'image_style.dart';

export 'image_style.dart';

/// Builds the widget shown when the image cannot be decoded.
///
/// The signature matches Flutter's `ImageErrorWidgetBuilder`, so a caller can
/// forward an existing builder unchanged.
typedef ImageErrorBuilder =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

/// A themed image.
///
/// ```dart
/// ShadcnImage(image: NetworkImage(url), width: 200, aspectRatio: 1)
/// ```
///
/// Give the widget at least one of [width], [height] or [aspectRatio]: with
/// none of them an unconstrained parent collapses the box to zero.
class ShadcnImage extends StatefulWidget {
  /// Creates a themed image.
  ///
  /// Named `ShadcnImage` rather than `Image`: Flutter's `widgets.dart` also
  /// exports an `Image`, and a file importing both would not compile without a
  /// prefix. The prefix follows the same rule as `ShadcnTheme`.
  const ShadcnImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.background,
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
    this.duration,
    this.scale = 1.0,
    this.alignment = Alignment.center,
    this.theme,
  }) : assert(
         width != null || height != null,
         'Image needs a width or a height; aspectRatio alone leaves one axis '
         'unbounded.',
       );

  /// The bytes to decode.
  final ImageProvider<Object> image;

  /// Box width; null derives it from [height]/[aspectRatio].
  final double? width;

  /// Box height; null derives it from [width]/[aspectRatio].
  final double? height;

  /// Width / height of the box; shadcn renders a square image.
  final double? aspectRatio;

  /// How the decoded image fills the box.
  final BoxFit fit;

  /// Corner radius override; null uses [ImageTheme.borderRadius] then
  /// `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Fill shown behind the image and as the default placeholder.
  final Color? background;

  /// Widget shown while the bytes load; null paints the background only.
  final Widget? placeholder;

  /// Widget shown when decoding fails; null keeps the background.
  final ImageErrorBuilder? errorBuilder;

  /// Accessible label; also marks the node as an image for screen readers.
  final String? semanticLabel;

  /// Fade-in duration; null uses [ImageTheme.duration].
  final Duration? duration;

  /// Logical-pixel scale of the decoded image.
  final double scale;

  /// Alignment of the decoded image inside the box.
  final AlignmentGeometry alignment;

  /// Widget-leg theme override, merged on top of the other legs.
  final ImageTheme? theme;

  @override
  State<ShadcnImage> createState() => _ShadcnImageState();
}

class _ShadcnImageState extends State<ShadcnImage> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  ImageInfo? _info;
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `createLocalImageConfiguration` reads MediaQuery/Directionality, so the
    // stream is resolved again whenever a dependency changes.
    _resolve();
  }

  @override
  void didUpdateWidget(covariant ShadcnImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _resolve();
    }
  }

  @override
  void dispose() {
    _detach();
    _info?.dispose();
    super.dispose();
  }

  void _detach() {
    final ImageStreamListener? listener = _listener;
    if (listener != null) {
      _stream?.removeListener(listener);
    }
    _listener = null;
    _stream = null;
  }

  void _resolve() {
    final ImageStream stream = widget.image.resolve(
      createLocalImageConfiguration(context),
    );
    if (stream.key == _stream?.key) {
      return;
    }
    _detach();
    _stream = stream;
    _info?.dispose();
    _info = null;
    _error = null;
    _stackTrace = null;
    final ImageStreamListener listener = ImageStreamListener(
      _onImage,
      onError: _onError,
    );
    _listener = listener;
    stream.addListener(listener);
  }

  void _onImage(ImageInfo info, bool synchronousCall) {
    if (!mounted) {
      info.dispose();
      return;
    }
    setState(() {
      _info?.dispose();
      _info = info;
      _error = null;
      _stackTrace = null;
    });
  }

  void _onError(Object error, StackTrace? stackTrace) {
    if (!mounted) {
      return;
    }
    setState(() {
      _info?.dispose();
      _info = null;
      _error = error;
      _stackTrace = stackTrace;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ImageTheme resolved = resolveComponentStyle<ImageTheme, ImageTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: imageDefaults,
    );
    final Color background =
        widget.background ??
        resolved.background?.resolve(theme.colors) ??
        theme.colors.muted;
    final BorderRadiusGeometry radius =
        widget.borderRadius ?? resolved.borderRadius ?? theme.borderRadiusLg;

    Widget content;
    final Widget? failure = _error == null
        ? null
        : widget.errorBuilder?.call(context, _error!, _stackTrace);
    if (failure != null) {
      content = failure;
    } else {
      // The picture layer is always present so it can fade in over whatever
      // placeholder the caller supplied.
      content = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (widget.placeholder != null) widget.placeholder!,
          AnimatedOpacity(
            opacity: _info == null ? 0 : 1,
            duration: widget.duration ?? resolved.duration!,
            child: RawImage(
              image: _info?.image,
              fit: widget.fit,
              scale: widget.scale,
              alignment: widget.alignment,
            ),
          ),
        ],
      );
    }

    Widget box = ClipRRect(borderRadius: radius, child: content);
    box = ColoredBox(color: background, child: box);
    box = Semantics(label: widget.semanticLabel, image: true, child: box);
    box = _size(box);
    return box;
  }

  Widget _size(Widget child) {
    final double? width = widget.width;
    final double? height = widget.height;
    final double? ratio = widget.aspectRatio;
    if (width != null && height != null) {
      return SizedBox(width: width, height: height, child: child);
    }
    if (width != null && ratio != null) {
      return SizedBox(width: width, height: width / ratio, child: child);
    }
    if (height != null && ratio != null) {
      return SizedBox(width: height * ratio, height: height, child: child);
    }
    return SizedBox(width: width, height: height, child: child);
  }
}
