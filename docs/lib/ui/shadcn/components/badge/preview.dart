// Named examples for the `badge` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// P7-D1b: the column centres its badges so the stage centres them.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'badge.dart';

Widget _badgeExample(BuildContext context, BadgeVariant variant, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Badge(variant: variant, child: Text(label)),
      Gap(ShadcnTheme.of(context).spacing.md),
      Badge(
        variant: variant,
        leading: const Icon(LucideIcons.star, size: 12),
        child: Text('$label with icon'),
      ),
    ],
  );
}

Widget _badgeDefault(BuildContext context) =>
    _badgeExample(context, BadgeVariant.primary, 'Default');

Widget _badgeSecondary(BuildContext context) =>
    _badgeExample(context, BadgeVariant.secondary, 'Secondary');

Widget _badgeOutline(BuildContext context) =>
    _badgeExample(context, BadgeVariant.outline, 'Outline');

Widget _badgeDestructive(BuildContext context) =>
    _badgeExample(context, BadgeVariant.destructive, 'Destructive');

/// Named docs examples for `badge`; the first entry is the default.
const List<ComponentPreview> badgePreviews = <ComponentPreview>[
  ComponentPreview('Default', _badgeDefault),
  ComponentPreview('Secondary', _badgeSecondary),
  ComponentPreview('Outline', _badgeOutline),
  ComponentPreview('Destructive', _badgeDestructive),
];
