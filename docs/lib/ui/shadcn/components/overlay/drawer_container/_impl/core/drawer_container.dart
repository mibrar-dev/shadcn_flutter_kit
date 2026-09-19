// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer_container.dart';

/// The visual chrome of a drawer: background decoration with a border and
/// rounded outer corners, an optional drag handle, optional surface blur,
/// and an optional barrier color (upstream parity with `shadcn_flutter`'s
/// `DrawerRawContainer`).
///
/// This widget is the reusable container extracted from the drawer/sheet
/// overlay implementation. It is used both by imperative drawer overlays
/// and by the controller-driven `PinnedSheet`.
///
/// Adaptation notes (registry port):
/// - The public constructor surface is identical to upstream (all parameters
///   kept, including [fadeAnimation], [extraSize], [overscroll],
///   [gestureWrapper] and the overscroll-growth inputs).
/// - The upstream overscroll growth render object is simplified to
///   equivalent leading-edge padding; [fadeAnimation] is accepted/stored and
///   drives a fade on the barrier wash when [barrierColor] is set (the
///   upstream `ModalBackdrop` stacking behavior is out of scope for this
///   additive port).
/// - The drag *gesture* is intentionally not owned here — callers wrap this
///   container in their own gesture detector (or pass [gestureWrapper]).
///
/// This is the fully-parameterized form. For a form that reads its
/// configuration from an ancestor [DrawerContainerData] and only takes a
/// [child], use [DrawerContainer].
class DrawerRawContainer extends StatelessWidget {
  /// The resolved position (never [OverlayPosition.start]/[OverlayPosition.end]).
  final OverlayPosition position;

  /// The sheet content.
  final Widget child;

  /// Whether the container expands to fill the cross axis.
  final bool expands;

  /// Whether to lay out the draggable content (handle gaps + overscroll growth).
  final bool draggable;

  /// Whether to show the drag handle bar.
  final bool showDragHandle;

  /// Explicit drag handle size, or null for the density-derived default.
  final Size? dragHandleSize;

  /// Corner radius override for the drawer.
  final BorderRadiusGeometry? borderRadius;

  /// Inner content padding.
  final EdgeInsets padding;

  /// Outer margin around the container (used by sheets for safe-area insets).
  final EdgeInsets margin;

  /// Surface opacity for the background.
  final double? surfaceOpacity;

  /// Surface blur amount for the background.
  final double? surfaceBlur;

  /// Barrier color wash drawn behind the container when [fadeAnimation] is
  /// provided (simplified upstream `ModalBackdrop` behavior).
  final Color? barrierColor;

  /// Stack index (0 = top-most). Affects opacity weakening.
  final int stackIndex;

  /// Gap before the drag handle.
  final double? gapBeforeDragger;

  /// Gap after the drag handle.
  final double? gapAfterDragger;

  /// Size constraints for the container.
  final BoxConstraints? constraints;

  /// Alignment of the container within its constraints.
  final AlignmentGeometry? alignment;

  /// Fade animation driving the barrier wash. When null, no barrier is drawn.
  final Animation<double>? fadeAnimation;

  /// Extra space (freed by the backdrop transform) consumed on the outer edge.
  final Size extraSize;

  /// Live overscroll (drag past fully-open) in logical pixels. Applied as
  /// simplified leading-edge growth padding (upstream uses a dedicated
  /// render object; visually equivalent for small values).
  final double overscroll;

  /// The measured content size, used for the overscroll growth divisor.
  final Size size;

  /// Optional wrapper applied around the inner handle+content layout, used
  /// by callers to attach a drag gesture that stays inside the decoration.
  final Widget Function(BuildContext context, Widget layout)? gestureWrapper;

  /// Cross-axis padding on the leading edge.
  final double startPadding;

  /// Cross-axis padding on the trailing edge.
  final double endPadding;

  /// Optional explicit cross-axis size. When set, the sheet does not stretch
  /// edge-to-edge; it is sized to this and positioned by [crossAxisAlignment].
  final AxisSize? crossAxisSize;

