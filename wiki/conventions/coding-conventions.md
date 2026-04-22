---
title: "Coding Conventions"
type: convention
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [conventions, coding, standards]
sources: []
related: []
status: draft
---

# Coding Conventions

> [!note] This is a stub page. The AI developer agent will populate it as
> conventions are established in the codebase. Fill in each section during
> Phase 3 (Technical Architecture) or Workflow 11 (Brownfield Onboarding).

## Language and Runtime

- **Primary language**: {LANGUAGE}
- **Runtime version**: {RUNTIME_VERSION}
- **Package manager**: {PACKAGE_MANAGER}

## File and Directory Naming

- {naming_rule_1}
- {naming_rule_2}

## Code Style

- **Formatter**: {FORMATTER}
- **Linter**: {LINTER}
- **Max line length**: {LINE_LENGTH}

## Module Structure

Describe the standard layout of a module/component:

```
{module_name}/
  {entry_file}       # Public interface
  {impl_file}        # Implementation
  {test_file}        # Tests
```

## Error Handling

- {error_handling_pattern_1}
- {error_handling_pattern_2}

## Logging

- {logging_pattern}

## Testing

See [[testing-conventions]] for the full testing strategy.

- **Test runner**: {TEST_RUNNER}
- **Coverage target**: {COVERAGE_TARGET}
- **Test file location**: {TEST_LOCATION}

## Imports and Dependencies

- {import_order_rule}
- {dependency_rule}

## Comments and Documentation

- {comment_standard}
- {docstring_standard}

## Security Conventions

See [[SECURITY]] for the full security checklist.

- All inputs validated at system boundaries.
- Secrets loaded from environment variables only.
- Parameterised queries for all database access.
