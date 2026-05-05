part of '../../card.dart';

/// A versatile container widget that provides a card-like appearance with styling options.
class Card extends StatelessWidget {
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

  /// Creates a [Card].
  const Card({
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
    final scaling = theme.scaling;
    final padding = styleValue(
      widgetValue: this.padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.all(theme.density.baseContentPadding * scaling),
    );
    final filled = styleValue(
      widgetValue: this.filled,
      themeValue: compTheme?.filled,
      defaultValue: false,
    );
    final fillColor = styleValue(
      widgetValue: this.fillColor,
      themeValue: compTheme?.fillColor,
      defaultValue: theme.colorScheme.border,
    );
    final borderRadius = styleValue(
      widgetValue: this.borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: null,
    );
    final borderColor = styleValue(
      widgetValue: this.borderColor,
      themeValue: compTheme?.borderColor,
      defaultValue: null,
    );
    final borderWidth = styleValue(
      widgetValue: this.borderWidth,
      themeValue: compTheme?.borderWidth,
      defaultValue: null,
    );
    final clipBehavior = styleValue(
      widgetValue: this.clipBehavior,
      themeValue: compTheme?.clipBehavior,
      defaultValue: Clip.none,
    );
    final boxShadow = styleValue(
      widgetValue: this.boxShadow,
      themeValue: compTheme?.boxShadow,
      defaultValue: null,
    );
    final surfaceOpacity = styleValue(
      widgetValue: this.surfaceOpacity,
      themeValue: compTheme?.surfaceOpacity,
      defaultValue: null,
    );
    final surfaceBlur = styleValue(
      widgetValue: this.surfaceBlur,
      themeValue: compTheme?.surfaceBlur,
      defaultValue: null,
    );
    final duration = styleValue(
      widgetValue: this.duration,
      themeValue: compTheme?.duration,
      defaultValue: null,
    );

    return OutlinedContainer(
      clipBehavior: clipBehavior,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      borderColor: borderColor,
      backgroundColor: filled ? fillColor : theme.colorScheme.card,
      boxShadow: boxShadow,
      padding: padding,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      duration: duration,
      child: DefaultTextStyle.merge(
        child: child,
        style: TextStyle(color: theme.colorScheme.cardForeground),
      ),
    );
  }
}

/// A card variant with surface blur and opacity effects.
