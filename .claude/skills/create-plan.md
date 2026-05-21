---
description: >
  Create a Markdown implementation plan in docs/plans/ using the right
  project template. Use when asked to create a plan, write a plan for
  something, or plan an implementation. Always present the plan for review
  before executing any code.
---

# Create Plan

## When to Use

- "Create a plan for X"
- "Write a plan before we start"
- "Plan out how to implement Y"
- Before starting a non-trivial component or refactor

## Step 1 — Select the Template

Read the relevant template from `docs/plans/templates/`:

| Situation                       | Template                        |
|---------------------------------|---------------------------------|
| New component                   | `new_component.md`              |
| Modifying an existing component | `component_modification.md`     |
| Removing a component            | `component_removal.md`          |
| Refactoring code                | `refactoring.md`                |
| Third-party integration         | `integration.md`                |
| Database / system migration     | `migration.md`                  |

Read the full template before writing anything.

## Step 2 — Review Recent Plans for Style

```bash
ls -t docs/plans/*.md | head -5
```

Read one or two recent plans to match current formatting and detail level.

## Step 3 — Determine the Filename

Format: `YYYY-MM-{slug}.md`

- `YYYY-MM` = current year and month
- `{slug}` = lowercase, hyphenated topic summary

Example: `2025-06-add-progress-bar-component.md`

## Step 4 — Gather Context

Before writing:
1. If a GitHub issue URL was provided, read it including all comments.
2. If modifying an existing component, read its source files.
3. Note any URLs the user has explicitly provided — include them verbatim
   in the External Resources section. **Never guess or invent URLs.**

## Step 5 — Write the Plan

Create `docs/plans/{filename}.md` following this structure:

```markdown
# {Plan Title}

## Overview

Why this change is being made. Link to the GitHub issue if one exists.

## External Resources

- [Name](URL)  ← only URLs the user explicitly provided

## Implementation Steps

### 1. {Step Title}

**Purpose**: One sentence explaining why this step is needed.

**File to Create/Edit**: `path/to/file`

**Reference Files**:
- `path/to/reference1`
- `path/to/reference2`

**Notes**: Any constraints or gotchas.

**Example Implementation**:
\`\`\`ruby
# concise code example
\`\`\`
```

Formatting rules:
- Wrap all lines at 80 characters
- One newline after every header
- Two newlines before any H1
- Never add component style variants unless explicitly requested

## Step 6 — Present for Review

After creating the file:
> "Plan saved at `docs/plans/{filename}`. Please review it before I
> start any implementation."

**Do not write any code until the user says to proceed.**

## Resources

- Plan templates: `docs/plans/templates/`
- Recent plans: `docs/plans/`
- Creating a plan rules: `.windsurf/rules/creating_a_plan.md`
- Non-code docs rules: `.windsurf/rules/non_code_documentation.md`
