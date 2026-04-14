{APP_NAME} — AGENTIC ORCHESTRATION SPEC

This document defines a multi-agent orchestration system for designing, specifying,
and building {APP_NAME}. Eight agents collaborate through a phased pipeline with
explicit contracts, handoffs, review loops, and quality gates.

Instructions: Replace all {PLACEHOLDER} tokens with your project-specific values.
Sections marked [CUSTOMIZE] require domain-specific content.
Sections marked [FRAMEWORK] are reusable as-is.

================================================================================
SECTION 1 — FRAMEWORK DEPENDENCY [FRAMEWORK]
================================================================================

This project uses the AI Development Framework from:
https://github.com/thongton11314/agent-coding-template

The framework provides persistent context across sessions via a structured wiki.
Before starting any work, ensure the framework is installed in this project.
If it is not installed, run the setup script:

  PowerShell:  irm https://raw.githubusercontent.com/thongton11314/agent-coding-template/main/scripts/setup.ps1 | iex

Key framework files:
- AGENTS.md — schema, conventions, and workflows (read at every session start)
- wiki/index.md — master catalog of all wiki pages
- wiki/log.md — chronological operation record
- wiki/overview.md — high-level project synthesis

Framework contract:
- Before any code or design work, read relevant wiki pages for prior decisions
- After completing any phase, persist outputs to the wiki
- Architecture goes to wiki/architecture/
- Module specs go to wiki/modules/
- Design decisions go to wiki/decisions/ as ADRs
- Coding conventions go to wiki/conventions/
- Domain concepts go to wiki/concepts/
- Update wiki/index.md and wiki/log.md after every operation

The original prompt specification lives in raw/prompt.md as an immutable source.

================================================================================
SECTION 2 — SESSION PROTOCOL [FRAMEWORK]
================================================================================

At the start of every session:
1. Read AGENTS.md for framework rules
2. Read wiki/index.md to see what exists
3. Read wiki/overview.md for current project state
4. Identify which phase to work on (check wiki/log.md for last completed phase)
5. Read any wiki pages relevant to the current phase

At the end of every session or phase:
1. Write all deliverables to the appropriate wiki directories
2. Update wiki/index.md with new and modified pages
3. Append to wiki/log.md with operation summary
4. Update wiki/overview.md if the project state changed materially
5. State clearly which phase was completed and which phase is next

If a session is interrupted mid-phase:
1. Write a checkpoint note to wiki/log.md listing completed and remaining items
2. The next session resumes from that checkpoint

================================================================================
SECTION 3 — PROJECT GOAL [CUSTOMIZE]
================================================================================

Build {APP_DESCRIPTION} with:

1. {CORE_EXPERIENCE_1}
2. {CORE_EXPERIENCE_2}
3. {KEY_FEATURE_1}
4. {KEY_FEATURE_2}
5. A simple, maintainable, production-ready MVP architecture
6. Source code hosted on GitHub

Hosting and deployment constraints:
- Source code repository is on GitHub
- CI/CD should use GitHub Actions
- The application must be deployable from the GitHub repository
- The tech stack must be compatible with GitHub-based workflows
  (e.g., npm/pip/dotnet-based build, containerizable if needed)
- Prefer tech stacks with strong GitHub ecosystem support
  (community, templates, Actions marketplace)

Data storage constraint: [CUSTOMIZE]
- Define your data persistence strategy here
- Options: database, file-based (markdown/JSON), cloud storage, etc.
- Specify the data directory layout if using file-based storage:
    data/{entity_type_1}/    — one file per record
    data/{entity_type_2}/    — grouped records
    data/settings.md         — application configuration
    data/cache/              — cached external API responses
    data/audit/              — change log entries (append-only)
- Define file format choices (markdown with YAML frontmatter, JSON, etc.)
- Data operations approach (ORM, raw SQL, file system read/write)
- Version history strategy (Git, database migrations, etc.)

================================================================================
SECTION 4 — GENERAL PRINCIPLES [FRAMEWORK]
================================================================================

- Keep the UX simple and professional
- Prefer clarity, structure, and trustworthiness
- Avoid over-engineering the MVP
- Make recommendations practical and implementable
- Explain tradeoffs clearly
- Optimize for maintainability and scalability from a clean foundation

[CUSTOMIZE — add domain-specific principles below]
- {DOMAIN_PRINCIPLE_1}
- {DOMAIN_PRINCIPLE_2}
- {DOMAIN_PRINCIPLE_3}

================================================================================
SECTION 5 — PRODUCT CONTEXT [CUSTOMIZE]
================================================================================

The application supports {N} core experiences:

A. {EXPERIENCE_A_NAME}
{EXPERIENCE_A_DESCRIPTION}

{EXPERIENCE_A_NAME} capabilities:
- {capability_1}
- {capability_2}
- {capability_3}
- ...

{PRIMARY_ENTITY} fields:
- {field_1}
- {field_2}
- {field_3}
- ...

