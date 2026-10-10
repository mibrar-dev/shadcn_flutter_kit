#!/usr/bin/env bash
# Queue: launches each P6 follow-up agent once the agents it depends on have exited.
cd "$(dirname "$0")/.."
running() { ps -eo args | grep -E "(run|continue)_agent.sh .* $1\$" | grep -vq grep; }
started() { [ -f "rearch/logs/$1.log" ]; }
launch() { started "$3" && return; printf "%s\n" "$3" >> rearch/logs/.watch; nohup rearch/run_agent.sh "$1" "$2" "$3" >/dev/null 2>&1 & }
while true; do
  running P6-F3 || launch "opencode-go/step-5-preview-free#high" rearch/briefs/fixes/P6-B1-blocks-categories-registry.md P6-B1
  running P6-T1 || launch "opencode-go/muse-spark-1.3-contributor#xhigh" rearch/briefs/fixes/P6-H1-home.md P6-H1
  { running P6-F3 || running P6-T2; } || launch "opencode/step-5-preview-free#high" rearch/briefs/fixes/P6-F4-component-pages.md P6-F4
  { started P6-B1 && ! running P6-B1; } && launch "opencode/step-5-preview-free#high" rearch/briefs/fixes/P6-B2-cli-blocks.md P6-B2
  { started P6-B1 && ! running P6-B1 && ! running P6-T2; } && launch "opencode-go/step-5-preview-free#high" rearch/briefs/fixes/P6-B3-docs-blocks-pages.md P6-B3
  started P6-B3 && started P6-B2 && started P6-H1 && started P6-F4 && exit 0
  sleep 60
done
