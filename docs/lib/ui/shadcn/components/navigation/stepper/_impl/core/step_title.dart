// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// StepTitle defines a reusable type for this registry module.
class StepTitle extends StatelessWidget {
  /// The main title widget for the step.
  final Widget title;

  /// Optional subtitle widget displayed below the title.
  final Widget? subtitle;

  /// Cross-axis alignment for the title and subtitle.
  final CrossAxisAlignment crossAxisAlignment;

  /// Callback invoked when the title is pressed.
  final VoidCallback? onPressed;

  /// Creates a [StepTitle].
  ///
  /// The [title] is required. The [subtitle], [crossAxisAlignment], and
  /// [onPressed] parameters are optional.
  ///
  /// Parameters:
  /// - [title] (Widget, required): main title content
  /// - [subtitle] (Widget?): optional subtitle below title
  /// - [crossAxisAlignment] (CrossAxisAlignment): text alignment (default: stretch)
  /// - [onPressed] (VoidCallback?): tap callback for interaction
  ///
  /// Example:
  /// ```dart
  /// StepTitle(
  ///   title: Text('Payment Info'),
  ///   subtitle: Text('Credit card details'),
  ///   crossAxisAlignment: CrossAxisAlignment.center,
  ///   onPressed: () => navigateToPayment(),
  /// );
  /// ```
  const StepTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.onPressed,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Clickable(
      mouseCursor: WidgetStatePropertyAll(
        onPressed == null ? MouseCursor.defer : SystemMouseCursors.click,
      ),
      onPressed: onPressed,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            title,
            if (subtitle != null) ...[
              /// Creates a `DensityGap` instance.
              DensityGap(0.25),
              subtitle!.muted().xSmall(),
            ],
          ],
        ),
      ),
    );
  }
}
