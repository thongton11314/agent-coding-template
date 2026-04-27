# AI Development Framework — Schema

This file defines conventions, structure, and workflows for the AI development agent.
Read this file at the start of every session.

---

## Purpose

This framework provides **persistent context** for AI-assisted development. It combines:
- **Knowledge management** — ingest documents, research, and references into a structured wiki.
- **Codebase awareness** — track architecture decisions, module contracts, conventions, and change history so the AI never loses context as the project grows.

**Before** any code or document operation, the AI reads the wiki to stay consistent.
**After** any operation, the AI updates the wiki to preserve context for future sessions.

---

## Terminology

- **Workflows** (1–11) — operational procedures for managing knowledge and code (ingest, query, lint, cleanup, etc.). Defined in this file.
- **Skills** — modular capabilities the developer agent uses: plan, implement, test, wiki-sync, review, commit.
- **Post-Change Pipeline** — the mandatory 5-step sequence (wiki → sync gate → tests → README → commit) that runs after every code change.
- **Sync Gate** — Workflow 9: bidirectional code↔wiki verification with a Code-Wiki Mapping Table.
- **Brownfield** — adoption of the framework on an already-running codebase (Workflow 11).

---

## Agent Model

This framework uses a **single developer agent** with modular skills, plus a
**read-only exploration agent** for searching and answering questions.

### Developer Agent

The developer agent handles all code and wiki changes. It operates through six skills:

| Skill | Purpose | When Used |
|-------|---------|-----------|
| **Plan** | Read requirements, identify affected wiki pages, break work into tasks with verify steps | Before any code change (Workflow 4) |
| **Implement** | Write code following conventions, match existing patterns, create tests | During code changes |
| **Test** | Run test suite, verify changes, fix failures | Post-Change Pipeline Step 3 |
| **Wiki Sync** | Update wiki pages, run Sync Gate, maintain index/log/overview | Post-Change Pipeline Steps 1–2 |
| **Review** | Lint wiki, check code↔wiki consistency, flag contradictions | Workflow 8, Workflow 9 |
| **Clean** | Safely delete orphan/deprecated/unused wiki pages | Workflow 8 (cleanup mode) |
| **Commit** | Stage files, write structured commit messages, push to remote | Post-Change Pipeline Step 5 |

The agent applies all skills in sequence during the Post-Change Pipeline. Skills are
not separate executables — they are documented capabilities that guide the agent's
behavior.

### Exploration Agent

A read-only agent for searching the codebase and answering questions. It never
modifies files, runs commands, or updates the wiki.

---

## Directory Structure

```
src/                  # Application source code
  frontend/           # UI code (when the app has a user interface)
  backend/            # Server/API code (when the app has a server)
  cli/                # CLI scripts (when the app has no backend server)
raw/                  # Immutable source documents (articles, papers, specs, data)
  assets/             # Downloaded images and attachments
wiki/                 # AI-maintained pages — never edit manually
  sources/            # One summary page per ingested document
  entities/           # People, orgs, products, tools, services
  concepts/           # Ideas, frameworks, patterns, theories
  analyses/           # Comparisons, syntheses, research outputs
  architecture/       # System design, component maps, data flows
  decisions/          # Architecture Decision Records (ADRs)
  conventions/        # Coding standards, naming rules, project patterns
  modules/            # One page per module/component/service
  deviations.md       # Audit trail of spec-vs-code divergences
  index.md            # Master catalog of all wiki pages
  log.md              # Chronological record of all operations
  overview.md         # High-level synthesis (knowledge + system state)
scripts/              # Setup, validation, and maintenance scripts
AGENTS.md             # This file — schema and conventions
```

### Source Code Layout

When creating an application, the agent organizes `src/` based on the project type:

- **Full-stack app** (has UI + server) → `src/frontend/` + `src/backend/`
- **API-only app** (server, no UI) → `src/backend/`
- **Frontend-only app** (UI, no server) → `src/frontend/`
- **CLI/script app** (no server, no UI) → `src/cli/`

The agent creates these subdirectories when the user requests application code.
The setup script only creates the empty `src/` directory.

---

## Page Conventions

### Frontmatter

