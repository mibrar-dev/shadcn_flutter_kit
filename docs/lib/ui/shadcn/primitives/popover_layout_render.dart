// Render object behind `PopoverLayout`: computes the child offset, applies
// size constraints and flips the popover when it would overflow.
//
// Ported from `shared/primitives/_impl/core/popover_layout_render.dart`.

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import 'overlay.dart';

/// Custom render object for popover positioning.
class PopoverLayoutRender extends RenderShiftedBox {
  Alignment _alignment;
  Alignment _anchorAlignment;
  Offset? _position;
  Size? _anchorSize;
  PopoverConstraint _widthConstraint;
  PopoverConstraint _heightConstraint;
  Offset? _offset;
  EdgeInsets _margin;
  double _scale;
  Alignment _scaleAlignment;
  FilterQuality? _filterQuality;
  bool _allowInvertHorizontal;
  bool _allowInvertVertical;
  bool _invertX = false;
  bool _invertY = false;

  /// Creates a popover layout render object.
  PopoverLayoutRender({
    RenderBox? child,
    required this._alignment,
    required this._position,
    required this._anchorAlignment,
    required this._widthConstraint,
    required this._heightConstraint,
    this._anchorSize,
    this._offset,
    this._margin = const EdgeInsets.all(8),
    required this._scale,
    required this._scaleAlignment,
    this._filterQuality,
    this._allowInvertHorizontal = true,
    this._allowInvertVertical = true,
  }) : super(child);

  /// Applies a new widget configuration, relayouting when anything changed.
  void updateConfiguration({
    required Alignment alignment,
    required Offset? position,
    required Alignment anchorAlignment,
    required PopoverConstraint widthConstraint,
    required PopoverConstraint heightConstraint,
    required Size? anchorSize,
    required Offset? offset,
    required EdgeInsets margin,
    required double scale,
    required Alignment scaleAlignment,
    required FilterQuality? filterQuality,
    required bool allowInvertHorizontal,
    required bool allowInvertVertical,
  }) {
    bool hasChanged = false;
    if (_alignment != alignment) {
      _alignment = alignment;
      hasChanged = true;
    }
    if (_position != position) {
      _position = position;
      hasChanged = true;
    }
    if (_anchorAlignment != anchorAlignment) {
      _anchorAlignment = anchorAlignment;
      hasChanged = true;
    }
    if (_widthConstraint != widthConstraint) {
      _widthConstraint = widthConstraint;
      hasChanged = true;
    }
    if (_heightConstraint != heightConstraint) {
      _heightConstraint = heightConstraint;
      hasChanged = true;
    }
    if (_anchorSize != anchorSize) {
      _anchorSize = anchorSize;
      hasChanged = true;
    }
    if (_offset != offset) {
      _offset = offset;
      hasChanged = true;
    }
    if (_margin != margin) {
      _margin = margin;
      hasChanged = true;
    }
    if (_scale != scale) {
      _scale = scale;
      hasChanged = true;
    }
    if (_scaleAlignment != scaleAlignment) {
      _scaleAlignment = scaleAlignment;
      hasChanged = true;
    }
    if (_filterQuality != filterQuality) {
      _filterQuality = filterQuality;
      hasChanged = true;
    }
    if (_allowInvertHorizontal != allowInvertHorizontal) {
      _allowInvertHorizontal = allowInvertHorizontal;
      hasChanged = true;
    }
    if (_allowInvertVertical != allowInvertVertical) {
      _allowInvertVertical = allowInvertVertical;
      hasChanged = true;
    }
    if (hasChanged) {
      markNeedsLayout();
    }
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return hitTestChildren(result, position: position);
  }

