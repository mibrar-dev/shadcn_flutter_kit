// The `pagination` component: previous/next controls plus a window of page
// buttons with skip-to-edge and ellipsis affordances.
//
// Ported from `components/navigation/pagination`. Built on the pilot `button`
// component and the `triple_dots` ellipsis; the page window is clamped so an
// out-of-range `page` can no longer produce a negative `List.generate` length
// (old bug).

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../triple_dots/triple_dots.dart';
import 'pagination_style.dart';

export 'pagination_style.dart';

/// A page selector.
///
/// ```dart
/// Pagination(
///   page: current,
///   totalPages: 20,
///   onPageChanged: (page) => setState(() => current = page),
/// );
/// ```
class Pagination extends StatelessWidget {
  /// Creates a pagination control.
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
    this.theme,
  });

  /// The active page (1-based). Out-of-range values are clamped for display.
  final int page;

  /// Total number of pages.
  final int totalPages;

  /// Called with the requested page number.
  final ValueChanged<int> onPageChanged;

  /// How many page buttons the window shows when the total exceeds it.
  final int maxPages;

  /// Whether a button jumping to the first page is shown before the window.
  final bool showSkipToFirstPage;

  /// Whether a button jumping to the last page is shown after the window.
  final bool showSkipToLastPage;

  /// Hides the previous button while on the first page.
  final bool hidePreviousOnFirstPage;

  /// Hides the next button while on the last page.
  final bool hideNextOnLastPage;

  /// Whether previous/next show a text label; null resolves the theme.
  final bool? showLabel;

  /// Gap override; null resolves [PaginationTheme.gap].
  final double? gap;

  /// Widget-leg theme override, merged on top of the other legs.
  final PaginationTheme? theme;

  int get _maxWindow => maxPages < 1 ? 1 : maxPages;

  int get _current => totalPages <= 0 ? 1 : page.clamp(1, totalPages);

  /// Whether a previous page exists.
  bool get hasPrevious => _current > 1;

  /// Whether a next page exists.
  bool get hasNext => _current < totalPages;

  /// The page numbers currently shown in the window.
  Iterable<int> get pages => _window(_maxWindow);

  /// First page of the current window.
  int get firstShownPage => _firstShown(_maxWindow);

  /// Last page of the current window.
  int get lastShownPage => _lastShown(_maxWindow);

  /// Whether the window has earlier pages to jump back to.
  bool get hasMorePreviousPages => firstShownPage > 1;

  /// Whether the window has later pages to jump forward to.
  bool get hasMoreNextPages => lastShownPage < totalPages;

  /// The window of [size] around the current page, clamped into range.
  Iterable<int> _window(int size) sync* {
    if (totalPages <= 0) {
      return;
    }
    final int window = size < 1 ? 1 : size;
    if (totalPages <= window) {
      yield* List<int>.generate(totalPages, (i) => i + 1);
      return;
    }
    final int start = _current - window ~/ 2;
    final int end = _current + window ~/ 2;
    if (start < 1) {
      yield* List<int>.generate(window, (i) => i + 1);
    } else if (end > totalPages) {
      yield* List<int>.generate(window, (i) => totalPages - window + i + 1);
    } else {
      yield* List<int>.generate(window, (i) => start + i);
    }
  }

  /// First page of a [size] window around the current page.
  int _firstShown(int size) {
    final int window = size < 1 ? 1 : size;
    if (totalPages <= window) {
      return 1;
    }
    final int start = _current - window ~/ 2;
    return start < 1 ? 1 : start;
  }

  /// Last page of a [size] window around the current page.
  int _lastShown(int size) {
    final int window = size < 1 ? 1 : size;
    if (totalPages <= window) {
      return totalPages;
    }
    final int end = _current + window ~/ 2;
    return end > totalPages ? totalPages : end;
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final PaginationTheme style =
        resolveComponentStyle<PaginationTheme, PaginationTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: paginationDefaults,
        );
    final double spacing = (gap ?? style.gap ?? 4) * ambient.scaling;
    final bool withLabel = showLabel ?? style.showLabel ?? true;
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final double iconSize = 12 * ambient.scaling;

    // A masonry column (~300 px) or a phone (375 px minus padding) cannot hold
    // the full window, so the control collapses to prev/ellipsis/current/next:
    // icon-only ends, a one-page window, no skip-to-edge buttons. Unbounded
    // widths (a horizontal scroll view, the docs stage) keep the full layout.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = _collapses(
          constraints.maxWidth,
          spacing: spacing,
          scaling: ambient.scaling,
          withLabel: withLabel,
        );
        final int window = compact ? 1 : _maxWindow;
        final bool labelled = !compact && withLabel;
        final bool skipFirst = !compact && showSkipToFirstPage;
        final bool skipLast = !compact && showSkipToLastPage;
        final int firstShown = _firstShown(window);
        final int lastShown = _lastShown(window);

        final List<Widget> children = <Widget>[];
        if (!hidePreviousOnFirstPage || hasPrevious) {
          children.add(_previous(localizations, labelled, iconSize));
        }
        if (firstShown > 1) {
          if (skipFirst && firstShown - 1 > 1) {
            children.add(_pageButton(1));
          }
          children.add(_ellipsis(firstShown - 1));
        }
        for (final int p in _window(window)) {
          children.add(_pageButton(p));
        }
        if (lastShown < totalPages) {
          children.add(_ellipsis(lastShown + 1));
          if (skipLast && lastShown + 1 < totalPages) {
            children.add(_pageButton(totalPages));
          }
        }
        if (!hideNextOnLastPage || hasNext) {
          children.add(_next(localizations, labelled, iconSize));
        }

        return IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _spaced(children, spacing),
          ),
        );
      },
    );
  }

  /// Whether the full window would overflow [maxWidth].
  ///
  /// Each control is estimated at one icon-button quantum (the button size
  /// table's `icon` size, 36, scaled) plus a calibration margin covering the
  /// widest measured sm control (a two-digit page, 52 at the default density);
  /// a labelled prev/next carries about two extra quanta of text. The estimate
  /// is deliberately conservative — collapsing early only drops labels and
  /// window neighbours, never a reachable page — and unbounded widths never
  /// collapse, so scroll views keep the full layout.
  bool _collapses(
    double maxWidth, {
    required double spacing,
    required double scaling,
    required bool withLabel,
  }) {
    if (!maxWidth.isFinite) {
      return false;
    }
    const double unit = 56;
    const double labelExtra = 112;
    int controls = 0;
    int labelled = 0;
    if (!hidePreviousOnFirstPage || hasPrevious) {
      controls++;
      if (withLabel) {
        labelled++;
      }
    }
    if (hasMorePreviousPages) {
      if (showSkipToFirstPage && firstShownPage - 1 > 1) {
        controls++;
      }
      controls++;
    }
    controls += pages.length;
    if (hasMoreNextPages) {
      controls++;
      if (showSkipToLastPage && lastShownPage + 1 < totalPages) {
        controls++;
      }
    }
    if (!hideNextOnLastPage || hasNext) {
      controls++;
      if (withLabel) {
        labelled++;
      }
    }
    if (controls <= 1) {
      return false;
    }
    final double estimate =
        controls * unit * scaling +
        (controls - 1) * spacing +
        labelled * labelExtra * scaling;
    return maxWidth < estimate;
  }

  Widget _pageButton(int pageNumber) {
    final bool isCurrent = pageNumber == _current;
    return Button(
      variant: isCurrent ? ButtonVariant.outline : ButtonVariant.ghost,
      size: ButtonSize.sm,
      onPressed: () => onPageChanged(pageNumber),
      child: Text('$pageNumber'),
    );
  }

  Widget _ellipsis(int targetPage) {
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.sm,
      onPressed: () => onPageChanged(targetPage),
      child: const TripleDots(),
    );
  }

  Widget _previous(
    ShadcnLocalizations localizations,
    bool withLabel,
    double iconSize,
  ) {
    final VoidCallback? onPressed = hasPrevious
        ? () => onPageChanged(_current - 1)
        : null;
    if (withLabel) {
      return Button(
        variant: ButtonVariant.ghost,
        size: ButtonSize.sm,
        onPressed: onPressed,
        leading: Icon(LucideIcons.chevronLeft, size: iconSize),
        child: Text(localizations.buttonPrevious),
      );
    }
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Semantics(
        label: localizations.buttonPrevious,
        child: Icon(LucideIcons.chevronLeft, size: iconSize),
      ),
    );
  }

  Widget _next(
    ShadcnLocalizations localizations,
    bool withLabel,
    double iconSize,
  ) {
    final VoidCallback? onPressed = hasNext
        ? () => onPageChanged(_current + 1)
        : null;
    if (withLabel) {
      return Button(
        variant: ButtonVariant.ghost,
        size: ButtonSize.sm,
        onPressed: onPressed,
        trailing: Icon(LucideIcons.chevronRight, size: iconSize),
        child: Text(localizations.buttonNext),
      );
    }
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Semantics(
        label: localizations.buttonNext,
        child: Icon(LucideIcons.chevronRight, size: iconSize),
      ),
    );
  }

  /// Intersperses fixed-width gaps between the controls.
  static List<Widget> _spaced(List<Widget> children, double gap) {
    if (gap <= 0 || children.length <= 1) {
      return children;
    }
    final List<Widget> spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) {
        spaced.add(SizedBox(width: gap));
      }
    }
    return spaced;
  }
}
