---
title: "ADR-001: Cross-Platform Agent Orchestration"
type: decision
created: 2026-05-05
updated: 2026-05-05
tags: [decision, adr, orchestration, multi-platform]
sources: []
related: [registry]
source_paths:
  - .github/copilot-instructions.md
  - .github/agents/agent-developer.md
  - .github/agents/agent-explorer.md
  - .claude/agents/agent-developer.md
  - .claude/agents/agent-explorer.md
  - CLAUDE.md
  - AGENTS.md
status: active
---

# ADR-001: Cross-Platform Agent Orchestration

## Context

This template is meant to run on **at least three AI coding platforms**:

- **VS Code (GitHub Copilot)** — uses `.github/copilot-instructions.md` plus
  subagents in `.github/agents/{name}.md`.
- **Claude Code** — uses `CLAUDE.md` at the repo root plus subagents in
  `.claude/agents/{name}.md`.
- **Codex (OpenAI)** — uses `AGENTS.md` at the repo root. Codex is single-agent;
  it has no native subagent file convention.

Before this ADR, only the VS Code path had explicit agent-routing instructions
("for code changes, delegate to `agent-developer`; for read-only, delegate to
`Explore`"). `CLAUDE.md` was a thin pointer to `AGENTS.md`, and `AGENTS.md` had
no top-of-file routing rule. As a result:

- A Claude Code user opening this project would see no subagent files and no
  delegation rule, so the framework's "two-agent" model would silently collapse
  back to a single-agent flow.
- A Codex user reading `AGENTS.md` would find the agent contracts buried in the
  middle of the schema, with no up-front rule telling them when to enter
  Developer-Agent mode versus Exploration-Agent mode.

The template's stated value proposition is **platform-agnostic orchestration**.
That value is only realized if every platform sees the same routing semantics.

## Options Considered

- **Option A — Single-source via `AGENTS.md` only.** Put the routing rule only
  in `AGENTS.md` and tell every platform to read it.
  - Pros: one source of truth.
  - Cons: VS Code Copilot already loads `.github/copilot-instructions.md`
    automatically and won't read `AGENTS.md` for routing; Claude Code's subagent
    discovery looks for `.claude/agents/`, not `.github/agents/`. Single-source
    breaks both native conventions.

- **Option B — Per-platform routing files mirroring native subagent conventions
  + behavioral-mode rule in `AGENTS.md` for single-agent platforms.** Add the
  routing rule to each platform's primary file (`copilot-instructions.md`,
  `CLAUDE.md`, `AGENTS.md`) and place subagent files at each platform's
  conventional path (`.github/agents/`, `.claude/agents/`). For Codex (single
  agent), express the rule as a behavioral-mode switch at the top of
  `AGENTS.md`.
  - Pros: every platform gets routing in the place it natively reads;
    Claude/Copilot subagent discovery works out of the box; Codex routing is
    explicit; behavior is identical across platforms (same triggers, same
    pipeline, same read-only guarantee).
  - Cons: subagent definitions live in two places (`.github/agents/` and
    `.claude/agents/`). Mitigated by keeping the file bodies byte-identical and
    documenting the parity in this ADR.

- **Option C — Symlinks from `.claude/agents/` to `.github/agents/`.**
  - Pros: no duplicated content.
  - Cons: symlinks don't survive Git on Windows for many users; the framework
    explicitly supports Windows + PowerShell setup; cross-platform symlink
    handling is unreliable.

## Decision

**Adopt Option B.**

- `.github/copilot-instructions.md` continues to own routing for VS Code Copilot
  (unchanged).
- `CLAUDE.md` is rewritten to mirror `copilot-instructions.md` and delegate to
  the `agent-developer` and `agent-explorer` subagents in `.claude/agents/`.
- `.claude/agents/agent-developer.md` and `.claude/agents/agent-explorer.md` are
  byte-equivalent ports of their `.github/agents/` counterparts.
- `AGENTS.md` gains a top-of-file `## Agent Routing — FIRST RULE` section that
  expresses the routing as a single-agent behavioral-mode switch and explicitly
  documents the platform-mapping (Copilot/Claude → delegate to subagent; Codex →
  apply the agent's behavioral contract directly).
- `scripts/setup.ps1` and `scripts/setup.sh` install the new `.claude/agents/`
  files alongside the existing `.github/agents/` ones.
- `README.md` "How to Integrate to Platform" lists the new files for the Claude
  path and explains Codex's behavioral-mode model.

## Consequences

- **Behavioral parity across platforms.** A user opening the project on any of
  the three platforms sees the same triggers, the same Pre-Change Checklist,
  the same Post-Change Pipeline, and the same read-only guarantees for
  exploration. No platform silently degrades to a single-agent flow.
- **Two copies of each subagent.** `.github/agents/agent-developer.md` and
  `.claude/agents/agent-developer.md` (and the `agent-explorer.md` pair) must be kept
  in sync. Drift risk is real but bounded — the files are short and only change
  when the framework's agent contracts change. A future Workflow could lint
  them; for now the pre-commit/validate-wiki hook covers wiki state, and these
  files are explicitly listed as `source_paths` here so the cleanup workflow
  flags them when out of sync.
- **No system-behavior change.** The Post-Change Pipeline, Sync Gate,
  Workflows 1–11, and Coding/Wiki Discipline principles are unchanged. Only the
  surface that exposes them per platform was updated.
- **Setup scripts stay idempotent.** `setup.ps1` and `setup.sh` skip files that
  already exist; existing installs upgrade cleanly when re-run with `-Force` (or
  by deleting the old files first).
- **Future platforms** plug in by adding their own primary instruction file and,
  if they have a native subagent convention, adding subagent files at that
  convention's path. The pattern is documented here.

## Status

`active` — adopted 2026-05-05. Supersedes the previous "CLAUDE.md is a thin
pointer" approach, which is no longer in effect.
