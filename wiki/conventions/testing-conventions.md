---
title: "Testing Conventions"
type: convention
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [conventions, testing, quality]
sources: []
related: [coding-conventions]
status: draft
---

# Testing Conventions

> [!note] This is a stub page. The AI developer agent will populate it as
> the test suite grows. Fill in each section during Phase 5 (Security, Quality,
> and Operations) or Workflow 11 (Brownfield Onboarding).

## Test Strategy

| Level | Tool | Scope | When to Write |
|-------|------|-------|---------------|
| Unit | {UNIT_TOOL} | Single function/class | Every new public function |
| Integration | {INTEGRATION_TOOL} | Module interactions | Every new API endpoint or service boundary |
| E2E | {E2E_TOOL} | Full user flows | Critical paths (happy + error) |

## Test File Conventions

- **Location**: {TEST_LOCATION}
- **Naming**: `test_{module}.{ext}` or `{module}.test.{ext}`
- **Function naming**: `test_{feature}_{scenario}` (e.g. `test_login_invalid_password`)

## Fixtures and Stubs

Describe the standard pattern for mocking external dependencies:

```
# Fake external service — returns deterministic responses, no network
class Fake{ExternalService}:
    def {method}(self, *args):
        return {CANNED_RESPONSE}

# Broken service — raises on first call, succeeds on second (tests fallback)
class Broken{ExternalService}:
    def __init__(self):
        self._calls = 0
    def {method}(self, *args):
        self._calls += 1
        if self._calls == 1:
            raise ConnectionError("simulated failure")
        return {CANNED_RESPONSE}
```

## Rules

- Tests must not require live external services — use fixtures or stubs.
- Every new feature needs: (1) a happy-path smoke test, (2) a failure-mode test.
- Tests must be deterministic — no time-dependent or random behaviour without seeding.
- Tests must run in under 30 seconds without a live environment.

## Running Tests

```bash
{TEST_COMMAND}
```

## Coverage

- Target: {COVERAGE_TARGET}%
- Exclude: {EXCLUDE_PATTERNS}
