# Brief P2-A — Build `foundation/` (layer 0) in the new tree

## Context
We are building the new architecture in a parallel tree `NEXT = $APP/lib/registry_next/` (PLAN §3 "Migration
strategy"). The old `$REG` stays untouched and must keep compiling. Clean break: no deprecated aliases, no shims.
Read PLAN §3–§5, and `$KIT/rearch/reports/OWNERSHIP.md` + `ownership.json` (`shared_map` entries with
`layer: "foundation"`, and the `external` section).

## Goal
Create `NEXT/foundation/`: the zero-dependency base layer. It may import only `package:flutter/widgets.dart`,
`foundation.dart`, `rendering.dart`, `services.dart`, `gestures.dart`, `painting.dart`, `scheduler.dart`,
`dart:*`, and other `foundation/` files. No third-party packages.

## Work
1. **Replace `data_widget`** with `NEXT/foundation/data.dart`. Implement exactly the API surface the registry uses
   (counts from ownership.json): `Data.inherit`, `Data.of`, `Data.maybeOf`, `Data.find`, `Data.maybeFind`,
   `Data.maybeFindMessenger`, `Data.maybeFindRoot`, `Data.capture` and whatever types those signatures need
   (e.g. `Data<T>` widget, `CapturedData`, `DataMessenger`… — check). Keep the same class/method names so later
   migration is an import swap. Study the original at `~/.pub-cache/hosted/pub.dev/data_widget-0.0.3/lib`
   (BSD-style licence) and the call sites in `$REG` (grep `Data\.`). Match semantics exactly (rebuild/notification
   behaviour, `updateShouldNotify`, root/messenger lookup). Implement only what is used — list anything in the
   package you deliberately did not port.
2. **Replace `gap`** with `NEXT/foundation/gap.dart`: `Gap` and `SliverGap` (only these are used: 32 + 4 call
   sites). Same constructor signatures as gap 3.0.1 (`~/.pub-cache/hosted/pub.dev/gap-3.0.1`, MIT) for the
   parameters the registry uses; it must work inside Flex (main-axis) and in scroll views.
3. **Consolidate the 39 foundation files** from ownership.json `shared_map` (layer `foundation`) into a small set
   of readable files, grouped by responsibility, each ≤ ~400 lines, e.g.:
   - `geometry.dart` (axis, axis alignment/insets/geometry, border utils, geometry extensions — prune members
     with 0 call sites, the audit lists them),
   - `platform.dart`, `constants.dart`, `keyboard.dart` (keyboard shortcut utils), `text_input.dart`,
     `style_value.dart`, `resizer.dart` (+ resizable item), `util.dart` only if something genuinely generic remains.
   - Icons: move `lucide_icons.dart`, `radix_icons.dart`, `bootstrap_icons.dart` to `NEXT/foundation/icons/`
     unchanged in content (they are big generated data files — exempt from the 400-line rule). Do NOT copy the
     `*_list.dart` files (audit: delete).
   - Items marked `split` in the shared map: put each piece where the audit says; if a piece belongs to
     `primitives`, leave it for Phase 2 primitives and list it in your report instead of copying.
   Copy code from `$REG/shared/**` and clean it: no `part`/`part of`, no `ignore_for_file`, no Material/Cupertino,
   no dead members, relative imports only inside `NEXT`. Behaviour must not change.
4. **Ownership of identical top-level functions** (orchestrator rule): `wrapDouble` and
   `shortcutActivatorToKeySet` live once, here.
5. Write `NEXT/foundation/README.md` (≤ 60 lines): what each file contains, the import rule for this layer.
6. If any code is adapted (not just inspired) from data_widget or gap, add their licence text to
   `$KIT/licenses/` (one file each) and a one-line attribution comment at the top of the adapted file.

## Tests
`$APP/test/registry_next/foundation/*_test.dart` (flutter_test, widgets only):
- data: inherit/of/maybeOf, find/maybeFind across nested scopes, rebuild on value change, `capture` re-injection
  into a different subtree (e.g. an overlay), messenger/root lookup — mirror how dialog/drawer/tooltip use it.
- gap: Row/Column main-axis sizing, inside a ListView, SliverGap in a CustomScrollView.
- geometry/keyboard helpers: at least the non-trivial functions.

## Outputs (only these)
- `$APP/lib/registry_next/foundation/**`, `$APP/test/registry_next/foundation/**`, `$KIT/licenses/*` (attribution only)
- `$KIT/rearch/reports/P2A_FOUNDATION.md`: file list with LOC, mapping old file → new file for all 39 entries,
  data_widget/gap API ported vs not ported, members pruned, items deferred to primitives.

## Gates (run all; paste results in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next/foundation test/registry_next/foundation
dart analyze lib/registry_next/foundation test/registry_next/foundation        # 0 issues
flutter test test/registry_next/foundation                                       # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next                  # 0 errors (warnings: only icon files too long)
dart run tool/rearch/check_single_owner.dart --root lib/registry_next            # 0 duplicates
flutter analyze lib/registry                                                     # old tree still compiles, unchanged
```
