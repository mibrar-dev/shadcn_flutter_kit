# foundation/ (layer 0)

The zero-dependency base layer of the new registry. Nothing here may import
`theme/`, `primitives/`, `components/` or any third-party package.

## Import rule

Allowed: `package:flutter/widgets.dart`, `foundation.dart`, `rendering.dart`,
`services.dart`, `gestures.dart`, `painting.dart`, `scheduler.dart`, `dart:*`
and other `foundation/` files. No Material/Cupertino, no packages.

## Files

- `data.dart` — `Data<T>` (`inherit`/`boundary`, `of`, `maybeOf`, `find`,
  `maybeFind`, `maybeFindMessenger`, `maybeFindRoot`, `capture`),
  `MultiData`, `DistinctData`, the data-holder inherited widgets and
  `CapturedData`. Adapted from `data_widget`.
- `data_messenger.dart` — `DataMessenger`, `DataMessengerRoot`,
  `ForwardableData` and the receiver registry used by
  `Data.maybeFindMessenger`.
- `captured_wrapper.dart` — `CapturedWrapper`: re-injects captured themes and
  data into overlay route subtrees.
- `gap.dart` — `Gap`, `SliverGap` and their render objects. Adapted from
  `gap`.
- `geometry.dart` — `AxisDirectional`, axis alignments/insets, border math and
  `optionallyResolve` geometry extensions.
- `platform.dart` — `isMobile`.
- `constants.dart` — `kDefaultDuration`, `degToRad`.
- `keyboard.dart` — `KeyboardShortcutDisplayHandle` and
  `shortcutActivatorToKeySet`.
- `text_input.dart` — `replaceWordAtCaret` and the `TextEditingValue`
  replace helper.
- `style_value.dart` — `styleValue` fallback helper.
- `resizer.dart` — `Resizer` public API for multi-panel resizing.
- `resizer_engine.dart` — internal borrow/collapse bookkeeping of `Resizer`.
- `resizable_item.dart` — `ResizableItem` state for the resizer.
- `time_of_day.dart` — `TimeOfDay` value type (Material-free).
- `icons/` — generated codepoint tables: `lucide_icons.dart`,
  `radix_icons.dart`, `bootstrap_icons.dart` (exempt from the 400-line rule).
