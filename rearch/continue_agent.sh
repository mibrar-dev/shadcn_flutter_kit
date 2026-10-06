#!/usr/bin/env bash
# Usage: rearch/continue_agent.sh <session-id> <model#variant> <prompt-file> <log-name>
set -u
KIT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$KIT"
opencode run --standalone --auto -s "$1" -m "$2" "$(cat "$3")" > "rearch/logs/$4.log" 2>&1
echo "exit=$?" >> "rearch/logs/$4.log"