  Matrix4 get _effectiveTransform {
    final Size childSize = child!.size;
    final Offset childOffset = (child!.parentData as BoxParentData).offset;
    var scaleAlignment = _scaleAlignment;
    if (_invertX || _invertY) {
      scaleAlignment = Alignment(
        _invertX ? -scaleAlignment.x : scaleAlignment.x,
        _invertY ? -scaleAlignment.y : scaleAlignment.y,
      );
    }
    final Matrix4 transform = Matrix4.identity();
    final Offset alignmentTranslation = scaleAlignment.alongSize(childSize);
    transform.translateByDouble(childOffset.dx, childOffset.dy, 0, 1);
    transform.translateByDouble(
      alignmentTranslation.dx,
      alignmentTranslation.dy,
      0,
      1,
    );
    transform.scaleByDouble(_scale, _scale, 1, 1);
    transform.translateByDouble(
      -alignmentTranslation.dx,
      -alignmentTranslation.dy,
      0,
      1,
    );
    transform.translateByDouble(-childOffset.dx, -childOffset.dy, 0, 1);
    return transform;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintTransform(
      transform: _effectiveTransform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final Matrix4 effectiveTransform = _effectiveTransform;
    transform.multiply(effectiveTransform);
    super.applyPaintTransform(child, transform);
  }

  @override
  bool get alwaysNeedsCompositing => child != null && _filterQuality != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final Matrix4 transform = _effectiveTransform;
      if (_filterQuality == null) {
        final Offset? childOffset = MatrixUtils.getAsTranslation(transform);
        if (childOffset == null) {
          final double det = transform.determinant();
          if (det == 0 || !det.isFinite) {
            layer = null;
            return;
          }
          layer = context.pushTransform(
            needsCompositing,
            offset,
            transform,
            super.paint,
            oldLayer: layer is TransformLayer ? layer as TransformLayer? : null,
          );
        } else {
          super.paint(context, offset + childOffset);
          layer = null;
        }
      } else {
        final Matrix4 effectiveTransform =
            Matrix4.translationValues(offset.dx, offset.dy, 0.0)
              ..multiply(transform)
              ..translateByDouble(-offset.dx, -offset.dy, 0, 1);
        final ui.ImageFilter filter = ui.ImageFilter.matrix(
          effectiveTransform.storage,
          filterQuality: _filterQuality!,
        );
        if (layer is ImageFilterLayer) {
          final ImageFilterLayer filterLayer = layer! as ImageFilterLayer;
          filterLayer.imageFilter = filter;
        } else {
          layer = ImageFilterLayer(imageFilter: filter);
        }
        context.pushLayer(layer!, super.paint, offset);
        assert(() {
          layer!.debugCreator = debugCreator;
          return true;
        }());
      }
    }
  }

  /// Constraints applied to the popover child.
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double minWidth = 0;
    double maxWidth = constraints.maxWidth;
    double minHeight = 0;
    double maxHeight = constraints.maxHeight;
    if (_widthConstraint == PopoverConstraint.anchorFixedSize) {
      assert(_anchorSize != null, 'anchorSize must not be null');
      minWidth = _anchorSize!.width;
      maxWidth = _anchorSize!.width;
    } else if (_widthConstraint == PopoverConstraint.anchorMinSize) {
      assert(_anchorSize != null, 'anchorSize must not be null');
      minWidth = _anchorSize!.width;
    } else if (_widthConstraint == PopoverConstraint.anchorMaxSize) {
      assert(_anchorSize != null, 'anchorSize must not be null');
      maxWidth = _anchorSize!.width;
    } else if (_widthConstraint == PopoverConstraint.intrinsic) {
      final double intrinsicWidth = child!.getMaxIntrinsicWidth(
        double.infinity,
      );
      if (intrinsicWidth.isFinite) {
        maxWidth = max(minWidth, intrinsicWidth);
      }
    }
    if (_heightConstraint == PopoverConstraint.anchorFixedSize) {
      assert(_anchorSize != null, 'anchorSize must not be null');
      minHeight = _anchorSize!.height;
      maxHeight = _anchorSize!.height;
    } else if (_heightConstraint == PopoverConstraint.anchorMinSize) {
      assert(_anchorSize != null, 'anchorSize must not be null');
      minHeight = _anchorSize!.height;
    } else if (_heightConstraint == PopoverConstraint.anchorMaxSize) {
      assert(_anchorSize != null, 'anchorSize must not be null');
      maxHeight = _anchorSize!.height;
    } else if (_heightConstraint == PopoverConstraint.intrinsic) {
      final double intrinsicHeight = child!.getMaxIntrinsicHeight(
        double.infinity,
      );
      if (intrinsicHeight.isFinite) {
        maxHeight = max(minHeight, intrinsicHeight);
      }
    }
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  @override
  void performLayout() {
    child!.layout(getConstraintsForChild(constraints), parentUsesSize: true);
    size = constraints.biggest;

    final Size childSize = child!.size;
    double offsetX = _offset?.dx ?? 0;
    double offsetY = _offset?.dy ?? 0;
    var position = _position;
    position ??= Offset(
      size.width / 2 + size.width / 2 * _anchorAlignment.x,
      size.height / 2 + size.height / 2 * _anchorAlignment.y,
    );
    double x =
        position.dx -
        childSize.width / 2 -
        (childSize.width / 2 * _alignment.x);
    double y =
        position.dy -
        childSize.height / 2 -
        (childSize.height / 2 * _alignment.y);

    double left = x - _margin.left;
    double top = y - _margin.top;
    double right = x + childSize.width + _margin.right;
    double bottom = y + childSize.height + _margin.bottom;
    if ((left < 0 || right > size.width) && _allowInvertHorizontal) {
      x =
          position.dx -
          childSize.width / 2 -
          (childSize.width / 2 * -_alignment.x);
      if (_anchorSize != null) {
        x -= _anchorSize!.width * _anchorAlignment.x;
      }
      left = x - _margin.left;
      right = x + childSize.width + _margin.right;
      offsetX *= -1;
      _invertX = true;
    } else {
      _invertX = false;
    }
    if ((top < 0 || bottom > size.height) && _allowInvertVertical) {
      y =
          position.dy -
          childSize.height / 2 -
          (childSize.height / 2 * -_alignment.y);
      if (_anchorSize != null) {
        y -= _anchorSize!.height * _anchorAlignment.y;
      }
      top = y - _margin.top;
      bottom = y + childSize.height + _margin.bottom;
      offsetY *= -1;
      _invertY = true;
    } else {
      _invertY = false;
    }
    final double dx = left < 0
        ? -left
        : right > size.width
        ? size.width - right
        : 0;
    final double dy = top < 0
        ? -top
        : bottom > size.height
        ? size.height - bottom
        : 0;
    final Offset result = Offset(x + dx + offsetX, y + dy + offsetY);
    final BoxParentData childParentData = child!.parentData as BoxParentData;
    childParentData.offset = result;
  }
}
