// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A [DecoratedBox] that can overflow its bounds.
///
/// [OverflowDecoratedBox] is similar to [DecoratedBox], but it can paint its
/// decoration outside its layout bounds when [expands] margins are provided.
/// This is used internally by [Clickable] to support negative margins for
/// visual effects like hover outlines.
class OverflowDecoratedBox extends SingleChildRenderObjectWidget {
  /// Creates an [OverflowDecoratedBox].
  const OverflowDecoratedBox({
    super.key,
    required this.decoration,
    required this.expands,
    super.child,
  });

  /// The amount by which the decoration should expand beyond the layout bounds.
  final EdgeInsets expands;

  /// The decoration to paint.
  final Decoration decoration;

  @override
  RenderOverflowDecoratedBox createRenderObject(BuildContext context) {
    return RenderOverflowDecoratedBox(
      decoration: decoration,
      position: DecorationPosition.background,
      expands: expands,
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderOverflowDecoratedBox renderObject,
  ) {
    renderObject
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context)
      ..expands = expands;
  }
}

/// The [RenderObject] for [OverflowDecoratedBox].
class RenderOverflowDecoratedBox extends RenderProxyBox {
  /// Creates a [RenderOverflowDecoratedBox].
  ///
  /// NOTE: upstream declares these as private named parameters
  /// (`this._decoration`, ...), which needs Dart 3.12+. This port uses public
  /// named parameters assigned to the same private fields so it compiles
  /// under this package's SDK constraint; the public getter/setter API is
  /// identical.
  RenderOverflowDecoratedBox({
    required Decoration decoration,
    DecorationPosition position = DecorationPosition.background,
    ImageConfiguration configuration = ImageConfiguration.empty,
    RenderBox? child,
    EdgeInsets expands = EdgeInsets.zero,
  }) : _decoration = decoration,
       _position = position,
       _configuration = configuration,
       _expands = expands,
       super(child);

  BoxPainter? _painter;

  /// The amount by which the decoration should expand beyond the layout bounds.
  EdgeInsets get expands => _expands;
  EdgeInsets _expands;
  set expands(EdgeInsets value) {
    if (value == _expands) {
      return;
    }
    _expands = value;
    markNeedsPaint();
  }

  /// The decoration to paint.
  Decoration get decoration => _decoration;
  Decoration _decoration;
  set decoration(Decoration value) {
    if (value == _decoration) {
      return;
    }
    _painter?.dispose();
    _painter = null;
    _decoration = value;
    markNeedsPaint();
  }

  /// Whether the decoration should be painted in the background or foreground.
  DecorationPosition get position => _position;
  DecorationPosition _position;
  set position(DecorationPosition value) {
    if (value == _position) {
      return;
    }
    _position = value;
    markNeedsPaint();
  }

  /// The image configuration for the decoration.
  ImageConfiguration get configuration => _configuration;
  ImageConfiguration _configuration;
  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
    _configuration = value;
    markNeedsPaint();
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();
    markNeedsPaint();
  }

  @override
  void dispose() {
    _painter?.dispose();
    super.dispose();
  }

  @override
  bool hitTestSelf(Offset position) {
    return _decoration.hitTest(
      size,
      position,
      textDirection: configuration.textDirection,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _painter ??= _decoration.createBoxPainter(markNeedsPaint);
    Size size = this.size;
    // expand size by negative margins for painting
    size = Size(
      size.width + expands.left + expands.right,
      size.height + expands.top + expands.bottom,
    );
    Offset adjustedOffset = offset.translate(-expands.left, -expands.top);
    final ImageConfiguration filledConfiguration = configuration.copyWith(
      size: size,
    );
    if (position == DecorationPosition.background) {
      int? debugSaveCount;
      assert(() {
        debugSaveCount = context.canvas.getSaveCount();
        return true;
      }());
      _painter!.paint(context.canvas, adjustedOffset, filledConfiguration);
      assert(() {
        if (debugSaveCount != context.canvas.getSaveCount()) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              '${_decoration.runtimeType} painter had mismatching save and restore calls.',
            ),
            ErrorDescription(
              'Before painting the decoration, the canvas save count was $debugSaveCount. '
              'After painting it, the canvas save count was ${context.canvas.getSaveCount()}. '
              'Every call to save() or saveLayer() must be matched by a call to restore().',
            ),
            DiagnosticsProperty<Decoration>(
              'The decoration was',
              decoration,
              style: DiagnosticsTreeStyle.errorProperty,
            ),
            DiagnosticsProperty<BoxPainter>(
              'The painter was',
              _painter,
              style: DiagnosticsTreeStyle.errorProperty,
            ),
          ]);
        }
        return true;
      }());
      if (decoration.isComplex) {
        context.setIsComplexHint();
      }
    }
    super.paint(context, offset);
    if (position == DecorationPosition.foreground) {
      _painter!.paint(context.canvas, offset, filledConfiguration);
      if (decoration.isComplex) {
        context.setIsComplexHint();
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(_decoration.toDiagnosticsNode(name: 'decoration'));
    properties.add(
      DiagnosticsProperty<ImageConfiguration>('configuration', configuration),
    );
  }
}