Every wiki page must start with YAML frontmatter:

```yaml
---
title: "Page Title"
type: source | entity | concept | analysis | architecture | decision | convention | module | overview
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
sources: []           # raw documents this page draws from
related: []           # related wiki pages (wikilink targets)
source_paths: []      # optional — repo-relative code paths this page documents
                      # (used by the cleanup workflow to detect stale pages)
status: active | draft | deprecated | superseded | spec | verified
---
```

> `source_paths` is optional but strongly recommended on `module`, `architecture`, and `convention`
> pages. It lets the validator flag wiki pages whose underlying code has been removed, so
> documentation does not silently drift out of sync with the codebase.

### Content Format

- Use standard markdown with `[[wikilinks]]` for cross-references between wiki pages.
- Use `> [!note]` callouts for editorial commentary or open questions.
- Use `> [!contradiction]` callouts when new data conflicts with existing claims.
- Use `> [!breaking]` callouts when a change breaks existing contracts or conventions.
- Headings: `##` for major sections, `###` for subsections. Reserve `#` for the page title only.
- Keep paragraphs concise — prefer bullet points for factual claims.
- Cite sources inline: `(Source: [[source-page-name]])`.

### Naming

- Filenames: lowercase, hyphenated. E.g. `machine-learning.md`, `user-auth-service.md`.
- Source pages: named after the source document.
- Entity pages: named after the entity.
- Module pages: named after the module/component.
- Decision pages: numbered. E.g. `adr-001-use-typescript.md`.
- Convention pages: named by topic. E.g. `error-handling.md`, `naming-conventions.md`.

---

## Workflows

### Knowledge Workflows

#### 1. Ingest a Source

When the user adds a new file to `raw/` and asks to ingest it:

1. **Read** the source document in full.
2. **Discuss** key takeaways with the user (3-5 bullet points). Wait for confirmation before proceeding.
3. **Create** a source summary page in `wiki/sources/`.
   - Include: title, author, date, key claims, notable quotes, relevance to existing wiki.
4. **Update** existing pages:
   - Add/revise relevant entity pages in `wiki/entities/`.
   - Add/revise relevant concept pages in `wiki/concepts/`.
   - Flag contradictions with `> [!contradiction]` callouts on affected pages.
   - Add `[[wikilinks]]` cross-references on all touched pages.
5. **Update** `wiki/index.md` — add entries for any new pages, update summaries for modified pages.
6. **Update** `wiki/overview.md` if the source materially changes the high-level synthesis.
7. **Append** to `wiki/log.md`.

#### 2. Query the Wiki

When the user asks a question:

1. **Read** `wiki/index.md` to identify relevant pages.
2. **Read** the relevant pages.
3. **Synthesize** an answer with inline citations: `(Source: [[page-name]])`.
4. **Offer** to file the answer as a new analysis page in `wiki/analyses/` if it's substantive.

#### 3. Create Analysis

When the user asks for a comparison, synthesis, or deep-dive:

1. **Gather** relevant wiki pages.
2. **Generate** the analysis as a new page in `wiki/analyses/`.
3. **Cross-reference** the analysis from relevant entity/concept pages.
4. **Update** `wiki/index.md`.
5. **Append** to `wiki/log.md`.

### Code Workflows

#### 4. Before Any Code Change

Before writing, modifying, or deleting code:

1. **Read** `wiki/index.md` to locate relevant module, architecture, decision, and convention pages.
2. **Read** the relevant pages to understand:
   - Existing patterns and conventions (`wiki/conventions/`).
   - Module contracts and dependencies (`wiki/modules/`).
   - Architecture constraints and data flows (`wiki/architecture/`).
   - Past decisions and their rationale (`wiki/decisions/`).
3. **Follow** established patterns. If the change conflicts with existing conventions, flag it to the user before proceeding.
4. **Apply Coding Discipline P1 — Think Before Coding** (see Guiding Principles). Name the interpretation you're acting on, state assumptions explicitly, and ask for clarification rather than guessing. For multi-step work, also draft a P4 plan (`N. [Step] → verify: [check]`) before writing code.

#### 5. After Any Code Change

