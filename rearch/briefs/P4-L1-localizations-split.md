# Brief P4-L1 — split `primitives/localizations/localizations.dart` + move error_system strings (mechanical)

`$APP/lib/registry_next/primitives/localizations/localizations.dart` is 618 lines (limit ~400) after several batches
added keys. Split it WITHOUT changing any public API or any translation.

## Do
1. Keep the abstract base class `ShadcnLocalizations` in `localizations.dart`, but group its English-default getters
   into `mixin`s by domain in sibling files, e.g. `localizations_form.dart` (form/validation/input), 
   `localizations_overlay.dart` (dialog/menu/popover/toast/drawer), `localizations_date_time.dart` (calendar/date/
   time/duration), `localizations_files.dart` (file picker/dropzone/upload), `localizations_misc.dart` — each ≤ ~400
   lines. `ShadcnLocalizations` = abstract class with those mixins applied (`with ...`) so every existing call site
   (`ShadcnLocalizations.of(context).foo`) and every locale subclass (`localizations_<code>.dart` overriding getters)
   keeps compiling unchanged. Public import stays `localizations.dart` (export the mixin files from it if needed).
2. Move the hard-coded English user-facing strings of `components/error_system/` (and its primitive
   `primitives/error_handling/`) into new getters (English fallback; copy a translation ONLY if Flutter's
   `flutter_localizations` ARB has the same string — never invent) and use them from those files.
3. Do not reorder/reformat the 43 locale files beyond what is needed; no translation values may change.

## Verify
- `grep -c` of every getter name before/after: identical set (write the before/after lists to the report).
- `cd $KIT && rearch/qa_gate.sh` — full gate must be clean (format, analyze, ALL tests, layers with no
  localizations file-too-long, owner 0, theme 0).

## Outputs
`lib/registry_next/primitives/localizations/**`, `components/error_system/**`, `primitives/error_handling/**`, their
tests, `rearch/reports/P4-L1.md`.
