QA round 2 for P3-D input. Gates green (301 tests) and the feature work is good. One blocking issue: file size.
`input.dart` 831 and `input_features.dart` 919 lines break the binding ~400-line rule, and the component folder may
hold only `input.dart`, `input_style.dart`, `input_theme.dart`, `preview.dart` (+ meta/README) — so do NOT add more
files under `components/input/`. Instead move REUSABLE machinery DOWN into primitives (text_area, number_input,
formatted_input and autocomplete will reuse it in Phase 4):

1. `primitives/text_editing/` (turn the single file into a folder): `text_editing.dart` (existing selection
   controls/menu), plus the EditableText host/state machinery from input.dart that is not Input-specific
   (controller/focus ownership, gesture builder wiring, form participation glue, undo, etc.).
2. `primitives/input_features/`: the feature framework (`InputFeature`, `InputFeatureState` host + `slot()`,
   `InputFeatureVisibility` composition) in one file, and the concrete reusable features grouped by responsibility
   (e.g. `adornment_features.dart` clear/password/copy/paste/hint, `numeric_features.dart` spinner/increment with
   min/max clamping, `suggestion_feature.dart` the generic suggestion slot). Each file ≤ ~400 lines.
3. `components/input/input.dart` keeps only the public `Input` widget + its state wiring, ≤ ~400 lines; delete
   `input_features.dart` from the component (re-export nothing — imports point at primitives).
4. Move/rename tests accordingly (`test/registry_next/primitives/text_editing_test.dart`,
   `test/registry_next/primitives/input_features_test.dart`, `test/registry_next/components/input_test.dart`).
   Every existing test must still exist and pass.
5. Update `meta.json` deps (`primitives: [text_editing, input_features, form_core, localizations, ...]`), README,
   and `P3D_INPUT.md` (new old→new mapping + LOC table).

Decisions: validator receiving raw text ('' not null) — accepted (matches Flutter TextFormField). Hint popover
alignment port — accepted; visual pass comes later.

Behaviour must not change. Rerun ALL gates; `check_layers` must show 0 errors and NO new file-too-long warnings
from your files. Finish with the `## RESULT` block.
