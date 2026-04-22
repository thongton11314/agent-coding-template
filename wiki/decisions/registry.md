---
title: "ADR Registry"
type: decision
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [decisions, adr, registry]
sources: []
related: []
status: active
---

# ADR Registry

Master list of all Architecture Decision Records. Update this table whenever
a new ADR is created to prevent number collisions.

| Number | Title | Status | Date | Page |
|--------|-------|--------|------|------|
| *(no ADRs yet)* | | | | |

---

## ADR Template

Copy this template when creating a new ADR in `wiki/decisions/adr-NNN-title.md`:

```markdown
---
title: "ADR-NNN: <Decision Title>"
type: decision
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [decision, adr]
sources: []
related: []
status: active
---

# ADR-NNN: <Decision Title>

## Context
<What problem or need prompted this decision?>

## Options Considered

- **Option A**: description — pros / cons
- **Option B**: description — pros / cons

## Decision
<What was chosen and why.>

## Consequences
<Trade-offs, risks, follow-up actions.>
```

---

## Status Values

- `active` — decision is in effect
- `superseded` — replaced by a later ADR (link to successor)
- `deprecated` — no longer relevant; removed without replacement
