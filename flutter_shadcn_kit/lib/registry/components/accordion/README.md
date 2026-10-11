# Accordion

Stacked expandable sections where at most one panel is open. `Accordion`
tracks the open item, `AccordionItem` animates its content and
`AccordionTrigger` is the header.

## When to use

- FAQ lists and settings groups where one section at a time is enough.
- Use `Collapsible` instead when sections must open independently.

## Snippet

```dart
Accordion(
  items: <Widget>[
    AccordionItem(
      trigger: const AccordionTrigger(child: Text('Is it accessible?')),
      content: const Text('Yes.'),
    ),
    AccordionItem(
      trigger: const AccordionTrigger(child: Text('Is it styled?')),
      content: const Text('Yes.'),
      expanded: true, // starts open when no other item is
    ),
  ],
);
```

## API

| Widget | Parameter | Type | Default | Notes |
|---|---|---|---|---|
| `Accordion` | `items` | `List<Widget>` | required | dividers inserted between items |
| | `theme` | `AccordionTheme?` | null | widget leg |
| `AccordionItem` | `trigger` | `Widget` | required | usually an `AccordionTrigger` |
| | `content` | `Widget` | required | revealed while expanded |
| | `expanded` | `bool` | false | initial state, applied once |
| | `theme` | `AccordionTheme?` | null | |
| `AccordionTrigger` | `child` | `Widget` | required | label next to the arrow |
| | `theme` | `AccordionTheme?` | null | |

The trigger is a `Clickable`: hover/press/focus states, Enter/Space
activation and a focus ring come from the primitive, and the semantic node
exposes `button` + `expanded`.

## Theme resolution

`widget theme > ComponentTheme<AccordionTheme> in tree > app overrides
(accordion_theme.dart) > accordionDefaults`, merged per field.

| `AccordionTheme` field | Default |
|---|---|
| `duration` | 200 ms |
| `curve` / `reverseCurve` | `easeIn` / `easeOut` |
| `padding` | content density × scaling |
| `iconGap` | 16 × scaling |
| `dividerHeight` | 1 × scaling |
| `dividerColor` | `muted` token |
| `arrowIcon` | Lucide `chevronUp` |
| `arrowIconColor` | `mutedForeground` token |

## Differences from the old `layout/accordion`

- **Fixed:** the old item re-applied `expanded: true` on every
  `didChangeDependencies` whenever no item was open, so collapsing the
  initially-expanded section re-opened it on the next inherited change. The
  initial state is applied exactly once.
- **Fixed:** a stray trailing `Divider()` (Material, default 16 px height)
  was appended after the last item; the column now ends with the last item.
- **Fixed:** a `GestureDetector` with no callbacks wrapped every item (dead
  hit-test plumbing); removed.
- **Fixed:** the trigger and item resolved `widget.theme ??
  ComponentTheme.maybeOf`, skipping the app-level `ComponentThemes` leg; all
  three widgets now use `resolveComponentStyle`.
- **Fixed:** Material imports (`Icons.keyboard_arrow_up`, `Divider`) are gone;
  the arrow defaults to the bundled Lucide set.
- Interaction moved from a hand-rolled `FocusableActionDetector` +
  `GestureDetector` + border decoration to `primitives/clickable` (keyboard
  activation, focus ring, hover/press states, semantics).
