#!/usr/bin/env bash
# Checks the toolchain against .tool-versions, installs git hooks and docs-check deps.
# Usage: scripts/bootstrap.sh [--ci]
#   --ci  skip Docker and Unity checks (CI runners and Claude Code web sessions)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

CI_MODE=0
[[ "${1:-}" == "--ci" ]] && CI_MODE=1

installed_version() {
  case "$1" in
    dotnet)  command -v dotnet >/dev/null && dotnet --version 2>/dev/null || true ;;
    node)    command -v node >/dev/null && node --version 2>/dev/null | sed 's/^v//' || true ;;
    docker)  command -v docker >/dev/null && docker version --format '{{.Server.Version}}' 2>/dev/null || true ;;
    git-lfs) command -v git-lfs >/dev/null && git lfs version 2>/dev/null | sed -E 's#^git-lfs/([0-9.]+).*#\1#' || true ;;
    jq)      command -v jq >/dev/null && jq --version 2>/dev/null | sed 's/^jq-//' || true ;;
    unity)   unity_version ;;
    *)       echo "" ;;
  esac
}

# Unity is checked, never installed. Looks at UNITY_EDITOR_PATH, then Unity Hub's default folders.
unity_version() {
  if [[ -n "${UNITY_EDITOR_PATH:-}" ]]; then
    basename "$(dirname "$UNITY_EDITOR_PATH")"; return
  fi
  local d
  for d in "/Applications/Unity/Hub/Editor" "$HOME/Unity/Hub/Editor" "/mnt/c/Program Files/Unity/Hub/Editor"; do
    if [[ -d "$d" ]]; then
      ls "$d" 2>/dev/null | grep -E '^6000' | sort -V | tail -n1; return
    fi
  done
  echo ""
}

status=0
printf '%-8s %-10s %-14s %s\n' TOOL REQUIRED FOUND RESULT
while read -r tool required; do
  [[ -z "$tool" || "$tool" == \#* ]] && continue
  if (( CI_MODE )) && [[ "$tool" == "docker" || "$tool" == "unity" ]]; then
    printf '%-8s %-10s %-14s %s\n' "$tool" "$required" "-" "skipped (--ci)"; continue
  fi
  found="$(installed_version "$tool")"
  if [[ -z "$found" ]]; then
    printf '%-8s %-10s %-14s %s\n' "$tool" "$required" "missing" "FAIL"; status=1
  elif [[ "$found" == "$required"* ]]; then
    printf '%-8s %-10s %-14s %s\n' "$tool" "$required" "$found" "ok"
  else
    printf '%-8s %-10s %-14s %s\n' "$tool" "$required" "$found" "FAIL (version)"; status=1
  fi
done < .tool-versions

if (( status != 0 )); then
  echo
  echo "bootstrap: toolchain incomplete. Install the tools marked FAIL (see README.md) and re-run." >&2
  exit "$status"
fi

git lfs install --local >/dev/null
git config core.hooksPath scripts/hooks
echo "bootstrap: git hooks -> scripts/hooks, git-lfs enabled"

if [[ ! -d tools/docs-check/node_modules ]]; then
  echo "bootstrap: installing docs-check dependencies"
  npm install --prefix tools/docs-check --no-audit --no-fund --silent
fi
echo "bootstrap: ok"