  /// Cross-axis alignment in `[-1, 1]` (-1 = start, 0 = center, 1 = end).
  /// Only meaningful when [crossAxisSize] bounds the sheet smaller than
  /// the axis.
  final double crossAxisAlignment;

  /// Creates a drawer container.
  const DrawerRawContainer({
    super.key,
    required this.position,
    required this.child,
    required this.size,
    required this.stackIndex,
    this.expands = false,
    this.draggable = true,
    this.showDragHandle = true,
    this.dragHandleSize,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor,
    this.gapBeforeDragger,
    this.gapAfterDragger,
    this.constraints,
    this.alignment,
    this.fadeAnimation,
    this.extraSize = Size.zero,
    this.overscroll = 0,
    this.gestureWrapper,
    this.startPadding = 0,
    this.endPadding = 0,
    this.crossAxisSize,
    this.crossAxisAlignment = 0,
  });

  bool get _crossIsHorizontal =>
      position == OverlayPosition.top || position == OverlayPosition.bottom;

  /// The border drawn around the drawer. Drawers border three sides.
  Border getBorder(ThemeData theme) {
    switch (position) {
      case OverlayPosition.left:
        return Border(
          right: BorderSide(color: theme.colorScheme.border),
          top: BorderSide(color: theme.colorScheme.border),
          bottom: BorderSide(color: theme.colorScheme.border),
        );
      case OverlayPosition.right:
        return Border(
          left: BorderSide(color: theme.colorScheme.border),
          top: BorderSide(color: theme.colorScheme.border),
          bottom: BorderSide(color: theme.colorScheme.border),
        );
      case OverlayPosition.top:
        return Border(
          left: BorderSide(color: theme.colorScheme.border),
          right: BorderSide(color: theme.colorScheme.border),
          bottom: BorderSide(color: theme.colorScheme.border),
        );
      case OverlayPosition.bottom:
        return Border(
          left: BorderSide(color: theme.colorScheme.border),
          right: BorderSide(color: theme.colorScheme.border),
          top: BorderSide(color: theme.colorScheme.border),
        );
      default:
        return Border.all(color: theme.colorScheme.border);
    }
  }

