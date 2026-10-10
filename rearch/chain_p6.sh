#!/usr/bin/env bash
# Queue: launches each P6 follow-up agent once the orchestrator has QA'd + committed its dependencies
# (marker rearch/logs/.ok-<ID>, created after the QA commit).
cd "$(dirname "$0")/.."
ok() { [ -f "rearch/logs/.ok-$1" ]; }
launch() { [ -f "rearch/logs/$3.log" ] && return; printf "%s\n" "$3" >> rearch/logs/.watch; nohup rearch/run_agent.sh "$1" "$2" "$3" >/dev/null 2>&1 & }
while true; do
  ok P6-F3 && launch "opencode-go/step-5-preview-free#high" rearch/briefs/fixes/P6-B1-blocks-categories-registry.md P6-B1
  ok P6-T1 && launch "opencode-go/muse-spark-1.3-contributor#xhigh" rearch/briefs/fixes/P6-H1-home.md P6-H1
  ok P6-F3 && ok P6-T2 && launch "opencode-go/muse-spark-1.3-contributor#xhigh" rearch/briefs/fixes/P6-F4-component-pages.md P6-F4
  ok P6-B1 && launch "opencode-go/step-5-preview-free#high" rearch/briefs/fixes/P6-B2-cli-blocks.md P6-B2
  ok P6-B1 && ok P6-T2 && launch "opencode-go/step-5-preview-free#high" rearch/briefs/fixes/P6-B3-docs-blocks-pages.md P6-B3
  n=0; for i in B1 B2 B3 H1 F4; do [ -f rearch/logs/P6-$i.log ] && n=$((n+1)); done; [ $n -eq 5 ] && exit 0
  sleep 60
done
