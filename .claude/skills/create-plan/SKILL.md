---
name: create-plan
description: Creates a structured Markdown implementation plan in docs/plans/
  using the appropriate template. Use when the user says "create a plan",
  "make a plan", "plan this out", "write a plan for", or "draft an
  implementation plan".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Create Plan

Produces a structured implementation plan in `docs/plans/` using the correct
project template.

## Instructions

### Step 1: Choose the template

Templates live in `docs/plans/templates/`. Pick based on the task:

| Task type | Template |
|-----------|----------|
| New component | `new_component.md` |
| Modifying an existing component | `component_modification.md` |
| Removing a component | `component_removal.md` |
| Refactoring code | `refactoring.md` |
| Third-party integration | `integration.md` |
| DB or system migration | `migration.md` |

Read the chosen template fully before writing the plan.

### Step 2: Review recent plans for style

List existing plans to find recent ones:

```bash
ls -lt docs/plans/*.md | head -10
```

Read one or two recent plans to match their formatting and level of detail.

### Step 3: Gather requirements

Identify from the user's request:

- The specific change or feature being planned.
- Any GitHub issue number and URL — include these verbatim in the plan.
- Any external links the user provides — embed them exactly as given.

If the task references a GitHub issue, read the issue (and its comments) to
extract context before writing.

### Step 4: Create the plan file

Name the file descriptively, e.g. `docs/plans/add-badge-icon-part.md`.

Populate every section from the template. Follow these formatting rules:

- Wrap lines at 80 characters.
- Add a newline after every header.
- Use two newlines before H1 headings.
- Do NOT add component variants unless the user explicitly requests them.

### Step 5: Present for review

After creating the file, tell the user the path and ask them to review it.

**Do NOT execute the plan** until the user explicitly says to proceed.

## Examples

**Example 1 — new component plan**

User: "Create a plan for a new Countdown component in the actions group."

1. Read `docs/plans/templates/new_component.md`
2. Check recent plans: `ls -lt docs/plans/*.md | head -5`
3. Create `docs/plans/add-countdown-component.md`
4. Fill in all template sections with Countdown-specific details
5. Report: "Plan created at docs/plans/add-countdown-component.md — please
   review before I start coding."

**Example 2 — plan from a GitHub issue**

User: "Create a plan for issue #87 at https://github.com/..."

1. Read the issue URL with the browser tool
2. Extract the requirements and acceptance criteria
3. Pick the appropriate template
4. Create the plan file referencing `Fixes #87`
5. Ask the user to review

## Troubleshooting

**Template not found** — Run `ls docs/plans/templates/` to see available
templates. If none fits, ask the user which template to base the plan on.

**Issue URL not accessible** — Ask the user to paste the issue description
directly into the chat.

**Plan file already exists** — Ask the user whether to overwrite or create a
new versioned file (e.g. `add-badge-v2.md`).
