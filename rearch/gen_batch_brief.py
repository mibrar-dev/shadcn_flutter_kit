#!/usr/bin/env python3
"""Usage: rearch/gen_batch_brief.py <batch-or-prim-id> — writes rearch/briefs/P4-<id>.md from p4_batches.json."""
import json
import pathlib
import sys

root = pathlib.Path(__file__).resolve().parent
data = json.loads((root / "reports/p4_batches.json").read_text())
want = sys.argv[1]
item = next((b for b in data.get("batches", []) + data.get("prims", []) if b.get("id") == want), None)
if item is None:
    sys.exit(f"no batch/prim with id {want!r}")
brief_id = want if want.startswith("P4") else f"P4-{want}"
text = (root / "briefs/P4-batch-template.md").read_text()
text = text.replace("{ID}", brief_id).replace("{BATCH_JSON}", json.dumps(item, indent=2))
out = root / f"briefs/{brief_id}.md"
out.write_text(text)
print(out)
