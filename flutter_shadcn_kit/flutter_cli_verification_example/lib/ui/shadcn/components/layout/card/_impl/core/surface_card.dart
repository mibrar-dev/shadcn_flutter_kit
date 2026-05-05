part of '../../card.dart';

/// SurfaceCard defines a reusable type for this registry module.
class SurfaceCard extends StatelessWidget {
  /// The child widget to display within the card.
  final Widget child;

  /// Padding inside the card around the [child].
  final EdgeInsetsGeometry? padding;

  /// Whether the card has a filled background.
  final bool? filled;

  /// The background fill color of the card.
  final Color? fillColor;

  /// Border radius for rounded corners on the card.
  final BorderRadiusGeometry? borderRadius;

  /// Color of the card's border.
  final Color? borderColor;

  /// Width of the card's border in logical pixels.
  final double? borderWidth;

  /// How to clip the card's content.
  final Clip? clipBehavior;

  /// Box shadows to apply to the card.
  final List<BoxShadow>? boxShadow;

  /// Opacity of the card's surface effect.
  final double? surfaceOpacity;

  /// Blur amount for the card's surface effect.
  final double? surfaceBlur;

  /// Duration for card appearance animations.
  final Duration? duration;

  /// Creates a [SurfaceCard].
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.filled,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior,
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
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<CardTheme>(context);
    final isSheetOverlay = SheetOverlayHandler.isSheetOverlay(context);
    final scaling = theme.scaling;
    if (isSheetOverlay) {
      final padding = styleValue(
        widgetValue: this.padding,
        themeValue: compTheme?.padding,
        defaultValue: EdgeInsets.all(
          theme.density.baseContentPadding * scaling,
        ),
      );
      return Padding(padding: padding, child: child);
    }
    return Card(
      clipBehavior: clipBehavior,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      borderColor: borderColor,
      filled: filled,
      fillColor: fillColor,
      boxShadow: boxShadow,
      padding: padding,
      surfaceOpacity:
          surfaceOpacity ?? compTheme?.surfaceOpacity ?? theme.surfaceOpacity,
      surfaceBlur: surfaceBlur ?? compTheme?.surfaceBlur ?? theme.surfaceBlur,
      duration: duration ?? compTheme?.duration,
      child: child,
    );
  }
}
