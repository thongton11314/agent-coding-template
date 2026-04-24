# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this template, please open a GitHub
Issue with the label `security`. Do not include exploit details in the issue body;
share them privately if needed.

---

## Ongoing Security Checklist

The AI developer agent runs this checklist for **every code change** that touches
authentication, API keys, data queries, file paths, or user input. It is not a
one-time gate — it applies continuously.

### A. Input Validation (OWASP A03)

- [ ] All user inputs are validated at system boundaries (not just client-side).
- [ ] Query parameters, headers, and request bodies are validated before use.
- [ ] Filenames and paths are sanitised — no path traversal (`../`) is possible.
- [ ] Numeric bounds are enforced; no unbounded pagination or loop inputs.

### B. Authentication & Authorization (OWASP A01, A07)

- [ ] Protected routes require authentication before executing.
- [ ] Authorization is checked per-request, not just at login.
- [ ] Privilege escalation paths are blocked (users cannot access other users' data).
- [ ] Tokens/sessions expire and are invalidated on logout.

### C. Secrets & Credentials (OWASP A02)

- [ ] API keys, passwords, and tokens are stored in environment variables — never
      hardcoded in source files.
- [ ] Secrets are never logged, exposed in error messages, or returned in API responses.
- [ ] `.env` files are in `.gitignore` and never committed.
- [ ] Client-side code never receives server-side secrets.

### D. Injection (OWASP A03)

- [ ] Database queries use parameterised statements or an ORM — no string interpolation
      into queries.
- [ ] Shell commands do not interpolate user input.
- [ ] LLM prompts that include user content are sanitised to prevent prompt injection.

### E. Data Exposure (OWASP A02, A05)

- [ ] Private data is never returned on public-facing endpoints.
- [ ] Error responses do not expose stack traces, internal paths, or schema details.
- [ ] Sensitive fields (passwords, tokens) are excluded from serialisation.

### F. Dependency Security (OWASP A06)

- [ ] Dependencies are pinned to specific versions in the lockfile.
- [ ] Known-vulnerable packages are flagged via `dependabot` or equivalent.
- [ ] No unnecessary permissions are granted to third-party packages.

### G. Destructive Actions

- [ ] Destructive operations (delete, drop, overwrite) require explicit confirmation.
- [ ] Irreversible operations are logged with actor, timestamp, and affected resource.

---

## ADR Requirement

Any architectural decision that introduces a new security boundary, changes an
authentication model, or exposes a new external surface must be recorded as an ADR
in `wiki/decisions/` and cross-referenced from `wiki/architecture/security-model.md`.

---

## Relevant OWASP Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
