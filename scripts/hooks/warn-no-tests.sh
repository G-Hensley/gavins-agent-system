#!/usr/bin/env bash
# PreToolUse hook for Edit/Write — warns when editing a source file with no
# corresponding test file.
# Reads Claude hook JSON from stdin, extracts .tool_input.file_path
# Never blocks (exit 0 always)

set -uo pipefail

INPUT="$(cat)"

FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)"

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Only act on source files
if ! printf '%s' "$FILE_PATH" | grep -qE '\.(py|ts|js|jsx|tsx)$'; then
  exit 0
fi

# Skip files that are themselves test files
BASENAME="$(basename "$FILE_PATH")"
if printf '%s' "$BASENAME" | grep -qE '^test_|\.test\.|\.spec\.'; then
  exit 0
fi

DIR="$(dirname "$FILE_PATH")"
STEM="${BASENAME%.*}"
EXT="${BASENAME##*.}"

found_test=false

# Python: test_<stem>.py alongside the file or in a tests/ sibling dir
if [[ "$EXT" == "py" ]]; then
  for candidate in \
    "$DIR/test_${STEM}.py" \
    "$DIR/tests/test_${STEM}.py" \
    "$(dirname "$DIR")/tests/test_${STEM}.py"
  do
    if [[ -f "$candidate" ]]; then
      found_test=true
      break
    fi
  done
fi

# JS/TS: <stem>.test.<ext>, <stem>.spec.<ext> alongside or in __tests__/
if [[ "$EXT" =~ ^(ts|js|jsx|tsx)$ ]]; then
  for candidate in \
    "$DIR/${STEM}.test.${EXT}" \
    "$DIR/${STEM}.spec.${EXT}" \
    "$DIR/${STEM}.test.ts" \
    "$DIR/${STEM}.spec.ts" \
    "$DIR/${STEM}.test.js" \
    "$DIR/${STEM}.spec.js" \
    "$DIR/__tests__/${STEM}.test.${EXT}" \
    "$DIR/__tests__/${STEM}.spec.${EXT}" \
    "$DIR/__tests__/${STEM}.test.ts" \
    "$DIR/__tests__/${STEM}.spec.ts"
  do
    if [[ -f "$candidate" ]]; then
      found_test=true
      break
    fi
  done
fi

if ! $found_test; then
  echo "WARNING: No test file found for $FILE_PATH"
  echo "  Expected one of: test_${STEM}.py, ${STEM}.test.ts, ${STEM}.spec.ts, etc."
  echo "  Write tests first (TDD)."
fi

exit 0
