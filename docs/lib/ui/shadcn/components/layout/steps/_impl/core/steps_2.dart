// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../steps.dart';

/// Steps defines a reusable type for this registry module.
class Steps extends StatelessWidget {
  /// List of widgets representing each step in the sequence.
  ///
  /// Each widget will be displayed with an automatically numbered
  /// circular indicator showing its position in the sequence.
  final List<Widget> children;

  /// Creates a [Steps] widget.
  ///
  /// Each child widget represents one step in the sequence and will be
  /// displayed with an automatically numbered circular indicator.
  ///
  /// Parameters:
  /// - [children] (`List<Widget>`, required): list of widgets representing each step
  ///
  /// Example:
  /// ```dart
  /// Steps(
  ///   children: [
  ///     Text('First step content'),
  ///     Text('Second step content'),
  ///     Text('Third step content'),
  ///   ],
  /// )
  /// ```
  const Steps({super.key, required this.children});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<StepsTheme>(context);

    /// Stores `indicatorSize` state/configuration for this implementation.
    final indicatorSize = compTheme?.indicatorSize ?? 28 * scaling;
    final spacing =
        compTheme?.spacing ??
        theme.density.baseContentPadding * scaling * 1.125;

    /// Stores `indicatorColor` state/configuration for this implementation.
    final indicatorColor = compTheme?.indicatorColor ?? theme.colorScheme.muted;

    /// Stores `connectorThickness` state/configuration for this implementation.
    final connectorThickness = compTheme?.connectorThickness ?? 1 * scaling;

    /// Stores `mapped` state/configuration for this implementation.
    List<Widget> mapped = [];
    for (var i = 0; i < children.length; i++) {
      /// Creates a `mapped.add` instance.
      mapped.add(
        /// Creates a `IntrinsicHeight` instance.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Creates a `Column` instance.
              Column(
                children: [
                  /// Creates a `Container` instance.
                  Container(
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                    ),
                    width: indicatorSize,
                    height: indicatorSize,
                    child: Center(
                      child: Text((i + 1).toString()).mono().bold(),
                    ),
                  ),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gapXs),

                  /// Creates a `Expanded` instance.
                  Expanded(
                    child: VerticalDivider(
                      thickness: connectorThickness,
                      color: indicatorColor,
                    ),
                  ),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gapXs),
                ],
              ),

              /// Creates a `Gap` instance.
              Gap(spacing),

              /// Creates a `Expanded` instance.
              Expanded(child: children[i].withPadding(bottom: 32 * scaling)),
            ],
          ),
        ),
      );
    }
    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: mapped,
      ),
    );
  }
}
