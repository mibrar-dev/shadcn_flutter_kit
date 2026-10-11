// Named examples for the `empty_state` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// No outer fixed-height box: the full-page sizes want a tall host, so each
// example is laid out in a box the stage already bounds.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../button/button.dart';
import '../../theme/theme.dart';
import 'empty_state.dart';

/// The full-page empty state, both actions.
Widget _emptyStateNoResults(BuildContext context) {
  return const EmptyState(
    variant: EmptyStateVariant.noResults,
    primaryAction: EmptyStateAction(label: 'Clear filters'),
  );
}

/// the full-page empty variant.
Widget _emptyStateEmpty(BuildContext context) {
  return const EmptyState(
    variant: EmptyStateVariant.empty,
    primaryAction: EmptyStateAction(label: 'Create project'),
    secondaryAction: EmptyStateAction(label: 'Import'),
  );
}

/// the error-fallback variant with a footer link.
Widget _emptyStateError(BuildContext context) {
  return const EmptyState(
    variant: EmptyStateVariant.errorFallback,
    primaryAction: EmptyStateAction(label: 'Try again'),
    footerAction: EmptyStateAction(
      label: 'Report this',
      variant: ButtonVariant.link,
    ),
  );
}

/// the compact scale, with and without the icon container.
Widget _emptyStateCompact(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const EmptyState(
        size: EmptyStateSize.compact,
        variant: EmptyStateVariant.empty,
        title: Text('Nothing here yet'),
        primaryAction: EmptyStateAction(label: 'Create'),
      ),
      Gap(spacing.xl),
      const EmptyState(
        size: EmptyStateSize.compact,
        variant: EmptyStateVariant.noResults,
        showIconContainer: false,
        title: Text('No matches'),
        description: Text('Try a different term.'),
      ),
    ],
  );
}

/// Named docs examples for `empty_state`; the first entry is the default.
const List<ComponentPreview> emptyStatePreviews = <ComponentPreview>[
  ComponentPreview('No results', _emptyStateNoResults),
  ComponentPreview('Empty', _emptyStateEmpty),
  ComponentPreview('Error fallback', _emptyStateError),
  ComponentPreview('Compact', _emptyStateCompact),
];
