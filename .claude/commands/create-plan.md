---
description: >
  Create a Markdown implementation plan in docs/plans/ using the appropriate
  template. Use when asked to "create a plan", "write a plan for", or "plan
  the implementation of". Always review templates first and never execute the
  plan unless explicitly asked.
---

# Create Plan

Create an implementation plan: `$ARGUMENTS`

## Step 1 — Choose the Right Template

Review available templates in `docs/plans/templates/`:

| Situation                        | Template                              |
|----------------------------------|---------------------------------------|
| New component                    | `new_component.md`                    |
| Modifying an existing component  | `component_modification.md`           |
| Removing a component             | `component_removal.md`                |
| Refactoring code                 | `refactoring.md`                      |
| Third-party integration          | `integration.md`                      |
| Database or system migration     | `migration.md`                        |

Read the chosen template in full before writing the plan.

## Step 2 — Review Recent Plans for Style

List recent plans:
```bash
ls -t docs/plans/*.md | head -5
```

Read 1–2 recent plans to match the current formatting style, especially:
- How implementation steps are structured
- How file paths are referenced
- How code examples are presented

## Step 3 — Determine Plan Filename

Use this format: `YYYY-MM-{slug}.md`

- `YYYY-MM` is the current year and month
- `{slug}` is a lowercase hyphenated summary of the plan topic

Example: `2025-06-add-progress-bar-component.md`

## Step 4 — Research Required Context

Before writing:
1. If a GitHub issue URL was provided, read it (including comments).
2. If the plan involves an existing component, read its source files.
3. Check if DaisyUI has relevant documentation (user may provide the URL).

## Step 5 — Write the Plan

Create the file at `docs/plans/{YYYY-MM-slug}.md`.

Structure:
```markdown
# {Plan Title}

## Overview

Brief description of what is being implemented and why. Link to GitHub
issue if applicable.

## External Resources

- [DaisyUI Component](https://daisyui.com/components/...)
- Any other relevant links provided by the user

## Implementation Steps

### 1. {Step Title}

**Purpose**: One sentence explaining why this step is needed.

**File to Create/Edit**: `path/to/file`

**Reference Files**:
- `path/to/reference1`
- `path/to/reference2`

**Notes**: Any important considerations.

**Example Implementation**:
\`\`\`ruby
# code example
\`\`\`
```

Rules:
- Wrap all lines at 80 characters
- Use only links explicitly provided by the user — never guess URLs
- NEVER add component variants unless explicitly requested
- Include exact file paths for every step
- Add two newlines before H1 headings; one newline after all headers

## Step 6 — Present for Review

After creating the file, tell the user:
> "I've created the plan at `docs/plans/{filename}`. Please review it
> before I begin implementation."

Do NOT begin coding unless the user explicitly says to proceed.

## Resources

- Plan templates: `docs/plans/templates/`
- Recent plans: `docs/plans/`
- Creating a plan rules: `.windsurf/rules/creating_a_plan.md`
- Non-code documentation rules: `.windsurf/rules/non_code_documentation.md`
