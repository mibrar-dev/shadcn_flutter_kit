// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../pagination.dart';

/// Pagination defines a reusable type for this registry module.
class Pagination extends StatelessWidget {
  /// Stores `page` state/configuration for this implementation.
  final int page;

  /// Stores `totalPages` state/configuration for this implementation.
  final int totalPages;

  /// Stores `onPageChanged` state/configuration for this implementation.
  final ValueChanged<int> onPageChanged;

  /// Stores `maxPages` state/configuration for this implementation.
  final int maxPages;

  /// Stores `showSkipToFirstPage` state/configuration for this implementation.
  final bool showSkipToFirstPage;

  /// Stores `showSkipToLastPage` state/configuration for this implementation.
  final bool showSkipToLastPage;

  /// Stores `hidePreviousOnFirstPage` state/configuration for this implementation.
  final bool hidePreviousOnFirstPage;

  /// Stores `hideNextOnLastPage` state/configuration for this implementation.
  final bool hideNextOnLastPage;

  /// Stores `showLabel` state/configuration for this implementation.
  final bool? showLabel;

  /// Stores `gap` state/configuration for this implementation.
  final double? gap;

  /// Creates a `Pagination` instance.
  const Pagination({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
    this.maxPages = 3,
    this.showSkipToFirstPage = true,
    this.showSkipToLastPage = true,
    this.hidePreviousOnFirstPage = false,
    this.hideNextOnLastPage = false,
    this.showLabel,
    this.gap,
  });

  /// Stores `hasPrevious` state/configuration for this implementation.
  bool get hasPrevious => page > 1;

  /// Stores `hasNext` state/configuration for this implementation.
  bool get hasNext => page < totalPages;

  Iterable<int> get pages sync* {
    if (totalPages <= maxPages) {
      yield* List.generate(totalPages, (index) => index + 1);
    } else {
      /// Stores `start` state/configuration for this implementation.
      final start = page - maxPages ~/ 2;

      /// Stores `end` state/configuration for this implementation.
      final end = page + maxPages ~/ 2;
      if (start < 1) {
        yield* List.generate(maxPages, (index) => index + 1);
      } else if (end > totalPages) {
        yield* List.generate(
          maxPages,
          (index) => totalPages - maxPages + index + 1,
        );
      } else {
        yield* List.generate(maxPages, (index) => start + index);
      }
    }
  }

  int get firstShownPage {
    if (totalPages <= maxPages) {
      return 1;
    } else {
      /// Stores `start` state/configuration for this implementation.
      final start = page - maxPages ~/ 2;
      return start < 1 ? 1 : start;
    }
  }

  int get lastShownPage {
    if (totalPages <= maxPages) {
      return totalPages;
    } else {
      /// Stores `end` state/configuration for this implementation.
      final end = page + maxPages ~/ 2;
      return end > totalPages ? totalPages : end;
    }
  }

  /// Stores `hasMorePreviousPages` state/configuration for this implementation.
  bool get hasMorePreviousPages => firstShownPage > 1;

  /// Stores `hasMoreNextPages` state/configuration for this implementation.
  bool get hasMoreNextPages => lastShownPage < totalPages;

  Widget _buildPreviousLabel(
    ShadcnLocalizations localizations,
    bool showLabel,
  ) {
    if (showLabel) {
      return GhostButton(
        onPressed: hasPrevious ? () => onPageChanged(page - 1) : null,
        leading: const Icon(RadixIcons.chevronLeft).iconXSmall(),
        child: Text(localizations.buttonPrevious),
      );
    }
    return GhostButton(
      onPressed: hasPrevious ? () => onPageChanged(page - 1) : null,
      child: const Icon(RadixIcons.chevronLeft).iconXSmall(),
    );
  }

  /// Executes `_buildNextLabel` behavior for this component/composite.
  Widget _buildNextLabel(ShadcnLocalizations localizations, bool showLabel) {
    if (showLabel) {
      return GhostButton(
        onPressed: hasNext ? () => onPageChanged(page + 1) : null,
        trailing: const Icon(RadixIcons.chevronRight).iconXSmall(),
        child: Text(localizations.buttonNext),
      );
    }
    return GhostButton(
      onPressed: hasNext ? () => onPageChanged(page + 1) : null,
      child: const Icon(RadixIcons.chevronRight).iconXSmall(),
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<PaginationTheme>(context);
    final gapValue = styleValue(
      widgetValue: gap,
      themeValue: compTheme?.gap,
      defaultValue: 4 * scaling,
    );
    final showLabel = styleValue(
      widgetValue: this.showLabel,
      themeValue: compTheme?.showLabel,
      defaultValue: true,
    );
    final localizations = ShadcnLocalizations.of(context);

    /// Stores `rowChildren` state/configuration for this implementation.
    final rowChildren = <Widget>[];
    if (!hidePreviousOnFirstPage || hasPrevious) {
      rowChildren.add(_buildPreviousLabel(localizations, showLabel));
    }
    if (hasMorePreviousPages) {
      if (showSkipToFirstPage && firstShownPage - 1 > 1) {
        /// Creates a `rowChildren.add` instance.
        rowChildren.add(
          /// Creates a `GhostButton` instance.
          GhostButton(
            onPressed: () => onPageChanged(1),
            child: const Text('1'),
          ),
        );
      }

      /// Creates a `rowChildren.add` instance.
      rowChildren.add(
        /// Creates a `GhostButton` instance.
        GhostButton(
          onPressed: () => onPageChanged(firstShownPage - 1),
          child: const MoreDots(),
        ),
      );
    }
    for (final p in pages) {
      if (p == page) {
        /// Creates a `rowChildren.add` instance.
        rowChildren.add(
          /// Creates a `OutlineButton` instance.
          OutlineButton(onPressed: () => onPageChanged(p), child: Text('$p')),
        );
      } else {
        /// Creates a `rowChildren.add` instance.
        rowChildren.add(
          /// Creates a `GhostButton` instance.
          GhostButton(onPressed: () => onPageChanged(p), child: Text('$p')),
        );
      }
    }
    if (hasMoreNextPages) {
      /// Creates a `rowChildren.add` instance.
      rowChildren.add(
        /// Creates a `GhostButton` instance.
        GhostButton(
          onPressed: () => onPageChanged(lastShownPage + 1),
          child: const MoreDots(),
        ),
      );
      if (showSkipToLastPage && lastShownPage + 1 < totalPages) {
        /// Creates a `rowChildren.add` instance.
        rowChildren.add(
          /// Creates a `GhostButton` instance.
          GhostButton(
            onPressed: () => onPageChanged(totalPages),
            child: Text('$totalPages'),
          ),
        );
      }
    }
    if (!hideNextOnLastPage || hasNext) {
      rowChildren.add(_buildNextLabel(localizations, showLabel));
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _applyGap(rowChildren, gapValue),
      ),
    );
  }

  /// Executes `_applyGap` behavior for this component/composite.
  static List<Widget> _applyGap(List<Widget> children, double gap) {
    if (gap <= 0 || children.length <= 1) {
      return children;
    }

    /// Stores `spaced` state/configuration for this implementation.
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) {
        spaced.add(SizedBox(width: gap));
      }
    }
    return spaced;
  }
}
