// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stage_container.dart';

/// StageContainer defines a reusable type for this registry module.
class StageContainer extends StatelessWidget {
  /// The breakpoint strategy for determining container width.
  ///
  /// Defaults to [StageBreakpoint.defaultBreakpoints].
  final StageBreakpoint breakpoint;

  /// Builder function that receives context and calculated padding.
  ///
  /// The padding parameter accounts for responsive adjustments.
  final Widget Function(BuildContext context, EdgeInsets padding) builder;

  /// Base padding for the container.
  ///
  /// Defaults to a density-aware horizontal padding when not provided.
  final EdgeInsets? padding;

  /// Creates a [StageContainer].
  const StageContainer({
    super.key,
    this.breakpoint = StageBreakpoint.defaultBreakpoints,
    required this.builder,
    this.padding,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<StageContainerTheme>(context);

    /// Stores `breakpoint` state/configuration for this implementation.
    final StageBreakpoint breakpoint = compTheme?.breakpoint ?? this.breakpoint;
    final EdgeInsets padding = styleValue(
      widgetValue: this.padding,
      defaultValue: EdgeInsets.symmetric(
        horizontal: theme.density.baseContainerPadding * 4.5,
      ),
      themeValue: compTheme?.padding,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        /// Stores `size` state/configuration for this implementation.
        var size = constraints.maxWidth;

        /// Stores `topPadding` state/configuration for this implementation.
        double topPadding = padding.top;

        /// Stores `bottomPadding` state/configuration for this implementation.
        double bottomPadding = padding.bottom;

        /// Stores `leftPadding` state/configuration for this implementation.
        double leftPadding = padding.left;

        /// Stores `rightPadding` state/configuration for this implementation.
        double rightPadding = padding.right;
        if (size < breakpoint.minSize) {
          return builder(context, padding.copyWith(left: 0, right: 0));
        } else if (size > breakpoint.maxSize) {
          double remainingWidth = (size - breakpoint.maxSize) / 2;
          leftPadding += remainingWidth;
          rightPadding += remainingWidth;
          leftPadding = max(0, leftPadding);
          rightPadding = max(0, rightPadding);
          return builder(
            context,

            /// Creates a `EdgeInsets.only` instance.
            EdgeInsets.only(
              top: topPadding,
              bottom: bottomPadding,
              left: leftPadding,
              right: rightPadding,
            ),
          );
        }
        double minWidth = breakpoint.getMinWidth(size);
        double maxWidth = breakpoint.getMaxWidth(size);

        /// Creates a `assert` instance.
        assert(
          minWidth <= maxWidth,
          'minWidth must be less than or equal to maxWidth ($minWidth > $maxWidth)',
        );
        double remainingWidth = (size - minWidth) / 2;
        leftPadding += remainingWidth;
        rightPadding += remainingWidth;
        leftPadding = max(0, leftPadding);
        rightPadding = max(0, rightPadding);
        return builder(
          context,

          /// Creates a `EdgeInsets.only` instance.
          EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding,
            left: leftPadding,
            right: rightPadding,
          ),
        );
      },
    );
  }
}
