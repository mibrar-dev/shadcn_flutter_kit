# flutter_shadcn_kit Registry Scalability Remediation Implementation Plan

---
## AGENT EXECUTION PROTOCOL — READ THIS BEFORE ANYTHING ELSE

This plan is designed for subagent-driven execution under a subscription 
account that may hit rate limits mid-task. Every agent session MUST follow 
this protocol exactly. There are no exceptions.

---

### BEFORE YOU WRITE A SINGLE LINE OF CODE

Do these three things in this order:

1. Read this entire plan file.
2. Read `docs/superpowers/checkpoints/MASTER_STATUS.md` to find the 
   active branch.
3. Read the checkpoint file for that branch at 
   `docs/superpowers/checkpoints/<branch-name>.md`.

Only after reading all three do you take any action.

---

### THE CHECKPOINT FILES

Every branch in this plan has a dedicated checkpoint file at:
`docs/superpowers/checkpoints/<branch-name>.md`

If a checkpoint file does not exist for the active branch yet, create it 
immediately using this exact template before doing anything else:

```
# Checkpoint: <branch-name>
Last updated: <YYYY-MM-DD HH:MM>
Status: IN_PROGRESS

## Completed Steps
(none yet)

## Current Step
<copy the first step from the plan here>

## Blocked On
Nothing

## Remaining Steps
<copy all steps from the plan task here>

## Verification Results
(none yet)

## Files Modified
(none yet)

## Decisions Made
(none yet)
```

---

### THE ONLY WAY YOU ARE ALLOWED TO WORK

**One step. Then checkpoint. Then next step.**

This is not optional. This is the entire system.

After completing each checkbox step:
- Mark it complete in the checkpoint file
- Record the exact command run and its result (PASS / FAIL + brief output)
- Append any modified files to the Files Modified list
- Write the next step into Current Step
- Save the checkpoint file
- Only then move to the next step

If you are about to run a long operation (generation, codemod, build):
- Write the checkpoint first
- Then run the operation
- Then update the checkpoint with the result

Never complete more than one step between checkpoint writes. 
Never summarise what you plan to do and call it a checkpoint. 
A checkpoint records actual completed work with actual results only.

---

### VERIFICATION RESULTS MUST BE REAL

Every verification command in each task's Verification section must be 
recorded in the checkpoint like this:

```
## Verification Results
- dart run tool/registry/registry_verify.dart --ci → ✅ PASS (exit 0)
- flutter analyze → ✅ PASS (0 errors, 0 warnings)
- docs flutter build web → ✅ PASS
- consumer harness flutter build web → ✅ PASS (2026-05-04 15:12)
```

If a command fails, record it as:
```
- flutter analyze → ❌ FAIL — lib/registry/shared/theme/component_theme_global_registry.dart:42 — The argument type 'String' can't be assigned...
```

Then stop. Do not proceed to the next step. Fix the failure first, 
record the fix in Decisions Made, re-run the command, and only continue 
when it passes.

---

### IF YOU ARE RESUMING AFTER A RATE LIMIT

You will know you are resuming if the checkpoint file exists and shows 
Status: IN_PROGRESS.

Do this:
1. Read the checkpoint file
2. Find Current Step
3. Check Verification Results — if the current step has no recorded 
   result, treat it as incomplete even if it appears in Completed Steps. 
   Redo it.
4. State out loud: "Resuming from: <current step>. Last verified: 
   <last passing verification result>."
5. Then continue from that step

Do not assume a step was done correctly just because it appears in 
Completed Steps without a recorded verification result. Absence of 
evidence is not evidence of completion.

---

### ENDING A SESSION

Before you stop for any reason — rate limit warning, task complete, or 
explicit stop instruction — do this:

1. Write the checkpoint file with the most recent completed step and its 
   result
2. Set Current Step to the exact next thing to do
3. Update Status to IN_PROGRESS or DONE
4. Update `docs/superpowers/checkpoints/MASTER_STATUS.md` with the 
   current branch status and step count
