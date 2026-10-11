# Brief P7-Q2b — continue P7-Q2 in a fresh session

Read `rearch/briefs/fixes/P7-Q2-component-qa.md` (binding brief) and your previous progress in
`rearch/reports/P7-Q2.md` plus the existing `flutter_shadcn_kit/test/registry/qa/*_qa_test.dart`. A previous session
crashed twice (it was investigating `scrollbar` `thumbVisibility` assertion and `resizable` below-minimum overflow via
`primitives/resizable_pane.dart computeSize`). Continue with the components not yet done in the report, fix bugs at the
root with regression tests, keep the report table updated after every ~3 components, then run the gates and write the
`## RESULT` block. Work in small steps (avoid huge outputs: pipe long test output through `tail`). Do NOT open PNGs.