After completing a code create/update/delete operation:

1. **Update module pages** (`wiki/modules/`) — reflect new exports, changed interfaces, added/removed dependencies.
2. **Update architecture pages** (`wiki/architecture/`) — if the change affects system design, data flows, or component relationships.
3. **Update convention pages** (`wiki/conventions/`) — if a new pattern was introduced or an existing one was modified.
4. **Create a decision record** (`wiki/decisions/`) — if the change involved a non-trivial architectural or design choice.
5. **Flag contradictions** — if the change conflicts with documented patterns, add `> [!breaking]` callouts on affected pages.
6. **Update** `wiki/index.md` for any new or modified pages.
7. **Append** to `wiki/log.md`.
8. **Run the Sync Gate** (Workflow 9) before marking the change complete.

#### 6. Register a Module

When a new module, component, or service is created:

1. **Create** a module page in `wiki/modules/` with:
   - Purpose and responsibility.
   - Public interface (exports, APIs, events).
   - Dependencies (what it imports/consumes).
   - Dependents (what depends on it) — update those module pages too.
   - Key design decisions and constraints.
2. **Update** `wiki/architecture/` pages to show the new component in the system.
3. **Cross-reference** from relevant concept and entity pages.
4. **Update** `wiki/index.md`.
5. **Append** to `wiki/log.md`.

#### 7. Record a Decision

When a design or architecture decision is made:

1. **Create** an ADR page in `wiki/decisions/` with:
   - Context — what problem or need prompted the decision.
   - Options considered — alternatives that were evaluated.
   - Decision — what was chosen and why.
   - Consequences — trade-offs, risks, follow-up actions.
   - Status — `active`, `superseded`, or `deprecated`.
2. **Cross-reference** from affected module, architecture, and convention pages.
3. **Update** `wiki/index.md`.
4. **Append** to `wiki/log.md`.

### Development Discipline Protocols

#### Post-Change Pipeline (mandatory after every code change)

After completing any code create/update/delete, execute all 5 steps in order.
No step may be skipped, even for "small" changes.

> Apply the **Coding Discipline** principles throughout (see Guiding Principles).
> Especially **Surgical Changes** (P3) when editing, and **Goal-Driven Execution**
> (P4) when defining what "done" means for each step.

**Step 1 — Update the Wiki**
- Update every affected module page in `wiki/modules/`.
- Update `wiki/architecture/` if system design or data flows changed.
- Create an ADR in `wiki/decisions/` for any non-trivial design choice.
- Add `> [!breaking]` callouts on pages affected by breaking changes.
- Always append to `wiki/log.md`. Always update `wiki/index.md`.

**Step 2 — Sync Gate**
Run Workflow 9. Both passes must succeed before proceeding.

**Step 3 — Run Tests**
- Run the project's full test suite.
- Report pass/fail. On failure, fix code (not tests) and re-run before continuing.
- For UI changes, rebuild the frontend bundle first.

**Step 4 — Update README.md**
- If the change affects the architecture diagram, Quick Start steps, API surface,
  environment variables, or configuration — update `README.md` accordingly.

**Step 5 — Commit and Push**
- Stage all changed files: code + wiki + tests.
- Write a structured commit message:
  ```
  <type>: <summary>

  - <file>: <what changed and why>
  - wiki/<page>: <what was updated>
  ```
  Types: `feat` | `fix` | `refactor` | `test` | `wiki` | `chore`
- Push to the current branch and confirm the remote SHA.

#### Dependency Impact Protocol

When modifying any module:
1. Search for all importers of that module.
2. Check if the public interface changed (signatures, return shapes, exports).
3. If yes — update every caller and their wiki module pages.
4. If a breaking change — add `> [!breaking]` callouts on all affected wiki pages.

#### Configuration Change Protocol

When project configuration files change (model config, environment variables, API keys):
1. Update every wiki page that names or describes the changed values.
2. Propagate to architecture pages, module pages, and README where applicable.
3. Register any spec-vs-code gap in `wiki/deviations.md`.

### Maintenance Workflows

#### 8. Lint / Health Check

When the user asks to lint or review the wiki:

