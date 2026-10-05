#!/usr/bin/env bash
# Usage: rearch/run_agent.sh <model#variant> <brief-file> <log-name>
set -u
KIT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$KIT"
PROMPT="$(cat rearch/briefs/_common.md; echo; echo '---'; echo; cat "$2")"
opencode run --auto --title "rearch:$3" -m "$1" "$PROMPT" > "rearch/logs/$3.log" 2>&1
echo "exit=$?" >> "rearch/logs/$3.log"
