// Home showcase: people and plan cards (P6-H1).
//
// Two home-only compositions: the contributor wall (`AvatarGroup` with a
// `HoverCard` handle) and the release timeline (`Timeline`).

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/avatar/avatar.dart';
import '../ui/shadcn/components/hover_card/hover_card.dart';
import '../ui/shadcn/components/timeline/timeline.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// `Contributors`: the avatar stack with a hoverable handle.
class HomeContributorsCard extends StatelessWidget {
  /// Creates the card.
  const HomeContributorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Contributors',
      subtitle: 'Seven people shipped this release.',
      children: <Widget>[
        const AvatarGroup(
          children: <Widget>[
            Avatar(initials: 'MO'),
            Avatar(initials: 'LM'),
            Avatar(initials: 'AK'),
            Avatar(initials: '+4'),
          ],
        ),
        const Gap(12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: <Widget>[
            Text(
              'Curated by',
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            HoverCard(
              hoverBuilder: (BuildContext context) => const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('@ledger'),
                  StudioHelper('Beautifully designed components.'),
                ],
              ),
              child: Text(
                '@ledger',
                style: theme.typography.small.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// `Release timeline`: three dated milestones from the registry timeline.
class HomeTimelineCard extends StatelessWidget {
  /// Creates the card.
  const HomeTimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Release timeline',
      subtitle: 'Midnight Drive — 2026.',
      children: <Widget>[
        Timeline(
          data: <TimelineData>[
            TimelineData(
              time: Text('09:00'),
              title: Text('Master delivered'),
              content: Text('Final WAV approved by the label.'),
            ),
            TimelineData(
              time: Text('11:30'),
              title: Text('Artwork signed off'),
              content: Text('Cover passed the store checks.'),
            ),
            TimelineData(
              time: Text('14:00'),
              title: Text('Distributed'),
              content: Text('Live on 40+ stores worldwide.'),
            ),
          ],
        ),
      ],
    );
  }
}