1. **Scan** all wiki pages for:
   - Orphan pages (no inbound `[[wikilinks]]`).
   - Broken `[[wikilinks]]` (target page doesn't exist).
   - Stale claims superseded by newer sources or code changes.
   - Unresolved `> [!contradiction]` or `> [!breaking]` callouts.
   - Modules in code that lack wiki pages.
   - Convention pages that don't match actual code patterns.
   - Missing or incomplete frontmatter fields.
   - Deprecated decisions still referenced as active.
   - Pages with `status: deprecated` or `status: superseded`.
2. **Report** findings as a checklist.
3. **Fix** issues with user approval.
4. **Append** to `wiki/log.md`.

##### Wiki Cleanup (Clean Skill)

When the user asks to "clean the wiki", "delete orphans", "remove unused pages",
or "prune the wiki", run the cleanup procedure:

1. **Run the lint scan** (steps above) to produce the full findings list.
2. **Identify deletable pages** — a page is safe to delete only if ALL of these are true:
   - It is an orphan (no inbound `[[wikilinks]]` from any active page), OR
     it has `status: deprecated` or `status: superseded`.
   - It is NOT one of the protected pages: `index`, `log`, `overview`, `deviations`, `registry`.
   - It is NOT referenced by any file in `src/`, `scripts/`, or root config files.
   - No active (non-deprecated) wiki page depends on it via `related:` frontmatter.
3. **Present the Cleanup Proposal Table** to the user:

```markdown
| Page | Path | Reason | Safe to Delete? |
|------|------|--------|-----------------|
| page-name | wiki/category/page-name.md | orphan / deprecated / superseded | ✅ / ❌ (reason) |
```

4. **Wait for approval.** Never delete without explicit user confirmation.
5. **Delete approved pages** from disk.
6. **Scrub references** to deleted pages:
   - Remove rows from `wiki/index.md`.
   - Remove from `related:` frontmatter arrays in any remaining pages.
   - Remove broken `[[wikilinks]]` in body text of remaining pages.
7. **Run `scripts/validate-wiki.ps1`** (or `.sh`) to confirm no broken links remain.
8. **Append** a cleanup entry to `wiki/log.md`:

```markdown
## [YYYY-MM-DD] clean | Wiki Cleanup
- **Operation**: clean
- **Pages deleted**: page1, page2, ...
- **Summary**: Removed N orphan/deprecated pages. No active references broken.
```

##### Safety Rules

- **Never delete pages that active code depends on.** If `source_paths` in any active
  module page references a path, the module page is not deletable.
- **Never delete without the proposal table.** The user must see exactly what will
  be removed and confirm.
- **Re-validate after deletion.** The final `validate-wiki` run is mandatory — if
  it fails, undo the deletion and report the issue.
- **Log everything.** Every deletion is recorded in `wiki/log.md`.
- **This skill only removes wiki pages.** It never deletes source code, scripts,
  config files, or raw/ documents.

#### 9. Sync Gate (Bidirectional Verification)

Required after every code change, before marking the change complete. This ensures code and wiki stay in sync in **both directions**. The Sync Gate is the verification loop for **Goal-Driven Execution** (Coding Discipline P4) at the change-set level: both passes must succeed or the change is not done.

##### Step 1 — Code-Wiki Mapping Table

Output a visible table listing every file touched:

```markdown
| Change | Type | Wiki Page Updated | Verified |
|--------|------|-------------------|----------|
| (every file created/modified/deleted) | create/modify/delete | (wiki page) | ✅/❌ |
```

Rules:
- Every row must map to a wiki page. If none exists, create one or update an existing one.
- The table must be shown to the user. Do not skip it.

##### Step 2 — Pass 1: Code → Wiki (every code artifact has documentation)

- List every file created, modified, or deleted in the change.
- For each, confirm it appears in the relevant wiki module page's directory listing.
- For each new route/endpoint, confirm it appears in the architecture routes page.
- For each new nav item, confirm it appears in the information architecture page.

##### Step 3 — Pass 2: Wiki → Code (every wiki claim is true)

- Read the directory listings in affected wiki module pages.
- Verify every listed file actually exists. If not: remove it or mark `(planned — not yet implemented)`.
- Verify route tables match registered routes.
- Verify navigation/sitemap matches actual routing config.

##### Output

A pass/fail summary for each direction. Both must pass before the change is considered complete.

##### Deviation Protocol

When implementation differs from spec:

1. Add `> [!note] Deviation: {description}` on the affected wiki page.
2. Update the directory listing to reflect reality, not aspiration.
3. Append an entry to `wiki/deviations.md`:

```markdown
| Date | Wiki Page | Spec Claim | Actual Implementation | Reason |
|------|-----------|------------|----------------------|--------|
```

#### 10. Deprecation & Cleanup Sync

Required whenever code is **deleted, renamed, moved, or materially refactored**. This keeps the wiki honest when the underlying codebase shrinks or shifts, and enforces **deprecation over deletion** so history is preserved.

##### Triggers

- A file, module, service, endpoint, or public symbol is removed.
- A file or module is renamed or moved to a new path.
- A dependency, integration, or external contract is retired.
- A documented pattern, convention, or decision no longer reflects the code.

##### Step 1 — Detect Affected Wiki Pages

1. Collect the list of repo-relative paths that were deleted, renamed, or moved.
2. Scan wiki pages for any of the following signals:
   - `source_paths:` frontmatter entries that reference a path no longer present in the repo.
   - Body references (code fences, inline backticks, `[[wikilinks]]`, or plain text) naming a removed file, module, route, or symbol.
   - ADRs (`wiki/decisions/`) whose `Decision` or `Consequences` depend on the removed code.
3. Run `scripts/validate-wiki.ps1` (or `.sh`) — the `source_paths` check emits non-fatal warnings for every stale path.

##### Step 2 — Classify Each Affected Page

For each page flagged in Step 1, classify the change:

| Classification | Meaning | Required Action |
|---------------|---------|-----------------|
| **Relocated** | Code moved but behavior unchanged | Update `source_paths` + body references to new path. Bump `updated`. |
| **Superseded** | Replaced by a different module/pattern | Set `status: superseded`. Add `> [!breaking]` callout linking to the replacement page. Bump `updated`. |
| **Deprecated** | Removed without a direct replacement | Set `status: deprecated`. Add `> [!deprecated]` callout with date + reason. Bump `updated`. |
| **Still accurate** | Page documents broader concept unaffected by the change | No status change. Remove stale path references only. |

##### Step 3 — Propose Changes (Approval Gate)

Before writing, present the user with a **Deprecation Proposal Table**:

```markdown
| Wiki Page | Classification | Proposed Status | Callout | Notes |
|-----------|---------------|-----------------|---------|-------|
```

Wait for approval. **Never silently overwrite or hard-delete a wiki page.** Lifecycle the page instead — `deprecated` and `superseded` pages stay on disk as historical record.

##### Step 4 — Apply Approved Changes

1. Flip `status` in frontmatter. Bump `updated` to today.
2. Add the callout at the top of the page body:
   - `> [!breaking] Superseded YYYY-MM-DD by [[replacement-page]]. Reason: ...`
   - `> [!deprecated] Deprecated YYYY-MM-DD. Reason: ...`
3. Update or remove stale `source_paths` entries.
4. Update `wiki/index.md` — mark the row as `deprecated` / `superseded` in the status column (if present) and move to an archived section if the index has one.
5. If the change alters documented behavior rather than just paths, append a row to `wiki/deviations.md`.
6. Append an entry to `wiki/log.md` with operation `deprecate` or `supersede`.

##### Step 5 — Re-run Sync Gate

After applying Step 4, run Workflow 9 (Sync Gate) to confirm the code-wiki mapping table reflects the deprecation and that no active page still claims the removed code exists.

##### Principles

- **Deprecation over deletion.** Pages are never hard-deleted by the agent. Only the user can remove historical pages manually.
- **Callouts are mandatory.** A status flip without a dated callout is incomplete.
- **Generic detection.** This workflow relies only on frontmatter (`source_paths`, `status`) and textual references — no language-specific parsers — so it works for any stack.

#### 11. Brownfield Onboarding

When adopting the framework on an already-running codebase:

1. **Run lint** (Workflow 8) to discover what wiki coverage is missing.
2. **Back-fill module pages** (`wiki/modules/`) — one page per existing module/service/component, written from the live code.
3. **Back-fill architecture pages** (`wiki/architecture/`) — describe the actual running system, not an aspirational design.
4. **Write ADRs** for the top 3–5 most consequential past decisions that shaped the codebase. Use the standard ADR template.
5. **Populate conventions** (`wiki/conventions/`) — document the coding patterns already in use so the AI follows them.
6. **Register ADRs** in `wiki/decisions/registry.md` — prevents future number collisions.
7. **Baseline `wiki/deviations.md`** — document any known gaps between the wiki and reality.
8. **Begin development** using the existing codebase as the source of truth.

> [!note] For brownfield projects, wiki/overview.md should be written from the actual system state, not the aspirational one. Mark any unverified claims as `(unverified — pending audit)`.

---

## Log Format

Each entry in `wiki/log.md` follows this format:

```markdown
## [YYYY-MM-DD] operation | Title
- **Operation**: ingest | query | lint | analysis | update
- **Pages touched**: [[page1]], [[page2]], ...
- **Summary**: One-line description of what changed.
```

---

## Index Format

Each entry in `wiki/index.md` follows this format:

```markdown
### Category Name

| Page | Summary | Sources | Updated |
|------|---------|---------|---------|
| [[page-name]] | One-line summary | 2 | 2026-04-13 |
```

---

## Guiding Principles

These are the non-negotiable defaults for every session. **Wiki Discipline** governs
how knowledge is filed and maintained. **Coding Discipline** governs how the agent
reasons about and writes code. Both apply together on every change.

### Wiki Discipline

1. **The wiki is the product.** Chat is ephemeral; the wiki is permanent. Anything valuable should be filed.
2. **Compound, don't repeat.** When new data arrives, update existing pages — don't create duplicates.
3. **Flag conflicts explicitly.** Contradictions are valuable information. Never silently overwrite.
4. **Cross-reference aggressively.** The value of the wiki grows with its connections.
5. **Human curates, LLM maintains.** The user decides what to ingest and what questions to ask. The LLM does all the filing, linking, and bookkeeping.

### Coding Discipline

These four principles apply to every code operation — Workflow 4 (before the change),
Workflow 5 (after the change), and every step of the Post-Change Pipeline. They are
safeguards against the LLM failure modes of silent assumption, overengineering,
scope creep, and unverifiable "done."

#### 1. Think Before Coding

> Don't assume. Don't hide confusion. Surface tradeoffs.

LLMs often pick an interpretation silently and run with it. This principle forces
explicit reasoning:

- **State assumptions explicitly** — If uncertain, ask rather than guess.
- **Present multiple interpretations** — Don't pick silently when ambiguity exists.
- **Push back when warranted** — If a simpler approach exists, say so.
- **Stop when confused** — Name what's unclear and ask for clarification.

Applied in Workflow 4 (before any code change): after reading the relevant wiki pages,
name the interpretation you're acting on and the assumptions you're making before
writing code.

#### 2. Simplicity First

> Minimum code that solves the problem. Nothing speculative.

Combat the tendency toward overengineering:

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If 200 lines could be 50, rewrite it.

The test: Would a senior engineer say this is overcomplicated? If yes, simplify.

#### 3. Surgical Changes

> Touch only what you must. Clean up only your own mess.

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that **your** changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request. This
principle also bounds the Sync Gate (Workflow 9) — the Code-Wiki Mapping Table
should only contain files you deliberately touched.

#### 4. Goal-Driven Execution

> Define success criteria. Loop until verified.

Transform imperative tasks into verifiable goals:

| Instead of...    | Transform to...                                                |
|------------------|----------------------------------------------------------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass"          |
| "Fix the bug"    | "Write a test that reproduces it, then make it pass"           |
| "Refactor X"     | "Ensure tests pass before and after"                           |

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the LLM loop independently. Weak criteria ("make it
work") require constant clarification. The Post-Change Pipeline's Step 3 (Run Tests)
is the final verification loop — but every earlier step should also name its own
check.
