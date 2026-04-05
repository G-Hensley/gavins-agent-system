#!/usr/bin/env bash
# PreToolUse hook for Bash — blocks dangerous commands
# Reads Claude hook JSON from stdin, extracts .tool_input.command
# Exit 2 = block the action; exit 0 = allow it

set -uo pipefail

INPUT="$(cat)"

COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)"

if [[ -z "$COMMAND" ]]; then
  exit 0
fi

block() {
  local reason="$1"
  echo "BLOCKED: $reason" >&2
  echo "Command was: $COMMAND" >&2
  exit 2
}

# rm -rf / (and common variants)
if printf '%s' "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f\s+/\s*$|rm\s+-[a-zA-Z]*f[a-zA-Z]*r\s+/\s*$'; then
  block "rm -rf / is not allowed"
fi
if printf '%s' "$COMMAND" | grep -qE 'rm\s+--no-preserve-root'; then
  block "rm --no-preserve-root is not allowed"
fi

# git push --force to main or master
if printf '%s' "$COMMAND" | grep -qE 'git\s+push.*(--force|-f)'; then
  if printf '%s' "$COMMAND" | grep -qE '\bmain\b|\bmaster\b'; then
    block "git push --force to main/master is not allowed"
  fi
fi

# git reset --hard
if printf '%s' "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  block "git reset --hard is not allowed"
fi

# DROP TABLE (case-insensitive)
if printf '%s' "$COMMAND" | grep -qiE '\bDROP\s+TABLE\b'; then
  block "DROP TABLE is not allowed"
fi

# DELETE FROM without WHERE
if printf '%s' "$COMMAND" | grep -qiE '\bDELETE\s+FROM\b'; then
  if ! printf '%s' "$COMMAND" | grep -qiE '\bWHERE\b'; then
    block "DELETE FROM without WHERE clause is not allowed"
  fi
fi

exit 0
