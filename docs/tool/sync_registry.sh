#!/usr/bin/env bash
# sync_registry.sh — mirror the canonical registry Dart sources into the docs app.
#
# docs/lib/ui/shadcn/{foundation,theme,primitives,components/<id>} is the exact
# layout the new CLI installs (`flutter_shadcn init` + `add --all`). Until the
# new CLI lands, this script produces the identical tree from the post-cutover
# registry so the docs app consumes components the way a user would.
#
# Usage:
#   docs/tool/sync_registry.sh           # mirror (idempotent)
#   docs/tool/sync_registry.sh --check   # dry run; exit 1 when out of date
#
# Environment:
#   REGISTRY  registry root (default: <kit>/flutter_shadcn_kit/lib/registry)
#
# Only `.dart` files are copied: the manifest `fileHashes` list is Dart-only
# (README.md / meta.json stay in the registry), and the mirror must not contain
# extra `.dart` files. `preview.dart` files ARE included — the component-page
# live previews load them through the deferred-import registry, and the
# manifest hashes cover them.
#
# `theme/app_theme.dart` is excluded from deletion: the CLI generates that file
# per project (from the chosen preset) and a re-sync must never clobber it.

set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="${REGISTRY:-$KIT/flutter_shadcn_kit/lib/registry}"
DEST="$KIT/docs/lib/ui/shadcn"
MODE="mirror"
if [[ "${1:-}" == "--check" ]]; then
  MODE="check"
elif [[ -n "${1:-}" ]]; then
  echo "usage: $0 [--check]" >&2
  exit 2
fi

if [[ ! -f "$SRC/manifests/registry.json" ]]; then
  echo "registry manifest not found under: $SRC" >&2
  echo "set REGISTRY to the post-cutover registry root." >&2
  exit 2
fi

echo "registry: $SRC"
echo "mirror:   $DEST ($MODE)"

# --include='*/' + --include='*.dart' + --exclude='*' restricts the copy to
# Dart files at any depth; --delete keeps the mirror exact; app_theme.dart is
# the one CLI-generated file under this tree, so it is protected from deletion.
FLAGS=(-a --delete -i --include='*/' --include='*.dart' --exclude='*'
  --exclude='app_theme.dart')

status=0
for dir in foundation theme primitives components; do
  if [[ "$MODE" == "check" ]]; then
    diff_output="$(rsync "${FLAGS[@]}" --dry-run "$SRC/$dir/" "$DEST/$dir/")"
    if [[ -n "$diff_output" ]]; then
      echo "out of date: $dir" >&2
      echo "$diff_output" >&2
      status=1
    fi
  else
    rsync "${FLAGS[@]}" "$SRC/$dir/" "$DEST/$dir/"
  fi
done

if [[ "$MODE" == "check" ]]; then
  if [[ "$status" -eq 0 ]]; then
    echo "mirror is up to date."
  fi
  exit "$status"
fi

count="$(find "$DEST" -name '*.dart' -type f | wc -l | tr -d ' ')"
echo "mirrored $count Dart files"
