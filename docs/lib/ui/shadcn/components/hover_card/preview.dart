// Named examples for the `hover_card` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'hover_card.dart';

/// Sample card content.
Widget _card(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text('@shadcn'),
      Gap(theme.spacing.xs),
      Text(
        'Beautifully designed components.',
        style: TextStyle(color: theme.colors.mutedForeground),
      ),
    ],
  );
}

/// The default card after the hover delay.
Widget _default(BuildContext context) {
  return HoverCard(hoverBuilder: _card, child: const Text('@shadcn'));
}

/// Rich content: title, bio and follower count.
Widget _richContent(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return HoverCard(
    hoverBuilder: (BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('@shadcn'),
        Gap(theme.spacing.xs),
        Text(
          'Beautifully designed components that you can copy and paste.',
          style: TextStyle(color: theme.colors.mutedForeground),
        ),
        Gap(theme.spacing.sm),
        Text(
          '12k followers',
          style: TextStyle(color: theme.colors.mutedForeground, fontSize: 12),
        ),
      ],
    ),
    child: const Text('@shadcn (rich)'),
  );
}

/// Named docs examples for `hover_card`; the first entry is the default.
const List<ComponentPreview> hoverCardPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Rich content', _richContent),
];
