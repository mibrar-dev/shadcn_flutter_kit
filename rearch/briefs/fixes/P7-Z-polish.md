# Brief P7-Z — final polish (orchestrator visual QA after the P7 batch, commit 102fb81)

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit, DOCS=$KIT/docs.
Do NOT open PNG images yourself (the model crashes on images); verify with widget tests reading real values.
1. Registry `command`: the search input inside the command surface still shows a thick (~2px) light focus ring around
   the whole input. shadcn: no ring/border on the command input; the row has only a 1px bottom border (border token);
   search icon size-4 at 50% opacity. Keep keyboard focus visible via the caret/selection only. Test: no BoxDecoration
   border around the focused input inside Command; bottom divider present.
2. Docs preview card toolbar (`docs/lib/widgets/example_preview_card.dart` & co.): on desktop the light/dark toggle and
   copy button sit right next to the Preview|Code tabs; they must be right-aligned in the toolbar (tabs left, actions
   right) at every width ≥ 320 while staying on one row. Test the rects at 1440 and 375.
3. `primitives/basic_layout.dart:101-111`: alignments default to non-directional `Alignment.topLeft/topCenter`, so
   alert and every BasicLayout consumer stays left-pinned in RTL → use `AlignmentDirectional`; RTL tests.
4. `primitives/clickable.dart`: add an additive `autofocus` parameter (owned FocusNode logic once, in the primitive);
   remove the hand-rolled duplicates in badge/chip; tests.
5. `primitives/form_core/object_form_prompt.dart`: the new shrink-wrap dialog card crashes for unbounded editors —
   bound the editor (max width/height from the viewport) so any editor works; test with an unbounded editor.
6. Split files over ~400 lines that you touch; list the remaining over-length files in the report.
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest/previews/blocks generators regenerate + --check; docs sync + --check,
codegen --check, format/analyze/test, `flutter build web --release`. Report `rearch/reports/P7-Z.md`, `## RESULT`.
No git ops.