5. Write: "SESSION END — Next session should resume from: <current step>"

If you skip this and the session ends, the next agent has no recovery 
point. Treat the end-of-session checkpoint write as the most important 
action in the entire session.

---

### MASTER STATUS FILE

`docs/superpowers/checkpoints/MASTER_STATUS.md` tracks all branches. 
Update it when a branch starts, when it is in progress, and when it 
merges. Format:

```
# Master Status
Last updated: <YYYY-MM-DD HH:MM>

| Branch                              | Status      | Step Progress | Notes        |
|-------------------------------------|-------------|---------------|--------------|
| branch-p0-registry-verify-gate      | DONE        | 7/7           | Merged       |
| branch-p0-type-safe-theme-registry  | IN_PROGRESS | 3/7           | Active       |
| branch-p0-token-pipeline-pilot      | NOT_STARTED | -             |              |
| branch-p1-theme-config-map-rollout  | NOT_STARTED | -             |              |
| branch-p1-generated-root-barrel     | NOT_STARTED | -             |              |
| branch-p1-component-barrel-cleanup  | NOT_STARTED | -             |              |
| branch-p2-tier-and-version-governance | NOT_STARTED | -           |              |
| branch-p3-explicit-theme-registration | NOT_STARTED | -           |              |
| branch-p3-opt-in-font-assets        | NOT_STARTED | -             |              |
```

---

### ROLLBACK RULE

If post-merge verification fails for any branch:
1. Record the failure in the checkpoint under Verification Results
2. Record the decision to rollback in Decisions Made  
3. Update MASTER_STATUS.md — set that branch to ROLLED_BACK
4. Stop. Do not start the next branch.
5. Write: "ROLLBACK REQUIRED — <branch-name> — Reason: <failure output>"

The next session will read this and open a new branch from updated main.

---

### THE RESUMPTION PROMPT (for the human to paste when restarting)

If you are the human reading this after a rate limit, paste this into 
your next Claude session:

> You are resuming a subagent-driven development task that was 
> interrupted by a rate limit. Before doing anything else, read these 
> files in order:
> 1. `docs/superpowers/plans/2026-05-04-registry-scalability-remediation.md`
> 2. `docs/superpowers/checkpoints/MASTER_STATUS.md`
> 3. The checkpoint file for the active branch listed in MASTER_STATUS
>
> After reading all three, state what was completed, state the current 
> step, state what you will do next, then do exactly that one step, 
> update the checkpoint, and stop for my review before continuing.

