// The `eye_dropper` component: [EyeDropperLayer] wraps a subtree and lets the
// user sample any pixel on screen; [pickColorFromScreen] opens a picking
// session through the nearest layer.
//
// Ported from `overlay/eye_dropper/**` (old tree). Screen capture, grid
// sampling and the magnified-grid painter live in
// `primitives/screen_capture.dart` (this component's file was over the ~400
// budget with them inline); the old `data_widget` package became the
// foundation `Data`/`ForwardableData`, and Material's `Colors` became the kit
// palette.
//
// Old bugs fixed, not ported:
//  * bottom/right edge crash: the picked-colour index came straight from
//    `floor()` and was never clamped;
//  * `previewScale == 0` divided the sample size by zero (the grid is capped
//    now);
//  * `shouldRepaint` ignored the background colour (fixed in
//    [PixelGridPainter]);
//  * a session could never be cancelled (Escape completes it with null);
//  * a touch tap without a prior hover never completed the session;
//  * two `package:flutter/material.dart` imports.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/data_messenger.dart';
import '../../primitives/screen_capture.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme.dart';
import '../history/history.dart';
import 'eye_dropper_style.dart';

export 'eye_dropper_style.dart';
export '../../primitives/screen_capture.dart' show ScreenSample;

/// Builds a preview label widget for the sampled colour.
typedef PreviewLabelBuilder =
    Widget Function(BuildContext context, Color color);

/// Eye-dropper sessions managed by an [EyeDropperLayer].
abstract class EyeDropperLayerScope {
  /// Prompts the user to pick a colour from the wrapped subtree.
  ///
  /// Completes with the sampled colour, or null when the session is cancelled
  /// (Escape). When [historyStorage] is given the colour is also pushed to it.
  Future<Color?> promptPickColor([ColorHistoryStorage? historyStorage]);

  /// Finds the outermost [EyeDropperLayerScope] above [context].
  static EyeDropperLayerScope findRoot(BuildContext context) {
    return _resolve(
      Data.maybeFindRoot<EyeDropperLayerScope>(context) ??
          Data.maybeFindMessenger<EyeDropperLayerScope>(context),
    );
  }

  /// Finds the nearest [EyeDropperLayerScope] above [context].
  static EyeDropperLayerScope find(BuildContext context) {
    return _resolve(
      Data.maybeFind<EyeDropperLayerScope>(context) ??
          Data.maybeFindMessenger<EyeDropperLayerScope>(context),
    );
  }

  static EyeDropperLayerScope _resolve(EyeDropperLayerScope? found) {
    if (found == null) {
      throw FlutterError(
        'No EyeDropperLayerScope found in context. Wrap the tree with an '
        'EyeDropperLayer.',
      );
    }
    return found;
  }
}

/// Wraps a subtree and enables sampling colours from it.
///
/// While a picking session is active the layer freezes a screenshot of the
/// subtree, follows the pointer with a magnified preview and completes the
/// session on tap (or cancels it with Escape).
class EyeDropperLayer extends StatefulWidget {
  /// Creates an eye-dropper layer.
  const EyeDropperLayer({
    super.key,
    required this.child,
    this.previewAlignment,
    this.showPreview,
    this.previewSize,
    this.previewScale,
    this.previewLabelBuilder,
    this.theme,
  });

  /// The subtree that can be sampled.
  final Widget child;

  /// Pins the preview to this alignment; null makes it follow the pointer.
  final AlignmentGeometry? previewAlignment;

  /// Whether the magnified preview is shown. Default: theme value (true).
  final bool? showPreview;

  /// Preview size override. Default: theme value (100x100), scaled.
  final Size? previewSize;

  /// Magnification override. Default: theme value (8).
  final double? previewScale;

  /// Custom label under the preview; defaults to the hex value.
  final PreviewLabelBuilder? previewLabelBuilder;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final EyeDropperTheme? theme;

  @override
  State<EyeDropperLayer> createState() => _EyeDropperLayerState();
}

/// One picking session: the completer plus the storages that joined it.
class _PickSession {
  _PickSession(this.completer);

  final Completer<Color?> completer;
  final Set<ColorHistoryStorage> storages = <ColorHistoryStorage>{};
}

