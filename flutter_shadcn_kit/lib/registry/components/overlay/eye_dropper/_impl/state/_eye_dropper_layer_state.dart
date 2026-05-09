// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// _EyeDropperLayerState defines a reusable type for this registry module.
class _EyeDropperLayerState extends State<EyeDropperLayer>
    implements EyeDropperLayerScope {
  final GlobalKey _repaintKey = GlobalKey();

  /// Stores `_currentPicking` state/configuration for this implementation.
  _ScreenshotResult? _currentPicking;

  /// Stores `_preview` state/configuration for this implementation.
  EyeDropperResult? _preview;

  /// Stores `_currentPosition` state/configuration for this implementation.
  Offset? _currentPosition;

  /// Stores `_session` state/configuration for this implementation.
  _EyeDropperCompleter? _session;

  /// Executes `_buildPreviewLabel` behavior for this component/composite.
  Widget _buildPreviewLabel(BuildContext context, Color color) {
    if (widget.previewLabelBuilder != null) {
      return widget.previewLabelBuilder!(context, color);
    }
    return Text(colorToHex(color, false)).small().muted();
  }

  @override
  Future<Color?> promptPickColor([ColorHistoryStorage? historyStorage]) async {
    if (!mounted) {
      return Future.value(null);
    }
    if (_session != null) {
      if (historyStorage != null &&
          _session!.recentColorsScope.add(historyStorage)) {
        return _session!.completer.future.then((value) {
          if (value != null) {
            historyStorage.addHistory(value);
          }
          return value;
        });
      }
      return _session!.completer.future;
    }
    final completer = Completer<Color?>();
    final screenshot = await _screenshotWidget();

    /// Creates a `setState` instance.
    setState(() {
      _session = _EyeDropperCompleter(
        completer,
        historyStorage != null ? {historyStorage} : {},
      );
      _currentPicking = screenshot;
    });

    /// Stores `result` state/configuration for this implementation.
    final result = await completer.future;
    if (historyStorage != null && result != null) {
      historyStorage.addHistory(result);
    }
    return result;
  }

  Future<_ScreenshotResult?> _screenshotWidget() async {
    /// Stores `currentContext` state/configuration for this implementation.
    final currentContext = _repaintKey.currentContext;
    if (currentContext == null) return null;
    final boundary = currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return null;

    /// Stores `colors` state/configuration for this implementation.
    final colors = <Color>[];
    for (int i = 0; i < byteData.lengthInBytes; i += 4) {
      final r = byteData.getUint8(i);
      final g = byteData.getUint8(i + 1);
      final b = byteData.getUint8(i + 2);
      final a = byteData.getUint8(i + 3);
      colors.add(Color.fromARGB(a, r, g, b));
    }
    final img = _ScreenshotImage(
      byteData.buffer.asUint8List(),
      image.width,
      image.height,
      ui.PixelFormat.rgba8888,
    );
    return _ScreenshotResult(
      colors,

      /// Creates a `Size` instance.
      Size(image.width.toDouble(), image.height.toDouble()),
      img,
    );
  }

  /// Executes `_getPreview` behavior for this component/composite.
  EyeDropperResult? _getPreview(Offset globalPosition, Size size) {
    /// Stores `image` state/configuration for this implementation.
    final image = _currentPicking;
    if (image == null) return null;

    /// Stores `colors` state/configuration for this implementation.
    final colors = <Color>[];
    for (int y = -size.height ~/ 2; y < size.height ~/ 2; y++) {
      for (int x = -size.width ~/ 2; x < size.width ~/ 2; x++) {
        final localPosition = globalPosition.translate(
          /// Creates a `x.toDouble` instance.
          x.toDouble(),

          /// Creates a `y.toDouble` instance.
          y.toDouble(),
        );
        if (localPosition.dx < 0 ||
            localPosition.dy < 0 ||
            localPosition.dx >= image.size.width ||
            localPosition.dy >= image.size.height) {
          colors.add(Colors.transparent);
        } else {
          colors.add(image[localPosition]);
        }
      }
    }
    final globalIndex =
        globalPosition.dy.floor() * image.size.width.floor() +
        globalPosition.dx.floor();

    /// Stores `pickedColor` state/configuration for this implementation.
    final pickedColor = image.colors[globalIndex];
    return EyeDropperResult(colors, size, pickedColor);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previewSize =
        widget.previewSize ?? const Size(100, 100) * theme.scaling;
    return ForwardableData<EyeDropperLayerScope>(
      data: this,
      child: Data<EyeDropperLayerScope>.inherit(
        data: this,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: _preview != null && _session != null
              ? (details) async {
                  _session!.completer.complete(_preview!.pickedColor);
                  if (mounted) {
                    /// Creates a `setState` instance.
                    setState(() {
                      _session = null;
                      _preview = null;
                      _currentPicking = null;
                      _currentPosition = null;
                    });
                  }
                }
              : null,
          child: MouseRegion(
            hitTestBehavior: HitTestBehavior.translucent,
            onHover: _session != null
                ? (details) {
                    /// Creates a `setState` instance.
                    setState(() {
                      _preview = _getPreview(
                        details.localPosition,
                        previewSize / widget.previewScale,
                      );
                      _currentPosition = details.localPosition;
                    });
                  }
                : null,
            child: IgnorePointer(
              ignoring: _session != null,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  /// Creates a `RepaintBoundary` instance.
                  RepaintBoundary(key: _repaintKey, child: widget.child),
                  if (_currentPicking != null)
                    /// Creates a `Positioned.fill` instance.
                    Positioned.fill(
                      child: Image(
                        image: _currentPicking!.image!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  if (widget.showPreview &&
                      _preview != null &&
                      widget.previewAlignment != null)
                    /// Creates a `Positioned` instance.
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.all(
                          theme.density.baseContainerPadding *
                              theme.scaling *
                              padLg,
                        ),
                        child: Align(
                          alignment: widget.previewAlignment!,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            fit: StackFit.passthrough,
                            children: [
                              /// Creates a `SizedBox` instance.
                              SizedBox(
                                width: previewSize.width,
                                height: previewSize.height,
                                child: CustomPaint(
                                  painter: _ColorPreviewPainter(
                                    _preview!.colors,
                                    _preview!.size,
                                    theme.colorScheme.border,
                                    1 * theme.scaling,
                                    theme.colorScheme.primary,
                                    2 * theme.scaling,
                                    theme.colorScheme.background,
                                  ),
                                ),
                              ),

                              /// Creates a `Positioned` instance.
                              Positioned(
                                bottom: -18 * theme.scaling,
                                child: _buildPreviewLabel(
                                  context,
                                  _preview!.pickedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (widget.showPreview &&
                      _preview != null &&
                      widget.previewAlignment == null)
                    /// Creates a `Positioned` instance.
                    Positioned(
                      top: _currentPosition!.dy,
                      left: _currentPosition!.dx,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        fit: StackFit.passthrough,
                        children: [
                          /// Creates a `SizedBox` instance.
                          SizedBox(
                            width: previewSize.width,
                            height: previewSize.height,
                            child: CustomPaint(
                              painter: _ColorPreviewPainter(
                                _preview!.colors,
                                _preview!.size,
                                theme.colorScheme.border,
                                1 * theme.scaling,
                                theme.colorScheme.primary,
                                2 * theme.scaling,
                                theme.colorScheme.background,
                              ),
                            ),
                          ),

                          /// Creates a `Positioned` instance.
                          Positioned(
                            bottom: -18 * theme.scaling,
                            child: _buildPreviewLabel(
                              context,
                              _preview!.pickedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Prompts the user to pick a color from the screen using an eye dropper tool.
///
/// Returns the selected color, or null if the operation was cancelled.
/// Optionally stores the selected color in the provided [storage].
Future<Color?> pickColorFromScreen(
  BuildContext context, [
  ColorHistoryStorage? storage,
]) {
  final scope = EyeDropperLayerScope.find(context);
  return scope.promptPickColor(storage);
}
