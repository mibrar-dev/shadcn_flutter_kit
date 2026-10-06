QA round 2 for P3-C dialog. Your gates pass (13 tests) and the focus-trap work is good. Fix:

F1 Theme must stay live while the dialog is open (dark-mode toggle, preset change). `ComponentTheme<T>` already
extends `InheritedTheme` (theme/theme.dart:350) and `ComponentThemes` is installed at the app ROOT, i.e. above the
Navigator, so it is already visible inside the route. Do: `InheritedTheme.capture(from: callerContext, to:
navigatorContext)` (as `primitives/popover_overlay_handler.dart:59` does), wrap the route content with
`themes.wrap(...)`, and resolve `DialogTheme` inside the shell's `build`. Barrier colour: resolve it in the route from
the captured context each time the barrier builds (override `buildModalBarrier`/`barrierColor` getter), not once at
show time. Test: open dialog, switch `ShadcnTheme` light→dark, pump — card background and barrier follow; a
`ComponentTheme<DialogTheme>` placed around the CALLER is honoured.

F2 Delete `anchorPoint` everywhere (no unused fields).

F3 Padding: match shadcn — the card has its own inner padding (shadcn `p-6` = 24 logical px × density) and the route
keeps a separate outer inset from the screen edge (`insetPadding`, default 16). Two theme fields: `padding` (inner)
and `insetPadding` (outer). Update defaults, theme doc, README, meta.json, tests.

F4 Localized barrier label: add `dialogDismiss` to `ShadcnLocalizations` (base `'Dismiss'`) in
`lib/registry_next/primitives/localizations/` and override it in every locale file with the correct translation
(use the same word Flutter's own localizations use for `modalBarrierDismissLabel` in that language if you know it;
otherwise leave the English fallback — do not invent). Wire `barrierLabel` to it, add `localizations` to
`deps.primitives`, delete `kDialogFallbackBarrierLabel` and the TODO. Extend
`test/registry_next/primitives/localizations_test.dart` only with one assertion for the new key.

F5 meta.json: remove the duplicate top-level `"dependencies"` block (`deps` is the single source).

Outputs: your previous Outputs + `lib/registry_next/primitives/localizations/**` (only the new key) + that one test
file. Ignore the `undeclared-dependency` gate failure — the orchestrator is fixing the checker separately.
Rerun your gates and finish with the `## RESULT` block.
