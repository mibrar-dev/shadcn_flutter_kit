part of '../../dialog.dart';

/// ModalContainer defines a reusable type for this registry module.
class ModalContainer extends StatelessWidget {
  /// Model key used to identify full-screen modal mode.
  static const kFullScreenMode = #modal_surface_card_fullscreen;

  /// Checks if the current context is in full-screen modal mode.
  ///
  /// Returns `true` if the modal should display in full-screen mode,
  /// which affects styling such as border radius and shadows.
  static bool isFullScreenMode(BuildContext context) {
    return Model.maybeOf<bool>(context, kFullScreenMode) == true;
  }

  /// The child widget to display inside the modal container.
  final Widget child;

  /// Padding applied inside the container around the child.
  final EdgeInsetsGeometry? padding;

  /// Whether the container should have a filled background.
  final bool filled;

  /// Background fill color when [filled] is true.
  final Color? fillColor;

  /// Border radius for the container corners.
  final BorderRadiusGeometry? borderRadius;

  /// Color of the container border.
  final Color? borderColor;

  /// Width of the container border in logical pixels.
  final double? borderWidth;

  /// Clipping behavior for the container content.
  final Clip clipBehavior;

  /// Drop shadow effects applied to the container.
  final List<BoxShadow>? boxShadow;

  /// Surface opacity for backdrop effects.
  final double? surfaceOpacity;

  /// Surface blur intensity for backdrop effects.
  final double? surfaceBlur;

  /// Animation duration for surface transitions.
  final Duration? duration;

  /// Creates a [ModalContainer].
  ///
  /// The [child] parameter is required. Other parameters customize the
  /// container's appearance and behavior.
  ///
  /// Parameters:
  /// - [child] (Widget, required): content to display in the container
  /// - [padding] (EdgeInsetsGeometry?, optional): inner padding around child
  /// - [filled] (bool, default: false): whether to show background fill
  /// - [fillColor] (Color?, optional): background fill color when filled is true
  /// - [borderRadius] (BorderRadiusGeometry?, optional): corner radius
  /// - [clipBehavior] (Clip, default: Clip.none): clipping behavior for content
  /// - [borderColor] (Color?, optional): border color
  /// - [borderWidth] (double?, optional): border width in logical pixels
  /// - [boxShadow] (`List<BoxShadow>?`, optional): drop shadow effects
  /// - [surfaceOpacity] (double?, optional): backdrop opacity level
  /// - [surfaceBlur] (double?, optional): backdrop blur intensity
  /// - [duration] (Duration?, optional): animation duration for transitions
  ///
  /// Example:
  /// ```dart
  /// ModalContainer(
  ///   filled: true,
  ///   padding: EdgeInsets.all(24),
  ///   borderRadius: BorderRadius.circular(8),
  ///   child: Text('Modal Content'),
  /// )
  /// ```
  const ModalContainer({
    super.key,
    required this.child,
    this.padding,
    this.filled = false,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    var fullScreenMode = Model.maybeOf<bool>(context, kFullScreenMode);
    return SurfaceCard(
      clipBehavior: clipBehavior,
      borderRadius: fullScreenMode == true ? BorderRadius.zero : borderRadius,
      borderWidth: fullScreenMode == true ? 0 : borderWidth,
      borderColor: borderColor,
      filled: filled,
      fillColor: fillColor,
      boxShadow: fullScreenMode == true ? const [] : boxShadow,
      padding: padding,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      duration: duration,
      child: child,
    );
  }
}

/// Custom painter that creates a barrier effect with an optional cutout.
///
/// Paints a large colored rectangle that covers the entire screen, with
/// an optional rounded rectangle cutout to create a "spotlight" effect
/// around modal content. Uses path clipping to create the cutout area.
///
/// Features:
/// - Full-screen barrier painting
/// - Rounded rectangle cutouts
/// - Configurable colors and padding
/// - Efficient repainting optimization
///
/// Example:
/// ```dart
/// CustomPaint(
///   painter: SurfaceBarrierPainter(
///     clip: true,
///     borderRadius: BorderRadius.circular(8),
///     barrierColor: Colors.black54,
///     padding: EdgeInsets.all(16),
///   ),
/// )
/// ```
