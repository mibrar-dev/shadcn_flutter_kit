QA round 2 for P3_PILOT_DESIGN.md. Edit only `$KIT/rearch/reports/P3_PILOT_DESIGN.md`. Keep it under ~620 lines.

F1 (I2, dependency direction): `input` must NOT depend on the `autocomplete` component — every component is
installable alone. Invert it: `input` exposes a small, generic feature/hook point (e.g. an `InputFeature` list or a
suggestion slot typed with primitives only); `autocomplete` depends on `input` and supplies the suggestion UI.
Update §2.2, §2.4, §2.5 meta.json, §2.6 mapping, §4 build order, and approval item I2.

F2 (I1, text editing regression): "stock EditableText" alone loses tap/double-tap/long-press selection, drag
handles, and copy/cut/paste/select-all. Specify the widgets-only replacement: `TextSelectionGestureDetectorBuilder`
(+ `TextSelectionGestureDetectorBuilderDelegate`), selection controls/handles that do not import Material or
Cupertino, and `contextMenuBuilder` with a small widgets-only toolbar (Cut/Copy/Paste/Select all, labels from
`primitives/localizations`). Put it in a primitive (`primitives/text_editing.dart` or similar) if `input` would
pass ~400 lines, and add tests for selection + copy/paste + context menu to §2.7. Say what of the old ~2.5k LOC layer
this replaces and what is truly dropped.

F3 (D3): current shadcn/ui dialog overlay is `bg-black/50`, not 80%. Use black alpha 0.5 as the default token value
and update D3.

F4: in §5, give a one-line recommendation for each approval item so the user can answer yes/no quickly.

Finish with the usual `## RESULT` block.
