// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../filter_bar.dart';

/// _FilterBarResolvedTheme defines a reusable type for this registry module.
class _FilterBarResolvedTheme {
  /// Stores `contentPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry contentPadding;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry borderRadius;

  /// Stores `helperTextStyle` state/configuration for this implementation.
  final TextStyle? helperTextStyle;

  /// Stores `borderSide` state/configuration for this implementation.
  final BorderSide borderSide;

  /// Creates a `_FilterBarResolvedTheme` instance.
  const _FilterBarResolvedTheme({
    required this.contentPadding,
    required this.borderRadius,
    required this.helperTextStyle,
    required this.borderSide,
  });

  /// Factory constructor that creates `_FilterBarResolvedTheme.resolve` instances.
  factory _FilterBarResolvedTheme.resolve(
    BuildContext context,
    FilterBarStyle style,
  ) {
    final theme = Theme.of(context);

    /// Stores `colorScheme` state/configuration for this implementation.
    final colorScheme = theme.colorScheme;

    return _FilterBarResolvedTheme(
      contentPadding: EdgeInsets.all(style.dense ? 8 : 12),
      borderRadius: theme.borderRadiusMd,
      helperTextStyle: theme.typography.textMuted.copyWith(
        color: colorScheme.mutedForeground,
      ),
      borderSide: BorderSide(color: colorScheme.border),
    );
  }
}
