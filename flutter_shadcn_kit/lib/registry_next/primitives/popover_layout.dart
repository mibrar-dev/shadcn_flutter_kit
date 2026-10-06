// `PopoverLayout`: positions and constrains its child relative to an anchor.
//
// Ported from `shared/primitives/_impl/core/popover_layout.dart`; the render
// object lives in `popover_layout_render.dart`.

import 'package:flutter/widgets.dart';

import 'overlay.dart';
import 'popover_layout_render.dart';

/// Positions a popover relative to an anchor, with automatic inversion when
/// the content would overflow the viewport.
class PopoverLayout extends SingleChildRenderObjectWidget {
  /// Popover alignment relative to the anchor.
  final Alignment alignment;

  /// Anchor alignment used to compute the attachment point.
  final Alignment anchorAlignment;

  /// Explicit position (overrides the alignment-derived one).
  final Offset? position;

  /// Size of the anchor widget.
  final Size? anchorSize;

  /// Width constraint strategy.
  final PopoverConstraint widthConstraint;

  /// Height constraint strategy.
  final PopoverConstraint heightConstraint;

  /// Additional offset from the computed position.
  final Offset? offset;

  /// Margin around the popover.
  final EdgeInsets margin;

  /// Scale factor applied to the popover.
  final double scale;

  /// Alignment point used for the scale transform.
  final Alignment scaleAlignment;

  /// Filter quality for scaled content.
  final FilterQuality? filterQuality;

  /// Whether horizontal inversion is allowed.
  final bool allowInvertHorizontal;

  /// Whether vertical inversion is allowed.
  final bool allowInvertVertical;

  /// Creates a popover layout.
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
    renderObject.updateConfiguration(
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
}
