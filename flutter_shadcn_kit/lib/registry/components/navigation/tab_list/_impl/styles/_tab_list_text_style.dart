// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../core/tab_list.dart';

/// _TabListTextStyle defines a reusable type for this registry module.
class _TabListTextStyle extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;
  final TextStyle Function(ThemeData theme) styleBuilder;

  const _TabListTextStyle({required this.child, required this.styleBuilder});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTextStyle.merge(style: styleBuilder(theme), child: child);
  }
}
