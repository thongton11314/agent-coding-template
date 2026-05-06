---
title: "ADR-002: Automated System Consistency Checks"
type: decision
created: 2026-05-05
updated: 2026-05-05
tags: [decision, adr, consistency, ci, validation]
sources: []
related: [registry, adr-001-cross-platform-agent-orchestration]
source_paths:
  - scripts/check-system-consistency.ps1
  - scripts/setup-hooks.ps1
  - .github/workflows/ci.yml
status: active
---

# ADR-002: Automated System Consistency Checks

## Context

Across this session and prior audits the framework accumulated a recurring class
of bug: **cross-file drift** between the canonical schema (`AGENTS.md`) and its
mirrors (`CLAUDE.md`, `.github/copilot-instructions.md`, `README.md`,
`wiki/overview.md`, the two `agent-developer.md` copies, and the two
`agent-explorer.md` copies).

Examples found by manual audit:

- `copilot-instructions.md` missing the "clean wiki" routing trigger that the
  other two entry points already had.
- `wiki/overview.md` and `README.md` claiming **6** developer-agent skills while
  `AGENTS.md` listed **7** (`Clean` was added but never propagated).
- `.github/agents/agent-developer.md` and `.claude/agents/agent-developer.md`
  description fields drifting (`src/frontend/` vs canonical wording).
- `agent-developer.md` Pre-Change Checklist not referencing the
  Coding-Discipline P1/P4 requirement that `AGENTS.md` Workflow 4 mandates.
- `tests/` and `config/` named in routing rules but absent from the canonical
  Directory Structure block.
- `validate-wiki.ps1` missing the `Source Paths` warn-only check that
  `validate-wiki.sh` had.

Every one of these was a documentation/parity bug, not a code-behavior bug —
but together they erode the framework's central promise that **`AGENTS.md` is
the single source of truth, mirrored verbatim everywhere else**.

`scripts/validate-wiki.ps1` is run by the pre-commit hook and CI, but it only
checks **wiki-internal** state (frontmatter, wikilinks, orphans, filenames). It
has no view into cross-file parity between AGENTS.md and the platform mirrors.

## Options Considered

- **Option A — Manual audits.** Continue catching drift with periodic
  consistency reviews.
  - Pros: zero engineering work.
  - Cons: drift ships between audits; depends on the auditor remembering all
    the parity invariants; doesn't scale; doesn't run in CI.

- **Option B — Extend `validate-wiki.ps1`** with cross-file parity checks.
  - Pros: one script, one entry point.
  - Cons: conflates two concerns (wiki health vs cross-file system
    consistency); the wiki script already runs against `wiki/` exclusively, and
    these checks read AGENTS.md / CLAUDE.md / agent files / scripts.

- **Option C — A new `check-system-consistency.ps1` script** with focused
  parity checks, wired into the same pre-commit hook and CI job that already
  runs the wiki check.
  - Pros: separation of concerns; easy to extend with new invariants without
    bloating the wiki validator; clear failure messages; both checks share the
    same fast feedback loop.
  - Cons: one more script to maintain.

## Decision

**Adopt Option C.**

Created `scripts/check-system-consistency.ps1` enforcing five invariants:

1. **Agent file pair byte-identity** — `.github/agents/agent-developer.md` ≡
   `.claude/agents/agent-developer.md`, and same for `agent-explorer.md` (per
   [[adr-001-cross-platform-agent-orchestration]]).
2. **Routing path-list parity** — the `` `src/`, `tests/`, `wiki/`, `config/`,
   or `scripts/` `` literal must match across `AGENTS.md`, `CLAUDE.md`, and
   `.github/copilot-instructions.md`.
3. **Trigger-list count parity** — same number of `- "..."` triggers in the
   "Triggers (non-exhaustive)" block of those three entry points.
4. **Directory-structure coverage** — every directory named in the routing
   path list appears in the `## Directory Structure` block of `AGENTS.md`.
5. **Skill-table parity** — the Developer Agent skills table in `AGENTS.md`
   and `README.md` must have the same row count.

Wired into:

- `scripts/setup-hooks.ps1` — the installed pre-commit hook now runs the
  wiki check **and** the system consistency check; either failure blocks the
  commit.
- `.github/workflows/ci.yml` — the existing `wiki-lint` job runs both scripts
  on every push and PR; either failure blocks merge.

`scripts/setup.ps1` and `scripts/setup.sh` install the new script alongside
the existing ones so fresh installs get it.

## Consequences

- **Drift is caught at commit time, not at audit time.** The classes of bug
  listed in Context above can no longer ship — any commit that introduces them
  fails the pre-commit hook locally and the `wiki-lint` job in CI.
- **One script per concern.** Wiki health stays in `validate-wiki.ps1`;
  cross-file system consistency lives in `check-system-consistency.ps1`. Adding
  a new invariant (e.g. "Pre-Change Checklist in `agent-developer.md` must
  reference Coding-Discipline P1") only touches the system-consistency script.
- **Single PowerShell script for cross-platform.** Per the
  `validate-wiki.ps1`/`.sh` drift incident (see `wiki/log.md` 2026-05-05
  Consistency Audit Fixes entry), maintaining two parallel scripts in
  PowerShell + Bash invites drift. The pre-commit hook prefers `pwsh` and falls
  back to `powershell`; CI installs PowerShell explicitly. A single script
  keeps the prevention-mechanism's own consistency easy to enforce.
- **Future invariants plug in.** New parity rules — for example, ensuring
  `wiki/overview.md` reflects the canonical skill list, or checking that ADR
  `source_paths` resolve — can be added as new `Record-Check` blocks without
  touching anything else.
- **No system behavior change.** The framework's runtime contracts (Workflows
  1–11, Post-Change Pipeline, Sync Gate, Coding/Wiki Discipline) are
  unchanged. This ADR only adds a verifier for invariants those contracts
  already implied.

## Status

`active` — adopted 2026-05-05. Replaces the implicit "manual audit" approach
with an automated check that runs on every commit and every CI build.