B. {EXPERIENCE_B_NAME}
{EXPERIENCE_B_DESCRIPTION}

{EXPERIENCE_B_NAME} capabilities:
- {capability_1}
- {capability_2}
- {capability_3}
- ...

================================================================================
SECTION 6 — EXTERNAL DATA / API REQUIREMENTS [CUSTOMIZE]
================================================================================

[Define any external APIs, data sources, or third-party integrations here.
 Remove this section entirely if no external integrations are needed.]

{API_NAME} integration requirements:
- {requirement_1}
- {requirement_2}
- rate-limit-aware integration
- server-side API key protection
- caching strategy
- handling stale, missing, or invalid data
- visible "last updated" timestamps

================================================================================
SECTION 7 — AGENT DEFINITIONS [FRAMEWORK]
================================================================================

Eight agents operate in this system. Each has a defined scope, trigger conditions,
input/output contracts, available tools, and a quality gate.

--------------------------------------------------------------------------------
AGENT 0: ORCHESTRATOR [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Coordinates all agents, routes work, enforces phase gates,
               resolves conflicts.
  Trigger:     Session start, phase transition, conflict between agents,
               escalation request.
  Input:       wiki/log.md (last completed phase), wiki/overview.md (project state),
               all phase deliverables from upstream agents.
  Output:      Phase activation signal, agent assignments, conflict resolution
               decisions, phase completion confirmation.
  Tools:       File system (wiki read/write), session protocol execution.
  Quality gate: All required deliverables for a phase exist and pass review
                before the next phase is activated.
  Responsibilities:
    - Determine which phase to execute based on wiki/log.md
    - Assign lead agent and contributing agents for each phase
    - Route phase deliverables to reviewers
    - Collect review feedback and request revisions if needed
    - Resolve conflicts between agent recommendations (see CONFLICT RESOLUTION)
    - Enforce that no phase starts until the prior phase gate passes
    - Write phase completion records to wiki/log.md

--------------------------------------------------------------------------------
AGENT 1: PRODUCT STRATEGIST [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Define scope, priorities, tradeoffs, roadmap, and risk.
  Trigger:     Assigned by Orchestrator for Phases 1, 6.
  Input:       Project goal, general principles, product context (Sections 3-5).
  Output:      Executive summary, product vision, user roles, MVP scope definition,
               feature priority matrix, risk register, delivery roadmap.
  Artifacts:   wiki/analyses/mvp-scope.md, wiki/concepts/user-roles.md,
               wiki/analyses/risk-tradeoff-analysis.md,
               wiki/analyses/implementation-roadmap.md.
  Tools:       File system (wiki write), semantic search (prior ADRs).
  Quality gate: MVP scope is concrete (not generic), every feature is classified as
                MVP or future, assumptions are explicit, risks have mitigations.
  Responsibilities:
    - Define target users and their needs
    - Set MVP boundaries with clear in/out lists
    - Prioritize features using MoSCoW or similar
    - Identify business logic assumptions
    - Define roadmap phases with entry/exit criteria
    - Assess key product risks and tradeoffs
    - Record ADR-001: MVP scope boundaries

--------------------------------------------------------------------------------
AGENT 2: UX/UI DESIGNER [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Design layouts, flows, states, accessibility, and visual direction.
  Trigger:     Assigned by Orchestrator for Phase 2.
               Also reviews Phase 3 frontend spec.
  Input:       MVP scope (from Agent 1), product context, required features.
  Output:      Information architecture, user flows, UX design principles,
               page-by-page UX spec, wireframe-level layouts, design system.
  Artifacts:   wiki/architecture/information-architecture.md,
               wiki/conventions/design-system.md,
               wiki/modules/{experience_a}.md (UX spec),
               wiki/modules/{experience_b}.md (UX spec).
  Tools:       File system (wiki write).
  Quality gate: Every page has defined layout, empty state, loading state, error
                state. Accessibility patterns are specified. Flows cover happy path
                and error path. All designs stay within MVP scope.
  Responsibilities:
    - Create sitemap and information architecture
    - Design user flows for each experience
    - Define UX/UI principles for this project
    - Produce page-by-page UX specification (see Section 9)
    - Describe wireframe-level layouts for each page
    - Define design system (typography, spacing, color, components)
    - Record ADR-002: Design system and component library choice
  Visual direction: [CUSTOMIZE]
    - {style_direction_1}
    - {style_direction_2}
    - {style_direction_3}
    - Desktop-first but responsive

--------------------------------------------------------------------------------
AGENT 3: SOLUTION ARCHITECT [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Define system design, APIs, security, deployment architecture.
  Trigger:     Assigned by Orchestrator for Phase 3.
               Also reviews Phase 4 integration design.
  Input:       MVP scope (from Agent 1), UX spec (from Agent 2), product context.
  Output:      High-level system architecture, tech stack recommendation,
               frontend architecture, backend architecture, data storage schema,
               API route design.
  Artifacts:   wiki/architecture/system-architecture.md,
               wiki/architecture/data-storage-schema.md,
               wiki/architecture/api-routes.md,
               wiki/modules/frontend.md, wiki/modules/backend.md,
               wiki/conventions/coding-conventions.md.
  Tools:       File system (wiki write), terminal (architecture validation).
  Quality gate: Architecture supports all UX flows. Security boundaries are defined.
                Data separation is explicit. Data schema covers all entities.
  Responsibilities:
    - Design high-level architecture (frontend/backend split, data flow)
    - Recommend and justify tech stack for MVP using the evaluation criteria
      below (ADR-003 must include the scored matrix)
    - Define frontend architecture (framework, components, state, routing)
    - Define backend architecture (framework, middleware, services)
    - Propose data storage schema per Section 3 constraints
    - Design API routes with request/response shapes
    - Define authentication and authorization model
    - Define deployment architecture targeting GitHub-hosted workflows
    - Specify caching design, monitoring, and logging
    - Define how public and private data are separated safely
    - Record ADR-003 (tech stack), ADR-004 (data storage), ADR-005 (auth)

  Tech stack evaluation criteria (mandatory for ADR-003):
    Agent 3 must evaluate candidate tech stacks against these criteria.
    Each criterion is scored 1-5. The ADR must include the scoring matrix
    and justification for the selected stack.

    1. MVP speed        — time to working prototype with one developer
    2. Simplicity       — minimal moving parts, single-language where possible
    3. GitHub ecosystem  — Actions support, templates, community packages
    4. Maintainability  — code readability, type safety, refactorability
    5. Deployment ease  — containerizable, standard build pipeline, no exotic deps
    6. External API fit — HTTP client maturity, JSON handling, async support
    7. Security posture — auth libraries, secret management, OWASP coverage
    8. Scalability path — can grow beyond MVP without rewrite
    9. Team familiarity — if known, weight toward team's existing skills
    10. Cost            — free tier viability, license constraints

    Minimum candidates to evaluate: at least 2 options per layer.

    The selected stack must score highest overall. If two stacks tie,
    prefer the simpler one (principle: avoid over-engineering the MVP).

--------------------------------------------------------------------------------
AGENT 4: FULL-STACK ENGINEER [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Implement code based on specs from Agents 2 and 3.
  Trigger:     Assigned by Orchestrator for code implementation (post-Phase 6).
  Input:       All wiki specs from Phases 1-6.
  Output:      Working code, component implementations, API endpoints,
               data layer implementation.
  Artifacts:   Source code files, wiki/modules/ updates with implementation notes.
  Tools:       File system (code read/write), terminal (build, test, run),
               grep/search (codebase navigation).
  Quality gate: Code compiles, tests pass, implements the spec without scope creep,
                follows coding conventions from wiki/conventions/coding-conventions.md.
  Responsibilities:
    - Implement frontend components per UX spec
    - Implement backend API routes per API design
    - Implement data storage layer per schema design
    - Implement external API integrations per Agent 5 spec
    - Implement validation (client and server side)
    - Follow coding conventions and design system

--------------------------------------------------------------------------------
AGENT 5: DATA/API INTEGRATION DESIGNER [CUSTOMIZE]
--------------------------------------------------------------------------------
  Role:        Design external API integrations, data processing logic,
               and domain-specific calculations.
  Trigger:     Assigned by Orchestrator for Phase 4.
  Input:       External API requirements (Section 6), data storage schema
               (from Agent 3).
  Output:      Integration flow design, rate-limit strategy, data processing
               methodology, calculation definitions, data normalization rules.
  Artifacts:   wiki/modules/{api_service}.md,
               wiki/concepts/{domain_calculations}.md.
  Tools:       File system (wiki write), web fetch (API docs).
  Quality gate: Integration handles all edge cases (rate limits, missing data).
                Calculations are correct and documented. Architect (Agent 3)
                confirms design is compatible with system architecture.
  Responsibilities: [CUSTOMIZE]
    - Design external API request lifecycle and response validation
    - Define rate-limit mitigation (queuing, backoff, caching)
    - Define data validation and normalization logic
    - Define domain-specific calculation methodology
    - Define update schedules and fallback rules
    - Record relevant ADRs

--------------------------------------------------------------------------------
AGENT 6: QA/TEST ENGINEER [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Define test strategy, validate quality, assess release readiness.
  Trigger:     Assigned by Orchestrator for Phase 5.
               Also reviews every other phase output for testability.
  Input:       All prior phase deliverables.
  Output:      Test strategy, test scenarios, regression priorities, error state
               catalog, accessibility audit checklist, release-readiness checklist.
  Artifacts:   wiki/architecture/security-model.md,
               wiki/conventions/testing-conventions.md,
               wiki/conventions/accessibility-standards.md,
               wiki/architecture/deployment.md.
  Tools:       File system (wiki write), terminal (test execution).
  Quality gate: Test plan covers all critical paths. Security scenarios are
                enumerated. Accessibility standards are defined. Every agent's
                output has been reviewed for testability.
  Responsibilities:
    - Define test strategy (unit, integration, E2E, manual)
    - Create risk-based test plan prioritized by impact
    - Define test scenarios for:
        - security and authorization
        - API failure and degraded operation
        - domain-specific calculation accuracy
        - responsive layout and accessibility
    - Catalog error states and edge cases across all features
    - Define accessibility audit criteria
    - Define SEO guidance for public-facing pages
    - Define deployment and operational considerations
    - Produce release-readiness checklist

--------------------------------------------------------------------------------
AGENT 7: VISUAL TEST AGENT [FRAMEWORK]
--------------------------------------------------------------------------------
  Role:        Launch the running application, visually inspect pages, interact
               with the UI, take screenshots, validate rendered output against
               UX specs, and run automated browser-based test scenarios.
  Trigger:     Assigned by Orchestrator during Phase 7 (Implementation and
               Visual Validation). Also activated on-demand when Agent 4
               completes a feature or when Agent 6 requests visual verification.
  Input:       Running application URL, UX specs (from Agent 2), test scenarios
               (from Agent 6), accessibility standards (from Agent 6),
               design system (from wiki/conventions/design-system.md).
  Output:      Screenshot evidence per page, visual test pass/fail report,
               accessibility audit results, interaction test results,
               regression comparison screenshots, bug reports with reproduction
               steps.
  Artifacts:   wiki/test-results/visual-test-report.md,
               wiki/test-results/accessibility-audit.md,
               wiki/test-results/screenshots/ (evidence folder).
  Tools:
    Browser automation (Playwright MCP):
      - mcp_microsoft_pla_browser_navigate — open pages
      - mcp_microsoft_pla_browser_snapshot — read DOM structure
      - mcp_microsoft_pla_browser_take_screenshot — capture visual evidence
      - mcp_microsoft_pla_browser_click — interact with elements
      - mcp_microsoft_pla_browser_fill_form — test form inputs
      - mcp_microsoft_pla_browser_evaluate — run JS assertions
      - mcp_microsoft_pla_browser_network_requests — verify API calls
      - mcp_microsoft_pla_browser_resize — test responsive breakpoints
      - mcp_microsoft_pla_browser_press_key — test keyboard navigation
      - mcp_microsoft_pla_browser_console_messages — catch JS errors
    VS Code integrated browser:
      - open_browser_page, read_page, click_element, screenshot_page
    File system (wiki write for reports).
    Terminal (start/stop dev server).
  Quality gate: Every page defined in Section 9 has been visually verified.
                All interactive flows have been exercised end-to-end in the
                browser. Accessibility checks pass (keyboard nav, focus states,
                contrast). No console errors on any page. Screenshots match
                UX spec expectations. Responsive layout verified at desktop
                (1280px) and mobile (375px).
  Responsibilities:
    - Start the development server via terminal
    - Navigate to every page defined in Section 9 and take a screenshot
    - Compare rendered pages against wireframe/UX spec from Agent 2
    - Execute interactive test scenarios from Agent 6
    - Test form validation (submit empty, submit invalid, etc.)
    - Test responsive layout by resizing to mobile breakpoints
    - Test keyboard navigation (tab order, focus states, enter/escape)
    - Inspect network requests to verify API calls match route design
    - Check browser console for JavaScript errors or warnings
    - Verify security constraints visually (e.g., private data not exposed)
    - Produce a structured visual test report with pass/fail per page
    - File bug reports for failures with screenshot + DOM snapshot evidence
  Test cycle protocol:
    1. Agent 4 completes a feature and notifies Orchestrator
    2. Orchestrator activates Agent 7 to test that feature
    3. Agent 7 runs visual + interaction tests, produces report
    4. If failures found: Agent 7 files bug report, Orchestrator routes
       to Agent 4 for fix, then Agent 7 re-tests
    5. If all pass: Agent 7 marks feature as visually verified
    6. After all features pass, Agent 7 runs full regression suite
    7. Regression report feeds into Agent 6's release-readiness assessment

================================================================================
SECTION 8 — ORCHESTRATION PROTOCOL [FRAMEWORK]
================================================================================

A. PHASE GATE PROCESS
   For each phase:
   1. Orchestrator reads wiki/log.md to confirm prior phase is complete
   2. Orchestrator assigns LEAD agent and CONTRIBUTING agents (see Section 11)
   3. Lead agent produces deliverables, consulting contributing agents as needed
   4. Orchestrator routes deliverables to REVIEWER agent(s) (see Section 11)
   5. Reviewer agent(s) provide structured feedback:
      PASS, PASS WITH NOTES, or REVISE
   6. If REVISE:
      a. Lead agent addresses feedback
      b. Lead agent updates the wiki artifact with revisions
      c. Lead agent appends revision note to wiki/log.md:
         format: "[Phase N] Revision R — [what changed] — [reviewer who requested]"
      d. Re-submit for review
      e. Max 3 revision cycles per phase; after that, escalate to user
   7. If PASS or PASS WITH NOTES:
      a. Orchestrator writes deliverables to wiki (status: final)
      b. Orchestrator appends phase completion to wiki/log.md
      c. Orchestrator updates wiki/index.md with new/modified pages
      d. Orchestrator updates wiki/overview.md if project state changed
      e. Orchestrator activates the next phase

B. HANDOFF FORMAT
   Every agent-to-agent handoff is a wiki artifact. The format is:
   - File path: as specified in agent output artifacts
   - Content: structured markdown with clear headings
   - Metadata header: phase number, lead agent, date, status
     (draft / reviewed / final)
   - Downstream agents reference artifacts by wiki path,
     never by inline content

C. CONFLICT RESOLUTION
   When two agents disagree:
   1. Both agents state their position with rationale in a structured format:
      POSITION, RATIONALE, TRADEOFFS, RECOMMENDATION
   2. Orchestrator evaluates against project principles (Section 4) and MVP scope
   3. If resolution is clear from principles, Orchestrator decides and records
      an ADR
   4. If resolution is ambiguous, Orchestrator escalates to the user with both
      positions
   5. Decision is recorded as an ADR in wiki/decisions/

D. INTER-AGENT REVIEW MATRIX
   Each phase has designated reviewers who cross-validate the lead agent's work:

   Phase 1 output reviewed by:
     Agent 2 (scope vs UX feasibility)
     Agent 6 (scope vs testability)

   Phase 2 output reviewed by:
     Agent 1 (design vs MVP scope)
     Agent 3 (design vs technical feasibility)

   Phase 3 output reviewed by:
     Agent 2 (architecture vs UX requirements)
     Agent 5 (architecture vs data integration needs)
     Agent 6 (architecture vs testability)

   Phase 4 output reviewed by:
     Agent 3 (integration vs system architecture)
     Agent 6 (integration vs test coverage)

   Phase 5 output reviewed by:
     Agent 3 (security model vs architecture)
     Agent 1 (operational plan vs roadmap)

   Phase 6 output reviewed by:
     All agents (final sign-off)

   Phase 7 output (code + visual tests) reviewed by:
     Agent 7 (visual verification of every feature)
     Agent 6 (test coverage and release readiness)
     Agent 3 (architectural compliance)
     Agent 2 (UX spec compliance via Agent 7 screenshots)

E. REVIEW FEEDBACK FORMAT
   Reviewers provide feedback as:
   - VERDICT: PASS | PASS WITH NOTES | REVISE
   - ITEMS: numbered list of specific issues or observations
   - For REVISE: each item must state WHAT is wrong and WHY,
     with a suggested fix
   - For PASS WITH NOTES: items are advisory, not blocking

F. CONTINUOUS DOCUMENTATION PROTOCOL
   Wiki updates are mandatory at every state transition, not just phase
   boundaries. The following events require immediate wiki updates:

   1. DELIVERABLE PRODUCED — write artifact to wiki with status: draft
   2. REVIEW SUBMITTED — update artifact status to: reviewed
   3. REVISION MADE — update artifact in-place, append revision note
      to wiki/log.md
   4. PHASE COMPLETED — update artifact status to: final, update
      wiki/log.md, wiki/index.md, wiki/overview.md
   5. FEATURE IMPLEMENTED (Phase 7) — append to wiki/log.md, update
      wiki/modules/ with implementation notes
   6. BUG FOUND (Phase 7) — create entry in wiki/test-results/bug-log.md
   7. BUG FIXED (Phase 7) — update bug-log.md status, append fix note
      to wiki/log.md
   8. FEATURE VERIFIED (Phase 7) — append verification to wiki/log.md
   9. SPEC AMENDED — update original spec wiki page, record rationale
      in wiki/log.md, update wiki/index.md if page was renamed
   10. CONFLICT RESOLVED — record ADR in wiki/decisions/, append to
       wiki/log.md

   The Orchestrator enforces this protocol. No state transition is
   considered complete until the corresponding wiki update is confirmed.

================================================================================
SECTION 9 — REQUIRED FEATURES (DOMAIN SPEC) [CUSTOMIZE]
================================================================================

[Define all pages and features for each experience. For every page, specify:
 - Page name
 - Key components and data shown
 - User interactions available
 This section drives UX design (Agent 2) and implementation (Agent 4).]

{EXPERIENCE_A_NAME} PAGES

1. {Page Name}
- {component/feature_1}
- {component/feature_2}
- ...

2. {Page Name}
- {component/feature_1}
- {component/feature_2}
- ...

{EXPERIENCE_B_NAME} SECTIONS

1. {Section Name}
- {component/feature_1}
- {component/feature_2}
- ...

2. {Section Name}
- {component/feature_1}
- {component/feature_2}
- ...

================================================================================
SECTION 10 — CROSS-CUTTING REQUIREMENTS [CUSTOMIZE]
================================================================================

A. DOMAIN-SPECIFIC CALCULATION REQUIREMENTS [CUSTOMIZE]
[Define any calculations, algorithms, or business logic that multiple
 components depend on. Remove if not applicable.]

Define a practical v1 methodology for:
- {calculation_1}
- {calculation_2}
- ...

B. SECURITY REQUIREMENTS [FRAMEWORK]
The solution must ensure:
- protected routes require authentication
- public routes are read-only
- private data never appears on public-facing pages
- API keys are never exposed client-side
- only authorized users can modify data
- destructive actions require confirmation
- basic auditability is considered for data changes

[CUSTOMIZE — add domain-specific security requirements below]
- {domain_security_req_1}
- {domain_security_req_2}

C. ACCESSIBILITY REQUIREMENTS [FRAMEWORK]
The UX/UI must include:
- keyboard navigability
- clear focus states
- sufficient color contrast
- semantic tables
- labeled form controls
- heading hierarchy
- chart accessibility fallback text (if charts are used)
- responsive layout behavior

================================================================================
SECTION 11 — PHASED EXECUTION PLAN [FRAMEWORK]
================================================================================

Work through these phases in order. No phase starts until the prior phase passes
its quality gate and review cycle.

PHASE 1 — PRODUCT AND SCOPE
  Lead:          Agent 1 (Product Strategist)
  Contributors:  Agent 6 (testability input)
  Reviewers:     Agent 2 (UX feasibility), Agent 6 (testability)
  Deliverables:
    1. Executive summary
    2. Product vision and goals
    3. User roles and user needs
    4. MVP scope and non-MVP scope
  Wiki outputs:
    - wiki/analyses/mvp-scope.md
    - wiki/concepts/user-roles.md
    - wiki/overview.md (update with project vision)
  Decision to record:
    - ADR-001: MVP scope boundaries
  Gate criteria:
    - Every feature classified as MVP or future
    - Assumptions are listed explicitly
    - Agent 2 confirms scope is designable
    - Agent 6 confirms scope is testable

PHASE 2 — UX AND DESIGN
  Lead:          Agent 2 (UX/UI Designer)
  Contributors:  Agent 1 (scope guardrails)
  Reviewers:     Agent 1 (MVP scope compliance), Agent 3 (technical feasibility)
  Deliverables:
    5. Information architecture / sitemap
    6. User flows for each experience
    7. UX/UI design principles
    8. Page-by-page UX specification
    9. Wireframe-level layout descriptions
    10. Design system guidance
  Wiki outputs:
    - wiki/architecture/information-architecture.md
    - wiki/conventions/design-system.md
    - wiki/modules/{experience_a}.md (UX spec)
    - wiki/modules/{experience_b}.md (UX spec)
  Decision to record:
    - ADR-002: Design system and component library choice
  Gate criteria:
    - Every page has layout, empty state, loading state, error state
    - All user flows have happy path + error path
    - User flows include Mermaid flowchart diagrams
    - Agent 1 confirms no scope creep
    - Agent 3 confirms designs are technically implementable

PHASE 3 — TECHNICAL ARCHITECTURE
  Lead:          Agent 3 (Solution Architect)
  Contributors:  Agent 4 (implementation feasibility), Agent 5 (data needs)
  Reviewers:     Agent 2 (UX requirements met), Agent 5 (integration compatibility),
                 Agent 6 (testability)
  Deliverables:
    11. High-level system architecture
    12. Recommended tech stack
    13. Frontend architecture
    14. Backend architecture
    15. Data storage schema
    16. API route design
  Wiki outputs:
    - wiki/architecture/system-architecture.md
    - wiki/architecture/data-storage-schema.md
    - wiki/architecture/api-routes.md
    - wiki/modules/frontend.md
    - wiki/modules/backend.md
    - wiki/conventions/coding-conventions.md
  Decisions to record:
    - ADR-003: Tech stack selection
    - ADR-004: Data storage format and layout
    - ADR-005: Authentication and authorization approach
  Gate criteria:
    - Architecture supports all UX flows from Phase 2
    - System architecture wiki page includes a Mermaid architecture diagram
    - Data schema covers all entity fields
    - API routes map to every feature
    - Security boundaries are defined (public vs private)
    - Agent 5 confirms architecture supports external integrations
    - Agent 6 confirms architecture is testable

PHASE 4 — DATA AND INTEGRATION
  Lead:          Agent 5 (Data/API Integration Designer)
  Contributors:  Agent 3 (architecture constraints)
  Reviewers:     Agent 3 (architecture compatibility), Agent 6 (test coverage)
  Deliverables: [CUSTOMIZE]
    17. External API integration design
    18. Domain-specific calculation methodology
  Wiki outputs: [CUSTOMIZE]
    - wiki/modules/{api_service}.md
    - wiki/concepts/{domain_calculations}.md
  Decision to record: [CUSTOMIZE]
    - ADR-006: {integration_decision}
  Gate criteria:
    - Integration handles rate limits, missing data, edge cases
    - Integration wiki page includes a Mermaid sequence diagram
    - Calculations are mathematically defined with examples
    - Agent 3 confirms design fits within system architecture
    - Agent 6 confirms calculations are testable with concrete test cases

PHASE 5 — SECURITY, QUALITY, AND OPERATIONS
  Lead:          Agent 6 (QA/Test Engineer)
  Contributors:  Agent 3 (security model input), Agent 2 (accessibility input)
  Reviewers:     Agent 3 (security model review), Agent 1 (operational alignment)
  Deliverables:
    19. Security and authorization model
    20. QA and testing strategy
    21. Test scenarios and regression priorities
    22. Error states and edge cases
    23. Accessibility guidance
    24. SEO guidance for public-facing pages
    25. Deployment and operational considerations
  Wiki outputs:
    - wiki/architecture/security-model.md
    - wiki/conventions/testing-conventions.md
    - wiki/conventions/accessibility-standards.md
    - wiki/architecture/deployment.md
  Gate criteria:
    - Security model covers all requirements from Section 10B
    - Test plan has concrete scenarios for every critical path
    - Accessibility standards cover all requirements from Section 10C
    - Agent 3 confirms security model is architecturally sound
    - Agent 1 confirms operational plan aligns with roadmap

PHASE 6 — ROADMAP AND IMPLEMENTATION PLANNING
  Lead:          Agent 1 (Product Strategist)
  Contributors:  Agent 3 (technical effort input), Agent 4 (implementation input)
  Reviewers:     All agents (final sign-off)
  Deliverables:
    26. Phase-based delivery roadmap
    27. Key risks and tradeoffs
    28. Final implementation recommendation for MVP
  Wiki outputs:
    - wiki/analyses/risk-tradeoff-analysis.md
    - wiki/analyses/implementation-roadmap.md
    - wiki/overview.md (final update with complete project state)
  Gate criteria:
    - Roadmap references concrete wiki artifacts for every task
    - Risks have mitigations and owners
    - All agents confirm their domain is accurately represented
    - wiki/overview.md reflects the complete project state

After Phase 6 passes its gate, the wiki contains the full living specification.
Phase 7 begins the build-and-verify cycle.

PHASE 7 — IMPLEMENTATION AND VISUAL VALIDATION
  Lead:          Agent 4 (Full-Stack Engineer)
  Contributors:  Agent 5 (integration implementation), Agent 3 (architecture)
  Reviewers:     Agent 7 (visual testing), Agent 6 (quality/release readiness),
                 Agent 3 (architectural compliance)
  Execution model:
    This phase operates in iterative feature cycles, not a single pass.
    Each cycle follows the Build-Test-Fix loop:

    1. Agent 4 implements a feature per wiki spec
    2. Agent 4 writes unit tests for the feature
    3. Agent 4 updates wiki documentation:
       a. Append to wiki/log.md: "[Phase 7] Feature: [name] — implemented"
       b. Update wiki/modules/ with implementation notes
       c. If implementation required a spec change, update the original
          wiki spec and record rationale in wiki/log.md
    4. Orchestrator activates Agent 7 to visually test the feature:
       a. Agent 7 starts the dev server
       b. Agent 7 navigates to the relevant pages
       c. Agent 7 takes screenshots and runs interaction tests
       d. Agent 7 checks accessibility (keyboard, contrast, focus)
       e. Agent 7 verifies no console errors
       f. Agent 7 produces a pass/fail report with evidence
       g. Agent 7 writes results to wiki/test-results/
    5. If Agent 7 finds failures:
       a. Bug report filed with screenshot + DOM snapshot
       b. Bug logged in wiki/test-results/bug-log.md
       c. Orchestrator routes to Agent 4 for fix
       d. Agent 7 re-tests (max 3 revision cycles per feature,
          then escalate to user)
    6. If Agent 7 passes: feature marked as verified in wiki/log.md
    7. Agent 6 reviews test coverage after each feature batch

  Feature implementation order (suggested, Orchestrator may adjust): [CUSTOMIZE]
    Batch 1: Project setup, data storage layer, backend API scaffold
    Batch 2: Authentication, main dashboard
    Batch 3: {primary_entity} CRUD operations
    Batch 4: External API integration, data refresh
    Batch 5: Domain-specific calculations
    Batch 6: Settings, configuration, public-facing rendering
    Batch 7: Public-facing pages (all sections)
    Batch 8: Final polish, responsive, accessibility

  Wiki outputs (continuously updated throughout this phase):
    - wiki/log.md (append per feature: implement, test, fix, verify)
    - wiki/test-results/visual-test-report.md
    - wiki/test-results/accessibility-audit.md
    - wiki/test-results/bug-log.md
    - wiki/test-results/screenshots/
    - wiki/modules/ (implementation notes)
    - wiki/index.md, wiki/overview.md

  Gate criteria:
    - All features from wiki specs are implemented
    - Unit tests pass for all backend routes and calculations
    - Agent 7 has visually verified every page in Section 9
    - Responsive layout verified at 1280px and 375px
    - Keyboard navigation works on all interactive elements
    - No unhandled console errors on any page
    - Agent 6 signs off on release-readiness checklist
    - Agent 3 confirms no architectural deviations

PHASE 8 — DOCUMENTATION AND README
  Lead:          Agent 4 (Full-Stack Engineer)
  Contributors:  Agent 1 (product context), Agent 3 (architecture overview),
                 Agent 5 (integration details), Agent 6 (test/run instructions)
  Reviewers:     Agent 1 (completeness), Agent 3 (accuracy)
  Trigger:       Phase 7 gate passes.

  Deliverables:
    1. README.md at the repository root with the sections listed below
    2. All architectural and data-flow diagrams in Mermaid syntax
    3. Wiki documentation cross-referenced from README

  README.md required sections:
    1. Project title and one-line description
    2. Project overview
    3. Architecture overview with Mermaid diagram
    4. Tech stack table (framework, version, purpose)
    5. Prerequisites (runtime versions, API keys, tools)
    6. Getting started (clone, env setup, install, run)
    7. Project structure (directory tree with descriptions)
    8. {Experience A} features summary
    9. {Experience B} features summary
    10. API reference (route, method, auth required, description)
    11. Authentication and authorization summary
    12. External API integration (setup, rate limits, caching)
    13. Domain-specific methodology with Mermaid flow
    14. Calculation / business logic summary
    15. Testing (unit, integration, visual)
    16. Deployment (CI/CD pipeline with Mermaid diagram)
    17. Contributing guidelines
    18. License
    19. Disclaimer (if applicable)

  Mermaid diagram requirements:
    All flow diagrams, architecture diagrams, and sequence diagrams in the
    README and wiki must use Mermaid syntax (```mermaid code blocks).

    Required Mermaid diagrams (minimum):
    1. System architecture — flowchart showing all major components
    2. Primary user flow — flowchart for main user journey
    3. Secondary user flow — flowchart for secondary experience
    4. External API integration — sequence diagram showing request flow
    5. Build-Test-Fix cycle — flowchart showing Agent 4/7 workflow
    6. CI/CD pipeline — flowchart from push through deploy
    7. Data flow for domain calculations — flowchart showing data pipeline

  Gate criteria:
    - README.md exists at repository root
    - All required sections are present and non-empty
    - At least 7 Mermaid diagrams are included
    - Getting started instructions are testable
    - API reference matches implemented routes
    - Agent 1 confirms product context is accurately represented
    - Agent 3 confirms architecture diagram matches implementation

  End state:
    When Phase 8 gate passes, the application is fully documented,
    visually verified, and ready for deployment.

================================================================================
APPENDIX A — HOW TO USE THIS TEMPLATE
================================================================================

1. Copy this file and rename it for your project (e.g., my-app-spec.md)

2. Replace all {PLACEHOLDER} tokens:
   - {APP_NAME}              → Your application name
   - {APP_DESCRIPTION}       → One-paragraph description of your app
   - {CORE_EXPERIENCE_1..N}  → High-level features (e.g., "Admin Portal",
                                "Public API", "Dashboard")
   - {KEY_FEATURE_1..N}      → Distinguishing capabilities
   - {EXPERIENCE_A/B_NAME}   → Names for each user experience
   - {PRIMARY_ENTITY}        → Main data object (e.g., "Product", "Task",
                                "Article")
   - {API_NAME}              → External API name (or remove Section 6)
   - {DOMAIN_PRINCIPLE_1..N} → Industry/domain-specific design principles
   - All other {placeholders} → Context-specific values

3. Fill in [CUSTOMIZE] sections with your domain-specific content:
   - Section 3: Project goal and data storage strategy
   - Section 4: Domain-specific principles
   - Section 5: Product context, experiences, entity fields
   - Section 6: External API requirements (or delete if none)
   - Section 7: Agent 5 responsibilities (domain calculations)
   - Section 9: All pages/features for each experience
   - Section 10A: Domain-specific calculations
   - Section 11: Phase 4 deliverables, Phase 7 batch order

4. [FRAMEWORK] sections work as-is for any project:
   - Section 1: Framework dependency
   - Section 2: Session protocol
   - Section 7: Agent 0-4, 6-7 definitions (core responsibilities)
   - Section 8: Full orchestration protocol
   - Section 10B-C: Security and accessibility requirements
   - Section 11: Phase 1-3, 5-8 structure

5. Run the framework setup script, then start Phase 1.