  /// The border radius applied to the two outer corners.
  BorderRadiusGeometry getBorderRadius(double radius) {
    switch (position) {
      case OverlayPosition.left:
        return BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        );
      case OverlayPosition.right:
        return BorderRadius.only(
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
        );
      case OverlayPosition.top:
        return BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        );
      case OverlayPosition.bottom:
        return BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        );
      default:
        return BorderRadius.circular(radius);
    }
  }

  /// The background decoration for the drawer.
  BoxDecoration getDecoration(ThemeData theme) {
    var backgroundColor = theme.colorScheme.background;
    var opacity = surfaceOpacity ?? theme.surfaceOpacity;
    if (opacity != null && opacity < 1) {
      var adjusted = opacity;
      if (stackIndex == 0) adjusted = (opacity * 1.25).clamp(0.0, 1.0);
      backgroundColor = backgroundColor.scaleAlpha(adjusted);
    }
    return BoxDecoration(
      color: backgroundColor,
      border: getBorder(theme),
      borderRadius: borderRadius ?? getBorderRadius(theme.radiusLg),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final handleSize =
        dragHandleSize ?? Size(32 * scaling, 4 * scaling);
    final before = gapBeforeDragger ?? theme.density.baseGap * scaling;
    final after = gapAfterDragger ?? theme.density.baseGap * scaling * 0.5;

    final isHorizontal = _crossIsHorizontal;
    final overscrollGrowth = overscroll <= 0
        ? EdgeInsets.zero
        : switch (position) {
            OverlayPosition.left => EdgeInsets.only(right: overscroll),
            OverlayPosition.right => EdgeInsets.only(left: overscroll),
            OverlayPosition.top => EdgeInsets.only(bottom: overscroll),
            OverlayPosition.bottom => EdgeInsets.only(top: overscroll),
            _ => EdgeInsets.zero,
          };

    Widget layout = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (draggable && showDragHandle) ...[
          SizedBox(height: before),
          Center(
            child: Container(
              width: handleSize.width,
              height: handleSize.height,
              decoration: BoxDecoration(
                color: theme.colorScheme.border,
                borderRadius: BorderRadius.circular(handleSize.height / 2),
              ),
            ),
          ),
          SizedBox(height: after),
        ],
        Flexible(child: Padding(padding: overscrollGrowth, child: child)),
      ],
    );
    if (gestureWrapper != null) {
      layout = Builder(
        builder: (context) => gestureWrapper!(context, layout),
      );
    }

    Widget decorated = Container(
      padding: padding,
      decoration: getDecoration(theme),
      child: layout,
    );
    if ((surfaceBlur ?? 0) > 0) {
      decorated = ClipRRect(
        borderRadius:
            borderRadius ?? getBorderRadius(theme.radiusLg),
        child: BackdropFilter(
          filter: _blurFilter(surfaceBlur!),
          child: decorated,
        ),
      );
    }

    Widget sized = LayoutBuilder(
      builder: (context, constraints) {
        final crossAxis = crossAxisSize?.resolve(
          isHorizontal ? constraints.maxWidth : constraints.maxHeight,
        );
        if (crossAxis == null) {
          Widget stretched = SizedBox(
            width: isHorizontal || expands ? double.infinity : null,
            child: decorated,
          );
          return stretched;
        }
        final align = Alignment(
          isHorizontal ? crossAxisAlignment : 0,
          isHorizontal ? 0 : crossAxisAlignment,
        );
        return Align(
          alignment: align,
          child: SizedBox(
            width: isHorizontal ? crossAxis : (expands ? double.infinity : null),
            height:
                isHorizontal ? null : (expands ? double.infinity : crossAxis),
            child: decorated,
          ),
        );
      },
    );

    if (constraints != null) {
      sized = ConstrainedBox(constraints: constraints!, child: sized);
    }
    if (alignment != null) {
      sized = Align(alignment: alignment!, child: sized);
    }
    if (margin != EdgeInsets.zero ||
        extraSize != Size.zero ||
        startPadding != 0 ||
        endPadding != 0) {
      sized = Padding(
        padding: margin +
            EdgeInsets.only(
              left: startPadding + extraSize.width,
              right: endPadding,
              top: extraSize.height,
            ),
        child: sized,
      );
    }

    if (fadeAnimation != null && barrierColor != null) {
      return Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: fadeAnimation!,
              child: ColoredBox(color: barrierColor!),
            ),
          ),
          sized,
        ],
      );
    }
    return sized;
  }
}

/// Backdrop blur filter helper (avoids a `dart:ui` import in the barrel).
ImageFilter _blurFilter(double sigma) => ImageFilter.blur(
      sigmaX: sigma,
      sigmaY: sigma,
    );

/// A sheet-styled raw container (single-edge border, square corners).
/// Upstream parity with `shadcn_flutter`'s `SheetRawContainer`.
class SheetRawContainer extends DrawerRawContainer {
  /// Creates a sheet container.
  const SheetRawContainer({
    super.key,
    required super.position,
    required super.child,
    required super.size,
    required super.stackIndex,
    super.expands = true,
    super.draggable = false,
    super.showDragHandle = true,
    super.dragHandleSize,
    super.padding,
    super.margin,
    super.surfaceOpacity,
    super.surfaceBlur,
    super.barrierColor,
    super.gapBeforeDragger,
    super.gapAfterDragger,
    super.constraints,
    super.alignment,
    super.fadeAnimation,
    super.extraSize,
    super.overscroll,
    super.gestureWrapper,
    super.startPadding,
    super.endPadding,
    super.crossAxisSize,
    super.crossAxisAlignment,
  });

