// Named examples for the `spinner` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'spinner.dart';

/// The size scale and a couple of stroke widths in one row.
Widget _spinnerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.xl,
    runSpacing: spacing.xl,
    alignment: WrapAlignment.center,
    children: const <Widget>[
      Spinner(),
      Spinner(size: 16),
      Spinner(size: 32),
      Spinner(size: 48),
      Spinner(strokeWidth: 2),
      Spinner(strokeWidth: 6),
    ],
  );
}

/// A small spinner inside a text row.
Widget _spinnerSmall(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Spinner(size: 14, strokeWidth: 2),
      Gap(spacing.sm),
      Text(
        'Loading...',
        style: TextStyle(
          fontSize: 13,
          color: ShadcnTheme.of(context).colors.mutedForeground,
        ),
      ),
    ],
  );
}

/// Named docs examples for `spinner`; the first entry is the default.
const List<ComponentPreview> spinnerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _spinnerDefault),
  ComponentPreview('Small', _spinnerSmall),
];
