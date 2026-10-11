// Named examples for the `chat` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'chat.dart';

/// A round initials avatar drawn with theme tokens.
class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.muted,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The conversation column, bounded so the stage never overflows.
class _ChatConversation extends StatelessWidget {
  const _ChatConversation();

  static const Widget _start = _ChatAvatar('JO');
  static const Widget _end = _ChatAvatar('AI');

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatGroup(
              avatarSuffix: _end,
              children: const <Widget>[
                ChatBubble(child: Text('Did you remember the meeting time?')),
                ChatBubble(child: Text('Please reply ASAP.')),
              ],
            ),
            Gap(spacing.lg),
            ChatGroup(
              avatarPrefix: _start,
              children: const <Widget>[
                ChatBubble(child: Text('Around 6 or 7?')),
                ChatBubble(child: Text('New phone who dis?')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Incoming bubbles only.
Widget _chatIncoming(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          ChatGroup(
            avatarPrefix: _ChatConversation._start,
            children: <Widget>[
              ChatBubble(child: Text('Is the build green yet?')),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Outgoing bubbles only.
Widget _chatOutgoing(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          ChatGroup(
            avatarSuffix: _ChatConversation._end,
            children: <Widget>[
              ChatBubble(child: Text('Deploying now - two minutes.')),
            ],
          ),
        ],
      ),
    ),
  );
}

/// A grouped run with a tailed shape.
Widget _chatGrouped(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ChatGroup(
            avatarPrefix: _ChatConversation._start,
            children: <Widget>[
              ChatBubble(child: Text('First message')),
              ChatBubble(child: Text('Second message')),
              ChatBubble(child: Text('Third message')),
            ],
          ),
          Gap(0),
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
          Gap(spacing.lg),
          ComponentTheme<ChatTheme>(
            data: const ChatTheme(
              widthFactor: 0.8,
              background: ThemedColor.ref(ColorRef.accent),
              foreground: ThemedColor.ref(ColorRef.accentForeground),
            ),
            child: const ChatGroup(
              children: <Widget>[
                ChatBubble(child: Text('Accented group bubble.')),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _chatDefault(BuildContext context) => const _ChatConversation();

/// Named docs examples for `chat`; the first entry is the default.
const List<ComponentPreview> chatPreviews = <ComponentPreview>[
  ComponentPreview('Default', _chatDefault),
  ComponentPreview('Incoming', _chatIncoming),
  ComponentPreview('Outgoing', _chatOutgoing),
  ComponentPreview('Grouped', _chatGrouped),
];
