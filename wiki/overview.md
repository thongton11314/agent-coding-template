---
title: "Overview"
type: overview
created: 2026-04-13
updated: 2026-04-27
tags: [overview, synthesis]
sources: []
status: active
---

# Overview

High-level synthesis across all knowledge and the codebase. This page evolves as sources are ingested and the system grows.

---

## Current State

The framework provides two core capabilities:
1. **Knowledge management** — ingest sources into a structured wiki with cross-references.
2. **AI-assisted development** — a single developer agent with modular skills (plan, implement, test, wiki-sync, review, commit) enforces the Post-Change Pipeline on every code change.

One source ingested covering REST API design conventions.

## Key Themes

- **API consistency** — standardized URL structures, HTTP methods, and status codes.
- **Developer experience** — structured errors, pagination, rate limiting, and auth patterns.
- **Pragmatism over purity** — URL versioning over header-based, cursor pagination over offset.
- **Single-agent architecture** — one developer agent with skill-based capabilities instead of multiple specialized agents.
- **Wiki as single source of truth** — all deliverables are wiki artifacts, not ephemeral chat.
- **Platform-agnostic** — works with VS Code (Copilot), Claude Code, and OpenAI Codex.

## System Architecture

The agent model uses a single developer agent with six skills:
- **Plan** — read requirements, break into tasks
- **Implement** — write code following conventions
- **Test** — run and write tests
- **Wiki Sync** — maintain wiki, run Sync Gate
- **Review** — lint wiki, check consistency
- **Commit** — stage, commit, push

Source code is organized in `src/` with `frontend/`, `backend/`, or `cli/` subdirectories based on project type.

## Active Conventions

*Coding patterns and standards will be listed here as they are established.*

## Open Questions

*Questions will be tracked here as they arise during research or development.*

## Evolving Thesis

*The central thesis or narrative will be developed here as patterns emerge.*
