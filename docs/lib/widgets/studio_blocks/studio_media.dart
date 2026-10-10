// The media blocks of the Theme Studio canvas: the reference's QR/share card,
// the file-upload dropzone, the OTP field and a chat thread.
//
// `Dropzone`, `InputOtp`, `ChatBubble` and `ChatGroup` are the registry
// components; the QR tile is a docs-only painter (`studio_paint.dart`).

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/chat/chat.dart';
import '../../ui/shadcn/components/dropzone/dropzone.dart';
import '../../ui/shadcn/components/input_otp/input_otp.dart';
import '../../ui/shadcn/components/text_area/text_area.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';
import 'studio_paint.dart';

/// `Scan to connect your mobile device`: the reference's QR share card.
class StudioShareCard extends StatelessWidget {
  /// Creates the card.
  const StudioShareCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Share this release',
      subtitle: 'Open the Ledger mobile app and scan this code to link.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

/// `Cover Art` upload: the registry dropzone with its browse action.
class StudioFileUploadCard extends StatelessWidget {
  /// Creates the card.
  const StudioFileUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Cover Art',
      subtitle: 'Upload the artwork of the release.',
      child: Dropzone(
        icon: const Icon(LucideIcons.image, size: 22),
        actionLabel: 'Upload Artwork',
        hint: const Text('Minimum 3000 × 3000px · JPEG or PNG only'),
      ),
    );
  }
}

/// `Verify your phone`: a six-slot OTP field with its action row.
class StudioOtpCard extends StatelessWidget {
  /// Creates the card.
  const StudioOtpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Verify your phone',
      subtitle: 'Enter the 6-digit code we texted to ···· 1192.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          InputOtp(length: 6),
          Gap(16),
          Row(
            children: <Widget>[
              Expanded(
                child: Button(
                  variant: ButtonVariant.outline,
                  onPressed: studioNoop,
                  child: Text('Resend'),
                ),
              ),
              Gap(12),
              Expanded(
                child: Button(
                  variant: ButtonVariant.primary,
                  onPressed: studioNoop,
                  child: Text('Verify'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `Support`: a short chat thread with a reply composer.
class StudioChatCard extends StatefulWidget {
  /// Creates the card.
  const StudioChatCard({super.key});

  @override
  State<StudioChatCard> createState() => _StudioChatCardState();
}

class _StudioChatCardState extends State<StudioChatCard> {
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
    return StudioCard(
      title: 'Support',
      subtitle: 'We reply within one business day.',
      trailing: const Badge(variant: BadgeVariant.secondary, child: Text('2')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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
          const TextArea(
            minLines: 2,
            maxLines: 3,
            hintText: 'Write a reply...',
          ),
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
      ),
    );
  }
}
