---
title: "Wiki Log"
type: overview
created: 2026-04-13
updated: 2026-05-05
tags: [log, changelog]
sources: []
status: active
---

# Wiki Log

Chronological record of all wiki operations. Append-only.

---

## [2026-04-13] init | Framework Initialized
- **Operation**: init
- **Pages touched**: [[index]], [[overview]], [[log]]
- **Summary**: Created unified AI development framework with knowledge + code workflows.

## [2026-04-13] ingest | REST API Design Best Practices
- **Operation**: ingest
- **Pages touched**: [[rest-api-design-best-practices]], [[rest]], [[api-design-patterns]], [[http-status-codes]], [[sarah-chen]], [[index]], [[overview]]
- **Summary**: Ingested article by Sarah Chen. Created source summary, 3 concept pages (REST, API Design Patterns, HTTP Status Codes), 1 entity page (Sarah Chen). Example ingest to demonstrate framework workflow.

## [2026-04-28] lint | Wiki Health Check Fix
- **Operation**: lint
- **Pages touched**: [[index]], [[rest-api-design-best-practices]], [[sarah-chen]], [[coding-conventions]], [[testing-conventions]], [[log]]
- **Summary**: Health check (Workflow 8) found 4 broken wikilinks, 2 missing pages, placeholder dates in 2 convention stubs, and missing Core section in index. Fixed by creating source and entity stubs, correcting dates, and adding Core/Sources/Entities entries to index.

## [2026-04-29] lint | Wiki Health Check Fix (round 2)
- **Operation**: lint
- **Pages touched**: [[registry]], [[rest]], [[api-design-patterns]], [[http-status-codes]], [[log]]
- **Summary**: Second Workflow 8 health check found 2 remaining issues: placeholder dates in registry.md and `.md` extension in `sources:` frontmatter field of 3 concept pages. Both fixed.

## [2026-05-05] update | Cross-Platform Agent Orchestration Parity
- **Operation**: update
- **Pages touched**: [[adr-001-cross-platform-agent-orchestration]], [[registry]], [[index]], [[log]]
- **Summary**: Added agent-routing FIRST RULE to AGENTS.md (behavioral-mode switch for Codex/single-agent platforms). Rewrote CLAUDE.md to mirror copilot-instructions.md (delegates to subagents in `.claude/agents/`). Created `.claude/agents/agent-developer.md` and `.claude/agents/explore.md` as byte-identical ports of their `.github/agents/` counterparts. Updated `scripts/setup.ps1` and `scripts/setup.sh` to install the new files. Updated README.md "How to Integrate to Platform" for Claude Code (subagent files) and Codex (behavioral-mode model). Recorded ADR-001 documenting the per-platform routing decision. No system-behavior change.

