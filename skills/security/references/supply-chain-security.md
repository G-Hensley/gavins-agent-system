# Supply Chain Security

## Dependency Auditing
- Run `pnpm audit` / `uv pip audit` / `cargo audit` before merging dependency changes
- Review new dependencies before adding: check maintainer reputation, download count, last update date
- Prefer well-maintained packages with many contributors over single-maintainer packages

## Lock Files
- Always commit lock files (pnpm-lock.yaml, uv.lock, Cargo.lock)
- Use `--frozen-lockfile` in CI to prevent surprise updates
- Review lock file changes in PRs — large diffs may indicate unexpected transitive updates

## Version Pinning
- Pin exact versions for production dependencies
- Use ranges only for development dependencies where flexibility is acceptable
- Update dependencies intentionally, not automatically in production

## Known Vulnerability Scanning
- Integrate vulnerability scanning in CI (Dependabot, Snyk, pnpm audit)
- Set severity thresholds — block merges on critical/high vulnerabilities
- Have a process for evaluating and patching flagged vulnerabilities
- Don't ignore vulnerabilities without documenting the reason

## Common Anti-Patterns
| Anti-Pattern | Fix |
|---|---|
| No lock file committed | Commit and enforce lock file |
| `pnpm install` in CI without lockfile | Use `pnpm install --frozen-lockfile` |
| Ignoring audit warnings | Review and patch or document exceptions |
| Adding deps without review | Check maintainer, age, download count first |
| Running postinstall scripts blindly | Review what scripts do before running |
