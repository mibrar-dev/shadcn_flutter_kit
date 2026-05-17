# Registry Manifest Agent Report

Date: 2026-05-17

Base branch: `branch-v1-registry-minimal-init-manifests`

Combined branch: `branch-v1-registry-manifest-hard-errors-combined`

## Purpose

The previous registry audit still had hard component-manifest errors where components imported shared files but their `meta.json` did not declare those shared dependencies. That means the CLI could install a component without copying all shared files it needs.

This pass split the remaining hard errors across three agents. Each agent edited disjoint component `meta.json` files and committed its own branch. The combined branch cherry-picks all agent commits and verifies the full registry state together.

## Audit Result After Combined Work

Command:

```bash
dart run flutter_shadcn_kit/tool/registry_manifest_audit.dart
```

Result:

- `component_manifests` errors: `0`
- Remaining hazards: `214`
- Remaining warning-level component metadata gaps: `106` unique components still miss flat `assets`/`fonts` fields
- Remaining theme warnings: `2`

The hard install correctness issue is resolved for the audited shared-dependency mismatches. Remaining work is warning-level metadata completion and theme-install narrowing.

## Agent A: Form And Input Manifests

Branch: `branch-v1-registry-form-input-manifests`

Commit: `49002b99`

Scope:

- `flutter_shadcn_kit/lib/registry/components/form/autocomplete/meta.json`
- `flutter_shadcn_kit/lib/registry/components/form/checkbox/meta.json`
- `flutter_shadcn_kit/lib/registry/components/form/form/meta.json`
- `flutter_shadcn_kit/lib/registry/components/form/formatted_input/meta.json`
- `flutter_shadcn_kit/lib/registry/components/form/text_field/meta.json`
- `flutter_shadcn_kit/lib/registry/components/control/clickable/meta.json`
- `flutter_shadcn_kit/lib/registry/components/display/keyboard_shortcut/meta.json`
- `flutter_shadcn_kit/lib/registry/components/layout/sortable/meta.json`

What changed:

- Added missing shared dependency IDs used by imports:
  - `util`
  - `color_extensions`
  - `animated_value_builder`
  - `constants`
  - `phone_number`
  - `slider_value`
  - `focus_outline`
  - `text_input_utils`
  - `keyboard_shortcut_utils`
  - `clickable`
- Added empty `assets: []` and `fonts: []` to the touched manifests where missing.

Effect on current code:

- Installing these form/control components now pulls the shared files they actually import.
- The registry source of truth is more complete per component.
- The CLI has fewer chances to produce generated component installs with missing imports.

Verification:

- All edited JSON files parsed successfully.
- Audit no longer reports errors for the scoped components.

## Agent B: Overlay And Navigation Manifests

Branch: `branch-v1-registry-overlay-nav-manifests`

Commit: `e6a0a1f0`

Scope:

- `flutter_shadcn_kit/lib/registry/components/overlay/context_menu/meta.json`
- `flutter_shadcn_kit/lib/registry/components/overlay/drawer/meta.json`
- `flutter_shadcn_kit/lib/registry/components/form/file_picker/meta.json`
- `flutter_shadcn_kit/lib/registry/components/overlay/menu/meta.json`
- `flutter_shadcn_kit/lib/registry/components/overlay/popup/meta.json`
- `flutter_shadcn_kit/lib/registry/components/overlay/tooltip/meta.json`
- `flutter_shadcn_kit/lib/registry/components/navigation/navigation_bar/meta.json`
- `flutter_shadcn_kit/lib/registry/components/navigation/navigation_menu/meta.json`
- `flutter_shadcn_kit/lib/registry/components/navigation/pagination/meta.json`
- `flutter_shadcn_kit/lib/registry/components/navigation/tabs/meta.json`

What changed:

- Added missing shared dependency IDs used by imports:
  - `animated_value_builder`
  - `util`
  - `lucide_icons`
  - `overlay`
  - `outlined_container`
  - `geometry_extensions`
  - `sheet_overlay`
  - `icon_extensions`
  - `color_extensions`
- Added empty `assets: []` and `fonts: []` to the touched manifests where missing.

Effect on current code:

- Overlay and navigation component installs now declare the shared primitives, icons, and utilities they depend on.
- `file_picker` is corrected at its actual registry path under `form/file_picker`.
- The CLI can trust these component manifests more safely during per-component installs.

Verification:

- All edited JSON files parsed successfully.
- Audit no longer reports errors for the scoped components.

## Agent C: Display And Utility Manifests

Branch: `branch-v1-registry-display-utility-manifests`

Commit: `01859a14`

Scope:

- `flutter_shadcn_kit/lib/registry/components/display/chat/meta.json`
- `flutter_shadcn_kit/lib/registry/components/display/markdown/meta.json`
- `flutter_shadcn_kit/lib/registry/components/display/skeleton/meta.json`
- `flutter_shadcn_kit/lib/registry/components/utility/error_system/meta.json`

What changed:

- Added missing shared dependency IDs used by imports:
  - `axis`
  - `outlined_container`
  - `style_value`
  - `color_extensions`
- Added empty `assets: []` and `fonts: []` to `markdown` where missing.

Effect on current code:

- Display and utility components now declare the shared helpers their Dart files import.
- `error_system` is corrected at its actual registry path under `utility/error_system`.
- The audit no longer flags these display/utility install manifests as incomplete.

Verification:

- All edited JSON files parsed successfully.
- Audit no longer reports errors for the scoped components.

## Combined Branch

Branch: `branch-v1-registry-manifest-hard-errors-combined`

Commits:

- `8182fc44` - form/input manifest fixes
- `6cb65d3d` - overlay/navigation manifest fixes
- `a9de1e32` - display/utility manifest fixes

What the combined branch changes:

- Brings all three agent scopes together in one branch.
- Reduces `component_manifests` hard errors from `39` to `0`.
- Leaves warning-level metadata and theme-install cleanup as explicit follow-up work.

## Remaining Work

- Add flat `assets: []` and `fonts: []` fields to the remaining 106 warning-level component manifests.
- Resolve the two theme-install warnings for `preset_themes` and `app_theme_preset`.
- Re-run the full CLI install QA after the combined branch is merged into the registry branch consumed by the CLI.
