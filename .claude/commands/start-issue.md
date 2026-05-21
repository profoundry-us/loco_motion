---
description: >
  Begin work on a GitHub issue: read the issue, propose a branch name, and
  optionally create an implementation plan. Use when asked to "start issue
  #NNN", "work on issue NNN", or given a GitHub issue URL.
---

# Start Issue

Start work on a GitHub issue: `$ARGUMENTS`

`$ARGUMENTS` should be a GitHub issue number (e.g., `123`) or a full GitHub
issue URL.

## Step 1 — Read the Issue

Use the GitHub MCP tools to fetch the issue:

```
mcp__github__issue_read repo="profoundry-us/loco_motion" issue_number=<NNN>
```

Read:
- The issue title
- The full description
- All comments (they may contain implementation decisions)
- Any linked issues or PRs

## Step 2 — Understand the Work

Based on the issue content, determine:
- **Type**: `feat` (new feature), `bug` (bug fix), `fix` (minor fix),
  `task` (chore/cleanup), `docs` (documentation), `refactor` (refactoring)
- **Scope**: the component or system area being changed
- **Key decisions**: any constraints or preferences mentioned in comments

## Step 3 — Propose a Branch Name

Craft a branch name using:
```
{type}-{issue_number}-{brief-hyphenated-description}
```

Examples:
- `feat-123-add-hover-component`
- `bug-456-fix-button-tooltip`
- `docs-789-update-getting-started`

Rules:
- All lowercase
- Use hyphens between words
- Keep the description short (3–5 words max)
- Use the exact issue number from GitHub

Present to the user:
> "Suggested branch name: `feat-123-add-hover-component`
>
> Run this to create it:
> ```bash
> git checkout -b feat-123-add-hover-component
> ```
> Would you like me to create this branch now?"

## Step 4 — Create the Branch (if confirmed)

```bash
git checkout -b {branch_name}
```

Then validate the branch name:
```bash
go run .claude/commands/shared_scripts/check_branch/main.go
```

## Step 5 — Ask About Planning

After the branch is created, ask:
> "Would you like me to create an implementation plan for this issue?"

- If **no**: stop here. The user will give further instructions.
- If **yes**: run `/create-plan` with the relevant context (issue title,
  description, and any links from the issue).

## Resources

- Branch validator: `.claude/commands/shared_scripts/check_branch/main.go`
- Starting an issue rules: `.windsurf/rules/starting_an_issue.md`
- Creating a plan: `.claude/commands/create-plan.md`
- GitHub repo: `https://github.com/profoundry-us/loco_motion`
