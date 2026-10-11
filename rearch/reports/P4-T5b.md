# P4-T5b — syntax highlighter polish (registry only)

Status: **done** (round 2 — both reported bugs fixed; goldens updated to the
correct kinds; item 3 of the original brief remains not applicable, see §3).

Scope honoured: only `lib/registry/primitives/syntax_highlight/*`,
`test/registry/primitives/syntax_*`, `lib/registry/manifests/registry.json`, the
docs mirror (`docs/lib/ui/shadcn/**` via `docs/tool/sync_registry.sh`) and this
report were written. No `docs/lib` page/widget was touched. No git state
commands were run.

---

## Round 2 — the two bugs are fixed

### Fix 1 — YAML quoted values were never strings
`syntax_scanners_markup.dart` built the YAML string rule from two adjacent raw
literals with **no `|` between them**, so the compiled pattern only matched a
`"…"` immediately followed by `'…'` and a plain `k: "v"` produced no string token
(the `:` inside the value even leaked out as an `operator`).

```dart
r'"(?:\\.|[^"\\\n])*"'   // "..."
r"|'(?:[^']|'')*'",      // '...' ('' is an escaped quote)   <- | restored
```

`k: "v"` now yields `string["v"]`; `c: "a: b"` yields one `string` token for the
whole value (the inner `:` no longer leaks). This matches every other language's
string rule (Dart, JS, Python, HTML, CSS and Bash all separate their
alternatives with `|`).

### Fix 2 — Dart ALL_CAPS constants
The `constant` rule `\b[A-Z][A-Z0-9_]{2,}\b` sat *after* the `type` rule
`\b[A-Z][A-Za-z0-9_]*\b`, whose character class is a superset, so it could never
win. The constant rule is now ordered **before** the type rule (with a comment
explaining why the order matters):

| Code | Kind (fixed) |
|---|---|
| `MAX`, `MAX_SIZE`, `HTML`, `URL` | `constant` |
| `HTMLParser`, `Abc`, `AB`, `Foo`, `String` | `type` |

`AB` stays `type` because the rule requires 3+ characters — documented by the
new `ALL_CAPS stops at the first lowercase letter` golden.

### Goldens updated to the correct kinds
| File | Change |
|---|---|
| `syntax_goldens_c_like_test.dart` | dart representative: `MAX` is now `constant`; `capitalized names are all type, never constant` renamed to `ALL_CAPS names are constants, mixed case stays type` and extended with `const Foo = 3`; new `ALL_CAPS stops at the first lowercase letter` |
| `syntax_goldens_markup_test.dart` | yaml representative: `"a: b"` and `"${HOME}/x"` are now `string` tokens; the `quoted values stay plain — pre-existing bug` test replaced by `quoted values, including a colon inside the value`; new `escaped and doubled quotes stay inside one string token` |

No golden pins buggy behaviour any more. Unaffected goldens were re-verified
(Kotlin/Swift/JS/TS/Python/Bash/HTML/CSS/JSON/Markdown snippets contain no
ALL_CAPS or quoted YAML).

---

## 1. `syntax_scanners.dart` split (442 lines → 5 files, max 158)

| File | Lines | Contents |
|---|---|---|
| `syntax_lexer.dart` | 64 | `SyntaxScanRule` + `lexScanRules` (the rule engine, formerly `_Rule`/`_lex`) |
| `syntax_scanners_c_like.dart` | 99 | Dart, Kotlin, Swift rule lists |
| `syntax_scanners_script.dart` | 145 | JavaScript/TypeScript, JSX/TSX, Python, Bash rule lists |
| `syntax_scanners_markup.dart` | 160 | HTML, CSS, JSON, YAML, Markdown rule lists |
| `syntax_scanners.dart` | 38 | `scanLanguage` dispatch (the public entry point) |

`check_layers` `file-too-long` warnings: **9 → 8**. No file exceeds 400.

`SyntaxScanRule`, `lexScanRules` and the 12 rule lists are public because Dart
privacy is per library and `part of` is banned by the gate; `scanLanguage` keeps
its exact signature and nothing was removed. `check_single_owner`: 0 duplicates.

The split itself was proved behaviour-neutral before the two bug fixes, by a
scratch harness that compared the shipped `scanLanguage` against a verbatim copy
of the committed implementation over 240 snippet×language runs, all 660
`.dart` files in `lib/registry`, and 400 fuzz + 8 pathological inputs. The only
intentional edit was collapsing `_jsxRules(typescript:)`, whose two keyword
regex literals are byte-identical (394 chars) into one `jsxScanRules` list,
pinned by a jsx/tsx equal-stream test.

---

## 2. Per-language golden tests (44 tests)

