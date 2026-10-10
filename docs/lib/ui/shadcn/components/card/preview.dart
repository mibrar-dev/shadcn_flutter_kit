// Named examples for the `card` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'card.dart';

/// The full shadcn slot composition.
Widget _cardDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return SizedBox(
    width: 320,
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardTitle(child: Text('Deployments')),
                CardDescription(child: Text('Ship a new build to production.')),
              ],
            ),
          ),
          Gap(spacing.lg),
          const CardContent(
            child: Text(
              'Every deploy is immutable; roll back from the history tab.',
            ),
          ),
          Gap(spacing.lg),
          CardFooter(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Button(
                  size: ButtonSize.sm,
                  variant: ButtonVariant.ghost,
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                Gap(spacing.sm),
                Button(
                  size: ButtonSize.sm,
                  onPressed: () {},
                  child: const Text('Deploy'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// A card whose header carries a clipped media band.
Widget _cardWithMedia(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    width: 320,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 96,
            child: ColoredBox(
              color: theme.colors.muted,
              child: Center(
                child: Icon(
                  LucideIcons.image,
                  size: 24,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          ),
          const CardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardTitle(child: Text('Cover art')),
                CardDescription(
                  child: Text('Generated from the preset palette.'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// A bare surface with only the footer slot filled.
Widget _cardWithFooter(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    width: 320,
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CardTitle(child: Text('Billing')),
          Gap(theme.spacing.xs),
          Text(
            'Bare card, default padding',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
          Gap(theme.spacing.lg),
          CardFooter(
            padding: EdgeInsetsDensity.pxAll(0),
            child: Button(
              size: ButtonSize.sm,
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Manage plan'),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Named docs examples for `card`; the first entry is the default.
const List<ComponentPreview> cardPreviews = <ComponentPreview>[
  ComponentPreview('Default', _cardDefault),
  ComponentPreview('With media', _cardWithMedia),
  ComponentPreview('With footer', _cardWithFooter),
];
