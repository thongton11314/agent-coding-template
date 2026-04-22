# Claude Code Instructions

Read `AGENTS.md` in full before every session. It contains the complete schema, conventions, and workflows for this project.

## Quick Rules
1. Never modify files in `raw/` — sources are immutable.
2. Before any code change — read relevant wiki pages (modules, conventions, decisions, architecture).
3. After any code change — execute the mandatory 5-step post-change pipeline:
   a. Update wiki (modules, architecture, ADRs, log.md, index.md)
   b. Run Sync Gate (Workflow 10) — Code-Wiki Mapping Table + bidirectional verification
   c. Run tests — fix code on failure before proceeding
   d. Update README.md if API surface or architecture changed
   e. Commit and push with structured commit message
4. Always update `wiki/index.md` and `wiki/log.md` after any wiki operation.
5. Use YAML frontmatter on every wiki page.
6. Use `[[wikilinks]]` for cross-references.
7. Flag contradictions with `> [!contradiction]` — never silently overwrite.
8. Flag breaking changes with `> [!breaking]` callouts.
9. New modules → register in `wiki/modules/` and update architecture pages.
10. Non-trivial design choices → record in `wiki/decisions/` as an ADR; register number in `wiki/decisions/registry.md`.
11. Discuss before ingesting — present key takeaways and wait for user confirmation.
12. Sync Gate is mandatory after every code change (Workflow 10). Both passes must succeed.
13. Spec-vs-code divergences → log in `wiki/deviations.md` and add `> [!note] Deviation:` callouts.
14. Security checklist → run `SECURITY.md` checklist for any change touching auth, API keys, queries, file paths, or user input.
15. Brownfield onboarding → use Workflow 11 from AGENTS.md when adopting the framework on an existing codebase.
