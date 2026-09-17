#!/bin/bash
# Claude Code on the web: make the docs check runnable in a fresh session. No-op locally.
set -euo pipefail
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi
cd "$CLAUDE_PROJECT_DIR"
bash scripts/bootstrap.sh --ci
