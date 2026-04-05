#!/usr/bin/env bash
# run-eval.sh — Execute evals for Gavin's Agent System
#
# Usage:
#   ./run-eval.sh --list                    List all available evals
#   ./run-eval.sh --results                 Show summary of past eval runs
#   ./run-eval.sh --run <path>              Run a specific eval by path
#   ./run-eval.sh --run-tier <N>            Run all evals in a tier (1-4)
#   ./run-eval.sh --run-all                 Run every eval
#   ./run-eval.sh --help                    Show this message
#
# Path examples:
#   --run tier-1-single-agent/cli-calculator
#   --run review-challenges/sql-injection
#   --run-tier 1
#   --run-tier 2

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"

TIERS=(
  "tier-1-single-agent"
  "tier-2-multi-agent"
  "tier-3-architecture-first"
  "tier-4-full-workflow"
)

REVIEW_CHALLENGES=(
  "review-challenges/sql-injection"
  "review-challenges/overpermissive-iam"
  "review-challenges/xss-vulnerability"
  "review-challenges/dependency-vuln"
  "review-challenges/spec-deviation"
  "review-challenges/code-quality-issues"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

usage() {
  sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

list_evals() {
  echo "Available evals:"
  echo ""
  echo "Tiers:"
  for tier in "${TIERS[@]}"; do
    local tier_path="${SCRIPT_DIR}/${tier}"
    if [[ -d "${tier_path}" ]]; then
      for eval_dir in "${tier_path}"/*/; do
        [[ -d "${eval_dir}" ]] || continue
        echo "  ${tier}/$(basename "${eval_dir}")"
      done
    fi
  done
  echo ""
  echo "Review challenges:"
  for challenge in "${REVIEW_CHALLENGES[@]}"; do
    echo "  ${challenge}"
  done
  exit 0
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

get_git_sha() {
  git -C "${SCRIPT_DIR}" rev-parse --short HEAD 2>/dev/null || echo "unknown"
}

require_claude() {
  command -v claude &>/dev/null || die "'claude' CLI not found in PATH. Install it and try again."
}

# ---------------------------------------------------------------------------
# Result scaffolding
# ---------------------------------------------------------------------------

write_result() {
  local output_dir="$1"
  local eval_id="$2"
  local status="$3"
  local iso_date
  iso_date="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  local git_sha
  git_sha="$(get_git_sha)"

  cat > "${output_dir}/result.json" <<JSON
{
  "eval": "${eval_id}",
  "date": "${iso_date}",
  "git_sha": "${git_sha}",
  "status": "${status}",
  "agents_dispatched": [],
  "metrics": {
    "total_tokens": null,
    "duration_seconds": null,
    "review_cycles": null
  },
  "findings": [],
  "notes": ""
}
JSON
}

# ---------------------------------------------------------------------------
# Results summary
# ---------------------------------------------------------------------------

show_results() {
  local found=0

  printf "%-50s  %-24s  %-10s  %-8s  %s\n" "EVAL" "DATE" "STATUS" "GIT_SHA" "NOTES"
  printf '%s\n' "$(python3 -c 'print("-" * 110)' 2>/dev/null || printf '%0.s-' $(seq 1 110))"

  while IFS= read -r result_file; do
    found=1
    if command -v python3 &>/dev/null; then
      python3 - "${result_file}" <<'PYEOF'
import json, sys
try:
    with open(sys.argv[1]) as f:
        d = json.load(f)
    eval_id   = d.get("eval", "unknown")[:49]
    date_val  = d.get("date", "")[:23]
    status    = d.get("status", "unknown")[:9]
    git_sha   = d.get("git_sha", "")[:7]
    notes     = (d.get("notes") or "")[:40]
    print(f"{eval_id:<50}  {date_val:<24}  {status:<10}  {git_sha:<8}  {notes}")
except Exception as e:
    print(f"  (could not parse {sys.argv[1]}: {e})")
PYEOF
    else
      echo "  ${result_file}"
    fi
  done < <(find "${SCRIPT_DIR}" -name "result.json" -path "*/output/result.json" | sort)

  if [[ "${found}" -eq 0 ]]; then
    echo "No past eval results found."
  fi

  exit 0
}

# ---------------------------------------------------------------------------
# Prompt extraction
# ---------------------------------------------------------------------------

# extract_prompt <eval-prompt.md path>
# For review challenges: extracts text between the first pair of --- delimiters.
# For tier evals: returns the full file content.
extract_prompt() {
  local prompt_file="$1"
  local is_review_challenge="${2:-false}"

  if [[ "${is_review_challenge}" == "true" ]]; then
    # Extract content between first --- and second --- delimiter
    python3 - "${prompt_file}" <<'PYEOF'
import sys, re
content = open(sys.argv[1]).read()
# Find content between first pair of --- delimiters
match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL | re.MULTILINE)
if match:
    print(match.group(1).strip())
else:
    # Fallback: print the whole file
    print(content.strip())
PYEOF
  else
    cat "${prompt_file}"
  fi
}

# ---------------------------------------------------------------------------
# Execution
# ---------------------------------------------------------------------------

# run_single_eval <eval_path_relative> <is_review_challenge>
# eval_path_relative: e.g. "tier-1-single-agent/cli-calculator" or "review-challenges/sql-injection"
run_single_eval() {
  local eval_rel="$1"
  local is_review_challenge="${2:-false}"
  local eval_dir="${SCRIPT_DIR}/${eval_rel}"
  local prompt_file="${eval_dir}/eval-prompt.md"
  local output_dir="${eval_dir}/output"

  [[ -d "${eval_dir}" ]]   || die "Eval directory not found: ${eval_dir}"
  [[ -f "${prompt_file}" ]] || die "eval-prompt.md not found in ${eval_dir}"

  mkdir -p "${output_dir}"

  echo "[run-eval] Running: ${eval_rel}"
  echo "[run-eval] Output:  ${output_dir}/response.json"

  local prompt
  prompt="$(extract_prompt "${prompt_file}" "${is_review_challenge}")"

  local status="passed"
  local start_ts
  start_ts="$(date +%s)"

  if ! claude --print --output-format json -p "${prompt}" > "${output_dir}/response.json" 2>&1; then
    status="failed"
    echo "[run-eval] FAILED: ${eval_rel}" >&2
  fi

  local end_ts
  end_ts="$(date +%s)"
  local duration=$(( end_ts - start_ts ))

  write_result "${output_dir}" "${eval_rel}" "${status}"

  # Patch duration into result.json
  python3 - "${output_dir}/result.json" "${duration}" <<'PYEOF'
import json, sys
path, secs = sys.argv[1], int(sys.argv[2])
with open(path) as f:
    d = json.load(f)
d["metrics"]["duration_seconds"] = secs
with open(path, "w") as f:
    json.dump(d, f, indent=2)
PYEOF

  echo "[run-eval] Done: ${eval_rel} (${duration}s) — ${status}"
}

# run_tier_evals <tier_dir_name>
run_tier_evals() {
  local tier="$1"
  local tier_path="${SCRIPT_DIR}/${tier}"

  [[ -d "${tier_path}" ]] || die "Tier directory not found: ${tier_path}"

  local count=0
  for eval_dir in "${tier_path}"/*/; do
    [[ -d "${eval_dir}" ]] || continue
    local eval_name
    eval_name="$(basename "${eval_dir}")"
    run_single_eval "${tier}/${eval_name}" "false"
    (( count++ )) || true
    echo ""
  done

  [[ "${count}" -gt 0 ]] || echo "[run-eval] No eval subdirectories found in ${tier_path}"
}

# resolve_tier_name <N>
# Converts short tier number (1-4) to full directory name
resolve_tier_name() {
  local n="$1"
  case "${n}" in
    1) echo "tier-1-single-agent" ;;
    2) echo "tier-2-multi-agent" ;;
    3) echo "tier-3-architecture-first" ;;
    4) echo "tier-4-full-workflow" ;;
    *) die "Unknown tier: ${n}. Valid values: 1 2 3 4" ;;
  esac
}

run_all_evals() {
  echo "[run-eval] Running all evals — $(date)"
  echo ""

  for tier in "${TIERS[@]}"; do
    echo "=== ${tier} ==="
    run_tier_evals "${tier}"
  done

  for challenge in "${REVIEW_CHALLENGES[@]}"; do
    echo "=== ${challenge} ==="
    run_single_eval "${challenge}" "true"
    echo ""
  done

  echo "[run-eval] All evals complete."
}

# ---------------------------------------------------------------------------
# Dispatch
# ---------------------------------------------------------------------------

main() {
  local arg="${1:-}"

  case "${arg}" in
    --help|-h)
      usage
      ;;
    --list|-l)
      list_evals
      ;;
    --results|-r)
      show_results
      ;;
    --run)
      [[ -n "${2:-}" ]] || die "--run requires a path argument (e.g. tier-1-single-agent/cli-calculator)"
      require_claude
      local eval_path="$2"
      local is_review="false"
      [[ "${eval_path}" == review-challenges/* ]] && is_review="true"
      run_single_eval "${eval_path}" "${is_review}"
      ;;
    --run-tier)
      [[ -n "${2:-}" ]] || die "--run-tier requires a tier number (1-4)"
      require_claude
      local tier_name
      tier_name="$(resolve_tier_name "$2")"
      echo "[run-eval] Running all evals in ${tier_name}"
      echo ""
      run_tier_evals "${tier_name}"
      ;;
    --run-all)
      require_claude
      run_all_evals
      ;;
    "")
      die "No arguments provided. Run with --help for usage."
      ;;
    *)
      die "Unknown argument: ${arg}. Run with --help for usage."
      ;;
  esac
}

main "$@"
