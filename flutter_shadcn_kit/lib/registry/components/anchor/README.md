# anchor

Describes the point an overlay (popover, menu, tooltip, combobox) positions
itself against, and keeps tracking it while it moves or scrolls.

## Getting started

Mark the anchor in the normal widget tree:

```dart
OverlayAnchor(
  anchor: 'user-menu',
  child: AvatarButton(onPressed: openMenu),
)
```

Then resolve it from the context of the `show()` call and subscribe:

```dart
const LinkedAnchor anchor = LinkedAnchor('user-menu');

final AnchorSubscription subscription = anchor.resolve(context).subscribe();
addListener(repaintOverlay);
renderObject.addPrePaintCallback((_) => subscription.notify());
```

Scope the keys so sibling screens can reuse them:

```dart
OverlayAnchorScope(child: settingsScreen)
```

For a one-off, `ContextAnchor` needs no key at all:

```dart
showOverlay(anchor: const ContextAnchor(buttonContext));
```

## API

| Member | Type | Notes |
|---|---|---|
| `Anchor.resolve(context)` | `Anchor` | Fills in defaults from the `show()` context. |
| `Anchor.subscribe()` | `AnchorSubscription` | **The caller owns it and must call `dispose()`.** |
| `subscription.isVisible` / `.anchorSize` | `bool` / `Size?` | Live reads. |
| `subscription.computeTransform(source)` | `Matrix4` | Anchor-local → `source`-local. Identity when singular. |
| `subscription.supportsCompositeTracking` | `bool` | `LinkedAnchor` enables zero-lag tracking; `ContextAnchor` polls per frame. |
| `OverlayAnchorScope` | widget | Gives a subtree its own `OverlayAnchorRegistry`. |
| `OverlayAnchorRegistry.find(key)` | `OverlayAnchorEntry?` | Falls back to the parent registry. |

## Theme

None. The component paints nothing, so there is no `<name>_style.dart` /
`<name>_theme.dart` pair.

## Differences from the old `overlay/anchor`

| Old | New |
|---|---|
| `OverlayAnchorRegistry.global` was process-wide mutable state; keys had to be globally unique | no global registry — `OverlayAnchor` asserts it sits under an `OverlayAnchorScope`, so sibling screens can reuse the same keys |
| `LinkedAnchor.subscribe()` fell back to `OverlayAnchorRegistry.global` when unresolved, silently binding to the wrong tree | asserts the anchor was resolved first |
| `AnchorSubscription`'s doc said "there's no explicit dispose method" while both implementations ran a per-frame `Ticker` until `dispose()` | `dispose()` is part of the interface and the tickers stop there |
| `_LinkedAnchorSubscription.isVisible` used `entry.context.findRenderObject() != null`, which stays true after detach | checks the render box's `attached` flag |
| `anchorTransformRelativeTo` called `Matrix4.invert()`, which throws on a singular (zero-scale) source | yields the identity |
| `OverlayAnchorEntry.context` was never read through a live check | field dropped; the entry carries the `RenderBox` only |
| `package:data_widget/data_widget.dart` (banned) + two suppressed-lint pragmas | `foundation/data.dart`, no lint suppressions |
| barrel + two `part`s + a suppress-all-lints pragma | one flat file |