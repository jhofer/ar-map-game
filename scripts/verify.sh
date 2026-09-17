#!/usr/bin/env bash
# The one verification entry point: format -> build -> test -> docs. CI calls this verbatim (F02).
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

declare -a names results
run_step() {
  local name="$1"; shift
  echo "== $name"
  if "$@"; then results+=("ok"); else results+=("FAIL"); fi
  names+=("$name")
}
skip_step() { names+=("$1"); results+=("skipped: $2"); echo "== $1 (skipped: $2)"; }

has_solution() { compgen -G "*.slnx" >/dev/null || compgen -G "*.sln" >/dev/null; }

if has_solution; then
  run_step format dotnet format --verify-no-changes
  run_step build  dotnet build -warnaserror --nologo
  run_step test   dotnet test --no-build --nologo
else
  skip_step format "no solution yet (F02)"
  skip_step build  "no solution yet (F02)"
  skip_step test   "no solution yet (F02)"
fi

run_step docs scripts/check-docs.sh

if command -v shellcheck >/dev/null; then
  run_step shellcheck shellcheck scripts/*.sh scripts/hooks/* .claude/hooks/*.sh deploy/minio/init.sh
else
  skip_step shellcheck "shellcheck not installed"
fi

echo
printf '%-12s %s\n' STEP RESULT
status=0
for i in "${!names[@]}"; do
  printf '%-12s %s\n' "${names[$i]}" "${results[$i]}"
  [[ "${results[$i]}" == "FAIL" ]] && status=1
done
exit "$status"
