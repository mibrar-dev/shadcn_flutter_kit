// Gallery preview for the `chat` component.
//
// Widgets-only: two groups (each side of the conversation) with avatars, a
// tailed group, a sharp-corner group, a plain group and a scoped
// `ComponentTheme<ChatTheme>` leg.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'chat.dart';

/// Preview entry point used by the docs gallery.
class ChatPreview extends StatelessWidget {
  /// Creates the preview.
  const ChatPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _ChatPreviewBody(),
      ),
    );
  }
}

class _ChatPreviewBody extends StatelessWidget {
  const _ChatPreviewBody();

  static const Widget _avatarStart = _PreviewAvatar('JO');
  static const Widget _avatarEnd = _PreviewAvatar('AI');

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ChatGroup(
                avatarSuffix: _avatarEnd,
                children: const <Widget>[
                  ChatBubble(child: Text('Did you remember the meeting time?')),
                  ChatBubble(child: Text('Please reply ASAP.')),
                ],
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              ChatGroup(
                color: ThemedColor.ref(ColorRef.accent),
                foreground: ThemedColor.ref(ColorRef.accentForeground),
                avatarPrefix: _avatarStart,
                children: const <Widget>[
                  ChatBubble(child: Text('Around 6 or 7?')),
                  ChatBubble(child: Text('New phone who dis?')),
                ],
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              ChatGroup(
                variant: ChatBubbleVariant.sharpCorner,
                children: const <Widget>[
                  ChatBubble(child: Text('Sharp corner bubbles.')),
                ],
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              ChatGroup(
                variant: ChatBubbleVariant.plain,
                spacing: 8,
                children: const <Widget>[
                  ChatBubble(child: Text('Plain bubbles, no tail.')),
                ],
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              ChatReaction(
                chips: <Widget>[
                  ChatReactionContainer(
                    onTap: () {},
                    selected: true,
                    child: const Text('\u{1F44D} 3'),
                  ),
                  const ChatReactionContainer(child: Text('\u{1F389} 1')),
                ],
                child: const ChatBubble(child: Text('Nice work!')),
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              ComponentTheme<ChatTheme>(
                data: const ChatTheme(
                  widthFactor: 0.8,
                  background: ThemedColor.ref(ColorRef.destructive),
                  foreground: ThemedColor.ref(ColorRef.destructiveForeground),
                ),
                child: const ChatGroup(
                  children: <Widget>[
                    ChatBubble(child: Text('Scoped theme leg (wide, danger).')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewAvatar extends StatelessWidget {
  const _PreviewAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.muted, shape: BoxShape.circle),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: colors.mutedForeground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
