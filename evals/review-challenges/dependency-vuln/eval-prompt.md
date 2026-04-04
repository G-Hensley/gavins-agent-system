# Eval Prompt

Use this exact prompt to trigger the appsec-reviewer agent:

---

Review the dependency manifests for the document processing API service at:

```
/Users/gavinhensley/Desktop/Projects/Gavins-Agent-System/evals/review-challenges/dependency-vuln/
```

Check both `package.json` (Node.js) and `requirements.txt` (Python) for known vulnerable dependencies. For each finding, include the CVE identifier, affected version, severity, and recommended fix version. Do not flag dependencies that are at safe versions.
