---
description: >
  Start work on a GitHub issue: read it, propose a branch name, create the
  branch, and optionally kick off a plan. Use when the user provides a
  GitHub issue number or URL and wants to begin working on it.
---

# Start Issue

## When to Use

- "Start issue #123"
- "Work on issue 456"
- "Begin work on https://github.com/profoundry-us/loco_motion/issues/78"
- User pastes a GitHub issue URL

## Step 1 — Read the Issue

Use the GitHub MCP tool to fetch the issue (replace NNN with the number):

```
mcp__github__issue_read
  owner: "profoundry-us"
  repo: "loco_motion"
  issue_number: NNN
```

Read:
- The title
- The full description
- All comments (they often contain implementation decisions)
- Any linked issues or PRs mentioned

## Step 2 — Understand the Work

Determine:
- **Type** — `feat` (new feature), `bug` (bug fix), `fix` (minor fix),
  `task` (chore/cleanup), `docs` (documentation), `refactor`
- **Scope** — the component or system area being changed
- **Key constraints** — anything from the issue or comments that shapes
  the approach

## Step 3 — Propose a Branch Name

Format:
```
{type}-{issue_number}-{brief-hyphenated-description}
```

Examples:
- `feat-123-add-hover-component`
- `bug-456-fix-button-tooltip`
- `docs-78-update-getting-started`

Rules:
- All lowercase, hyphens between words
- Keep description to 3–5 words
- Use the exact issue number

Present to the user:
> "Suggested branch: `feat-123-add-hover-component`
>
> ```bash
> git checkout -b feat-123-add-hover-component
> ```
> Shall I create this branch?"

## Step 4 — Create the Branch (on confirmation)

```bash
git checkout -b {branch_name}
```

Validate the name:
```bash
python .claude/skills/shared_scripts/check_branch.py
```

## Step 5 — Ask About Planning

After the branch is created:
> "Would you like me to create an implementation plan for this issue?"

- **No** → stop here; wait for the user's next instruction
- **Yes** → use the `create-plan` skill with the issue title, description,
  and any links from the issue as context

## Resources

- Branch validator: `.claude/skills/shared_scripts/check_branch.py`
- Starting an issue rules: `.windsurf/rules/starting_an_issue.md`
- GitHub repo: https://github.com/profoundry-us/loco_motion
