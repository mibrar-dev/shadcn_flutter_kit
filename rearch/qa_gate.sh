#!/usr/bin/env bash
# Usage: rearch/qa_gate.sh [path ...]   — runs every registry_next gate, prints a compact summary.
# Optional paths limit the banned-pattern grep (defaults to lib/registry_next).
set -u
KIT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$KIT/flutter_shadcn_kit"
P=("${@:-lib/registry_next}")
echo "format:  $(dart format --set-exit-if-changed lib/registry_next test/registry_next 2>&1 | tail -1)"
echo "analyze: $(dart analyze lib/registry_next 2>&1 | tail -1) | tests: $(dart analyze test/registry_next 2>&1 | tail -1)"
echo "test:    $(flutter test test/registry_next 2>&1 | tail -1 | sed 's/.*\(+[0-9]*.*\)/\1/' | cut -c1-120)"
echo "rearch:  $(flutter test test/rearch 2>&1 | tail -1 | sed 's/.*\(+[0-9]*.*\)/\1/' | cut -c1-80)"
echo "layers:  $(dart run tool/rearch/check_layers.dart --root lib/registry_next 2>&1 | grep -v ': 0 (' | tail -n +2 | tr '\n' ' ')"
echo "owner:   $(dart run tool/rearch/check_single_owner.dart --root lib/registry_next 2>&1 | tail -1)"
echo "theme:   $(dart run tool/rearch/check_user_theme.dart --root lib/registry_next --strict 2>&1 | tail -1)"
echo "banned:  $(grep -rlnE "// ignore|^import 'package:flutter/(material|cupertino).dart'|^part |^import 'package:(data_widget|gap)/" "${P[@]}" --include=*.dart 2>/dev/null | tr '\n' ' ')"
echo "stray:   $(git -C "$KIT" status --short | grep -v 'flutter_shadcn_kit/lib/registry_next\|flutter_shadcn_kit/test/registry_next\|rearch/' | tr '\n' ' ')"
