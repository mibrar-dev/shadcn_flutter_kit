#!/usr/bin/env bash
# Phase 4 cutover: `lib/registry_next/` replaces `lib/registry/`.
#
# Usage (run from the kit repo root):
#   ./rearch/cutover.sh [--dry-run|--apply]   (default: --dry-run)
#
# --dry-run prints every step without changing anything.
# --apply performs the cutover. It refuses to run when `git status` is not
# clean or when any blocker component is still missing from registry_next.
# See rearch/reports/P4_CUTOVER.md for the full plan and inventory.
set -euo pipefail

MODE="${1:---dry-run}"
if [[ "$MODE" != "--dry-run" && "$MODE" != "--apply" ]]; then
  echo "usage: $0 [--dry-run|--apply]" >&2; exit 2
fi

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$KIT/flutter_shadcn_kit"
REG="$APP/lib/registry"
NEXT="$APP/lib/registry_next"
OLD_BAK="$APP/lib/registry_old"

# Executed 2026-10-09 (P4-Z). The cutover is a one-shot; refuse to run again
# so a future invocation cannot half-move the already-flat tree.
if [[ ! -d "$NEXT" ]]; then
  echo "cutover already executed: lib/registry_next is gone. Nothing to do." >&2
  echo "See rearch/reports/P4_CUTOVER_RESULT.md." >&2
  exit 1
fi

# Blockers: new components with no finished home in registry_next yet
# (B24: color_picker, phone_input, filter_bar; B25: color_input, text_animate).
BLOCKERS=(color_picker phone_input filter_bar color_input text_animate)

do_it() {
  if [[ "$MODE" == "--apply" ]]; then
    echo "+ $*"
    "$@"
  else
    echo "[dry-run] $*"
  fi
}

missing=()
for name in "${BLOCKERS[@]}"; do
  [[ -d "$NEXT/components/$name" ]] || missing+=("$name")
done

echo "=== P4 cutover $MODE ==="
echo "kit: $KIT"
if ((${#missing[@]} > 0)); then
  echo "BLOCKERS (${#missing[@]}): ${missing[*]} — not yet in lib/registry_next/components/"
else
  echo "blockers: none — all B24/B25 components present"
fi

if [[ "$MODE" == "--apply" ]]; then
  if ((${#missing[@]} > 0)); then
    echo "REFUSING --apply: blockers exist. Land B24/B25 first." >&2; exit 1
  fi
  if [[ -n "$(git -C "$KIT" status --porcelain)" ]]; then
    echo "REFUSING --apply: git status is not clean. Commit or stash first." >&2; exit 1
  fi
  branch="$(git -C "$KIT" branch --show-current)"
  if [[ "$branch" != "refactor/rearchitecture" ]]; then
    echo "REFUSING --apply: expected branch refactor/rearchitecture, on '$branch'." >&2; exit 1
  fi
fi

echo "--- step 1: rename trees (single commit) ---"
do_it git -C "$KIT" mv flutter_shadcn_kit/lib/registry flutter_shadcn_kit/lib/registry_old
do_it git -C "$KIT" mv flutter_shadcn_kit/lib/registry_next flutter_shadcn_kit/lib/registry
echo "--- step 2: delete old tree (same commit) ---"
do_it git -C "$KIT" rm -r -q flutter_shadcn_kit/lib/registry_old

echo "--- step 3: rewrite registry_next/ imports to registry/ ---"
if [[ "$MODE" == "--apply" ]]; then
  grep -rl "registry_next/" "$APP/lib" "$APP/test" "$APP/tool" "$KIT/docs/lib" \
    --include="*.dart" --include="*.md" --include="*.json" \
    | xargs sed -i '' "s#registry_next/#registry/#g"
  echo "+ registry_next/ -> registry/ rewritten"
else
  n="$(grep -rl "registry_next/" "$APP/lib" "$APP/test" "$APP/tool" "$KIT/docs/lib" \
    --include="*.dart" --include="*.md" --include="*.json" | wc -l)"
  echo "[dry-run] rewrite registry_next/ -> registry/ in $n files (sed)"
fi

echo "--- step 4: manual rewrites (old category paths no longer exist) ---"
echo "These files import old paths (registry/components/<category>/<name>/,"
echo "registry/shared/, registry/themes_preset/) and must be rewritten to the"
echo "flat layout (registry/components/<name>/, registry/foundation|theme|primitives/):"
grep -rln "package:flutter_shadcn_kit/registry/" "$APP/lib/flutter_shadcn_kit.dart" "$APP/lib/main.dart" 2>/dev/null || true
grep -rln "^export 'registry/\|^import 'registry/" "$APP/lib/flutter_shadcn_kit.dart" 2>/dev/null || true
grep -rln "\.\./registry/components/\|\.\./\.\./registry/components/" "$APP/lib/examples" 2>/dev/null || true
echo "(full list: grep -rn 'registry/components/<category>/' lib tool test docs — see P4_CUTOVER.md §7)"
echo "Regenerate the barrel after the rewrite:"
echo "  [dry-run] dart run tool/registry/registry_barrel_generate.dart   # Phase 5: must read flat layout"

echo "--- step 5: regenerate manifests ---"
do_it dart run tool/registry/registry_components_manifest.dart
do_it dart run tool/registry/registry_index_generate.dart
do_it dart run tool/theme/theme_index_generate.dart

echo "--- step 6: retire old tests ---"
do_it git -C "$KIT" rm -r -q flutter_shadcn_kit/test/registry/components
do_it git -C "$KIT" rm -q flutter_shadcn_kit/test/registry/consumer_fixture_font_pubspec_alignment_test.dart flutter_shadcn_kit/test/registry/shared_font_manifest_test.dart

echo "--- step 7: post-cutover gates ---"
do_it flutter analyze
do_it flutter test
do_it dart run tool/rearch/check_layers.dart --strict
do_it dart run tool/rearch/check_single_owner.dart --strict
do_it dart run tool/rearch/check_user_theme.dart --strict

echo "=== done ($MODE) ==="
if [[ "$MODE" == "--dry-run" ]]; then
  echo "No changes made. Re-run with --apply (after blockers land) to execute."
fi
