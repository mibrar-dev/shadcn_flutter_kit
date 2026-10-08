// The `outlined_container` component: [OutlinedContainer] (a themed bordered
// surface with optional translucency and backdrop blur), [SurfaceBlur] (the
// blur wrapper it re-exports), and the dashed [DashedContainer] /
// [DashedLine] painters.
//
// Owner copy per OWNERSHIP R2: the old `shared/primitives` fork's body is
// merged in and the dead widget-leg `theme` field now feeds the resolver.

import 'dart:math' as math;
import 'dart:ui' show ImageFilter, PathMetric;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'outlined_container_style.dart';

export 'outlined_container_style.dart';

/// A blur layer clipped to [borderRadius].
///
/// Rendered even at zero sigma so toggling [surfaceBlur] never remounts the
/// child subtree.
class SurfaceBlur extends StatelessWidget {
  /// Creates a blur layer.
  const SurfaceBlur({
    super.key,
    required this.child,
    required this.surfaceBlur,
    this.borderRadius,
  });

  /// The child blurred against the backdrop.
  final Widget child;

  /// Blur sigma; values <= 0 draw an identity filter.
  final double surfaceBlur;

  /// Clip radius of the blur layer. Default: square corners.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final double sigma = surfaceBlur <= 0 ? 0 : surfaceBlur;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: child,
      ),
    );
  }
}

/// An animated, outlined surface.
///
/// ```dart
/// OutlinedContainer(
///   padding: const EdgeInsets.all(16),
///   child: const Text('Card body'),
/// );
/// ```
class OutlinedContainer extends StatefulWidget {
  /// Creates an outlined container.
  const OutlinedContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.borderStyle,
    this.boxShadow,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.width,
    this.height,
    this.duration,
    this.theme,
  });

  /// Content inside the container.
  final Widget child;

  /// Surface fill override.
  final ThemedColor? backgroundColor;

  /// Border colour override.
  final ThemedColor? borderColor;

  /// Corner radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Border width override.
  final double? borderWidth;

  /// Border style override.
  final BorderStyle? borderStyle;

  /// Elevation shadows override.
  final List<BoxShadow>? boxShadow;

  /// Inner padding override.
  final EdgeInsetsGeometry? padding;

  /// How the child is clipped to the decoration.
  final Clip clipBehavior;

  /// Multiplies the fill alpha.
  final double? surfaceOpacity;

  /// Backdrop blur sigma; null or <= 0 draws no blur.
  final double? surfaceBlur;

  /// Fixed width.
  final double? width;

  /// Fixed height.
  final double? height;

  /// Animation duration for decoration changes; null snaps.
  final Duration? duration;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final OutlinedContainerTheme? theme;

  @override
  State<OutlinedContainer> createState() => _OutlinedContainerState();
}

class _OutlinedContainerState extends State<OutlinedContainer> {
  /// Keeps the child subtree alive when [SurfaceBlur] is added or removed.
  final GlobalKey _surfaceKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final OutlinedContainerTheme resolved =
        resolveComponentStyle<OutlinedContainerTheme, OutlinedContainerTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: outlinedContainerDefaults,
        );
    final BorderRadiusGeometry radius =
        widget.borderRadius ?? resolved.borderRadius ?? ambient.borderRadiusXl;
    final BorderRadius resolvedRadius = radius.resolve(
      Directionality.of(context),
    );
    final double? surfaceOpacity =
        widget.surfaceOpacity ?? resolved.surfaceOpacity;
    Color? background = (widget.backgroundColor ?? resolved.backgroundColor)
        ?.resolve(ambient.colors);
    if (background != null && surfaceOpacity != null) {
      background = background.withValues(
        alpha: (background.a * surfaceOpacity).clamp(0.0, 1.0),
      );
    }
    final Color borderColor =
        (widget.borderColor ?? resolved.borderColor)?.resolve(ambient.colors) ??
        ambient.colors.muted;
    final double borderWidth =
        widget.borderWidth ?? resolved.borderWidth ?? ambient.scaling;
    final BorderStyle borderStyle =
        widget.borderStyle ?? resolved.borderStyle ?? BorderStyle.solid;
    final List<BoxShadow> boxShadow =
        widget.boxShadow ?? resolved.boxShadow ?? const <BoxShadow>[];
    final EdgeInsetsGeometry padding =
        widget.padding ?? resolved.padding ?? EdgeInsets.zero;
    final double? surfaceBlur = widget.surfaceBlur ?? resolved.surfaceBlur;

    Widget surface = AnimatedContainer(
      key: _surfaceKey,
      duration: widget.duration ?? Duration.zero,
      width: widget.width,
      height: widget.height,
      clipBehavior: widget.clipBehavior,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
          style: borderStyle,
        ),
        borderRadius: resolvedRadius,
        boxShadow: boxShadow,
      ),
      child: widget.child,
    );
    if (surfaceBlur != null && surfaceBlur > 0) {
      surface = SurfaceBlur(
        surfaceBlur: surfaceBlur,
        borderRadius: _outlinedSubtractBorder(resolvedRadius, borderWidth),
        child: surface,
      );
    }
    return surface;
  }
}

