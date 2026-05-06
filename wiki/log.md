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