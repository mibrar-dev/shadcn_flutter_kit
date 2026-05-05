# Checkpoint: branch-p2-tier-and-version-governance
Last updated: 2026-05-05 04:56
Status: IN_PROGRESS

## Completed Steps
(none yet)

## Current Step
Extend the metadata schema with a `tier` field and allowed values `primitive`, `component`, and `pattern`.

## Blocked On
Nothing

## Remaining Steps
- [ ] Extend the metadata schema with a `tier` field and allowed values `primitive`, `component`, and `pattern`.
- [ ] Create `tool/registry/registry_tier_backfill.dart` to pre-populate `tier` across existing `meta.json` files.
- [ ] Default the backfill script to `component` for all current entries, then apply an explicit override map for known primitives and patterns.
- [ ] Seed the override map with the obvious edge cases first, including `clickable`, `control`, `form_field`, `basic`, `overlay`, `wrapper`, `app`, `scaffold`, and `filter_bar`, then do one human review pass to correct any remaining misclassifications.
- [ ] Update `registry_meta_update.dart` and `scripts/new_component.dart` so new components receive `tier` metadata automatically.
- [ ] Define the minimum viable versioning/deprecation policy and document where breaking changes must be recorded.

## Verification Results
(none yet)

## Files Modified
- `docs/superpowers/checkpoints/MASTER_STATUS.md`
- `docs/superpowers/checkpoints/branch-p2-tier-and-version-governance.md`

## Decisions Made
(none yet)
