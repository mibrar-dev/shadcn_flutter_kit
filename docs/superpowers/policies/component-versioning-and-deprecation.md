# Component Versioning And Deprecation Policy

Date: 2026-05-05

## Purpose

This policy defines the minimum versioning and deprecation rules for component
metadata in `flutter_shadcn_kit` and states where breaking changes must be
recorded.

## Scope

This applies to:

- component `meta.json`
- manifest entries in `flutter_shadcn_kit/lib/registry/manifests/components.json`
- new component scaffolding
- future component API changes that affect copy-paste consumers

## Version Rules

- Every component must carry a `version` string in its metadata.
- New components start at `1.0.0`.
- Non-breaking additions or internal fixes increment the patch version.
- Backward-compatible API additions increment the minor version.
- Breaking API changes increment the major version.

## What Counts As Breaking

The following are breaking for consumers unless explicitly documented otherwise:

- removing or renaming exported classes, typedefs, functions, enums, or themes
- changing constructor parameters in a non-backward-compatible way
- changing generated install structure or required shared dependencies
- changing public type signatures in a way that breaks existing copied code
- removing previously documented exported helpers, even if they were accidental

## Deprecation Rules

- Prefer deprecation before removal when a public symbol is intentionally
  supported.
- Use Dart `@Deprecated(...)` annotations where practical on still-exported API.
- Record the deprecation reason and planned removal version in docs or release
  notes when annotation alone is not enough.
- Accidental leakage that was never intended as supported API may be removed
  directly, but the removal must still be documented as a consumer-visible
  change.

## Required Recording Surfaces

Breaking changes must be recorded in both places below:

1. The affected component metadata/manifests by updating `version`.
2. A branch-scoped or release-scoped note under `docs/superpowers/release-notes/`.

If a future repo-wide changelog is introduced, it should become the primary
human-readable release surface, but until then `docs/superpowers/release-notes/`
is the required record for consumer-visible changes.

## Enforcement Expectations

- `scripts/new_component.dart` must scaffold `version` and `tier`.
- registry tooling must preserve existing `version` and `tier` unless explicitly
  changed.
- PRs that introduce breaking changes should include a matching release-note
  entry before merge.