/// Reduces each corner radius by [borderWidth], never below zero.
BorderRadius _outlinedSubtractBorder(BorderRadius radius, double borderWidth) {
  Radius safe(Radius corner) => Radius.elliptical(
    math.max(0, corner.x - borderWidth),
    math.max(0, corner.y - borderWidth),
  );

  return BorderRadius.only(
    topLeft: safe(radius.topLeft),
    topRight: safe(radius.topRight),
    bottomLeft: safe(radius.bottomLeft),
    bottomRight: safe(radius.bottomRight),
  );
}

/// Paints dashes along a rounded rectangle or a straight line.
class _DashedPainter extends CustomPainter {
  const _DashedPainter({
    required this.width,
    required this.gap,
    required this.thickness,
    required this.color,
    required this.rounded,
    this.borderRadius,
  });

  final double width;
  final double gap;
  final double thickness;
  final Color color;
  final bool rounded;
  final BorderRadius? borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final double step = gap + width;
    if (step <= 0) {
      return;
    }
    final Path path = Path();
    final BorderRadius radius = borderRadius ?? BorderRadius.zero;
    if (rounded) {
      path.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, size.height),
          topLeft: radius.topLeft,
          topRight: radius.topRight,
          bottomLeft: radius.bottomLeft,
          bottomRight: radius.bottomRight,
        ),
      );
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0);
    }
    final Path dashes = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      for (double start = 0; start < metric.length; start += step) {
        final double end = math.min(start + width, metric.length);
        dashes.addPath(metric.extractPath(start, end), Offset.zero);
      }
    }
    canvas.drawPath(
      dashes,
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _DashedPainter oldDelegate) =>
      oldDelegate.width != width ||
      oldDelegate.gap != gap ||
      oldDelegate.thickness != thickness ||
      oldDelegate.color != color ||
      oldDelegate.rounded != rounded ||
      oldDelegate.borderRadius != borderRadius;
}

/// A rounded-rectangle border painted as dashes.
class DashedContainer extends StatelessWidget {
  /// Creates a dashed border around [child].
  const DashedContainer({
    super.key,
    this.strokeWidth,
    this.gap,
    this.thickness,
    this.color,
    this.borderRadius,
    required this.child,
  });

  /// Length of one dash. Default: 8 times the ambient scaling.
  final double? strokeWidth;

  /// Space between dashes. Default: 5 times the ambient scaling.
  final double? gap;

  /// Stroke thickness. Default: the ambient scaling.
  final double? thickness;

  /// Dash colour. Default: the `border` token.
  final ThemedColor? color;

  /// Corner radius. Default: the ambient `borderRadiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// The child inside the dashed border.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    return CustomPaint(
      painter: _DashedPainter(
        width: strokeWidth ?? 8 * ambient.scaling,
        gap: gap ?? 5 * ambient.scaling,
        thickness: thickness ?? ambient.scaling,
        color: color?.resolve(ambient.colors) ?? ambient.colors.border,
        borderRadius: (borderRadius ?? ambient.borderRadiusLg).resolve(
          Directionality.of(context),
        ),
        rounded: true,
      ),
      child: child,
    );
  }
}

/// A horizontal dashed rule.
class DashedLine extends StatelessWidget {
  /// Creates a dashed rule.
  const DashedLine({
    super.key,
    this.width,
    this.gap,
    this.thickness,
    this.color,
  });

  /// Length of one dash. Default: 8 times the ambient scaling.
  final double? width;

  /// Space between dashes. Default: 5 times the ambient scaling.
  final double? gap;

  /// Stroke thickness. Default: the ambient scaling.
  final double? thickness;

  /// Dash colour. Default: the `border` token.
  final ThemedColor? color;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    return CustomPaint(
      painter: _DashedPainter(
        width: width ?? 8 * ambient.scaling,
        gap: gap ?? 5 * ambient.scaling,
        thickness: thickness ?? ambient.scaling,
        color: color?.resolve(ambient.colors) ?? ambient.colors.border,
        rounded: false,
      ),
    );
  }
}