| File | Lines | Covers |
|---|---|---|
| `syntax_highlight_support.dart` | 72 | `kinds()`, `kindSequence()`, `expectKinds()`, `expectRoundTrip()`, `expectGolden()` |
| `syntax_goldens_c_like_test.dart` | 233 | Dart (8), Kotlin (3), Swift (4) |
| `syntax_goldens_script_test.dart` | 241 | JS (3), TS (2), JSX/TSX (2), Python (4), Bash (3) |
| `syntax_goldens_markup_test.dart` | 246 | HTML (3), CSS (3), JSON (2), YAML (4), Markdown (3) |

Each of the 12 languages the brief names has a representative snippet asserted as
the **exact token-kind sequence**, and every golden also asserts the span
round-trip (tokens sorted, non-overlapping, in bounds; spans concatenate back to
the source). Edge cases: multi-line strings/comments, Dart `$x`/`${}` and
escaped `\$`, JS template literals with `${}` and escaped backticks, raw and
prefixed strings, escapes, decorators/annotations, non-nesting block comments,
shell `#`-in-string, shebang comments, JSON key/value split, YAML block scalars
and anchors, Markdown fences/images/quotes.

### Fuzz requirement (already satisfied, left untouched)
`syntax_highlight_test.dart` (589 lines, from the previous task) already runs
**every `.dart` file in `lib/registry`** through the Dart scanner asserting no
throw, no overlap, in-bounds tokens and spans that concatenate back to the
input. It was left as-is; the new goldens are split files.

Suite: `flutter test test/registry` **+2756, all passed** (baseline +2712 → +44).

---

## 3. `theme.dart` syntax wiring — condition not met, no change made

`theme/theme.dart` is 472 lines (`check_layers` counts 473) and already trips
`file-too-long`; the brief asked to move the syntax wiring into
`theme/syntax_colors.dart` **if** that brought it back toward ≤ ~450 without
changing the public API. It does not, so nothing was changed:

* `git show 3bcd9c0~1:…/theme/theme.dart` had **zero** syntax references (456
  lines). Commit `3bcd9c0` already moved the palette out — that is what
  `theme/syntax_colors.dart` is (219 lines: `SyntaxTokenKind`, `SyntaxColors`,
  light/dark palettes, `forBrightness`, `lerp`, `colorFor`).
* What remains is 13 lines of `ShadcnThemeData` plumbing: the `syntax` import,
  the ctor parameter, the field (+doc), the `syntaxColors` getter (+doc), the
  `copyWith` parameter and body, the `lerp` line, and the `==`/`hashCode` entries.
* A field cannot move out of its class and an extension cannot add one, so the
  only movable part is the 3-line `syntaxColors` getter. Moving it into
  `syntax_colors.dart` would require a `theme.dart` ↔ `syntax_colors.dart`
  import cycle (the getter needs `ShadcnThemeData`) and saves 3 lines: 473 → ~470,
  still above the 450 target.
* The alternative that *would* hit the number — moving `ComponentTheme`,
  `ComponentThemes`, `ComponentThemeData` and `resolveComponentStyle` out of
  `theme.dart` (~134 lines → ~340) — contradicts `REARCHITECTURE_PLAN.md` §6.5,
  the source of truth: "`theme.dart` (ShadcnTheme, ThemeData,
  **ComponentTheme<T>**, lerp/animated)".

**Recommendation:** leave `theme.dart` as-is and lower the `file-too-long`
allowance for the token files (`typography.dart` 614, `color_tokens.dart` 588,
`theme.dart` 473, `tokens.dart` 455) or split them in a dedicated task.

---

## Gates

