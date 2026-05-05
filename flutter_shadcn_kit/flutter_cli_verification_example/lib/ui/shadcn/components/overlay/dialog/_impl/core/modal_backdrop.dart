part of '../../dialog.dart';

/// ModalBackdrop defines a reusable type for this registry module.
class ModalBackdrop extends StatelessWidget {
  /// Determines if surface clipping should be enabled based on opacity.
  ///
  /// Returns `true` if [surfaceOpacity] is null or less than 1.0,
  /// indicating that clipping is needed for proper visual effects.
  static bool shouldClipSurface(double? surfaceOpacity) {
    if (surfaceOpacity == null) {
      return true;
    }
    return surfaceOpacity < 1;
  }

  /// The child widget to display above the backdrop.
  final Widget child;

  /// Border radius for the backdrop cutout around the child.
  final BorderRadiusGeometry? borderRadius;

  /// Padding around the child widget.
  final EdgeInsetsGeometry? padding;

  /// Color of the backdrop barrier.
  final Color? barrierColor;

  /// Animation for fade in/out transitions.
  final Animation<double>? fadeAnimation;

  /// Whether the backdrop should behave as a modal.
  final bool? modal;

  /// Whether to apply surface clipping effects.
  final bool? surfaceClip;

  /// Creates a [ModalBackdrop].
  ///
  /// The [child] parameter is required and represents the content to display
  /// above the backdrop.
  ///
  /// Parameters:
  /// - [child] (Widget, required): content widget displayed above backdrop
  /// - [modal] (bool?, optional): enables modal behavior, defaults to true
  /// - [surfaceClip] (bool?, optional): enables surface clipping, defaults to true
  /// - [borderRadius] (BorderRadiusGeometry?, optional): corner radius for cutout
  /// - [barrierColor] (Color?, optional): backdrop color, defaults to black with 80% opacity
  /// - [padding] (EdgeInsetsGeometry?, optional): padding around child
  /// - [fadeAnimation] (`Animation<double>?`, optional): fade transition animation
  ///
  /// Example:
  /// ```dart
  /// ModalBackdrop(
  ///   barrierColor: Colors.black54,
  ///   fadeAnimation: slideController,
  ///   child: AlertDialog(title: Text('Alert')),
  /// )
  /// ```
  const ModalBackdrop({
    super.key,
    this.modal,
    this.surfaceClip,
    this.borderRadius,
    this.barrierColor,
    this.padding,
    this.fadeAnimation,
    required this.child,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<ModalBackdropTheme>(context);
    final modal = styleValue(
      widgetValue: this.modal,
      themeValue: compTheme?.modal,
      defaultValue: true,
    );
    final surfaceClip = styleValue(
      widgetValue: this.surfaceClip,
      themeValue: compTheme?.surfaceClip,
      defaultValue: true,
    );
    final borderRadius = styleValue(
      widgetValue: this.borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: BorderRadius.zero,
    );
    final padding = styleValue(
      widgetValue: this.padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.zero,
    );
    final barrierColor = styleValue(
      widgetValue: this.barrierColor,
      themeValue: compTheme?.barrierColor,
      defaultValue: const Color.fromRGBO(0, 0, 0, 0.8),
    );
    if (!modal) {
      return child;
    }
    var textDirection = Directionality.of(context);
    var resolvedBorderRadius = borderRadius.resolve(textDirection);
    var resolvedPadding = padding.resolve(textDirection);
    Widget paintWidget = CustomPaint(
      painter: SurfaceBarrierPainter(
        clip: surfaceClip,
        borderRadius: resolvedBorderRadius,
        barrierColor: barrierColor,
        padding: resolvedPadding,
      ),
    );
    if (fadeAnimation != null) {
      paintWidget = FadeTransition(opacity: fadeAnimation!, child: paintWidget);
    }
    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          if (!surfaceClip)
/// Creates a `Positioned.fill` instance.
            Positioned.fill(child: IgnorePointer(child: paintWidget)),
          child,
          if (surfaceClip)
/// Creates a `Positioned.fill` instance.
            Positioned.fill(child: IgnorePointer(child: paintWidget)),
        ],
      ),
    );
  }
}

/// A container widget that provides consistent styling for modal content.
///
/// Wraps modal content in a [SurfaceCard] with appropriate styling that
/// adapts to full-screen mode. Handles surface effects, borders, shadows,
/// and clipping behavior automatically based on the modal context.
///
/// Features:
/// - Automatic full-screen mode detection
/// - Surface styling with blur and opacity effects
/// - Configurable borders and shadows
/// - Clip behavior control
/// - Theme integration
///
/// Example:
/// ```dart
/// ModalContainer(
///   padding: EdgeInsets.all(16),
///   borderRadius: BorderRadius.circular(12),
///   filled: true,
///   child: Column(
///     children: [
///       Text('Dialog Title'),
///       Text('Dialog content here'),
///     ],
///   ),
/// )
/// ```
