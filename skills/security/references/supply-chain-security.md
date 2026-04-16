# Supply Chain Security

Source: OWASP A03:2025 Software Supply Chain Failures, OWASP Software Component Verification Standard

## Why This Matters

Supply chain attacks are OWASP A03:2025. Real-world incidents: SolarWinds (18,000 orgs compromised via vendor update), Log4Shell (CVE-2021-44228, millions of Java apps), npm worms (credential-harvesting packages auto-propagating). A single compromised dependency can bypass all your application security.

## Dependency Evaluation (Before Adding)

Before `pnpm add` or `uv add`, evaluate:
- **Maintainer reputation**: known maintainers, multiple contributors, organizational backing
- **Activity**: last commit date, issue response time, release cadence
- **Download count**: high adoption = more eyes on code, faster vulnerability discovery
- **Dependency tree**: how many transitive deps does it pull in? Fewer = smaller attack surface
- **License**: check compatibility (MIT/Apache = safe, GPL/AGPL = review needed)
- **Security history**: check for past CVEs, how quickly they were patched

When in doubt, prefer standard library or well-known alternatives over niche packages.

## Dependency Auditing

Run audits on every CI build — fail on high/critical:
```yaml
# GitHub Actions
- run: pnpm audit --audit-level=high
# or
- run: pip install uv && uv sync --frozen && uv pip audit
```

**pnpm audit**: checks against npm advisory database. `--audit-level=high` fails on high/critical.
**uv pip audit**: checks against PyPI advisory database and OSV.

Review audit results — don't suppress warnings without documented justification. Track exceptions in a `audit-exceptions.json` or similar with expiration dates.

## Lock Files

**Always commit**: `pnpm-lock.yaml`, `uv.lock`, `Cargo.lock`. Lock files pin the entire transitive dependency tree — without them, builds are non-deterministic and vulnerable to dependency confusion.

**CI enforcement**: `pnpm install --frozen-lockfile` / `uv sync --frozen`. Prevents CI from silently resolving to different versions than what was reviewed.

**Review lock file changes**: large lockfile diffs in PRs may indicate unexpected transitive updates. Treat lockfile changes as security-relevant code changes.

## Version Pinning

- **Production deps**: exact versions (`"express": "4.18.2"`)
- **Dev deps**: ranges acceptable (`"vitest": "^1.0.0"`)
- **Update intentionally**: Dependabot/Renovate PRs, reviewed individually. Never auto-merge production dependency updates.
- **Major version bumps**: read changelog, check breaking changes, run full test suite, one major bump per PR

## SBOM (Software Bill of Materials)

Maintain an SBOM for production deployments. Lists every dependency and version in the shipped artifact.

**Tools**: `pnpm licenses list`, Syft, CycloneDX. Generate in CI and store with each release.

**Why**: when a new CVE drops (like Log4Shell), you can instantly determine which services are affected without scanning every repo.

## Package Integrity

**Lock file hashes**: pnpm and uv include integrity hashes in lockfiles — verified on install.

**Subresource Integrity (SRI)**: for any CDN-loaded script or stylesheet, add `integrity="sha384-..."` attribute. Prevents CDN compromise from injecting malicious code.

**Registry security**: use official registries (npmjs.com, pypi.org). For private packages, use private registries with authentication. Configure `.npmrc` / `uv.toml` to scope packages correctly.

**Typosquatting defense**: verify package names carefully. `express` vs `expres`, `lodash` vs `1odash`. Use scoped packages where available (`@org/package`).

## CI/CD Pipeline Security

- **Signed commits**: require GPG-signed commits on protected branches
- **Protected branches**: require PR reviews, passing CI, no force-push on main
- **Dependency caching**: cache from lockfile hash — prevents stale cache with different versions
- **Minimal CI permissions**: CI runners get only the permissions needed for build/test/deploy
- **No secrets in logs**: mask secrets in CI output, use secret managers for credentials
- **Pin CI action versions**: `uses: actions/checkout@v4` not `@main`. Review action source.

## Automated Updates

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      minor-and-patch:
        update-types: ["minor", "patch"]
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
```

Group minor/patch updates (low risk). Review major updates individually. Never auto-merge without CI passing.

## Common Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| No lock file committed | Commit and enforce with `--frozen-lockfile` |
| Ignoring audit warnings | Review, patch, or document exceptions with expiry |
| Adding deps without evaluation | Check maintainer, activity, deps tree, license |
| Running postinstall scripts blindly | Review scripts, use `--ignore-scripts` + explicit allow |
| Auto-merging dependency updates | CI must pass; manual review for major versions |
| No SBOM | Generate with each release for CVE impact analysis |
| Unpinned CI action versions | Pin to specific version tags, not `@main` |
