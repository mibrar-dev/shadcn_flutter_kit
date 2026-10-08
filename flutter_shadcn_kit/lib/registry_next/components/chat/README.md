# Chat

Chat bubbles and groups for conversational layouts, widgets-only (no
Material, no Cupertino): a bubble takes up to `widthFactor` of its row and
aligns to its side, a group stacks bubbles and can flank them with avatars.

## When to use

- Message lists, assistant transcripts, comment threads.

## Snippets

```dart
ChatGroup(
  // any widget works here; `avatar` is a separate component
  avatarPrefix: const Avatar(initials: 'JO'),
  children: const [
    ChatBubble(child: Text('Around 6 or 7?')),
    ChatBubble(child: Text('New phone who dis?')),
  ],
);

ChatGroup(
  variant: ChatBubbleVariant.sharpCorner,
  children: const [ChatBubble(child: Text('Sharp corner.'))],
);
```

## API

| `ChatBubble` | Default | Notes |
|---|---|---|
| `variant` | `tail` | `plain` / `tail` / `sharpCorner` |
| `alignment` | `AlignmentDirectional.centerEnd` | side of the row |
| `color` | `primary` token | fill; foreground follows `primaryForeground` |
| `padding` | 12 / 8 | inner padding |
| `borderRadius` | ambient `radiusLg` | corner radius |
| `borderColor` | null | optional outline (+ `borderWidth`) |
| `corner` | derived from `alignment` | corner that sharpens / carries the tail |
| `widthFactor` | `0.5` | share of the row the bubble may use |
| `theme` | null | widget-leg `ChatTheme` |

| `ChatGroup` | Default | Notes |
|---|---|---|
| `children` | required | bubbles, top to bottom |
| `alignment`/`color`/`foreground`/`variant`/`borderRadius`/`padding`/`borderColor` | null | surface overrides applied to every bubble in the group |
| `spacing` | `2` | gap between bubbles |
| `avatarPrefix` / `avatarSuffix` | null | widgets flanking the bubbles |
| `avatarAlignment` / `avatarSpacing` | `topEnd` / `8` | avatar placement |

## Theming

`ChatTheme` follows the standard four legs: widget `theme` argument > nearest
`ComponentTheme<ChatTheme>` > app `ComponentThemes` > `chatDefaults`.
Overrides are values only; see `chat_theme.dart`. A `ChatGroup` publishes its
own explicit values as the scoped leg (only explicit values, so app overrides
below the group still reach the bubbles).

## Reactions

```dart
ChatReaction(
  child: const ChatBubble(child: Text('Nice work!')),
  chips: <Widget>[
    ChatReactionContainer(
      selected: liked,
      onTap: () => setState(() => liked = !liked),
      child: const Text('👍 3'),
    ),
    const ChatReactionContainer(child: Text('🎉 1')),
  ],
);
```

`ChatReaction` hangs the chip row over the bubble's side corner (derived from
the bubble alignment, or the explicit `corner`; `gap`/`extraWidth` tune the
overlap) and the union stays aligned to that side — including RTL. The
overlap layout itself is the reusable `primitives/overlap_layout.dart`.
Chip colours and padding are five `ChatTheme` fields
(`reactionBackground`, `reactionForeground`, `reactionSelectedBackground`,
`reactionSelectedForeground`, `reactionPadding`); the chip outline is the
`border` token and a selected chip's label is `primaryForeground`.

## Behaviour notes

- The tail is painted by the bubble itself; which bubble of a group carries
  it is `ChatTailBehavior` (`last` by default) resolved against the position
  the group feeds through `ChatBubbleData`.
- The bubble positions itself with `LayoutBuilder` + `Align`, so an
  unbounded-width ancestor (the old `ChatConstrainedBox` crashed there) is
  safe.
- Bubbles inherit their label colour through `DefaultTextStyle`/`IconTheme`
  (the old copy picked a near-black/white by luminance).
- The bubble measures its `widthFactor` with the
  `primitives/fractional_align_box.dart` render box, which answers intrinsic
  queries — bubbles and groups sit safely inside `IntrinsicHeight` /
  `IntrinsicWidth` and other intrinsic layouts.

## Not ported

- `ChatCollapsible` (a marker nothing ever read) and `ChatBubbleData.copyWith`
  were dead code.
- `ChatBubbleData.copyWith` (dead). Reactions are ported: see above.
