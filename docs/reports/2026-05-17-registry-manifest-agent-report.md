# Registry Manifest Agent Report

Date: 2026-05-17

Base branch: `branch-v1-registry-minimal-init-manifests`

Combined branch: `branch-v1-registry-manifest-hard-errors-combined`

## Purpose

The registry audit exposed two classes of production readiness issues:

- Hard component manifest errors: components imported shared registry files that were not declared in the component `meta.json`.
- Warning-level metadata and theme install issues: many component manifests did not expose flat `assets` and `fonts` keys, and shared theme entries still referenced generated theme folders too broadly.

The work was split across OpenCode worker branches and then cherry-picked into the combined branch for final verification.

## Before

Initial audit state before the hard-error pass:

- `component_manifests` hard errors: `39`
- Missing shared dependency declarations meant the CLI could install a component without installing every shared file it imports.

Audit state after the first hard-error pass, before this continuation:

- `component_manifests` hard errors: `0`
- Remaining hazards: `214`
- Warning-level component metadata gaps: `106` components missing flat `assets` or `fonts`
- Theme-install warnings: `2`

## After

Final audit state on the combined branch:

- `component_manifests` hard errors: `0`
- Warning-level metadata hazards: `0`
- Theme-install hazards: `0`
- Total registry audit hazards: `0`

Verification command:

```bash
dart run flutter_shadcn_kit/tool/registry_manifest_audit.dart
```

Result:

```text
Registry manifest audit passed. No hazards found.
```

Additional JSON verification:

```bash
python3 -m json.tool flutter_shadcn_kit/lib/registry/manifests/components.json >/dev/null
find flutter_shadcn_kit/lib/registry/components -path '*/meta.json' -exec python3 -m json.tool {} >/dev/null \;
```

Both commands exited successfully.

## Agent A: Form And Input Manifest Dependencies

Branch: `branch-v1-registry-form-input-manifests`

Original worker commit: `49002b99`

Combined commit: `8182fc44`

Scope:

- Form components with missing shared dependency declarations.
- Control/display/layout components that were part of the same hard-error group.

What changed:

- Added missing shared dependency IDs used by Dart imports.
- Added empty `assets: []` and `fonts: []` where needed on touched manifests.

Code impact:

- Form and related component installs now pull required shared primitives and utility files through the component manifest.
- The CLI can treat the component manifest as the per-component install source of truth for these components.

## Agent B: Overlay And Navigation Manifest Dependencies

Branch: `branch-v1-registry-overlay-nav-manifests`

Original worker commit: `e6a0a1f0`

Combined commit: `6cb65d3d`

Scope:

- Overlay components.
- Navigation components.
- `form/file_picker`, which was located in the form registry path but grouped with this dependency issue.

What changed:

- Added missing shared dependency IDs including overlay primitives, icon helpers, geometry helpers, and utility files.
- Added empty `assets: []` and `fonts: []` where needed on touched manifests.

Code impact:

- Overlay and navigation component installs now declare the shared files they import.
- The `file_picker` manifest now resolves from its actual registry path and declares its dependency surface correctly.

## Agent C: Display And Utility Manifest Dependencies

Branch: `branch-v1-registry-display-utility-manifests`

Original worker commit: `01859a14`

Combined commit: `a9de1e32`

Scope:

- Display components with missing dependency declarations.
- Utility registry components involved in the hard-error audit.

What changed:

- Added missing shared dependency IDs used by display and utility imports.
- Added flat metadata keys where needed on touched manifests.

Code impact:

- Display and utility component installs now include required shared helpers instead of relying on broad init-time shared installs.

## Theme Manifest Fix

Combined commit: `5db8c5a3`

Scope:

- `flutter_shadcn_kit/lib/registry/manifests/components.json`

What changed:

- Removed generated theme folder file entries from shared registry entries:
  - `preset_themes`
  - `app_theme_preset`

Code impact:

- Init/shared install paths no longer copy every generated theme file through broad shared entries.
- Theme installation is narrower and aligns with the requirement that init should not install unused generated theme folders.

## Agent D: Form And Control Metadata Completion

Branch: `branch-v1-registry-metadata-form-control`

Original worker commit: `81307aec`

Combined commit: `9feec8b7`

Scope:

- 31 form/control component manifests.

What changed:

- Added missing top-level `assets: []` and `fonts: []` fields.

Code impact:

- Form/control manifests now expose explicit empty asset and font metadata.
- The CLI can read component asset/font metadata without falling back to implicit assumptions.

## Agent E: Display And Utility Metadata Completion

Branch: `branch-v1-registry-metadata-display-utility`

Original worker commit: `0afacddc`

Combined commit: `124e4a45`

Scope:

- 34 display/utility component manifests.

What changed:

- Added missing top-level `assets: []` and `fonts: []` fields.

Code impact:

- Display/utility component manifests now have complete flat metadata for asset/font resolution.

## Agent F: Layout, Overlay, And Navigation Metadata Completion

Branch: `branch-v1-registry-metadata-layout-overlay-nav`

Original worker commit: `a17ffa5c`

Combined commit: `80da22d4`

Scope:

- 41 layout/overlay/navigation component manifests.

What changed:

- Added missing top-level `assets: []` and `fonts: []` fields.
- Normalized several manifests that had dependency metadata but lacked the flat asset/font keys required by the audit.

Code impact:

- Layout, overlay, and navigation component manifests now expose complete install metadata.
- Component installs can stay per-component instead of depending on broad shared file copying during init.

## Final Combined Branch Commits

- `8182fc44` - Fix form and input registry manifest dependencies
- `6cb65d3d` - Fix overlay and navigation registry manifest dependencies
- `a9de1e32` - Fix display registry manifest dependencies
- `6d292032` - Report registry manifest agent fixes
- `5db8c5a3` - Limit shared theme manifest entries
- `9feec8b7` - Add form and control asset font metadata
- `124e4a45` - Add display and utility asset font metadata
- `80da22d4` - Add layout overlay navigation asset font metadata

## Current Status

The registry manifest audit is clean on the combined branch. The remaining production validation work is CLI-side end-to-end QA against this registry state: interactive `init`, optional assets/fonts/icons prompts, per-component install behavior, and `pubspec.yaml` preservation.
