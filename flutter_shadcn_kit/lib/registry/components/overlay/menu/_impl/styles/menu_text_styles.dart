// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// _MenuTextStyle defines a reusable type for this registry module.
class _MenuTextStyle extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;
  final TextStyle Function(ThemeData theme) styleBuilder;

  const _MenuTextStyle({required this.child, required this.styleBuilder});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTextStyle.merge(style: styleBuilder(theme), child: child);
  }
}

/// Extension helpers used by this registry module.
extension MenuTextStyleExtensions on Widget {
  /// Executes `xSmall` behavior for this component/composite.
  Widget xSmall() {
    return _MenuTextStyle(
      child: this,
      styleBuilder: (theme) => theme.typography.xSmall,
    );
  }

  /// Executes `muted` behavior for this component/composite.
  Widget muted() {
    return _MenuTextStyle(
      child: this,
      styleBuilder: (theme) =>
          /// Creates a `TextStyle` instance.
          TextStyle(color: theme.colorScheme.mutedForeground),
    );
  }

  /// Executes `semiBold` behavior for this component/composite.
  Widget semiBold() {
    return _MenuTextStyle(
      child: this,
      styleBuilder: (theme) => theme.typography.semiBold,
    );
  }

  /// Executes `medium` behavior for this component/composite.
  Widget medium() {
    return _MenuTextStyle(
      child: this,
      styleBuilder: (theme) => theme.typography.medium,
    );
  }

  /// Executes `normal` behavior for this component/composite.
  Widget normal() {
    return _MenuTextStyle(
      child: this,
      styleBuilder: (theme) => theme.typography.normal,
    );
  }
}

/// Extension helpers used by this registry module.
extension MenuIconStyleExtensions on Widget {
  /// Executes `iconSmall` behavior for this component/composite.
  Widget iconSmall() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return IconTheme(data: theme.iconTheme.small, child: this);
      },
    );
  }
}
