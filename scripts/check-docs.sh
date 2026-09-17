#!/usr/bin/env bash
# Link, anchor and mermaid checks over docs/**/*.md and root *.md.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
if [[ ! -d tools/docs-check/node_modules ]]; then
  npm install --prefix tools/docs-check --no-audit --no-fund --silent
fi
node tools/docs-check/check-links.mjs
node tools/docs-check/check-mermaid.mjs
