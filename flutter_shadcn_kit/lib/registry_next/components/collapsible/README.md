# Collapsible

An expandable section. `Collapsible` owns the expansion state (or is
controlled through `isExpanded`); `CollapsibleTrigger` toggles it;
`CollapsibleContent` hides or shows its child.

## When to use

- "Show more" sections, FAQ entries and activity feeds.
- Any content that should collapse independently of other sections (use
  `Accordion` when only one section may be open).

## Snippet

```dart
Collapsible(
  children: <Widget>[
    const CollapsibleTrigger(child: Text('Recent activity')),
    CollapsibleContent(child: activityList),
  ],
);
```

Controlled:

```dart
Collapsible(
  isExpanded: open,
  onExpansionChanged: (value) => setState(() => open = value),
  children: children,
);
```

## API

| Widget | Parameter | Type | Default | Notes |
|---|---|---|---|---|
| `Collapsible` | `children` | `List<Widget>` | required | trigger + content panes |
| | `isExpanded` | `bool?` | null | non-null = controlled |
| | `onExpansionChanged` | `ValueChanged<bool>?` | null | receives the **new** state |
| | `theme` | `CollapsibleTheme?` | null | widget leg |
| `CollapsibleTrigger` | `child` | `Widget` | required | label next to the icon |
| | `theme` | `CollapsibleTheme?` | null | |
| `CollapsibleContent` | `collapsible` | `bool` | true | false keeps the pane always visible |
| | `child` | `Widget` | required | |

The trigger icon is the kit's `Button` (ghost, icon size), so it is focusable
and keyboard-activatable (Enter/Space).

## Theme resolution

`widget theme > ComponentTheme<CollapsibleTheme> in tree > app overrides
(collapsible_theme.dart) > collapsibleDefaults`, merged per field.

| `CollapsibleTheme` field | Default |
|---|---|
| `padding` | content density × scaling |
| `iconExpanded` | Lucide `chevronsDownUp` |
| `iconCollapsed` | Lucide `chevronsUpDown` |
| `crossAxisAlignment` | `stretch` |
| `mainAxisAlignment` | `start` |
| `iconGap` | 16 × scaling |

## Differences from the old `layout/collapsible`

- **Fixed:** `onExpansionChanged` was called with the **old** state, and an
  uncontrolled section with a callback never actually toggled (the old code
  replaced the `setState` with the callback). The new state reports the new
  value and only skips `setState` when `isExpanded` is provided.
- **Fixed:** the trigger and the section resolved
  `widget.theme ?? ComponentTheme.maybeOf`, skipping the app-level
  `ComponentThemes` leg; both now use `resolveComponentStyle`.
- **Fixed:** the default icons came from `package:flutter/material.dart`
  (`Icons.unfold_less`/`unfold_more`); the defaults are now Lucide icons and
  no Material import remains.
- `data_widget`/`gap` imports are replaced by `foundation/data.dart` and
  `foundation/gap.dart`; the trigger label uses `primitives/text` modifiers.
