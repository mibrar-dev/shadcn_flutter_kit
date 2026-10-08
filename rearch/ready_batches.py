#!/usr/bin/env python3
"""Usage: rearch/ready_batches.py <running ids...> — prints batches whose component deps are all accepted."""
import json, os, subprocess, sys
root = os.path.dirname(os.path.abspath(__file__))
d = json.load(open(os.path.join(root, 'reports/p4_batches.json')))
running = set(sys.argv[1:])
prims = {'text', 'basic', 'hidden', 'hover', 'popover', 'fade_scroll', 'debug', 'flex'}
alias = {'linear_progress_indicator': 'progress', 'circular_progress_indicator': 'spinner', 'text_field': 'input'}
comp_dir = os.path.join(root, '../flutter_shadcn_kit/lib/registry_next/components')
tracked = subprocess.run(['git', '-C', root, 'ls-files', comp_dir], capture_output=True, text=True).stdout
committed = {p.split('components/')[1].split('/')[0] for p in tracked.split() if 'components/' in p}
for b in d['batches']:
    names = {c['name'] for c in b['components']}
    if b['id'] in running or names & committed == names - {'flex', 'fade_scroll', 'debug'} and names & committed:
        continue
    need = set()
    for c in b['components']:
        for dep in c.get('component_deps') or []:
            dep = alias.get(dep, dep)
            if dep in prims or dep in names: continue
            if dep not in committed: need.add(dep)
    print(b['id'], 'READY' if not need else 'needs ' + ','.join(sorted(need)))
