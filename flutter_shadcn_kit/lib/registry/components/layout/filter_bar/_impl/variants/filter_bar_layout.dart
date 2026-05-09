// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../filter_bar.dart';

/// _FilterBarLayout defines a reusable type for this registry module.
class _FilterBarLayout {
  /// Stores `isSingleRow` state/configuration for this implementation.
  final bool isSingleRow;

  /// Stores `maxSearchWidth` state/configuration for this implementation.
  final double maxSearchWidth;

  /// Stores `sortWidth` state/configuration for this implementation.
  final double sortWidth;

  /// Creates a `_FilterBarLayout` instance.
  const _FilterBarLayout({
    required this.isSingleRow,
    required this.maxSearchWidth,
    required this.sortWidth,
  });

  /// Factory constructor that creates `_FilterBarLayout.resolve` instances.
  factory _FilterBarLayout.resolve({
    required double maxWidth,
    required FilterBarStyle style,
    required int trailingControlCount,
    required bool hasSortControl,
    required bool hasDateControl,
    required bool hasCounterText,
    required bool hasClearAction,
  }) {
    if (!maxWidth.isFinite || maxWidth <= 0) {
      return _FilterBarLayout(
        isSingleRow: false,
        maxSearchWidth: double.infinity,
        sortWidth: style.minSortWidth,
      );
    }

    final controlCount =
        1 +
        (hasSortControl ? 1 : 0) +
        (hasDateControl ? 1 : 0) +
        trailingControlCount +
        (hasCounterText ? 1 : 0) +
        (hasClearAction ? 1 : 0);
    final gapWidth = style.spacing * (controlCount > 1 ? controlCount - 1 : 0);
    final minWidth =
        style.minSearchWidth +
        (hasSortControl ? style.minSortWidth : 0) +
        (hasDateControl ? 164 : 0) +
        (trailingControlCount * 140) +
        (hasCounterText ? 90 : 0) +
        (hasClearAction ? 86 : 0) +
        gapWidth;

    /// Stores `isSingleRow` state/configuration for this implementation.
    final isSingleRow = maxWidth >= minWidth;
    return _FilterBarLayout(
      isSingleRow: isSingleRow,
      maxSearchWidth: isSingleRow ? maxWidth * 0.42 : double.infinity,
      sortWidth: style.minSortWidth,
    );
  }
}
