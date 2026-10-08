# navigation_bar

One navigation container for three layouts — horizontal `bar`, compact `rail`
and labelled `sidebar` — plus the item widgets `NavigationItem`,
`NavigationCollapsible`, `NavigationGroup`, `NavigationLabel` and
`NavigationDivider`.

```dart
NavigationBar(
  index: selected,
  onSelected: (index) => setState(() => selected = index),
  labelType: NavigationLabelType.selected,
  children: <NavigationBarItem>[
    NavigationItem(child: Icon(RadixIcons.home), label: Text('Home')),
    NavigationItem(child: Icon(RadixIcons.gear), label: Text('Settings')),
    NavigationItem(child: Icon(RadixIcons.exit), onPressed: _logOut),
  ],
)
```

## API

- `NavigationBar` — the container; `container`, `direction`, `alignment`,
  `spacing`, `labelType`, `labelPosition`, `labelSize`, `padding`,
  `constraints`, `index`, `onSelected`, `backgroundColor`, `expanded`,
  `header`, `footer`, `theme`.
- `NavigationItem` — one row: `child`, `label`, `index`, `selected`,
  `onChanged`, `onPressed` (action mode), `enabled`, `overflow`, `style`,
  `activeStyle`.
- `NavigationCollapsible` — expandable header with nested items; controlled
  (`expanded`) or uncontrolled (`initialExpanded`).
- `NavigationGroup`, `NavigationLabel`, `NavigationDivider`, `NavigationGap`
  and `NavigationSlot` — section chrome and custom header/footer rows.
- `NavigationBarTheme` / `NavigationItemStyle` — the theme slices; the
  user-owned file is `navigation_bar_theme.dart`.

Items inside a `NavigationGroup` or `NavigationCollapsible` are outside the
container's direct numbering: give them an explicit `index` (or `selected`).

Keyboard: items register with the container's roving group, so the arrow keys
walk the items (skipping disabled ones) and Enter/Space activate. `labelType:
tooltip` shows labels in a tooltip on hover; `NavigationOverflow.marquee`
scrolls long labels.

## Fixed (not ported)

- The `material.dart` import (Icons/Divider/VerticalDivider) — Radix icons and
  a plain 1px rule now.
- `NavigationWidget.selectable` was inverted (`index == null` meant selectable);
  the whole custom-wrapper API is replaced by `NavigationItem`.
- The old container counted Spacers as children when passing `childCount`,
  which `NavigationPadding` then used for first/last detection — the numbering
  and the padding no longer disagree.
- The sliver sidebar path cast every child `as Widget` and painted labels with
  a negative-indent painter; sidebars are a plain scroll view now.
- `NavigationGroup.labelFloating` / `labelPinned` were stored no-ops; dropped.
- The public parity aliases (`NavigationLabeled`, `NavigationChildOverflowHandle`)
  exposed private classes; dropped (clean break).

## Deviations

- `NavigationRail` / `NavigationSidebar` → `NavigationBar(container: ...)`;
  `NavigationButton` → `NavigationItem(onPressed:)`; `NavigationBarAlignment`
  → `MainAxisAlignment`; `NavigationWidget` dropped; key-based selection
  dropped. `NavigationGap` and `NavigationSlot` are kept.
- `surfaceBlur`, `surfaceOpacity`, `expandedSize` / `collapsedSize` and the
  size-keeping flags are dropped.
- The styled row, the item widgets and the item theme slice live in
  `primitives/navigation` (P4-B22, Q7): the component cannot fit its
  three-Dart-file folder otherwise. The container injects the tooltip and
  marquee wrappers, so the primitive imports no component.
- `Toggle` is not used for the item's selected state: the roving traversal map
  must reach the item's `Clickable`, which `Toggle` does not expose.
