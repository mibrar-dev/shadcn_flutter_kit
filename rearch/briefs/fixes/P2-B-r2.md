QA round 1 on lib/registry_next/theme: gates pass, but REJECTED WITH REQUIRED FIXES. Apply all, re-run every gate
from your brief (rearch/briefs/P2-B-theme.md), update rearch/reports/P2B_THEME.md, finish with the RESULT block.

F1 (bug) ShadowScale.derive uses subtractive deltas (offsetY - dy, blur - dblBlur). That only reproduces the defaults
for the default atoms; a real shadcn/tweakcn theme (offsetY 1px, blur 3px) yields negative offsets/blur. Implement
the tweakcn formula with ABSOLUTE detail layers:
- 2xs, xs: [ambient(opacity * 0.5)]
- sm, shadow: [ambient(1.0), detail(y: 1, blur: 2)]
- md: [ambient(1.0), detail(y: 2, blur: 4)]; lg: [ambient(1.0), detail(y: 4, blur: 6)]; xl: [ambient(1.0), detail(y: 8, blur: 10)]
- 2xl: [ambient(opacity * 2.5)]
- ambient = BoxShadow(offset: (offsetX, offsetY), blurRadius: blur, spreadRadius: spread, colour alpha = opacity * mult)
- detail = BoxShadow(offset: (offsetX, y), blurRadius: b, spreadRadius: spread - 1, colour alpha = opacity)
Tests: (a) derive() with default atoms vs defaultShadowScale: geometry exactly equal, alpha within ±1/255 (document
why); (b) shadcn/tailwind default base (offsetX 0, offsetY 1, blur 3, spread 0, black, opacity 0.1) gives
shadowSm == [0,1 blur 3 spread 0 @0.1, 0,1 blur 2 spread -1 @0.1] and shadowMd second layer 0,2 blur 4 spread -1;
(c) no negative blur for any size with those atoms.

F2 (design) Remove the static global registry `ComponentThemes` (static mutable Map) — global mutable state is not
production-grade (tests leak, multiple app roots, hot-restart ordering). Replace with an inherited app-level widget:
`ComponentThemes(themes: <ComponentThemeData>[...], child: ...)` placed at the app root (ShadcnApp will provide it
later); `ComponentThemes.maybeOf<T>(context)` returns the entry of type T from the nearest ComponentThemes. It is a
different widget type from `ComponentTheme<T>`, so the app leg and the scoped leg stay distinct. Update the
resolver and tests (precedence; ComponentTheme.maybeOf never reads ComponentThemes). Update theme/README.md: the
generated `component_themes.dart` now exports `const appComponentThemes = <ComponentThemeData>[...]` passed to the
app root.

F3 (robustness) The resolver takes a caller-supplied merge lambda — exactly where the earlier override-wins bug
lived. Make it impossible to get wrong: add `abstract interface class Mergeable<S> { S merge(S? fallback); }`
(receiver wins, fallback fills nulls), constrain `S extends Mergeable<S>`, drop the `merge` parameter, and have the
resolver do `acc = slice.merge(acc)`. StateValue and component style classes implement Mergeable.

F4 (rules) No ignore comments allowed: remove `// ignore: use_key_in_widget_constructors` (theme.dart:447) by
deleting the `Styleable` interface entirely (components just have a nullable `theme` field), and fix
color_utils.dart:226 `// ignore: deprecated_member_use_from_same_package` by not using the deprecated member
(delete it if it is ours). `grep -rn '// ignore' lib/registry_next/theme` must return nothing.

F5 typography.dart is 613 lines. Prune members with zero use in $REG/components (grep; report counts). If still
> ~450 lines after pruning, leave it and say why.
