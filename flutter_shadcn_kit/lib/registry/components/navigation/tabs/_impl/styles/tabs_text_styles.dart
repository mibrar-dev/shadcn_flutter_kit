// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// _TabsTextStyle defines a reusable type for this registry module.
class _TabsTextStyle extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;
  final TextStyle Function(ThemeData theme) styleBuilder;

  const _TabsTextStyle({required this.child, required this.styleBuilder});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTextStyle.merge(style: styleBuilder(theme), child: child);
  }
}

/// Extension helpers used by this registry module.
extension TabsTextStyleExtensions on Widget {
  /// Executes `muted` behavior for this component/composite.
  Widget muted() {
    return _TabsTextStyle(
      child: this,
      styleBuilder: (theme) =>
          /// Creates a `TextStyle` instance.
          TextStyle(color: theme.colorScheme.mutedForeground),
    );
  }

  /// Executes `foreground` behavior for this component/composite.
  Widget foreground() {
    return _TabsTextStyle(
      child: this,
      styleBuilder: (theme) => TextStyle(color: theme.colorScheme.foreground),
    );
  }

  /// Executes `small` behavior for this component/composite.
  Widget small() {
    return _TabsTextStyle(
      child: this,
      styleBuilder: (theme) => theme.typography.small,
    );
  }

  /// Executes `medium` behavior for this component/composite.
  Widget medium() {
    return _TabsTextStyle(
      child: this,
      styleBuilder: (theme) => theme.typography.medium,
    );
  }
}
