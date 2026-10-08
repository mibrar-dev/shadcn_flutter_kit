// The `drawer_container` component: reusable drawer/sheet chrome for pinned
// sheets and drawer overlays.
//
// Ported from `components/overlay/drawer_container`. The old tree read a
// `data_widget` `Data<DrawerContainerData>` ancestor, themed with
// `Theme.colorScheme`, and shipped a `SheetRawContainer` subclass plus glass
// and overscroll-growth parameters the accepted `drawer` already dropped.
// This port reads the ambient shadcn tokens, folds the sheet chrome into
// `isSheet`, and keeps the `AxisSize` algebra verbatim.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../primitives/axis_size.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../drawer/drawer.dart' show OverlayPosition;
export '../../primitives/axis_size.dart';
export '../drawer/drawer.dart' show OverlayPosition;

/// The visual chrome of a drawer or sheet: background, edge border, rounded
/// outer corners, an optional drag handle and an optional barrier wash.
///
/// The drag *gesture* is intentionally not owned here — callers wrap this
/// container in their own gesture detector.
class DrawerRawContainer extends StatelessWidget {
  const DrawerRawContainer({
    super.key,
    required this.position,
    required this.child,
    this.isSheet = false,
    this.expands = false,
    this.draggable = true,
    this.showDragHandle = true,
    this.dragHandleSize,
    this.borderRadius,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.barrierColor,
    this.gapBeforeDragger,
    this.gapAfterDragger,
    this.constraints,
    this.alignment,
    this.fadeAnimation,
    this.crossAxisSize,
    this.crossAxisAlignment = 0,
    this.startPadding = 0,
    this.endPadding = 0,
  });

  final OverlayPosition position;

  final Widget child;

  final bool isSheet;

  final bool expands;

  final bool draggable;

  final bool showDragHandle;

  final Size? dragHandleSize;

  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry? padding;

  final EdgeInsets margin;

  final Color? barrierColor;

  final double? gapBeforeDragger;

  final double? gapAfterDragger;

  final BoxConstraints? constraints;

  final AlignmentGeometry? alignment;

  final Animation<double>? fadeAnimation;

  final AxisSize? crossAxisSize;

  final double crossAxisAlignment;

  final double startPadding;

  final double endPadding;

  bool get _crossIsHorizontal =>
      position == OverlayPosition.top || position == OverlayPosition.bottom;

  Border _border(ShadcnColors colors) {
    final BorderSide side = BorderSide(color: colors.border);
    if (isSheet) {
      return switch (position) {
        OverlayPosition.left => Border(right: side),
        OverlayPosition.right => Border(left: side),
        OverlayPosition.top => Border(bottom: side),
        OverlayPosition.bottom => Border(top: side),
        OverlayPosition.start ||
        OverlayPosition.end => Border.all(color: colors.border),
      };
    }
    return switch (position) {
      OverlayPosition.left => Border(top: side, right: side, bottom: side),
      OverlayPosition.right => Border(top: side, left: side, bottom: side),
      OverlayPosition.top => Border(left: side, right: side, bottom: side),
      OverlayPosition.bottom => Border(left: side, right: side, top: side),
      OverlayPosition.start ||
      OverlayPosition.end => Border.all(color: colors.border),
    };
  }

  BorderRadius _resolvedRadius(double radius) {
    if (isSheet) {
      return BorderRadius.zero;
    }
    return switch (position) {
      OverlayPosition.left => BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
      OverlayPosition.right => BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      ),
      OverlayPosition.top => BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
      OverlayPosition.bottom => BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      OverlayPosition.start ||
      OverlayPosition.end => BorderRadius.circular(radius),
    };
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnColors colors = theme.colors;
    final Size handle = dragHandleSize ?? const Size(32, 4);
    final bool isHorizontal = _crossIsHorizontal;

