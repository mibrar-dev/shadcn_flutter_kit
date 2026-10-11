# Brief P6-B2 — CLI: install blocks + categories

CLI repo `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli` (branch
refactor/rearchitecture — never touch main). Read `$KIT/rearch/reports/P6-B1.md` and the manifest v2 `blocks` section
(`/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry/manifests/registry.json`).

## Do
- `add <id>` resolves components AND blocks (`add login-01`); a block installs to `lib/ui/shadcn/blocks/<id>/` with all
  transitive component/primitive/theme/foundation deps; lock v2 records blocks (hashes); `remove`/`update` handle blocks
  (user edits never overwritten, as for components).
- `list` / `search` / `info` show `category` for components and blocks (`list --blocks`, `list --category <c>`,
  grouping by category in human output, JSON output stable).
- Docs/help text updated; tests (unit + the e2e acceptance test adds a block install into a temp app and `flutter
  analyze` passes).
Gates: `dart format --output=none --set-exit-if-changed .`, `dart analyze` 0, `dart test`, and
`dart test -t e2e --run-skipped test/e2e/acceptance_test.dart`. No git state changes.
Report `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P6-B2.md`, `## RESULT`.
