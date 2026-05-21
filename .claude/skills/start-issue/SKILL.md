---
name: start-issue
description: Reads a GitHub issue, crafts a branch name, and optionally creates
  an implementation plan. Use when the user says "start this issue", "work on
  issue", "begin issue", "pick up issue", or "let's work on".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Start Issue

Reads a GitHub issue and sets up the branch and (optionally) a plan for the
work.

## Instructions

### Step 1: Read the issue

Visit the provided GitHub issue URL. Read:

- The issue title and body.
- All comments for additional context or clarified requirements.
- Any linked issues or PRs.

### Step 2: Craft a branch name

Use the format: `{type}-{issue_number}-{short-description}`

| Part | Rule |
|------|------|
| `type` | One of: `feat`, `bug`, `fix`, `task`, `chore`, `docs`, `refactor` |
| `issue_number` | Numeric ID from the issue URL |
| `short-description` | Lowercase kebab-case summary (3–5 words) |

Examples:

- `feat-45-add-badge-icon`
- `bug-102-fix-modal-close`
- `task-87-update-card-docs`

### Step 3: Present the branch name

Show the user the proposed branch name and ask them to create it:

```bash
git checkout -b {proposed-branch-name}
```

Do NOT create the branch yourself.

### Step 4: Offer a plan

Ask the user: "Would you like me to create an implementation plan for this
issue?"

- If **no**: stop here.
- If **yes**: follow the `create-plan` skill to build a plan file in
  `docs/plans/`.

### Step 5: Validate the branch (after user creates it)

Once the user has created the branch, optionally run:

```bash
python .claude/skills/shared-scripts/check_branch.py
```

to confirm the branch name follows conventions.

## Examples

**Example 1 — feature issue**

Issue: #45 "Add icon support to Badge component"

- Type: `feat`
- Branch: `feat-45-add-badge-icon`
- Plan template: `new_component.md` or `component_modification.md`

**Example 2 — bug issue**

Issue: #102 "Modal doesn't close on outside click in Safari"

- Type: `bug`
- Branch: `bug-102-fix-modal-close`
- Plan template: `component_modification.md`

**Example 3 — documentation task**

Issue: #87 "Document all DataDisplay components"

- Type: `docs`
- Branch: `docs-87-document-data-display`
- Plan template: `refactoring.md` (or no plan if small)

## Troubleshooting

**Issue URL not accessible** — Ask the user to paste the issue title and
description into the chat so the branch name can still be crafted.

**Branch name conflicts with an existing branch** — Append a short disambiguating
suffix, e.g. `feat-45-add-badge-icon-v2`, and confirm with the user.

**Unclear issue type** — When a bug fix also refactors code, prefer the primary
intent (`fix` for a bug, `refactor` for intentional cleanup).
