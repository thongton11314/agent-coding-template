# Claude Code Instructions

Read `AGENTS.md` in full before every session. It contains the complete schema, conventions, and workflows for this project.

## Quick Rules
1. Never modify files in `raw/` — sources are immutable.
2. Before any code change — read relevant wiki pages (modules, conventions, decisions, architecture).
3. After any code change — update affected wiki pages and append to `wiki/log.md`.
4. Always update `wiki/index.md` and `wiki/log.md` after any wiki operation.
5. Use YAML frontmatter on every wiki page.
6. Use `[[wikilinks]]` for cross-references.
7. Flag contradictions with `> [!contradiction]` — never silently overwrite.
8. Flag breaking changes with `> [!breaking]` callouts.
