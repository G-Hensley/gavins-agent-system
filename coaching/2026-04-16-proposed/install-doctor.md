---
name: install-doctor
description: Diagnose and fix the Claude Code Agent System install — verifies symlinks are intact, detects Windows-specific failure modes (MSYS symlink support, Developer Mode), and prints a minimal remediation. Use when sessions aren't picking up recently committed skills/agents/rules, when `/improve` returns empty from a non-empty backlog, or when you suspect the global CLAUDE.md is not loading.
---

# install-doctor

A diagnostic skill that wraps `scripts/install.sh --verify` with pattern recognition and host-specific remediation. The raw `--verify` output tells you what's broken; this skill tells you why and how to fix it without having to context-switch into the install script.

## When to invoke

- Sessions not behaving as expected — expected skill/agent/rule not triggering
- Just committed to `gavins-agent-system/skills/` or `agents/` and want to confirm the change reached `~/.claude/`
- On a fresh machine after cloning the repo
- Recommended: run once per week before Friday's coaching task

## Behavior

1. Run `bash scripts/install.sh --verify` from the repo root.
2. Parse output line by line:
   - `[OK]` — skip
   - `[MISSING]` — symlink does not exist. Offer to run the install step for that single dir.
   - `[WRONG TARGET]` — symlink points to the wrong place (repo was moved?). Offer to unlink + relink.
   - `[DEAD LINK]` — target missing on disk. Offer to inspect whether the target was renamed, then restore or drop the symlink.
3. If EVERY item is `[MISSING]` and you're on Windows, diagnose:
   - Check whether Developer Mode is on: `reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense`
   - Check whether the current Git Bash is elevated: `whoami /groups | grep -E 'High Mandatory Level|S-1-16-12288'`
   - If neither, print: "Symlink creation requires Developer Mode OR an Administrator shell. Pick one, then re-run install.sh."
4. After any remediation, re-run `--verify` and confirm.

## Reference implementation sketch

```bash
#!/usr/bin/env bash
# scripts/hooks/install-doctor.sh or invoked from install.sh --doctor

bash "$REPO_DIR/scripts/install.sh" --verify > /tmp/verify-out 2>&1
case $? in
  0) echo "All symlinks intact."; exit 0 ;;
  1) ;;
esac

broken=$(grep -c '^\[MISSING\]\|^\[WRONG TARGET\]\|^\[DEAD LINK\]' /tmp/verify-out)
total=$(grep -cE '^\[' /tmp/verify-out)
echo "$broken/$total symlinks broken."

if [ "$broken" = "$total" ] && uname -s | grep -qi 'MINGW\|MSYS\|CYGWIN'; then
  dev_mode=$(reg query "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense 2>/dev/null | grep -c '0x1')
  is_admin=$(whoami /groups 2>/dev/null | grep -c 'S-1-16-12288')
  if [ "$dev_mode" = "0" ] && [ "$is_admin" = "0" ]; then
    cat <<EOF
All symlinks are missing and you are on Windows without Developer Mode and without admin rights.
Pick one:
  (a) Enable Developer Mode: Settings > System > For developers > Developer Mode
  (b) Re-run this script from an Administrator Git Bash shell

Then: bash scripts/install.sh && bash scripts/install.sh --verify
EOF
    exit 2
  fi
fi

echo "Run: bash scripts/install.sh  (will re-symlink broken entries)"
```

## Files to create

- `scripts/hooks/install-doctor.sh` — the diagnostic script above
- Add `/install-doctor` slash command in `commands/install-doctor.md` that invokes the script and reports
- Add a PostToolUse hook on `Edit|Write` matching paths `skills/**/SKILL.md` or `agents/**/*.md` or `commands/**/*.md` — warn if verify has not been run since the last touch of those paths

## Success criteria

- Running `/install-doctor` on a working machine prints "All symlinks intact." and exits 0
- Running it on a half-installed machine prints the exact remediation path (enable Developer Mode / run as admin) with zero extra words
- Takes less than 3 seconds in the happy path