## [2026-05-05] update | README Platform Integrations Section
- **Operation**: update
- **Pages touched**: [[log]]
- **Summary**: Replaced README "How to Integrate to Platform" with expanded "Platform Integrations" section. Added cross-platform comparison table (entry-point + subagent dir + dispatch model + auto-detection) covering VS Code, Claude Code, and Codex. Added a unified install snippet (one setup command installs all three platforms' files), per-platform "verify it's working" prompts, and a link to ADR-001 explaining why Codex uses a single-file inlined-routing layout vs. mirrored subagents on the other two. Documentation-only change; no agent behavior modified.

## [2026-05-05] update | Consistency Audit Fixes
- **Operation**: update
- **Pages touched**: [[overview]], [[index]], [[log]]
- **Summary**: Fixed 6 documentation/script-parity drifts surfaced by audit. (1) Added 'clean wiki' trigger to .github/copilot-instructions.md. (2) Ported source_paths warn-only check from validate-wiki.sh to validate-wiki.ps1. (3) overview.md: 6 skills -> 7 (added Clean). (4) README.md: added Clean row to skills table. (5) setup.sh: fixed broken 'bash setup-hooks.ps1' next-step. (6) Both agent-developer.md description fields aligned to canonical wording (src/, tests/, wiki/, config/, or scripts/). No system behavior change. validate-wiki.ps1: all checks pass.

## [2026-05-05] update | Rename Explore -> agent-explorer + Strengthen Contract
- **Operation**: update
- **Pages touched**: [[adr-001-cross-platform-agent-orchestration]], [[log]]
- **Summary**: Renamed `.github/agents/explore.md` -> `agent-explorer.md` and `.claude/agents/explore.md` -> `agent-explorer.md` (via git mv, history preserved). Rewrote agent body with a stronger behavioural contract: Pre-Read Checklist (read `wiki/index.md` first), 7-rule Behavioural Contract (cite, read in bulk, surface gaps, scope, stop-when-blocked), Hard Constraints (no writes, no git, no `agent-developer` invocation), structured Output Format (Finding / Locations / Context / Gaps / Suggested next step), and explicit Cross-Platform Parity note (byte-identical pair per ADR-001). Naming now consistent with `agent-developer` (lowercase, hyphenated). Updated references in `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `README.md` (3 sections), `scripts/setup.ps1`, `scripts/setup.sh`, and ADR-001 (`source_paths` + decision narrative). Verified byte-identical pairs via SHA256. `validate-wiki.ps1`: all checks pass. No system-behaviour change beyond the stronger explorer-agent contract.

## [2026-05-05] update | Add tests/ and config/ to canonical Directory Structure
- **Operation**: update
- **Pages touched**: [[log]]
- **Summary**: Closed real gap surfaced by agent-explorer test invocation: routing rules in AGENTS.md/CLAUDE.md/.github/copilot-instructions.md name `tests/` and `config/` as developer-agent triggers, but the canonical Directory Structure block in AGENTS.md (and the mirrored block in README.md) did not list them. Added both directories with "(created on demand)" notes, matching the existing on-demand pattern for `src/frontend/`, `src/backend/`, `src/cli/`. No code change. validate-wiki.ps1: all checks pass. Both agent file pairs (agent-developer, agent-explorer) verified byte-identical via SHA256.
## [2026-05-05] update | Mirror tests/ and config/ into wiki/overview.md
- **Operation**: update
- **Pages touched**: [[overview]], [[log]]
- **Summary**: User noted tests/ and config/ were added to AGENTS.md and README.md Directory Structure blocks but not reflected in wiki/overview.md System Architecture section. Updated overview.md to name tests/ and config/ as on-demand sibling top-level directories alongside src/. validate-wiki.ps1 still passes.
## [2026-05-05] update | Add Drift-Prevention Mechanism (ADR-002)
- **Operation**: update
- **Pages touched**: [[adr-002-automated-system-consistency-checks]], [[registry]], [[index]], [[log]]
- **Summary**: Two consistency review passes surfaced (1) `agent-developer.md` Pre-Change Checklist drift from AGENTS.md Workflow 4 — missing Coding Discipline P1/P4 reference and the agent-explorer fallback rule; (2) no automated mechanism to catch the cross-file drift class that has appeared in every prior audit. Fixes: added P1/P4 step and explorer-fallback step to the Pre-Change Checklist in both `.github/agents/agent-developer.md` and `.claude/agents/agent-developer.md` (kept byte-identical, new SHA256 18C090C1...). Created `scripts/check-system-consistency.ps1` enforcing 5 invariants — agent pair byte-identity, routing path-list parity (AGENTS.md / CLAUDE.md / .github/copilot-instructions.md), trigger-list count parity, Directory Structure coverage of routing paths, skill-table row-count parity (AGENTS.md vs README.md). Wired into `scripts/setup-hooks.ps1` (pre-commit hook) and `.github/workflows/ci.yml` (wiki-lint job). Added to `scripts/setup.ps1` and `scripts/setup.sh` install lists so fresh installs get it. Recorded ADR-002. Updated README "Validation" section. Both checks pass; no system behaviour change.