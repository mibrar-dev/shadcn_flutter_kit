// Named examples for the `breadcrumb` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'breadcrumb.dart';

/// The default chevron trail.
Widget _breadcrumbDefault(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: Breadcrumb(
      children: <Widget>[Text('Home'), Text('Components'), Text('Breadcrumb')],
    ),
  );
}

/// The slash separator.
Widget _breadcrumbSlash(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: Breadcrumb(
      separator: Breadcrumb.slashSeparator,
      children: <Widget>[
        Text('src'),
        Text('components'),
        Text('breadcrumb.dart'),
      ],
    ),
  );
}

/// A collapsed trail: the root collapses to an ellipsis crumb.
Widget _breadcrumbCollapsed(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Align(
        alignment: AlignmentDirectional.centerStart,
        child: Breadcrumb(
          separator: Breadcrumb.slashSeparator,
          children: <Widget>[
            Text('...'),
            Text('components'),
            Text('breadcrumb.dart'),
          ],
        ),
      ),
      Gap(spacing.lg),
      const Align(
        alignment: AlignmentDirectional.centerStart,
        child: Breadcrumb(
          padding: EdgeInsetsDensity.pxSymmetric(horizontal: 4),
          children: <Widget>[Text('Docs'), Text('Getting started')],
        ),
      ),
    ],
  );
}

/// Named docs examples for `breadcrumb`; the first entry is the default.
const List<ComponentPreview> breadcrumbPreviews = <ComponentPreview>[
  ComponentPreview('Default', _breadcrumbDefault),
  ComponentPreview('With slash', _breadcrumbSlash),
  ComponentPreview('Collapsed', _breadcrumbCollapsed),
];
