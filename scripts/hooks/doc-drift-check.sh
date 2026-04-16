#!/usr/bin/env bash
# PostToolUse hook for Bash(git commit*) — checks if docs are drifting behind code.
# Warns after 3+ commits since any .md file was last modified.
# Never blocks (exit 0 always).

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

# Only trigger on git commit commands
case "$COMMAND" in
  git\ commit*) ;;
  *) exit 0 ;;
esac

# Count commits since last doc change
LAST_DOC_COMMIT=$(git log -1 --format=%H -- '*.md' 2>/dev/null)
if [ -z "$LAST_DOC_COMMIT" ]; then
  exit 0
fi

COMMITS_SINCE=$(git rev-list --count "$LAST_DOC_COMMIT"..HEAD 2>/dev/null || echo "0")

if [ "$COMMITS_SINCE" -ge 3 ]; then
  # Check what changed since last doc update
  CHANGED_FILES=$(git diff --name-only "$LAST_DOC_COMMIT"..HEAD 2>/dev/null | grep -v '\.md$' | head -10)
  if [ -n "$CHANGED_FILES" ]; then
    echo ""
    echo "Doc drift warning: $COMMITS_SINCE commits since docs were last updated."
    echo "Changed files since last doc update:"
    echo "$CHANGED_FILES" | sed 's/^/  /'
    echo ""
    echo "Consider running /doc-sync to check for stale documentation."
  fi
fi

exit 0