  @override
  Border getBorder(ThemeData theme) {
    switch (position) {
      case OverlayPosition.left:
        return Border(right: BorderSide(color: theme.colorScheme.border));
      case OverlayPosition.right:
        return Border(left: BorderSide(color: theme.colorScheme.border));
      case OverlayPosition.top:
        return Border(bottom: BorderSide(color: theme.colorScheme.border));
      case OverlayPosition.bottom:
        return Border(top: BorderSide(color: theme.colorScheme.border));
      default:
        return Border.all(color: theme.colorScheme.border);
    }
  }

  @override
  BorderRadiusGeometry getBorderRadius(double radius) => BorderRadius.zero;

  @override
  BoxDecoration getDecoration(ThemeData theme) {
    var backgroundColor = theme.colorScheme.background;
    var opacity = surfaceOpacity ?? theme.surfaceOpacity;
    if (opacity != null && opacity < 1) {
      var adjusted = opacity;
      if (stackIndex == 0) adjusted = (opacity * 1.25).clamp(0.0, 1.0);
      backgroundColor = backgroundColor.scaleAlpha(adjusted);
    }
    return BoxDecoration(color: backgroundColor, border: getBorder(theme));
  }
}

/// The configuration for a [DrawerContainer], provided to descendants via a
/// [Data] widget (upstream parity with `shadcn_flutter`).
///
/// A [DrawerContainer] reads this and builds the appropriate raw container
/// (drawer or sheet) around its child. This lets a content builder wrap
/// arbitrary content in a bare `DrawerContainer(child: ...)` without
/// threading every visual parameter through the builder.
class DrawerContainerData {
  /// The resolved position.
  final OverlayPosition position;

  /// The measured content size.
  final Size size;

  /// The stack index (0 = top-most).
  final int stackIndex;

  /// Whether the container expands along the cross axis.
  final bool expands;

  /// Whether to lay out the draggable content.
  final bool draggable;

  /// Whether to show the drag handle.
  final bool showDragHandle;

  /// Explicit drag handle size.
  final Size? dragHandleSize;

  /// Corner radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Inner content padding.
  final EdgeInsets padding;

  /// Outer margin.
  final EdgeInsets margin;

  /// Surface opacity.
  final double? surfaceOpacity;

  /// Surface blur.
  final double? surfaceBlur;

  /// Barrier color.
  final Color? barrierColor;

  /// Gap before the drag handle.
  final double? gapBeforeDragger;

  /// Gap after the drag handle.
  final double? gapAfterDragger;

  /// Size constraints.
  final BoxConstraints? constraints;

  /// Alignment within constraints.
  final AlignmentGeometry? alignment;

  /// Fade animation driving the barrier wash.
  final Animation<double>? fadeAnimation;

  /// Extra freed space consumed on the outer edge.
  final Size extraSize;

  /// Live overscroll in logical pixels.
  final double overscroll;

  /// Creates a drawer container configuration.
  const DrawerContainerData({
    required this.position,
    required this.size,
    required this.stackIndex,
    this.expands = false,
    this.draggable = true,
    this.showDragHandle = true,
    this.dragHandleSize,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor,
    this.gapBeforeDragger,
    this.gapAfterDragger,
    this.constraints,
    this.alignment,
    this.fadeAnimation,
    this.extraSize = Size.zero,
    this.overscroll = 0,
  });

  /// Builds a [DrawerRawContainer] around [child] using this configuration.
  Widget buildDrawer(
    Widget child, {
    double startPadding = 0,
    double endPadding = 0,
    AxisSize? crossAxisSize,
    double crossAxisAlignment = 0,
  }) {
    return DrawerRawContainer(
      position: position,
      size: size,
      stackIndex: stackIndex,
      expands: expands,
      draggable: draggable,
      showDragHandle: showDragHandle,
      dragHandleSize: dragHandleSize,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      barrierColor: barrierColor,
      gapBeforeDragger: gapBeforeDragger,
      gapAfterDragger: gapAfterDragger,
      constraints: constraints,
      alignment: alignment,
      fadeAnimation: fadeAnimation,
      extraSize: extraSize,
      overscroll: overscroll,
      startPadding: startPadding,
      endPadding: endPadding,
      crossAxisSize: crossAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      child: child,
    );
  }