| Gate | Result |
|---|---|
| `dart format lib/registry test/registry` | 851 files, 0 changed |
| `dart analyze lib/registry` | No issues found! |
| `dart analyze test/registry` | No issues found! |
| `flutter test test/registry` | +2756, all passed |
| `flutter test test/rearch` | +42, all passed |
| `rearch/qa_gate.sh` | clean on every line; `file-too-long: 8` (was 9); owner 0; user-theme 0; banned clean |
| `gen_registry_manifest.dart` + `--check` | regenerated, up to date |
| `docs/tool/sync_registry.sh` + `--check` | mirrored 660 Dart files, up to date |
| `docs gen_docs_data.dart --check` | up to date (8 files), parse errors: none |
| `docs flutter analyze` | **No issues found!** (the 6 warnings seen in round 1 were the concurrent docs agent's in-flight `docs/test` edits; they are gone now) |

## Files written (round 2)

* `flutter_shadcn_kit/lib/registry/primitives/syntax_highlight/syntax_scanners_c_like.dart` (YAML/Dart rule order + `|` fix — the Dart fix)
* `flutter_shadcn_kit/lib/registry/primitives/syntax_highlight/syntax_scanners_markup.dart` (YAML `|` fix)
* `flutter_shadcn_kit/test/registry/primitives/syntax_goldens_c_like_test.dart`
* `flutter_shadcn_kit/test/registry/primitives/syntax_goldens_markup_test.dart`
* `flutter_shadcn_kit/lib/registry/manifests/registry.json` (regenerated)
* `docs/lib/ui/shadcn/primitives/syntax_highlight/{syntax_scanners_c_like,syntax_scanners_markup}.dart` (mirror)
* `rearch/reports/P4-T5b.md` (this file)

## Commands run (round 2)

| Command | Outcome |
|---|---|
| `dart format lib/registry test/registry` | 851 files, 0 changed |
| `dart analyze lib/registry` / `test/registry` | No issues found! (both) |
| `flutter test test/registry` | +2756, all passed |
| `flutter test test/rearch` | +42, all passed |
| `./rearch/qa_gate.sh` | all lines green |
| `gen_registry_manifest.dart` + `--check` | regenerated, up to date |
| `docs/tool/sync_registry.sh` + `--check` | 660 files mirrored, up to date |
| `docs gen_docs_data.dart --check` | up to date, 0 parse errors |
| `docs flutter analyze` | No issues found! |
| scratch probe (deleted) | confirmed the new kind streams for every changed golden before rewriting them |

## RESULT
status: done
files_written: [
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry/primitives/syntax_highlight/syntax_scanners_c_like.dart,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry/primitives/syntax_highlight/syntax_scanners_markup.dart,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry/manifests/registry.json,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/test/registry/primitives/syntax_goldens_c_like_test.dart,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/test/registry/primitives/syntax_goldens_markup_test.dart,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/docs/lib/ui/shadcn/primitives/syntax_highlight/syntax_scanners_c_like.dart,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/docs/lib/ui/shadcn/primitives/syntax_highlight/syntax_scanners_markup.dart,
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P4-T5b.md
]
commands_run:
  - "dart format lib/registry test/registry -> 851 files, 0 changed"
  - "dart analyze lib/registry -> No issues found!"
  - "dart analyze test/registry -> No issues found!"
  - "flutter test test/registry -> +2756 all passed (was +2754, +2 new goldens)"
  - "flutter test test/rearch -> +42 all passed"
  - "./rearch/qa_gate.sh -> every line green; layers file-too-long 8; owner 0; banned clean"
  - "dart run tool/registry/gen_registry_manifest.dart [--check] -> regenerated, up to date"
  - "docs/tool/sync_registry.sh [--check] -> 660 Dart files mirrored, up to date"
  - "cd docs && dart run tool/gen_docs_data.dart --check -> up to date, parse errors none"
  - "cd docs && flutter analyze -> No issues found! (round 1's 6 warnings were the concurrent agent's docs/test edits, now resolved)"
  - "scratch probe (deleted) -> verified the new kind streams before rewriting each golden"
key_findings: [
  "Fix 1: the YAML string rule was two adjacent raw literals with no | between them, so `k: \\\"v\\\"` produced no string token and the colon inside the value leaked as an operator. | restored; quoted values now emit one string token each (escapes and '' doubling stay inside it).",
  "Fix 2: Dart's ALL_CAPS constant rule sat after the type rule whose character class is a superset, so it could never fire. Constant rule now ordered before type: MAX/MAX_SIZE/HTML/URL are constant, HTMLParser/Abc/AB/Foo/String stay type (AB stays type because the rule needs 3+ chars - documented by a new golden).",
  "Goldens updated to the correct kinds: dart representative (MAX -> constant), the ALL_CAPS test renamed and extended, two new goldens (ALL_CAPS boundary, YAML escaped/doubled quotes), yaml representative and the quoted-values test rewritten to expect string tokens. No golden pins buggy behaviour any more.",
  "The scanner split itself was already proved behaviour-neutral by a differential harness against a verbatim copy of the committed implementation (240 snippet x language runs, all 660 registry .dart files, 400 fuzz + 8 pathological inputs).",
  "theme.dart item 3 remains not applicable: commit 3bcd9c0 already moved the palette to syntax_colors.dart; the 13 remaining syntax lines are ShadcnThemeData plumbing a field must own, so only a 3-line getter could move (needs an import cycle) -> 473 -> ~470, not <= ~450; the alternative contradicts REARCHITECTURE_PLAN.md 6.5.",
  "All gates green after the fixes: format 0 changed, analyze 0 issues (registry, tests, docs), test +2756, rearch +42, manifest --check, mirror --check, docs codegen --check."
]
open_questions: [
  "theme.dart / tokens.dart / color_tokens.dart / typography.dart still trip file-too-long (473/455/588/614): accept as warnings or split in a dedicated task? Plan 6.5 keeps ComponentTheme<T> in theme.dart, which is why brief item 3 could not be met as written.",
  "ALL_CAPS with only 2 letters (AB) is type while 3+ (ABC) is constant — inherent to the existing \\b[A-Z][A-Z0-9_]{2,}\\b shape; kept and pinned rather than widened."
]
