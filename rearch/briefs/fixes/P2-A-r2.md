Your previous run was cut off by a network error (ECONNRESET) before you finished. The orchestrator checked the
state you left: `lib/registry_next/foundation/` formats clean, analyzes with 0 issues, 0 layer errors, 0 duplicates,
licences written, README present. Remaining work — finish all of it:

1. `flutter test test/registry_next/foundation` → 50 pass, 4 FAIL:
   - util_test.dart "joinSeparator joins a list keeping a list": expected List<int>, actual SkipIterable.
   - keyboard_test.dart "shortcutActivatorToKeySet expands logical key sets": expected Meta Left + Meta Right, got only Key K.
   - util_test.dart "CachedValueWidget honours CachedValue.shouldRebuild": expected 1, actual 2 (line ~123).
   - util_test.dart "ListExtension.swapItem moves an item backward and inserts missing items".
   - (gap_test.dart "Gap sizes along the Row main axis" also appears in the failure listing — check it.)
   For EACH failure decide whether the TEST or the CODE is wrong by comparing against the OLD implementation in
   `$REG/shared/utils/**` (and its call sites in `$REG/components`). Behaviour must match the old code exactly —
   fix the code if it deviates, fix the test if the test's expectation was wrong. State the verdict per failure in
   the report with the old file:line you compared against.
2. Write `$KIT/rearch/reports/P2A_FOUNDATION.md` exactly as the brief (rearch/briefs/P2-A-foundation.md) requires:
   file list + LOC, old → new mapping for all 39 foundation entries, data_widget/gap API ported vs not ported,
   members pruned, items deferred to primitives, and the 4 failure verdicts.
3. Re-run every gate from the brief and paste results (all green required), then the RESULT block.
Write large files in chunks (rule 8 in _common.md).
