# Copilot Instructions

## Project Type
This is an **LLM Wiki** — a personal knowledge base maintained by an LLM agent.

## Key Files
- `AGENTS.md` — Full schema, conventions, and workflows. **Read this first on every session.**
- `wiki/index.md` — Master catalog of all wiki pages.
- `wiki/log.md` — Chronological operation log.
- `wiki/overview.md` — High-level synthesis.

## Core Rules
1. **Never modify files in `raw/`.** Sources are immutable.
2. **Always update `wiki/index.md` and `wiki/log.md`** after any wiki operation.
3. **Use YAML frontmatter** on every wiki page (see AGENTS.md for format).
4. **Use `[[wikilinks]]`** for cross-references between wiki pages.
5. **Flag contradictions** with `> [!contradiction]` callouts — never silently overwrite.
6. **Discuss before ingesting** — present key takeaways and wait for user confirmation.

## Workflow Quick Reference
- **Ingest**: User adds file to `raw/` → agent reads → discusses → creates/updates wiki pages.
- **Query**: Agent reads `wiki/index.md` → finds relevant pages → synthesizes answer.
- **Lint**: Agent scans for orphans, broken links, stale claims → reports → fixes with approval.
- **Analysis**: Agent gathers pages → generates analysis in `wiki/analyses/` → updates index.

## Code-Aware Rules
7. **Before any code change** — read relevant wiki pages (modules, conventions, decisions, architecture) to stay consistent.
8. **After any code change** — update affected wiki pages (modules, architecture, conventions) and log the change.
9. **New modules** → register in `wiki/modules/` and update architecture pages.
10. **Non-trivial design choices** → record in `wiki/decisions/` as an ADR.
11. **Breaking changes** → flag with `> [!breaking]` callouts on affected pages.
