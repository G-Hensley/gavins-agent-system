#!/usr/bin/env bash
# run-eval.sh — Execute evals for Gavin's Agent System
#
# Usage:
#   ./run-eval.sh <target>            Run a specific tier or review challenge
#   ./run-eval.sh all                 Run every eval
#   ./run-eval.sh --list              List all available evals
#   ./run-eval.sh --help              Show this message
#
# Target examples:
#   tier-1
#   tier-2
#   tier-3
#   tier-4
#   review-challenges/sql-injection
#   review-challenges/xss-vulnerability

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="${SCRIPT_DIR}/results"
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
  # Print the header comment block at the top of the file (lines 2-17)
  sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

list_evals() {
  echo "Available evals:"
  echo ""
  echo "Tiers:"
  for tier in "${TIERS[@]}"; do
    echo "  ${tier}"
  done
  echo ""
  echo "Review challenges:"
  for challenge in "${REVIEW_CHALLENGES[@]}"; do
    echo "  ${challenge}"
  done
  echo ""
  echo "Meta targets:"
  echo "  all"
  exit 0
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

validate_target() {
  local target="$1"
  [[ -z "${target}" ]] && die "No target specified. Run with --help for usage."

  # Normalize tier shorthand (e.g. "tier-1" -> "tier-1-single-agent")
  case "${target}" in
    tier-1) target="tier-1-single-agent" ;;
    tier-2) target="tier-2-multi-agent" ;;
    tier-3) target="tier-3-architecture-first" ;;
    tier-4) target="tier-4-full-workflow" ;;
  esac

  # Check existence
  if [[ "${target}" != "all" ]]; then
    local path="${SCRIPT_DIR}/${target}"
    [[ -d "${path}" ]] || die "Target not found: ${path}"
  fi

  echo "${target}"
}

make_results_dir() {
  local target_slug="${1//\//-}"
  local run_dir="${RESULTS_DIR}/${TIMESTAMP}-${target_slug}"
  mkdir -p "${run_dir}"
  echo "${run_dir}"
}

# ---------------------------------------------------------------------------
# Execution stubs
# ---------------------------------------------------------------------------

run_tier() {
  local tier="$1"
  local run_dir="$2"
  local tier_path="${SCRIPT_DIR}/${tier}"

  echo "[run-eval] Target: ${tier}"
  echo "[run-eval] Results: ${run_dir}"
  echo "[run-eval] Eval directory: ${tier_path}"
  echo ""

  # TODO: iterate over prompts in tier directory and execute each against the agent system
  echo "[run-eval] PLACEHOLDER — would run all prompts under ${tier_path}/"
  echo "[run-eval] Results would be written to ${run_dir}/"

  # Stub result file so downstream tooling has something to read
  cat > "${run_dir}/result.json" <<JSON
{
  "target": "${tier}",
  "timestamp": "${TIMESTAMP}",
  "status": "placeholder",
  "note": "Execution logic not yet implemented. Scaffold only."
}
JSON

  echo "[run-eval] Wrote stub result to ${run_dir}/result.json"
}

run_review_challenge() {
  local challenge="$1"
  local run_dir="$2"
  local challenge_path="${SCRIPT_DIR}/${challenge}"

  echo "[run-eval] Target: ${challenge}"
  echo "[run-eval] Results: ${run_dir}"
  echo "[run-eval] Challenge directory: ${challenge_path}"
  echo ""

  # TODO: load prompt.md, send artifact + prompt to the target reviewer agent, score output against rubric.md
  echo "[run-eval] PLACEHOLDER — would dispatch reviewer agent for ${challenge_path}/"
  echo "[run-eval] Results would be written to ${run_dir}/"

  cat > "${run_dir}/result.json" <<JSON
{
  "target": "${challenge}",
  "timestamp": "${TIMESTAMP}",
  "status": "placeholder",
  "note": "Execution logic not yet implemented. Scaffold only."
}
JSON

  echo "[run-eval] Wrote stub result to ${run_dir}/result.json"
}

run_all() {
  local run_dir
  run_dir="$(make_results_dir all)"

  echo "[run-eval] Running all evals"
  echo "[run-eval] Results root: ${run_dir}"
  echo ""

  for tier in "${TIERS[@]}"; do
    echo "--- ${tier} ---"
    run_tier "${tier}" "${run_dir}/${tier}"
    echo ""
  done

  for challenge in "${REVIEW_CHALLENGES[@]}"; do
    local slug="${challenge//\//-}"
    echo "--- ${challenge} ---"
    run_review_challenge "${challenge}" "${run_dir}/${slug}"
    echo ""
  done

  echo "[run-eval] All evals complete. Results in ${run_dir}/"
}

# ---------------------------------------------------------------------------
# Dispatch
# ---------------------------------------------------------------------------

main() {
  local arg="${1:-}"

  case "${arg}" in
    --help|-h) usage ;;
    --list|-l) list_evals ;;
    all)       run_all ;;
    "")        die "No target specified. Run with --help for usage." ;;
    *)
      local target
      target="$(validate_target "${arg}")"
      local run_dir
      run_dir="$(make_results_dir "${target}")"

      # Route to the right runner
      if [[ "${target}" == review-challenges/* ]]; then
        run_review_challenge "${target}" "${run_dir}"
      else
        run_tier "${target}" "${run_dir}"
      fi
      ;;
  esac
}

main "$@"
