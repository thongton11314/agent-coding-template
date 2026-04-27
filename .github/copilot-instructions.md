# Copilot Instructions

## Agent Routing — FIRST RULE

**For any request that involves creating features, fixing bugs, refactoring code,
modifying modules, updating the wiki, adding tests, editing configuration, or
changing any file in `src/`, `tests/`, `wiki/`, `config/`, or `scripts/`
— delegate the entire task to the `agent-developer` agent.**

Use `agent-developer` automatically. Do not ask the user whether to use it.

Triggers (non-exhaustive):
- "add", "create", "implement", "build" → any code or feature
- "fix", "debug", "patch", "resolve" → any bug or error
- "refactor", "rename", "move", "clean up" → any code structure change
- "update wiki", "update docs", "update README", "update architecture"
- "add test", "write test", "generate test"
- "update", "change", "modify", "edit" → any file in the codebase

For **read-only exploration** — "what does X do?", "where is Y?", "find all Z",
"show me W" — use the `Explore` agent.

Only answer directly (without delegating) for pure conceptual questions that
require no file access.

---

## Project Type
This is an **LLM Wiki** — a personal knowledge base maintained by an LLM agent.

## Key Files
- `AGENTS.md` — Full schema, conventions, and workflows. **Read this first on every session.**
- `SECURITY.md` — Ongoing security checklist (applied per-change).
- `wiki/index.md` — Master catalog of all wiki pages.
- `wiki/log.md` — Chronological operation log.
- `wiki/overview.md` — High-level synthesis.
- `wiki/decisions/registry.md` — ADR number registry (prevents collisions).

---

## Mandatory Post-Change Pipeline

**Every time any code or wiki change is made — without exception — execute all
5 steps before declaring the task complete.**

1. **Update the Wiki** — module pages, architecture, ADRs, log.md, index.md
2. **Sync Gate** — Code-Wiki Mapping Table + bidirectional verification (Workflow 9)
3. **Run Tests** — full test suite; fix code on failure before proceeding
4. **Update README.md** — if API surface, architecture, or Quick Start changed
5. **Commit and Push** — structured commit message; confirm remote SHA

---

## Core Rules
1. **Never modify files in `raw/`.** Sources are immutable.
2. **Always update `wiki/index.md` and `wiki/log.md`** after any wiki operation.
3. **Use YAML frontmatter** on every wiki page (see AGENTS.md for format).
4. **Use `[[wikilinks]]`** for cross-references between wiki pages.
5. **Flag contradictions** with `> [!contradiction]` callouts — never silently overwrite.
6. **Flag breaking changes** with `> [!breaking]` callouts on affected pages.
7. **Discuss before ingesting** — present key takeaways and wait for user confirmation.
8. **New modules** → register in `wiki/modules/` and update architecture pages.
9. **Non-trivial design choices** → record in `wiki/decisions/` as an ADR;
   register the ADR number in `wiki/decisions/registry.md`.
10. **Sync Gate is mandatory** after every code change (Workflow 9).
11. **Spec-vs-code divergences** → log in `wiki/deviations.md` and add
    `> [!note] Deviation:` callouts on affected pages.
12. **Security checklist** → run `SECURITY.md` checklist for any change touching
    auth, API keys, queries, file paths, or user input.

## Workflow Quick Reference

| Workflow | Trigger | Action |
|----------|---------|--------|
| **Ingest** | File added to `raw/` | Read → discuss → create/update wiki pages |
| **Query** | Question about content | Read `wiki/index.md` → find pages → synthesize answer |
| **Lint** | Health check request | Scan for orphans, broken links, stale claims → report → fix with approval |
| **Analysis** | Comparison or deep-dive | Gather pages → generate `wiki/analyses/` page → update index |
| **Brownfield** | Existing codebase | Run Workflow 11 from AGENTS.md → back-fill wiki → begin development |
