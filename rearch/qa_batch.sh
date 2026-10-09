#!/usr/bin/env bash
# Usage: rearch/qa_batch.sh <component|primitives/path> ...
# QA gates scoped to a batch's own folders (other batches may be in flight). Compact output.
set -u
KIT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$KIT/flutter_shadcn_kit"
C=lib/registry_next/components
L=""; T=""; NAMES=""
for x in "$@"; do
  if [[ "$x" == primitives/* ]]; then p="lib/registry_next/$x"; else p="$C/$x"; NAMES="$NAMES $x"; fi
  if [ ! -e "$p" ]; then echo "MISSING: $p"; continue; fi
  L="$L $p"
  base=$(basename "${x%.dart}")
  for t in test/registry_next/components/${base}_test.dart test/registry_next/primitives/${base}_test.dart; do
    [ -f "$t" ] && T="$T $t"
  done
done
for n in $NAMES; do
  [ -d "$C/$n" ] || continue
  extra=$(ls "$C/$n" | grep -vxE "$n.dart|${n}_style.dart|${n}_theme.dart|preview.dart|meta.json|README.md" | tr '\n' ' ')
  max=$(wc -l "$C/$n"/*.dart | grep -v total | sort -n | tail -1 | awk '{print $1}')
  dup=$(python3 -c "import json;d=json.load(open('$C/$n/meta.json'));print('DUP-dependencies' if 'dependencies' in d else '', d.get('deps',{}).get('components'))" 2>&1)
  echo "layout $n: max=$max ${extra:+EXTRA=[$extra]} $dup"
done
echo "tests found: $(echo $T | wc -w)"
echo "format:  $(dart format --output=none --set-exit-if-changed $L $T 2>&1 | tail -1)"
for p in $L $T; do r=$(dart analyze "$p" 2>&1 | tail -1); [ "$r" = "No issues found!" ] || echo "analyze $p: $r"; done
[ -n "$T" ] && echo "test:    $(flutter test $T 2>&1 | tail -1 | sed 's/.*\(+[0-9]*.*\)/\1/' | cut -c1-100)"
echo "banned:  $(grep -rlnE "// ignore|^import 'package:flutter/(material|cupertino).dart'|^part |^import 'package:(data_widget|gap)/" $L --include=*.dart 2>/dev/null | tr '\n' ' ')"
J=$(mktemp)
dart run tool/rearch/check_layers.dart --root lib/registry_next --json "$J" >/dev/null 2>&1
python3 - "$J" "$@" <<'EOF'
import json, sys
d = json.load(open(sys.argv[1])); keys = sys.argv[2:]
hits = [f for f in d['findings'] if any(('components/' + k + '/') in f['file'] or k in f['file'] for k in keys)]
print('layers:  ' + ('clean' if not hits else ''))
for f in hits: print('  ', f['rule'], f['file'], f['message'][:90])
EOF
rm -f "$J"
echo "owner:   $(dart run tool/rearch/check_single_owner.dart --root lib/registry_next 2>&1 | tail -1)"
echo "theme:   $(dart run tool/rearch/check_user_theme.dart --root lib/registry_next --strict 2>&1 | tail -1)"