class _EyeDropperLayerState extends State<EyeDropperLayer>
    implements EyeDropperLayerScope {
  final GlobalKey _boundaryKey = GlobalKey();
  final FocusNode _focusNode = FocusNode(debugLabel: 'EyeDropperLayer');

  ScreenCapture? _screen;
  ScreenSample? _preview;
  Offset? _position;
  _PickSession? _session;

  @override
  Future<Color?> promptPickColor([ColorHistoryStorage? historyStorage]) async {
    if (!mounted) {
      return null;
    }
    final _PickSession? active = _session;
    if (active != null) {
      final Future<Color?> future = active.completer.future;
      if (historyStorage == null || !active.storages.add(historyStorage)) {
        return future;
      }
      return future.then((Color? color) {
        if (color != null) {
          historyStorage.addHistory(color);
        }
        return color;
      });
    }
    final ScreenCapture? screen = await captureRenderBoundary(_boundaryKey);
    if (!mounted || screen == null) {
      // Nothing to sample (the boundary was not paint-ready): fail the session
      // instead of opening one that can never complete.
      return null;
    }
    final _PickSession session = _PickSession(Completer<Color?>());
    if (historyStorage != null) {
      session.storages.add(historyStorage);
    }
    setState(() {
      _session = session;
      _screen = screen;
    });
    _focusNode.requestFocus();
    final Color? color = await session.completer.future;
    for (final ColorHistoryStorage storage in session.storages) {
      if (color != null) {
        storage.addHistory(color);
      }
    }
    return color;
  }

  void _complete(Color? color) {
    final _PickSession? session = _session;
    if (session == null) {
      return;
    }
    session.completer.complete(color);
    setState(() {
      _session = null;
      _screen?.dispose();
      _screen = null;
      _preview = null;
      _position = null;
    });
  }

  @override
  void dispose() {
    _session?.completer.complete(null);
    _screen?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _complete(null);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final EyeDropperTheme style =
        resolveComponentStyle<EyeDropperTheme, EyeDropperTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: eyeDropperDefaults,
        );
    final Size previewSize =
        (widget.previewSize ?? style.previewSize ?? const Size(100, 100)) *
        ambient.scaling;
    final double previewScale = (widget.previewScale ?? style.previewScale ?? 8)
        .clamp(0.25, 64);
    final bool showPreview = widget.showPreview ?? style.showPreview ?? true;
    final Size sampleSize = Size(
      previewSize.width / previewScale,
      previewSize.height / previewScale,
    );

    void updatePreview(Offset position) {
      final ScreenCapture? screen = _screen;
      if (_session == null || !showPreview || screen == null) {
        return;
      }
      setState(() {
        _position = position;
        _preview = screen.sample(position, sampleSize);
      });
    }

    final ScreenCapture? screen = _screen;
    final ScreenSample? preview = _preview;
    return ForwardableData<EyeDropperLayerScope>(
      data: this,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _onKey,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: screen == null
              ? null
              : (TapDownDetails details) => _complete(
                  screen.sample(details.localPosition, sampleSize).pickedColor,
                ),
          child: MouseRegion(
            hitTestBehavior: HitTestBehavior.translucent,
            onHover: _session == null
                ? null
                : (PointerHoverEvent event) =>
                      updatePreview(event.localPosition),
            child: IgnorePointer(
              ignoring: _session != null,
              child: Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.none,
                children: <Widget>[
                  RepaintBoundary(key: _boundaryKey, child: widget.child),
                  if (screen != null)
                    Positioned.fill(
                      child: RawImage(image: screen.image, fit: BoxFit.fill),
                    ),
                  if (showPreview && preview != null)
                    _buildPreview(
                      context,
                      ambient,
                      style,
                      previewSize,
                      preview,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(
    BuildContext context,
    ShadcnThemeData ambient,
    EyeDropperTheme style,
    Size previewSize,
    ScreenSample preview,
  ) {
    final ShadcnColors colors = ambient.colors;
    final Widget previewBox = SizedBox(
      width: previewSize.width,
      height: previewSize.height,
      child: CustomPaint(
        painter: PixelGridPainter(
          colors: preview.colors,
          gridSize: preview.size,
          borderColor: style.borderColor?.resolve(colors) ?? colors.border,
          borderWidth: (style.borderWidth ?? 1) * ambient.scaling,
          selectedBorderColor:
              style.selectedBorderColor?.resolve(colors) ?? colors.primary,
          selectedBorderWidth:
              (style.selectedBorderWidth ?? 2) * ambient.scaling,
          backgroundColor:
              style.backgroundColor?.resolve(colors) ?? colors.background,
        ),
      ),
    );
    final Widget label =
        widget.previewLabelBuilder?.call(context, preview.pickedColor) ??
        Text(colorToHex(preview.pickedColor)).small().muted();
    final Widget stack = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        previewBox,
        Positioned(bottom: -18 * ambient.scaling, child: label),
      ],
    );
    final AlignmentGeometry? alignment = widget.previewAlignment;
    if (alignment != null) {
      return Positioned.fill(
        child: Padding(
          padding: EdgeInsets.all(
            ambient.density.baseContainerPadding * ambient.scaling * 2,
          ),
          child: Align(alignment: alignment, child: stack),
        ),
      );
    }
    return Positioned(top: _position!.dy, left: _position!.dx, child: stack);
  }
}

/// Prompts the user to pick a colour from the screen.
///
/// Uses the nearest [EyeDropperLayer]; optionally pushes the picked colour to
/// [storage]. Completes with null when the session is cancelled.
Future<Color?> pickColorFromScreen(
  BuildContext context, [
  ColorHistoryStorage? storage,
]) {
  return EyeDropperLayerScope.find(context).promptPickColor(storage);
}
