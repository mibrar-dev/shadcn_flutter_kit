// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../collapsible.dart';

/// Interactive trigger row used by [Collapsible].
class CollapsibleTrigger extends StatelessWidget {
  /// Creates a trigger with [child] content.
  const CollapsibleTrigger({super.key, required this.child});

  /// Content shown alongside the indicator icon.
  final Widget child;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<CollapsibleTheme>(context);
    final state = Data.of<CollapsibleStateData>(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;

    final padding =
        compTheme?.padding ?? theme.density.baseContentPadding * scaling;

    /// Stores `iconGap` state/configuration for this implementation.
    final iconGap = compTheme?.iconGap ?? 16 * scaling;

    /// Stores `iconExpanded` state/configuration for this implementation.
    final iconExpanded = compTheme?.iconExpanded ?? Icons.unfold_less;

    /// Stores `iconCollapsed` state/configuration for this implementation.
    final iconCollapsed = compTheme?.iconCollapsed ?? Icons.unfold_more;

    final iconTheme = IconThemeData(
      size:
          theme.iconTheme.xSmall.size ??
          theme.iconTheme.small.size ??
          16 * scaling,
      color: theme.colorScheme.mutedForeground,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Creates a `Expanded` instance.
        Expanded(child: child.small().semiBold()),

        /// Creates a `Gap` instance.
        Gap(iconGap),

        /// Creates a `GhostButton` instance.
        GhostButton(
          onPressed: state.handleTap,
          child: IconTheme(
            data: iconTheme,
            child: Icon(state.isExpanded ? iconExpanded : iconCollapsed),
          ),
        ),
      ],
    ).withPadding(horizontal: padding);
  }
}
