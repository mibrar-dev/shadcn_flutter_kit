// Home showcase: media cards — chat, share, upload (P6-H1).
//
// Extends the Theme Studio media blocks
// (`studio_blocks/studio_media.dart`): the support thread, the QR share
// card and the cover-art dropzone, re-shelled in [CollageCard].

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/chat/chat.dart';
import '../ui/shadcn/components/dropzone/dropzone.dart';
import '../ui/shadcn/components/text_area/text_area.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_paint.dart';

/// `Support`: a short chat thread with a reply composer.
class HomeChatCard extends StatefulWidget {
  /// Creates the card.
  const HomeChatCard({super.key});

  @override
  State<HomeChatCard> createState() => _HomeChatCardState();
}

class _HomeChatCardState extends State<HomeChatCard> {
  final TextEditingController _reply = TextEditingController();

  static const List<(String, bool)> thread = <(String, bool)>[
    ('The royalty report shows a lower split than expected.', true),
    ('Can you re-check the 2026-01 payout?', true),
    ('I see it — that month was prorated after the reissue.', false),
  ];

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Support',
      subtitle: 'We reply within one business day.',
      trailing: const Badge(variant: BadgeVariant.secondary, child: Text('2')),
      children: <Widget>[
        ChatGroup(
          children: <Widget>[
            for (final (String text, bool mine) in thread)
              ChatBubble(
                alignment: mine ? AlignmentDirectional.centerEnd : null,
                variant: mine
                    ? ChatBubbleVariant.tail
                    : ChatBubbleVariant.plain,
                child: Text(text),
              ),
          ],
        ),
        const Gap(12),
        const TextArea(minLines: 2, maxLines: 3, hintText: 'Write a reply...'),
        const Gap(12),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Button(
            variant: ButtonVariant.primary,
            size: ButtonSize.sm,
            leading: const Icon(LucideIcons.send, size: 14),
            onPressed: _reply.clear,
            child: const Text('Send'),
          ),
        ),
      ],
    );
  }
}

/// `Share this release`: the reference's QR share card.
class HomeShareCard extends StatelessWidget {
  /// Creates the card.
  const HomeShareCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Share this release',
      subtitle: 'Open the Ledger mobile app and scan this code to link.',
      children: <Widget>[
        const StudioQrTile(size: 108, seed: 11),
        const Gap(16),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'midnight-drive-2026',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.typography.small.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
            const Gap(8),
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              leading: const Icon(LucideIcons.copy, size: 14),
              onPressed: () {},
              child: const Text('Copy link'),
            ),
          ],
        ),
      ],
    );
  }
}

/// `Cover Art` upload: the registry dropzone with its browse action.
class HomeUploadCard extends StatelessWidget {
  /// Creates the card.
  const HomeUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Cover Art',
      subtitle: 'Upload the artwork of the release.',
      children: <Widget>[
        Dropzone(
          icon: Icon(LucideIcons.image, size: 22),
          actionLabel: 'Upload Artwork',
          hint: Text('Minimum 3000 × 3000px · JPEG or PNG only'),
        ),
      ],
    );
  }
}
