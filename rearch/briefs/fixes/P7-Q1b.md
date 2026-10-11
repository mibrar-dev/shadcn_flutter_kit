# Brief P7-Q1b — finish P7-Q1 in a fresh session

Binding brief: `rearch/briefs/fixes/P7-Q1-component-qa.md`. Progress: `rearch/reports/P7-Q1.md` and the existing
`flutter_shadcn_kit/test/registry/qa/*_qa_test.dart`. The previous session died ("reasoning item expired") while
working on code_snippet (long lines scroll test passing). Continue with the components in your list not yet marked done
in the report; fix bugs at the root with regression tests; update the report every ~3 components. Another QA agent
(P7-Q2) owns the second half of the components — never overwrite its `qa/*_qa_test.dart` files (only your list).
Then gates (`rearch/qa_gate.sh`, generators --check, docs sync + --check, docs analyze/test; record failures that are
only in other agents' in-flight files) and the `## RESULT` block. Pipe long outputs through `tail`. Do NOT open PNGs.
No git ops.
