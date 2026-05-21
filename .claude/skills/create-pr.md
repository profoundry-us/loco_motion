---
description: >
  Generate a pull request description, update CHANGELOG.md, commit that
  update, push, and open the PR on GitHub. Use when the user asks to
  create a PR, open a pull request, or submit their work for review.
---

# Create PR

## When to Use

- "Create a PR"
- "Open a pull request"
- "Submit this for review"
- After `commit-and-push` completes and user confirms

## Step 1 — Verify Clean State

```bash
git status --porcelain
```

If there are uncommitted changes:
> "There are uncommitted changes. Please commit them first
> (use the `commit-and-push` skill)."

## Step 2 — Gather Branch Context

```bash
git branch --show-current
git log --oneline main..HEAD
git diff main...HEAD --stat
```

Extract the issue number from the branch name if present.

## Step 3 — Read All Changes

```bash
git diff main...HEAD
```

Group changes by type:
- New components added
- Existing components modified
- Bug fixes
- Demo / documentation changes
- Dependency or config updates

## Step 4 — Build the PR Description

Use `.github/pull_request_template.md` as the skeleton. Fill in:

**Context** — Why is this change needed? Reference the GitHub issue.

**Description** — What was changed? Use `<code>filename</code>` tags for
file references (not backticks, not links).

**Related Issues** — `Fixes #NNN` when an issue number was found.

**Type of Change** — Mark the right checkbox(es) with `[x]`.

**Checklist** — Check off items that are true.

Skip the Screenshots and Additional Notes sections.

## Step 5 — Present the Description

Show the full description as a Markdown code block and ask:
> "Does this PR description look good? I'll update CHANGELOG.md and
> then open the PR."

Wait for the user's confirmation before continuing.

## Step 6 — Update CHANGELOG.md

1. Read `git diff main...HEAD` for all changes.
2. Open `CHANGELOG.md` and find the `[Unreleased]` section
   (create it at the top if missing).
3. Add entries under the right subsection(s):
   - `### Component Changes` — component additions/modifications
   - `### Demo / Docs Changes` — example views, guides, docs
   - `### General Changes` — config, tooling, dependencies
4. Entry format: `feat(Scope): Description ([Fixes #NNN](URL))`
5. Never alter existing entries.

## Step 7 — Commit CHANGELOG

```bash
git add CHANGELOG.md
git commit -m 'docs: Update CHANGELOG'
git push -u origin $(git branch --show-current)
```

## Step 8 — Open the PR

Use the GitHub MCP to create the PR:

```
mcp__github__create_pull_request
  owner: "profoundry-us"
  repo: "loco_motion"
  title: "{one-line summary}"
  body: "{full PR description}"
  head: "{current branch}"
  base: "main"
```

Return the PR URL to the user.

## Resources

- PR template: `.github/pull_request_template.md`
- CHANGELOG: `CHANGELOG.md`
- Creating a PR rules: `.windsurf/rules/creating_a_pull_request.md`
- PR description rules: `.windsurf/rules/generating_a_pr_description.md`
- Changelog rules: `.windsurf/rules/updating_the_changelog.md`
