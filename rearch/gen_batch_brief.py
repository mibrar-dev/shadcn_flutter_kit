#!/usr/bin/env python3
"""Usage: rearch/gen_batch_brief.py <id> [<id> ...] — writes rearch/briefs/P4-<id>.md from p4_batches.json."""
import json
import pathlib
import sys

root = pathlib.Path(__file__).resolve().parent
data = json.loads((root / "reports/p4_batches.json").read_text())
ids = sys.argv[1:]
pool = {b.get("id"): b for b in data.get("batches", []) + data.get("prims", [])}
missing = [i for i in ids if i not in pool]
if missing:
    sys.exit(f"unknown ids: {missing}")
item = pool[ids[0]] if len(ids) == 1 else [pool[i] for i in ids]
want = ids[0] if len(ids) == 1 else "+".join(i.replace("P4-", "") for i in ids)
brief_id = want if want.startswith("P4") else f"P4-{want}"
text = (root / "briefs/P4-batch-template.md").read_text()
text = text.replace("{ID}", brief_id).replace("{BATCH_JSON}", json.dumps(item, indent=2))
out = root / f"briefs/{brief_id}.md"
out.write_text(text)
print(out)
