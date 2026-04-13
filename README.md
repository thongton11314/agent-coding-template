# AI Development Framework

A reusable template for AI-assisted development. The AI maintains a persistent wiki that tracks both knowledge (documents, research) and codebase context (architecture, modules, decisions, conventions) — so it never loses context as your project grows.

## Quick Start

### Option A: New Project (GitHub Template)

Click **"Use this template"** on the [GitHub repo](https://github.com/YOUR_USERNAME/agent-coding-template) → creates a new repo with the framework pre-loaded.

### Option B: Existing Project (Setup Script)

**Linux / macOS:**
```bash
curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/agent-coding-template/main/scripts/setup.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/agent-coding-template/main/scripts/setup.ps1 | iex
```

The script creates all directories and files, skipping any that already exist in your project.

### Option C: Tell Your AI to Install It

In any AI chat inside your project, say:

> "Clone github.com/YOUR_USERNAME/agent-coding-template and run `scripts/setup.ps1` (or `setup.sh`) to install the AI development framework into this project."

The AI runs the setup script → framework is installed → AI reads `AGENTS.md` → ready.

### Supported AI Tools

Once the framework files are in your project, the AI tool auto-detects its config:

   | AI Tool | Config File | Auto-loaded? |
   |---------|------------|:---:|
   | GitHub Copilot | `.github/copilot-instructions.md` | Yes |
   | OpenAI Codex | `AGENTS.md` | Yes |
   | Claude Code | `CLAUDE.md` | Yes |
   | Cursor | `.cursorrules` | Yes |
   | Windsurf | `.windsurfrules` | Yes |
   | Cline / Roo Code | `.clinerules` | Yes |

All config files point to `AGENTS.md` as the single source of truth.

## How It Works

```mermaid
flowchart TD
    subgraph Input
        U1["You add source to raw/"]
        U2["You request code change"]
    end

    subgraph Knowledge Workflow
        U1 --> R1["AI reads source"]
        R1 --> D1["AI discusses key takeaways"]
        D1 --> W1["AI creates/updates wiki pages\n(sources, entities, concepts)"]
    end

    subgraph Code Workflow
        U2 --> R2["AI reads wiki first\n(conventions, architecture,\nmodules, decisions)"]
        R2 --> C1["AI makes the change\n(consistent with existing patterns)"]
        C1 --> W2["AI updates wiki after\n(modules, architecture, log)"]
    end

    subgraph Wiki
        W1 --> IDX["wiki/index.md\nwiki/log.md\nwiki/overview.md"]
        W2 --> IDX
    end

    style Input fill:#e8f4fd,stroke:#2196F3
    style Wiki fill:#e8f5e9,stroke:#4CAF50
```

The wiki compounds over time. Every source ingested and every code change enriches it.

## Structure

```
raw/                  # Your source documents (immutable)
wiki/                 # AI-maintained pages (don't edit manually)
  sources/            # Summaries of ingested documents
  entities/           # People, orgs, products, tools
  concepts/           # Ideas, frameworks, patterns
  analyses/           # Comparisons, syntheses
  architecture/       # System design, data flows
  modules/            # One page per component/service
  decisions/          # Architecture Decision Records
  conventions/        # Coding standards, project patterns
  index.md            # Master catalog of all pages
  log.md              # Chronological operation record
  overview.md         # High-level synthesis
AGENTS.md             # Schema — the single source of truth
scripts/              # Validation and maintenance tools
```

## Key Commands

| Action | What to Say |
|--------|------------|
| Ingest a source | "Ingest `raw/my-article.md`" |
| Ask a question | "What does the wiki say about X?" |
| Health check | "Lint the wiki" |
| Create analysis | "Compare X and Y across sources" |

## Validation

Run the wiki health check script:

**Windows (PowerShell):**
```powershell
pwsh scripts/validate-wiki.ps1
```

**Linux / macOS (Bash):**
```bash
bash scripts/validate-wiki.sh
```

Checks for: missing frontmatter, broken `[[wikilinks]]`, orphan pages, filename conventions, index coverage.

## Example

The template ships with one ingested example:

- **Source**: `raw/rest-api-design-best-practices.md`
- **Generated pages**: source summary, 3 concept pages (REST, API Design Patterns, HTTP Status Codes), 1 entity page (Sarah Chen)
- **Updated**: `wiki/index.md`, `wiki/log.md`, `wiki/overview.md`

This shows exactly what the AI produces from a single ingest operation.

## Customization

All conventions live in `AGENTS.md`. Modify it to:
- Add new page types or wiki categories.
- Change frontmatter fields.
- Adjust workflows for your team's needs.
- Add domain-specific conventions.

The editor config files (`.cursorrules`, `CLAUDE.md`, etc.) all point to `AGENTS.md` — update once, works everywhere.

