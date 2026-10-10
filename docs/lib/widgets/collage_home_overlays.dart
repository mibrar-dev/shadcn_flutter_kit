// Home showcase: overlay cards, part 1 — dialog, alert, drawer (P6-H1).
//
// Every card opens its real registry overlay (`showShadcnDialog`,
// `showAlertDialog`, `openDrawer` / `openSheet`), the way the reference
// home's `Alert Dialog` trigger does: the collage shows the composed scene,
// the overlay opens on demand.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/alert_dialog/alert_dialog.dart';
import '../ui/shadcn/components/avatar/avatar.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/dialog/dialog.dart';
import '../ui/shadcn/components/drawer/drawer.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// `Share document`: an avatar row whose action opens a real dialog.
class HomeDialogCard extends StatelessWidget {
  /// Creates the card.
  const HomeDialogCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Share document',
      subtitle: 'Invite people to this workspace.',
      children: <Widget>[
        Row(
          children: <Widget>[
            const Avatar(initials: 'MO', size: 34),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Q2 royalty report.pdf',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.typography.small.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Only you have access',
                    style: theme.typography.small.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(12),
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          leading: const Icon(LucideIcons.share2, size: 14),
          onPressed: () => showShadcnDialog<void>(
            context: context,
            builder: (BuildContext dialogContext) => AlertDialog(
              title: const Text('Share this document'),
              description: const Text(
                'Anyone with the link can view the Q2 royalty report. '
                'Access expires in 7 days.',
              ),
              actions: <Widget>[
                Button(
                  variant: ButtonVariant.outline,
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                Button(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Copy link'),
                ),
              ],
            ),
          ),
          child: const Text('Open dialog'),
        ),
      ],
    );
  }
}

/// `Danger zone`: a destructive action confirmed through a real alert.
class HomeAlertConfirmCard extends StatelessWidget {
  /// Creates the card.
  const HomeAlertConfirmCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Danger zone',
      subtitle: 'Deleting a project cannot be undone.',
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              LucideIcons.shieldAlert,
              size: 16,
              color: theme.colors.destructive,
            ),
            const Gap(12),
            const Expanded(child: StudioHelper('Midnight Drive — 2026')),
          ],
        ),
        const Gap(12),
        Button(
          variant: ButtonVariant.destructive,
          size: ButtonSize.sm,
          leading: const Icon(LucideIcons.trash2, size: 14),
          onPressed: () => showAlertDialog<bool>(
            context: context,
            icon: const Icon(LucideIcons.trash2, size: 20),
            title: const Text('Delete this project?'),
            description: const Text(
              'The release, its royalties and every report will be removed '
              'permanently.',
            ),
            actions: <Widget>[
              Button(
                variant: ButtonVariant.outline,
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              Button(
                variant: ButtonVariant.destructive,
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
          child: const Text('Delete project'),
        ),
      ],
    );
  }
}

/// `Account panel`: buttons opening the registry drawer and sheet.
class HomeDrawerCard extends StatelessWidget {
  /// Creates the card.
  const HomeDrawerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Account panel',
      subtitle: 'The same content as a drawer or a sheet.',
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Button(
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                onPressed: () => openDrawer<void>(
                  context: context,
                  builder: (BuildContext drawerContext) => _HomePanelSheet(
                    onClose: () => Navigator.pop(drawerContext),
                  ),
                ),
                child: const Text('Open drawer'),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Button(
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                onPressed: () => openSheet<void>(
                  context: context,
                  builder: (BuildContext sheetContext) => _HomePanelSheet(
                    onClose: () => Navigator.pop(sheetContext),
                  ),
                ),
                child: const Text('Open sheet'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The panel body shared by the drawer and the sheet demos.
class _HomePanelSheet extends StatelessWidget {
  /// Creates the panel.
  const _HomePanelSheet({required this.onClose});

  /// Closes the overlay.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Account',
            style: theme.typography.h4.copyWith(fontWeight: FontWeight.w600),
          ),
          const Gap(4),
          const StudioHelper('Profile, billing and notifications.'),
          const Gap(16),
          const StudioRow(label: 'Plan', value: r'Pro · $29/mo'),
          const StudioRow(label: 'Renewal', value: '1 Jun 2026'),
          const Gap(16),
          Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: onClose,
            child: const Text('Close panel'),
          ),
        ],
      ),
    );
  }
}