---

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` for every task in this plan. Use `superpowers:executing-plans` only as a fallback if subagent-driven execution is unavailable. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stabilize the registry and theme architecture so new components can be added without manual multi-file drift, token theme overrides actually work, and future scaling to 150+ components does not introduce brittle global bottlenecks.

**Architecture:** Execute the work as a sequence of independently mergeable branches. Start with CI and compatibility guardrails, then fix theme correctness, then remove manual-update bottlenecks, then add metadata governance, and only after that tackle optional runtime optimizations. Docs/DX expansion is explicitly out of scope for this plan and should be handled in a separate follow-up plan after stabilization lands.

**Tech Stack:** Flutter, Dart, generated registry/theme tooling under `flutter_shadcn_kit/tool/`, GitHub Actions, Graphify, `components.json` manifest pipeline.

---

## Current Repo Facts

- Registry component directories currently span 7 categories under `flutter_shadcn_kit/lib/registry/components/`.
- The repo currently contains 133 `meta.json` files under `flutter_shadcn_kit/lib/registry/components/`.
- `flutter_shadcn_kit/lib/registry/components/component_theme_global_configs.dart` is generated and already acts as a graph-level hub/god node.
- `flutter_shadcn_kit/lib/registry/shared/theme/component_theme_global_registry.dart` still keys resolvers by `String`.
- `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart` still exposes `null` theme values and open `if` chains in `resolve<T>()`.
- There are 68 `*_theme_config.dart` files under `flutter_shadcn_kit/lib/registry/components/**/_impl/themes/config/`.
- All 68 `*_theme_config.dart` files contain generated/manual-warning headers and all 68 expose a `resolve<T>()` method today.
- No dedicated in-repo generator for per-component `*_theme_config.dart` files is discoverable today, so Task 4 should assume a scripted codemod or newly added local generator is required.
- `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart` is still manually maintained and currently contains top-level `hide` clauses.
- `flutter_shadcn_kit/tool/registry/README.md` states that `docs/lib/ui/shadcn` is a generated docs mirror and must not be hand-edited.
- `flutter_shadcn_kit/tool/registry/registry_sync_all.dart --force` is the existing repo mechanism for refreshing manifest outputs, docs snapshots, and docs mirror inputs.
- `flutter_shadcn_kit/flutter_cli_verification_example/` already exists but is still a stock Flutter app and does not yet exercise copied registry components.
- Only `.github/workflows/docs-deploy.yml` exists today. There is no registry freshness CI gate yet.

## Branching Rules

- Every task below starts from the latest `main`.
- Do not stack unrelated tasks on top of each other.
- Merge only after verification passes for that task.
- If a task depends on a prior task, rebase or recreate from updated `main` after the dependency merges.
- Branch prefix: `branch-`.
- Every task below must be executed with `superpowers:subagent-driven-development` so implementation, verification, and review can run faster through isolated subagents.

## Branch Naming Convention

- `branch-p0-registry-verify-gate`
- `branch-p0-type-safe-theme-registry`
- `branch-p0-token-pipeline-pilot`
- `branch-p1-theme-config-map-rollout`
- `branch-p1-generated-root-barrel`
- `branch-p1-component-barrel-cleanup`
- `branch-p2-tier-and-version-governance`
- `branch-p3-explicit-theme-registration`
- `branch-p3-opt-in-font-assets`

## Priority and Category Matrix

| Priority | Category | Outcome |
| --- | --- | --- |
| P0 | Tooling / CI | Prevent manifest, docs mirror, and consumer drift before larger refactors land |
| P0 | Theme Infrastructure | Replace fragile string-key registration with typed registration |
| P0 | Theme Correctness | Make token config override paths actually produce runtime values |
| P1 | Theme Maintainability | Remove `resolve<T>()` if-chains and reduce per-component boilerplate |
| P1 | Registry / Export Tooling | Generate the root barrel and move symbol hiding closer to component boundaries |
| P2 | Metadata Governance | Add tiering, versioning discipline, and component lifecycle metadata |
| P3 | Runtime Scalability | Make theme registration and assets pay-for-what-you-use |

## Merge Order

1. `branch-p0-registry-verify-gate`
2. `branch-p0-type-safe-theme-registry`
3. `branch-p0-token-pipeline-pilot`
4. `branch-p1-theme-config-map-rollout`
5. `branch-p1-generated-root-barrel`
6. `branch-p1-component-barrel-cleanup`
7. `branch-p2-tier-and-version-governance`
8. `branch-p3-explicit-theme-registration`
9. `branch-p3-opt-in-font-assets`

## Locked Architectural Decisions

1. **Token files are the source of truth.**
   `*_theme_tokens.dart` is the canonical theme-value source. `*_theme_defaults.dart` must become derived compatibility output or be removed once rollout allows. Do not introduce a temporary adapter architecture that preserves two independent value sources.

2. **Docs mirror sync is mandatory for generated-file tasks.**
   Any task that changes registry/theme generation or generated source structure must run:
   `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force`
   Then verify:
   `cd docs && flutter analyze && flutter build web`

3. **Task 4 is generator/codemod-first, not discovery-first.**
   Scope is already known: 68 generated `*_theme_config.dart` files all need the same `resolve<T>()` treatment. Do not spend execution time rediscovering that scope.

4. **Lazy registration via import side effects is rejected.**
   The target pattern is explicit per-component registration helpers plus a compatibility bootstrap function that registers everything. Do not rely on import-time side effects or brittle static initialization behavior.

5. **Consumer compatibility must stay green during structural work.**
   Repurpose `flutter_shadcn_kit/flutter_cli_verification_example/` into a minimal harness that contains 2-3 representative copied components. Recommended set: `button`, `text_field`, and `dialog`. Tasks 2, 5, and 6 must verify that harness builds after their changes.

## Cross-Cutting Verification Rules

- After any code modification task in this plan, run `graphify update .`.
- After any task touching generated registry/theme outputs, run the docs mirror sync command and verify the docs app still builds.
- For tasks that affect package API surface or install structure, update changelog/release notes for breaking changes before merge.
- If post-merge verification fails for any task: revert the merge, file an issue with failing evidence, and re-branch from updated `main`.

### Task 1: Add Registry Freshness Gate and Minimal Consumer Compatibility Harness

**Priority:** P0  
**Category:** Tooling / CI  
**Branch:** `branch-p0-registry-verify-gate`

**Files:**
- Modify: `flutter_shadcn_kit/tool/registry/registry_verify.dart`
- Create: `.github/workflows/registry-verify.yml`
- Modify: `flutter_shadcn_kit/tool/registry/README.md` or `flutter_shadcn_kit/tool/docs/registry_verify.md`
- Modify: `flutter_shadcn_kit/flutter_cli_verification_example/lib/main.dart`
- Modify: `flutter_shadcn_kit/flutter_cli_verification_example/pubspec.yaml`
- Add copied component files under `flutter_shadcn_kit/flutter_cli_verification_example/lib/ui/shadcn/**` using the existing registry install flow

**Intent:**
- Add a CI-safe mode for registry verification.
- Fail PRs when `components.json`, docs snapshots, or generated mirror inputs diverge from the filesystem.
- Land the CI gate even if the consumer harness needs to start as a minimal baseline in the same branch.
- Establish the consumer compatibility harness before structural changes start landing.

**Steps:**
- [ ] Add `--ci` handling to `flutter_shadcn_kit/tool/registry/registry_verify.dart`.
- [ ] Keep the existing filesystem and docs snapshot checks, but make failure output concise and non-interactive in CI mode.
- [ ] Create `.github/workflows/registry-verify.yml` to run `dart run tool/registry/registry_verify.dart --ci` from `flutter_shadcn_kit/`.
- [ ] First make the CI gate independently mergeable inside the branch: verify the workflow and `--ci` mode work before touching the consumer harness.
- [ ] Repurpose `flutter_cli_verification_example/` into a minimal copy-paste consumer harness by installing/copying `button`, `text_field`, and `dialog` into `lib/ui/shadcn/**`.
- [ ] If full three-component setup is blocked by install-flow rough edges, land a minimal harness baseline in the same branch that proves at least `button` installs/builds cleanly, then expand it to `text_field` and `dialog` before starting Task 2.
- [ ] Replace the stock counter app with a small screen that imports and renders the harness components actually installed in this branch.
- [ ] Document the local pre-PR sequence: registry verify, docs build, and consumer harness build.

**Verification:**
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web`
- Expected: all commands pass.

**Merge Gate:**
- CI workflow exists and fails on stale manifest/docs state.
- CI gate is proven independently.
- Consumer harness builds and is ready for reuse by later tasks, even if it starts as a minimal baseline and is expanded before Task 2 begins.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 2: Replace String-Based Theme Registry Keys With `Type`

**Priority:** P0  
**Category:** Theme Infrastructure  
**Branch:** `branch-p0-type-safe-theme-registry`

**Files:**
- Modify: `flutter_shadcn_kit/lib/registry/shared/theme/component_theme_global_registry.dart`
- Modify: `flutter_shadcn_kit/lib/registry/components/component_theme_global_configs.dart`
- Modify: `flutter_shadcn_kit/tool/theme/component_theme_global_configs_generate.dart`
- Generated outputs refreshed via sync:
  - `docs/assets/registry/components.json`
  - `docs/lib/ui/shadcn/**`

**Intent:**
- Remove rename-fragile, obfuscation-fragile registry lookups.
- Make registration compile-time typed instead of stringly typed.
- Keep docs mirror and consumer harness green while the registry key type changes.

**Steps:**
- [ ] Change `ComponentThemeGlobalRegistry` from `Map<String, Object? Function()>` to `Map<Type, Object? Function()>`.
- [ ] Replace `registerByName(String typeName, ...)` with `register<T>(...)`.
- [ ] Update `flutter_shadcn_kit/tool/theme/component_theme_global_configs_generate.dart` to emit typed registration calls.
- [ ] Regenerate `flutter_shadcn_kit/lib/registry/components/component_theme_global_configs.dart`.
- [ ] Run `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` so the docs mirror and docs snapshot are refreshed from the canonical registry sources.
- [ ] Verify the docs app still builds before opening the PR.
- [ ] Verify the consumer harness still builds and note any breaking API surface in changelog/release notes if discovered.

**Verification:**
- Run: `cd flutter_shadcn_kit && dart run tool/theme/component_theme_global_configs_generate.dart`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force`
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`
- Run: `cd docs && flutter analyze && flutter build web`
- Run: `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web`
- Expected: generated file is stable, docs build, and consumer harness remains compatible.

**Merge Gate:**
- No `T.toString()` lookup remains in global theme registration.
- Generator output is deterministic.
- Docs mirror and consumer harness are green.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 3: Wire Token Config Into Real Runtime Theme Values With a Button Pilot

**Priority:** P0  
**Category:** Theme Correctness  
**Branch:** `branch-p0-token-pipeline-pilot`

**Files:**
- Modify: `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart`
- Modify: `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_tokens.dart`
- Modify: `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_defaults.dart`
- Modify: `flutter_shadcn_kit/lib/registry/components/control/button/_impl/styles/component_theme_button_style.dart`
- Add: button theme resolution tests under the package test tree
- Generated outputs refreshed via sync:
  - `docs/assets/registry/components.json`
  - `docs/lib/ui/shadcn/**`

**Intent:**
- Prove the token pipeline works end-to-end with one component before rolling it across the full library.
- Lock in the chosen architecture now: token values are canonical, defaults are derived from tokens, and widget-level resolution must observe the tokenized theme.

**Steps:**
- [ ] Refactor the button theme pipeline so `button_theme_tokens.dart` is the only independent source of theme values.
- [ ] Replace `static const ...Theme? ... = null;` in `button_theme_config.dart` with real resolved theme instances or getters built directly from token constants.
- [ ] Convert `button_theme_defaults.dart` into a derived compatibility layer over token values, or remove it for button immediately if the surrounding tooling allows that without churn.
- [ ] Make `component_theme_button_style.dart` read the resolved global theme path in a way that changes behavior when token values change.
- [ ] Add a narrow test proving that a non-default tokenized value changes the resolved button theme used by the component.
- [ ] Run `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` and verify the docs app still builds.
- [ ] Validate the pilot in the docs app before merge to main. If the visual or behavioral diff extends beyond intended button theme behavior, stop and fix the branch before merge.
- [ ] Document the button pilot pattern in theme tooling docs so Task 4 has a single rollout contract.

**Verification:**
- Run: `cd flutter_shadcn_kit && flutter test`
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force`
- Run: `cd docs && flutter analyze && flutter build web`
- Expected: tests pass and the docs app renders the button pilot without regressions.

**Merge Gate:**
- Button theme globals are no longer always `null`.
- There is at least one test that would fail if the token chain became inert again.
- Docs build proves the pilot behaves in the integrated app.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 4: Replace Per-Component `resolve<T>()` If-Chains With Typed Maps Across All 68 Theme Config Files

**Priority:** P1  
**Category:** Theme Maintainability  
**Branch:** `branch-p1-theme-config-map-rollout`

**Files:**
- Modify: all 68 generated `flutter_shadcn_kit/lib/registry/components/**/_impl/themes/config/*_theme_config.dart`
- Create or modify: local codemod/generator support under `flutter_shadcn_kit/tool/theme/` or `flutter_shadcn_kit/tool/registry/`
- Generated outputs refreshed via sync if the codemod affects mirrored files

**Intent:**
- Remove open/closed violations in config resolution.
- Apply one consistent migration across the known 68-file scope rather than rediscovering the shape during implementation.

**Steps:**
- [ ] Treat all 68 `*_theme_config.dart` files as the fixed rollout scope for this branch.
- [ ] Introduce a scripted codemod or dedicated local generator/template update to replace `if (T == X)` chains with typed map lookup output. Do not hand-edit 68 files individually.
- [ ] Apply the codemod/generator to all 68 files in one pass.
- [ ] Keep the button pilot structure from Task 3 intact while migrating the shared resolve pattern.
- [ ] If mirrored outputs change, run `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` and verify the docs app still builds.
- [ ] Update changelog/release notes if the generated API surface changes in a consumer-visible way.

**Verification:**
- Run: `cd flutter_shadcn_kit && rg -n "if \\(T ==" lib/registry/components -g '*_theme_config.dart'`
- Expected: no remaining theme config `resolve<T>()` if-chains.
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd flutter_shadcn_kit && flutter test`
- Expected: rollout compiles and preserves button pilot behavior.

**Merge Gate:**
- All 68 theme config files use typed map resolution.
- The migration is scripted and repeatable rather than manual.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 5: Generate the Root Package Barrel

**Priority:** P1  
**Category:** Registry / Export Tooling  
**Branch:** `branch-p1-generated-root-barrel`

**Files:**
- Create: `flutter_shadcn_kit/tool/registry/registry_barrel_generate.dart`
- Modify: `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart`
- Modify: `flutter_shadcn_kit/tool/registry/registry_sync_all.dart`
- Modify: `flutter_shadcn_kit/tool/registry/registry_verify.dart`
- Modify: `flutter_shadcn_kit/tool/registry/README.md` or matching readme docs
- Generated outputs refreshed via sync:
  - `docs/assets/registry/components.json`
  - `docs/lib/ui/shadcn/**`

**Intent:**
- Remove the last manual registry touchpoint when adding a component.
- Make barrel freshness verifiable in CI.
- Keep this task explicitly in sync with Task 4’s generated theme-config rollout.

**Steps:**
- [ ] Rebase this branch after Task 4 merges.
- [ ] Re-run any Task 4 codemod/generation outputs after rebase so theme config artifacts are current before barrel generation begins.
- [ ] Implement `registry_barrel_generate.dart` to emit a deterministic root barrel from manifest-driven source data.
- [ ] Replace the hand-maintained `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart` with a generated file marker.
- [ ] Update `registry_sync_all.dart` so barrel generation is part of the standard sync flow.
- [ ] Extend `registry_verify.dart` to fail when the generated barrel is stale.
- [ ] Run `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` so the docs mirror is refreshed after the barrel contract changes.
- [ ] Verify the docs app still builds.
- [ ] Verify the consumer harness still builds and document any breaking changes in changelog/release notes.

**Verification:**
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_barrel_generate.dart`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd docs && flutter analyze && flutter build web`
- Run: `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web`
- Expected: root barrel generation is deterministic and does not break docs or consumers.

**Merge Gate:**
- Root barrel is generated.
- Adding a component no longer requires editing the root barrel by hand.
- Task 4 outputs and Task 5 outputs are verified together after rebase.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 6: Push Symbol Hiding Down to Component Barrels

**Priority:** P1  
**Category:** Registry / Export Hygiene  
**Branch:** `branch-p1-component-barrel-cleanup`

**Files:**
- Modify: component barrel files such as `flutter_shadcn_kit/lib/registry/components/**/<component>.dart`
- Modify: `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart` generator if export metadata needs hide support
- Update consumer harness if public import paths or names change

**Intent:**
- Stop leaking internal helper types into the root package surface.
- Reduce top-level `hide` complexity and collision risk without breaking copy-paste consumers silently.

**Steps:**
- [ ] Inventory all current `hide` clauses in `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart`.
- [ ] Move symbol filtering into the owning component barrel where practical.
- [ ] Where collisions are caused by poorly named public types, rename or internalize those types instead of endlessly hiding them.
- [ ] Re-generate the root barrel once component barrels become self-contained.
- [ ] Update the consumer harness if copied imports or symbol names need adjustment.
- [ ] Document all consumer-visible renames or export changes in changelog/release notes before merge.

**Verification:**
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd flutter_shadcn_kit && rg -n " hide " lib/flutter_shadcn_kit.dart`
- Run: `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web`
- Expected: root barrel has no or near-zero hide clauses and consumer harness still builds.

