part of '../../overlay.dart';

/// PopoverLayoutRender defines a reusable type for this registry module.
class PopoverLayoutRender extends RenderShiftedBox {
/// Stores `_alignment` state/configuration for this implementation.
  Alignment _alignment;
/// Stores `_anchorAlignment` state/configuration for this implementation.
  Alignment _anchorAlignment;
/// Stores `_position` state/configuration for this implementation.
  Offset? _position;
/// Stores `_anchorSize` state/configuration for this implementation.
  Size? _anchorSize;
/// Stores `_widthConstraint` state/configuration for this implementation.
  PopoverConstraint _widthConstraint;
/// Stores `_heightConstraint` state/configuration for this implementation.
  PopoverConstraint _heightConstraint;
/// Stores `_offset` state/configuration for this implementation.
  Offset? _offset;
/// Stores `_margin` state/configuration for this implementation.
  EdgeInsets _margin;
/// Stores `_scale` state/configuration for this implementation.
  double _scale;
/// Stores `_scaleAlignment` state/configuration for this implementation.
  Alignment _scaleAlignment;
/// Stores `_filterQuality` state/configuration for this implementation.
  FilterQuality? _filterQuality;
/// Stores `_allowInvertHorizontal` state/configuration for this implementation.
  bool _allowInvertHorizontal;
/// Stores `_allowInvertVertical` state/configuration for this implementation.
  bool _allowInvertVertical;

/// Stores `_invertX` state/configuration for this implementation.
  bool _invertX = false;
/// Stores `_invertY` state/configuration for this implementation.
  bool _invertY = false;

  /// Creates a popover layout render object.
  ///
  /// All parameters control how the popover is positioned and sized relative
  /// to its anchor.
  PopoverLayoutRender({
    RenderBox? child,
    required Alignment alignment,
    required Offset? position,
    required Alignment anchorAlignment,
    required PopoverConstraint widthConstraint,
    required PopoverConstraint heightConstraint,
    Size? anchorSize,
    Offset? offset,
    EdgeInsets margin = const EdgeInsets.all(8),
    required double scale,
    required Alignment scaleAlignment,
    FilterQuality? filterQuality,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
  }) : _alignment = alignment,
       _position = position,
       _anchorAlignment = anchorAlignment,
       _widthConstraint = widthConstraint,
       _heightConstraint = heightConstraint,
       _anchorSize = anchorSize,
       _offset = offset,
       _margin = margin,
       _scale = scale,
       _scaleAlignment = scaleAlignment,
       _filterQuality = filterQuality,
       _allowInvertHorizontal = allowInvertHorizontal,
       _allowInvertVertical = allowInvertVertical,
       super(child);

  @override
/// Executes `computeDryLayout` behavior for this component/composite.
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
/// Executes `hitTest` behavior for this component/composite.
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return hitTestChildren(result, position: position);
  }

  Matrix4 get _effectiveTransform {
/// Stores `childSize` state/configuration for this implementation.
    Size childSize = child!.size;
    Offset childOffset = (child!.parentData as BoxParentData).offset;
/// Stores `scaleAlignment` state/configuration for this implementation.
    var scaleAlignment = _scaleAlignment;
    if (_invertX || _invertY) {
      scaleAlignment = Alignment(
        _invertX ? -scaleAlignment.x : scaleAlignment.x,
        _invertY ? -scaleAlignment.y : scaleAlignment.y,
      );
    }
    Matrix4 transform = Matrix4.identity();
    Offset alignmentTranslation = scaleAlignment.alongSize(childSize);
    transform.translateByDouble(childOffset.dx, childOffset.dy, 0, 1);
/// Creates a `transform.translateByDouble` instance.
    transform.translateByDouble(
      alignmentTranslation.dx,
      alignmentTranslation.dy,
      0,
      1,
    );
    transform.scaleByDouble(_scale, _scale, 1, 1);
/// Creates a `transform.translateByDouble` instance.
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
/// Executes `hitTestChildren` behavior for this component/composite.
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
/// Executes `applyPaintTransform` behavior for this component/composite.
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
/// Stores `effectiveTransform` state/configuration for this implementation.
    Matrix4 effectiveTransform = _effectiveTransform;
    transform.multiply(effectiveTransform);
    super.applyPaintTransform(child, transform);
  }

  @override
/// Stores `alwaysNeedsCompositing` state/configuration for this implementation.
  bool get alwaysNeedsCompositing => child != null && _filterQuality != null;

  @override
/// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
/// Stores `transform` state/configuration for this implementation.
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
/// Creates a `Matrix4.translationValues` instance.
            Matrix4.translationValues(offset.dx, offset.dy, 0.0)
              ..multiply(transform)
              ..translateByDouble(-offset.dx, -offset.dy, 0, 1);
        final ui.ImageFilter filter = ui.ImageFilter.matrix(
          effectiveTransform.storage,
          filterQuality: _filterQuality!,
        );
        if (layer is ImageFilterLayer) {
/// Stores `filterLayer` state/configuration for this implementation.
          final ImageFilterLayer filterLayer = layer! as ImageFilterLayer;
          filterLayer.imageFilter = filter;
        } else {
          layer = ImageFilterLayer(imageFilter: filter);
        }
        context.pushLayer(layer!, super.paint, offset);
/// Creates a `assert` instance.
        assert(() {
          layer!.debugCreator = debugCreator;
          return true;
        }());
      }
    }
  }

  /// Computes appropriate box constraints for the popover child.
  ///
  /// Applies width and height constraint strategies to the child based on
  /// anchor size, viewport constraints, and margin settings.
  ///
  /// Parameters:
  /// - [constraints]: The incoming constraints from parent
  ///
  /// Returns box constraints with min/max values for width and height.
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
/// Stores `minWidth` state/configuration for this implementation.
    double minWidth = 0;
/// Stores `maxWidth` state/configuration for this implementation.
    double maxWidth = constraints.maxWidth;
/// Stores `minHeight` state/configuration for this implementation.
    double minHeight = 0;
/// Stores `maxHeight` state/configuration for this implementation.
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
      double intrinsicWidth = child!.getMaxIntrinsicWidth(double.infinity);
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
      double intrinsicHeight = child!.getMaxIntrinsicHeight(double.infinity);
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
/// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    child!.layout(getConstraintsForChild(constraints), parentUsesSize: true);
    size = constraints.biggest;
/// Stores `childSize` state/configuration for this implementation.
    Size childSize = child!.size;
/// Stores `offsetX` state/configuration for this implementation.
    double offsetX = _offset?.dx ?? 0;
/// Stores `offsetY` state/configuration for this implementation.
    double offsetY = _offset?.dy ?? 0;
/// Stores `position` state/configuration for this implementation.
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
/// Stores `left` state/configuration for this implementation.
    double left = x - _margin.left;
/// Stores `top` state/configuration for this implementation.
    double top = y - _margin.top;
/// Stores `right` state/configuration for this implementation.
    double right = x + childSize.width + _margin.right;
/// Stores `bottom` state/configuration for this implementation.
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
    Offset result = Offset(x + dx + offsetX, y + dy + offsetY);
/// Stores `childParentData` state/configuration for this implementation.
    BoxParentData childParentData = child!.parentData as BoxParentData;
    childParentData.offset = result;
  }
}