    final Widget layout = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (draggable && showDragHandle) ...<Widget>[
          SizedBox(height: gapBeforeDragger ?? 8),
          Center(
            child: Container(
              width: handle.width,
              height: handle.height,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(handle.height / 2),
              ),
            ),
          ),
          SizedBox(height: gapAfterDragger ?? 4),
        ],
        Flexible(child: child),
      ],
    );

    final Widget decorated = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        border: _border(colors),
        borderRadius: borderRadius ?? _resolvedRadius(theme.radiusLg),
      ),
      child: layout,
    );

    Widget sized = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final double? crossAxis = crossAxisSize?.resolve(
          isHorizontal ? box.maxWidth : box.maxHeight,
        );
        if (crossAxis == null) {
          return SizedBox(
            width: isHorizontal || expands ? double.infinity : null,
            child: decorated,
          );
        }
        return Align(
          alignment: Alignment(
            isHorizontal ? crossAxisAlignment : 0,
            isHorizontal ? 0 : crossAxisAlignment,
          ),
          child: SizedBox(
            width: isHorizontal
                ? crossAxis
                : (expands ? double.infinity : null),
            height: isHorizontal
                ? (expands ? double.infinity : null)
                : crossAxis,
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
    if (margin != EdgeInsets.zero || startPadding != 0 || endPadding != 0) {
      sized = Padding(
        padding:
            margin + EdgeInsets.only(left: startPadding, right: endPadding),
        child: sized,
      );
    }

    if (fadeAnimation != null && barrierColor != null) {
      return Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
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

/// The configuration for a [DrawerContainer], provided to descendants via a
/// [Data] widget.
class DrawerContainerData {
  const DrawerContainerData({
    required this.position,
    this.isSheet = false,
    this.expands = false,
    this.draggable = true,
    this.showDragHandle = true,
    this.dragHandleSize,
    this.borderRadius,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.barrierColor,
    this.gapBeforeDragger,
    this.gapAfterDragger,
    this.constraints,
    this.alignment,
    this.fadeAnimation,
  });

  final OverlayPosition position;

  final bool isSheet;

  final bool expands;

  final bool draggable;

  final bool showDragHandle;

  final Size? dragHandleSize;

  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry? padding;

  final EdgeInsets margin;

  final Color? barrierColor;

  final double? gapBeforeDragger;

  final double? gapAfterDragger;

  final BoxConstraints? constraints;

  final AlignmentGeometry? alignment;

  final Animation<double>? fadeAnimation;

  Widget build(
    Widget child, {
    double startPadding = 0,
    double endPadding = 0,
    AxisSize? crossAxisSize,
    double crossAxisAlignment = 0,
  }) {
    return DrawerRawContainer(
      position: position,
      isSheet: isSheet,
      expands: expands,
      draggable: draggable,
      showDragHandle: showDragHandle,
      dragHandleSize: dragHandleSize,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      barrierColor: barrierColor,
      gapBeforeDragger: gapBeforeDragger,
      gapAfterDragger: gapAfterDragger,
      constraints: constraints,
      alignment: alignment,
      fadeAnimation: fadeAnimation,
      startPadding: startPadding,
      endPadding: endPadding,
      crossAxisSize: crossAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      child: child,
    );
  }
}

/// A container that takes only a [child] and reads the rest of its
/// configuration from an ancestor [DrawerContainerData].
class DrawerContainer extends StatelessWidget {
  const DrawerContainer({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
    this.alignment = 0,
  });

  const DrawerContainer.alignStart({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = -1;

  const DrawerContainer.alignCenter({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = 0;

  const DrawerContainer.alignEnd({
    super.key,
    required this.child,
    this.startPadding = 0,
    this.endPadding = 0,
    this.size,
  }) : alignment = 1;

  final Widget child;

  final double startPadding;

  final double endPadding;

  final AxisSize? size;

  final double alignment;

  @override
  Widget build(BuildContext context) {
    return Data.of<DrawerContainerData>(context).build(
      child,
      startPadding: startPadding,
      endPadding: endPadding,
      crossAxisSize: size,
      crossAxisAlignment: alignment,
    );
  }
}
