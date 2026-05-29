---
name: start-issue
description: Reads a GitHub issue, crafts a branch name, and optionally creates
  an implementation plan. Use when the user says "start this issue", "work on
  issue", "begin issue", "pick up issue", or "let's work on".
metadata:
  author: profoundry-us
  version: 1.1.0
---

# Start Issue

Reads an existing GitHub issue, reads relevant code for context, proposes a
branch name, and optionally kicks off an implementation plan.

## Instructions

### Step 1: Read the issue

Fetch the issue using the GitHub MCP server (`get_issue` for
`profoundry-us/loco_motion`), falling back to the `gh` CLI only if the MCP
server is unavailable:

```bash
gh issue view {number} --repo profoundry-us/loco_motion
```

Read:

- The issue title and body.
- All comments for additional context or clarified requirements.
- Any linked issues or PRs.

### Step 2: Read relevant files

Before crafting a branch name or plan, read the files mentioned or implied by
the issue. This is required — a branch name and plan built without reading the
code often miss key details.

- **Documentation issues** — read both the current docs and the correct
  reference implementation to understand the gap.
- **Bug fixes** — read the component class, template, and spec to understand
  current behavior.
- **Features** — read related components and the helpers registry to
  understand existing patterns.

### Step 3: Craft a branch name

Use the format: `{type}-{issue_number}-{short-description}`

| Part | Rule |
|------|------|
| `type` | One of: `feat`, `bug`, `fix`, `task`, `chore`, `docs`, `refactor` |
| `issue_number` | Numeric ID from the issue URL |
| `short-description` | Lowercase kebab-case summary (3–5 words) |

Examples:

- `feat-45-add-badge-icon`
- `bug-102-fix-modal-close`
- `docs-106-update-install-docs`

### Step 4: Present the branch name

Show the user the proposed branch name and ask them to create it:

```bash
git checkout -b {proposed-branch-name}
```

Do NOT create the branch yourself.

### Step 5: Offer a plan

Ask the user: "Would you like me to create an implementation plan for this
issue?"

- If **no**: stop here.
- If **yes**: follow the `create-plan` skill to build a plan file in
  `docs/plans/`.

### Step 6: Validate the branch (after user creates it)

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
- Files to read: `app/components/daisy/data_display/badge_component.rb`,
  its template, and `lib/loco_motion/helpers.rb`
- Plan template: `new_component.md` or `component_modification.md`

**Example 2 — bug issue**

Issue: #102 "Modal doesn't close on outside click in Safari"

- Type: `bug`
- Branch: `bug-102-fix-modal-close`
- Files to read: modal component class, template, and Playwright spec
- Plan template: `component_modification.md`

**Example 3 — documentation task**

Issue: #106 "Update README install docs for Tailwind 4 and DaisyUI 5"

- Type: `docs`
- Branch: `docs-106-update-install-docs`
- Files to read: `README.md` and demo app CSS / tailwind config for reference
- Plan template: `refactoring.md` (or no plan if small)

## Troubleshooting

**Issue URL not accessible** — Ask the user to paste the issue title and
description into the chat so the branch name can still be crafted.

**Branch name conflicts with an existing branch** — Append a short
disambiguating suffix, e.g. `feat-45-add-badge-icon-v2`, and confirm with
the user.

**Unclear issue type** — When a bug fix also refactors code, prefer the
primary intent (`fix` for a bug, `refactor` for intentional cleanup).

**Need to create an issue first** — Use the `create-issue` skill, then return
here once the issue is posted.
