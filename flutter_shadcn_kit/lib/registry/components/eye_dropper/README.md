# Eye Dropper

Samples any pixel of the wrapped subtree: wrap the app (or a demo area) once
with `EyeDropperLayer`, then call `pickColorFromScreen` from anywhere below it.

```dart
EyeDropperLayer(child: MyApp());

final Color? color = await pickColorFromScreen(context);
```

Pass a `ColorHistoryStorage` (from `RecentColorsScope`) to push the picked
colour into the recent-colours list:

```dart
final color = await pickColorFromScreen(context, ColorHistoryStorage.of(context));
```

## API

| Member | Notes |
|---|---|
| `EyeDropperLayer(child, previewAlignment, showPreview, previewSize, previewScale, previewLabelBuilder, theme)` | wraps the sampleable subtree |
| `pickColorFromScreen(context, [storage])` | opens a session; completes with the colour or null |
| `EyeDropperLayerScope.find(context)` / `.findRoot(context)` | the session scope |
| `EyeDropperResult` | sampled grid + picked colour (`operator[]` clamps) |
| `PreviewLabelBuilder` | custom label under the preview |

The preview follows the pointer; set `previewAlignment` to pin it. Tap applies
the colour, Escape cancels. Sessions started from the same layer share one
screenshot and complete together.

## Theme

`EyeDropperTheme` owns the preview size/scale/visibility and the three painter
colours (ring `border`, centre `primary`, backing `background`); widths are
multiplied by the ambient `scaling`.

## Differences from the old `overlay/eye_dropper`

- `data_widget`/Material are gone: `ForwardableData` comes from
  `foundation/data_messenger.dart`, the transparent fallback from
  `theme/color_utils.dart`, the default label from `colorToHex`.
- A picking session can be cancelled (Escape completes null). The old session
  leaked its completer forever if the user never tapped.
- Touch input can pick: the old `onTapDown` ran only when a hover preview
  already existed, so a touch tap did nothing.
- Edge fix: the picked colour is clamped, fixing the RangeError on the last
  pixel row/column (and one pixel past the boundary).
- `previewScale <= 0` no longer divides by zero.
- `EyeDropperTheme` is new; the old widget hard-coded every preview colour.
