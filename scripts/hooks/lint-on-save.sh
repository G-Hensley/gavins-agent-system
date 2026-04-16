#!/usr/bin/env bash
# PostToolUse hook for Edit|Write — runs ruff on Python files after edits.
# Warns on lint failures but never blocks (exit 0 always).

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)

# Only lint Python files
case "$FILE_PATH" in
  *.py)
    if command -v ruff &>/dev/null; then
      OUTPUT=$(ruff check "$FILE_PATH" 2>&1)
      if [ $? -ne 0 ]; then
        echo "ruff found issues in $FILE_PATH:"
        echo "$OUTPUT"
      fi
    fi
    ;;
esac

exit 0
