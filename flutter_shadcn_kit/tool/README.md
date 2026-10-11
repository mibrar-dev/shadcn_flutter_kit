# Tooling Layout

- `tool/registry/` — the generated registry manifest and the package barrel.
- `tool/rearch/` — re-architecture guardrails (`check_layers`,
  `check_single_owner`, `check_user_theme`, `api_snapshot`) and
  `gen_app_theme.dart`.

Run all of them from `flutter_shadcn_kit/`. The registry tree is the flat
`lib/registry/{foundation,theme,primitives,components,themes}` layout.