**Merge Gate:**
- Root barrel no longer carries broad cross-component internal leakage.
- Consumer compatibility has been checked with a copied-components harness.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 7: Add Tier and Version Governance

**Priority:** P2  
**Category:** Metadata Governance  
**Branch:** `branch-p2-tier-and-version-governance`

**Files:**
- Modify: `flutter_shadcn_kit/lib/registry/manifests/components.json`
- Modify: manifest schema file if present alongside `components.json`
- Modify: `flutter_shadcn_kit/lib/registry/components/**/meta.json`
- Modify: `flutter_shadcn_kit/tool/registry/registry_meta_update.dart`
- Modify: `flutter_shadcn_kit/tool/common/registry_component_metadata.dart`
- Create: `flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart`
- Modify: `flutter_shadcn_kit/scripts/new_component.dart`

**Intent:**
- Separate primitives, components, and patterns explicitly.
- Stop treating every component as perpetual `1.0.0` with no lifecycle signals.
- Make the 133-file tier backfill tractable with tooling instead of manual one-by-one editing.

**Steps:**
- [ ] Extend the metadata schema with a `tier` field and allowed values `primitive`, `component`, and `pattern`.
- [ ] Create `tool/registry/registry_tier_backfill.dart` to pre-populate `tier` across existing `meta.json` files.
- [ ] Default the backfill script to `component` for all current entries, then apply an explicit override map for known primitives and patterns.
- [ ] Seed the override map with the obvious edge cases first, including `clickable`, `control`, `form_field`, `basic`, `overlay`, `wrapper`, `app`, `scaffold`, and `filter_bar`, then do one human review pass to correct any remaining misclassifications.
- [ ] Update `registry_meta_update.dart` and `scripts/new_component.dart` so new components receive `tier` metadata automatically.
- [ ] Define the minimum viable versioning/deprecation policy and document where breaking changes must be recorded.