  /// Builds a [SheetRawContainer] around [child] using this configuration.
  Widget buildSheet(
    Widget child, {
    double startPadding = 0,
    double endPadding = 0,
    AxisSize? crossAxisSize,
    double crossAxisAlignment = 0,
  }) {
    return SheetRawContainer(
      position: position,
      size: size,
      stackIndex: stackIndex,
      expands: expands,
      draggable: draggable,
      showDragHandle: showDragHandle,
      dragHandleSize: dragHandleSize,
      padding: padding,
      margin: margin,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      barrierColor: barrierColor,
      gapBeforeDragger: gapBeforeDragger,
      gapAfterDragger: gapAfterDragger,
      constraints: constraints,
      alignment: alignment,
      fadeAnimation: fadeAnimation,
      extraSize: extraSize,
      overscroll: overscroll,
      startPadding: startPadding,
      endPadding: endPadding,
      crossAxisSize: crossAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      child: child,
    );
  }
}

/// A drawer container that takes only a [child] and reads the rest of its
/// configuration from an ancestor [DrawerContainerData] (upstream parity).
///
/// Delegates to [DrawerRawContainer]. The caller may additionally control
/// cross-axis padding ([startPadding], [endPadding]), the cross-axis [size],
/// and [alignment] (-1 start, 0 center, 1 end; or the
/// [DrawerContainer.alignStart]/[alignCenter]/[alignEnd] constructors).
class DrawerContainer extends StatelessWidget {
  /// The sheet content.
  final Widget child;

  /// Cross-axis padding on the leading edge.
  final double startPadding;

  /// Cross-axis padding on the trailing edge.
  final double endPadding;

  /// Optional cross-axis size (so the sheet doesn't stretch edge-to-edge).
  final AxisSize? size;

  /// Cross-axis alignment in `[-1, 1]`.
  final double alignment;

  /// Creates a data-driven drawer container.
  const DrawerContainer({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
    this.alignment = 0,
  });

  /// A drawer container aligned to the cross-axis start.
  const DrawerContainer.alignStart({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = -1;

  /// A drawer container centered on the cross axis.
  const DrawerContainer.alignCenter({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = 0;

  /// A drawer container aligned to the cross-axis end.
  const DrawerContainer.alignEnd({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = 1;

  @override
  Widget build(BuildContext context) {
    return Data.of<DrawerContainerData>(context).buildDrawer(
      child,
      startPadding: startPadding,
      endPadding: endPadding,
      crossAxisSize: size,
      crossAxisAlignment: alignment,
    );
  }
}

/// A sheet container that takes only a [child] and reads the rest of its
/// configuration from an ancestor [DrawerContainerData] (upstream parity).
///
/// Delegates to [SheetRawContainer].
class SheetContainer extends StatelessWidget {
  /// The sheet content.
  final Widget child;

  /// Cross-axis padding on the leading edge.
  final double startPadding;

  /// Cross-axis padding on the trailing edge.
  final double endPadding;

  /// Optional cross-axis size (so the sheet doesn't stretch edge-to-edge).
  final AxisSize? size;

  /// Cross-axis alignment in `[-1, 1]`.
  final double alignment;

  /// Creates a data-driven sheet container.
  const SheetContainer({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
    this.alignment = 0,
  });

  /// A sheet container aligned to the cross-axis start.
  const SheetContainer.alignStart({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = -1;

  /// A sheet container centered on the cross axis.
  const SheetContainer.alignCenter({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = 0;

  /// A sheet container aligned to the cross-axis end.
  const SheetContainer.alignEnd({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = 1;

  @override
  Widget build(BuildContext context) {
    return Data.of<DrawerContainerData>(context).buildSheet(
      child,
      startPadding: startPadding,
      endPadding: endPadding,
      crossAxisSize: size,
      crossAxisAlignment: alignment,
    );
  }
}
