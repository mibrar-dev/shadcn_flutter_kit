part of '../../overlay.dart';

/// PopoverLayout defines a reusable type for this registry module.
class PopoverLayout extends SingleChildRenderObjectWidget {
  /// Popover alignment relative to anchor.
  final Alignment alignment;

  /// Anchor alignment for positioning.
  final Alignment anchorAlignment;

  /// Explicit position offset (overrides alignment).
  final Offset? position;

  /// Size of the anchor widget.
  final Size? anchorSize;

  /// Width constraint strategy.
  final PopoverConstraint widthConstraint;

  /// Height constraint strategy.
  final PopoverConstraint heightConstraint;

  /// Additional offset from computed position.
  final Offset? offset;

  /// Margin around the popover.
  final EdgeInsets margin;

  /// Scale factor for the popover.
  final double scale;

  /// Alignment point for scaling transformation.
  final Alignment scaleAlignment;

  /// Filter quality for scaled content.
  final FilterQuality? filterQuality;

  /// Whether to allow horizontal position inversion.
  final bool allowInvertHorizontal;

  /// Whether to allow vertical position inversion.
  final bool allowInvertVertical;

  /// Creates a popover layout widget.
  const PopoverLayout({
    super.key,
    required this.alignment,
    required this.position,
    required this.anchorAlignment,
    required this.widthConstraint,
    required this.heightConstraint,
    this.anchorSize,
    this.offset,
    required this.margin,
    required Widget super.child,
    required this.scale,
    required this.scaleAlignment,
    this.filterQuality,
    this.allowInvertHorizontal = true,
    this.allowInvertVertical = true,
  });

  @override
/// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return PopoverLayoutRender(
      alignment: alignment,
      position: position,
      anchorAlignment: anchorAlignment,
      widthConstraint: widthConstraint,
      heightConstraint: heightConstraint,
      anchorSize: anchorSize,
      offset: offset,
      margin: margin,
      scale: scale,
      scaleAlignment: scaleAlignment,
      filterQuality: filterQuality,
      allowInvertHorizontal: allowInvertHorizontal,
      allowInvertVertical: allowInvertVertical,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant PopoverLayoutRender renderObject,
  ) {
/// Stores `hasChanged` state/configuration for this implementation.
    bool hasChanged = false;
    if (renderObject._alignment != alignment) {
      renderObject._alignment = alignment;
      hasChanged = true;
    }
    if (renderObject._position != position) {
      renderObject._position = position;
      hasChanged = true;
    }
    if (renderObject._anchorAlignment != anchorAlignment) {
      renderObject._anchorAlignment = anchorAlignment;
      hasChanged = true;
    }
    if (renderObject._widthConstraint != widthConstraint) {
      renderObject._widthConstraint = widthConstraint;
      hasChanged = true;
    }
    if (renderObject._heightConstraint != heightConstraint) {
      renderObject._heightConstraint = heightConstraint;
      hasChanged = true;
    }
    if (renderObject._anchorSize != anchorSize) {
      renderObject._anchorSize = anchorSize;
      hasChanged = true;
    }
    if (renderObject._offset != offset) {
      renderObject._offset = offset;
      hasChanged = true;
    }
    if (renderObject._margin != margin) {
      renderObject._margin = margin;
      hasChanged = true;
    }
    if (renderObject._scale != scale) {
      renderObject._scale = scale;
      hasChanged = true;
    }
    if (renderObject._scaleAlignment != scaleAlignment) {
      renderObject._scaleAlignment = scaleAlignment;
      hasChanged = true;
    }
    if (renderObject._filterQuality != filterQuality) {
      renderObject._filterQuality = filterQuality;
      hasChanged = true;
    }
    if (renderObject._allowInvertHorizontal != allowInvertHorizontal) {
      renderObject._allowInvertHorizontal = allowInvertHorizontal;
      hasChanged = true;
    }
    if (renderObject._allowInvertVertical != allowInvertVertical) {
      renderObject._allowInvertVertical = allowInvertVertical;
      hasChanged = true;
    }
    if (hasChanged) {
      renderObject.markNeedsLayout();
    }
  }
}

/// Custom render object for popover layout positioning.
///
/// Handles the low-level layout calculations for positioning popover content
/// relative to an anchor with automatic constraint adjustments and inversion
/// when the popover would overflow the viewport.