**Verification:**
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_tier_backfill.dart`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_meta_update.dart`
- Run: `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Expected: schema, metadata, and scaffolding are aligned.

**Merge Gate:**
- Metadata schema supports tiering.
- Tier backfill is scripted and human-reviewed.
- Versioning policy is documented well enough to drive future API changes.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 8: Introduce Explicit Per-Component Theme Registration With a Compatibility Bootstrap

**Priority:** P3  
**Category:** Runtime Scalability  
**Branch:** `branch-p3-explicit-theme-registration`

**Files:**
- Modify: `flutter_shadcn_kit/lib/registry/components/component_theme_global_configs.dart`
- Modify: component barrels or component theme config files that expose registration helpers
- Modify: any supporting generator/codemod added in earlier tasks
- Add tests for idempotent registration behavior

**Intent:**
- Remove the eager all-components startup registration path as the only supported mode.
- Replace the vague lazy-registration idea with an explicit, testable registration API.

**Steps:**
- [ ] Introduce explicit per-component registration helpers such as `registerButtonThemeGlobals()`.
- [ ] Keep `registerComponentThemeGlobalConfigs()` as a compatibility bootstrap function that simply calls all per-component registrars.
- [ ] Ensure registration remains idempotent so repeated setup calls are safe.
- [ ] Migrate the explicit pilot set first: `button`, `text_field`, and `dialog`, then expand once the explicit pattern is stable.
- [ ] Update docs and examples so consumers know they can register only the components they use or call the compatibility bootstrap for full preload.

**Verification:**
- Run: `cd flutter_shadcn_kit && flutter test`
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Expected: explicit registrars and compatibility bootstrap both work and are covered by tests.

**Merge Gate:**
- Import-time side effects are not used.
- Full eager registration is no longer the only viable path.
- Compatibility story for existing consumers is documented.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

### Task 9: Make Font and Icon Assets Opt-In Shared Groups

**Priority:** P3  
**Category:** Asset Scalability  
**Branch:** `branch-p3-opt-in-font-assets`

**Files:**
- Modify: `flutter_shadcn_kit/pubspec.yaml`
- Modify: `flutter_shadcn_kit/lib/registry/manifests/components.json`
- Modify: shared asset metadata and CLI install logic where asset groups are resolved
- Update: docs explaining asset installation behavior

**Intent:**
- Reduce consumer bundle cost, especially for apps using a small subset of components.
- Align shared asset installation with the existing shared-group model used for source files.

**Steps:**
- [ ] Inventory current bundled fonts and icon assets in `flutter_shadcn_kit/pubspec.yaml`.
- [ ] Model icon/font asset groups explicitly in manifest/shared metadata.
- [ ] Update CLI install logic so components pull only the asset groups they actually need.
- [ ] Add verification around generated consumer `pubspec.yaml` changes if the CLI mutates assets automatically.
- [ ] Document any installation contract changes for consumers.

**Verification:**
- Run: `cd flutter_shadcn_kit && flutter analyze`
- Run: `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web`
- Run: install a small sample app with a limited component set and verify only required assets are added.
- Compare sample build asset lists before and after.

**Merge Gate:**
- Assets are no longer always-all-in.
- CLI install path remains deterministic for consumers.
- Consumer harness still builds with the new asset-install contract.

**Rollback:**
- If post-merge verification fails: revert the merge, file an issue, and recreate the branch from updated `main`.

## Recommended First Three Branches

1. `branch-p0-registry-verify-gate`
   Reason: adds the CI guardrail and the consumer harness before structural changes begin.
2. `branch-p0-type-safe-theme-registry`
   Reason: small, high-signal correctness fix with clear docs/consumer verification.
3. `branch-p0-token-pipeline-pilot`
   Reason: validates the core theme architecture before library-wide rollout.

## Risks and Constraints

- The docs app still depends on a generated mirror under `docs/lib/ui/shadcn`, so every generated-file task must run the sync/build loop explicitly before merge.
- The per-component theme config files are marked generated, but no dedicated in-repo generator is currently discoverable. Task 4 must therefore introduce a repeatable codemod or local generator instead of manual edits.
- Tier classification is partly judgment-based. The backfill script should do the bulk work, but a review pass is still required for edge cases.
- Consumer compatibility is a first-class requirement for Tasks 2, 5, and 6 because this package is consumed through file copy rather than only package imports.

## Out of Scope

- Widgetbook migration and broader docs/DX redesign.
- A full de-vendoring rewrite of the docs app architecture.
- Any large API redesign unrelated to registry, theming, metadata, or install structure.

## Definition of Done

- Registry freshness is enforced in CI.
- A reusable consumer compatibility harness exists and stays green through structural tasks.
- Global theme registration is keyed by `Type`, not string names.
- The token pipeline demonstrably changes runtime component output for the button pilot and establishes the canonical rollout pattern.
- Root barrel maintenance is generated rather than manual.
- Metadata distinguishes primitives, components, and patterns.
- Runtime scalability follow-ups use explicit registration and opt-in assets rather than brittle side effects.
- Docs/DX follow-up work is deferred to a separate plan after stabilization completes.

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-05-04-registry-scalability-remediation.md`.

Two execution options:

1. Subagent-Driven (recommended) - implement one branch/task at a time with review between branches.
2. Inline Execution - execute the branches in this session, starting with the first selected task.
