---
description: >
  Generate a pull request description, update CHANGELOG.md, commit that
  update, and push. Use when asked to "create a PR", "open a pull request",
  or "generate a PR description". Presents the description as a code block
  for review before creating the PR.
---

# Create Pull Request

Generate and open a pull request: `$ARGUMENTS`

## Step 1 — Verify Clean State

```bash
git status --porcelain
```

If there are uncommitted changes, stop and say:
> "There are uncommitted changes. Please run `/commit-and-push` first."

## Step 2 — Gather Branch Information

```bash
git branch --show-current
git log --oneline main..HEAD
git diff main...HEAD --stat
```

Extract the issue number from the branch name
(e.g., `feat-123-...` → `#123`).

## Step 3 — Identify All Changes

Read the diff for context:
```bash
git diff main...HEAD
```

Review every changed file. Group changes by:
- New components added
- Existing components modified
- Bug fixes
- Demo / documentation changes
- Dependency updates
- Configuration changes

## Step 4 — Generate PR Description

Use the template in `.github/pull_request_template.md` as the base.

Fill in each section:

**Context**: Why is this change needed? Reference the GitHub issue and explain
the problem it solves.

**Description**: What was changed? List the key changes, referencing files
using `<code>filename</code>` tags (not backticks or links).

**Related Issues**: `Fixes #NNN` (use the issue number from the branch name).

**Type of Change**: Mark the appropriate checkbox(es) with `[x]` (no spaces).

**Checklist**: Check off items that are true for this PR.

Rules:
- Format as Markdown
- Use `<code>` tags for file references (not backticks)
- Skip "Screenshots" and "Additional Notes" sections
- Be concise but complete

## Step 5 — Present for Review

Output the PR description as a Markdown code block:

````markdown
```markdown
## Context
...

## Related Issues
Fixes #NNN

## Type of Change
- [x] New feature
...

## Description
...

## Checklist
- [x] My code follows the code style of this project
...
```
````

Ask the user:
> "Does this PR description look good? I'll update CHANGELOG.md and then
> create the PR."

Wait for confirmation before proceeding.

## Step 6 — Update CHANGELOG.md

1. Run `git diff main...HEAD` to gather all changes.
2. Open `CHANGELOG.md` and check for an `[Unreleased]` section.
3. If it exists, add new entries under the appropriate subsection:
   - `### Component Changes` — for component additions/modifications
   - `### Demo / Docs Changes` — for example views, documentation
   - `### General Changes` — for everything else
4. If no `[Unreleased]` section exists, create it at the top.
5. Write concise, present-tense entries:
   - `feat(Button): Add icon support via IconableComponent`
   - `fix(Diff): Replace comment-based Tailwind safelist with constant`

Never alter existing changelog entries.

## Step 7 — Commit CHANGELOG

```bash
git add CHANGELOG.md
git commit -m 'docs: Update CHANGELOG'
git push -u origin $(git branch --show-current)
```

## Step 8 — Check Last Push Output

After push, check if the output contains a `Create a pull request` URL.
If it does, present it to the user as a clickable link.

## Step 9 — Create the PR (if requested)

If the user confirms, use the GitHub MCP to create the PR:

```
mcp__github__create_pull_request
  repo="profoundry-us/loco_motion"
  title="{first_line_of_description}"
  body="{full_pr_description}"
  head="{current_branch}"
  base="main"
```

## Resources

- PR template: `.github/pull_request_template.md`
- CHANGELOG: `CHANGELOG.md`
- Creating a PR rules: `.windsurf/rules/creating_a_pull_request.md`
- PR description rules: `.windsurf/rules/generating_a_pr_description.md`
- Updating changelog rules: `.windsurf/rules/updating_the_changelog.md`
- GitHub repo: `https://github.com/profoundry-us/loco_motion`
