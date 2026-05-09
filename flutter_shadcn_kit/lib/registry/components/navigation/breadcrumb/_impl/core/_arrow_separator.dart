// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../breadcrumb.dart';

/// _ArrowSeparator defines a reusable type for this registry module.
class _ArrowSeparator extends StatelessWidget {
  const _ArrowSeparator();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.density.baseGap * scaling * 1.5,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: theme.colorScheme.mutedForeground,
          size: 12 * scaling,
        ),
        child: const Icon(RadixIcons.chevronRight),
      ),
    );
  }
}
