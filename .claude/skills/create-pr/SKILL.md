---
name: create-pr
description: Generates a pull request description from commit history, updates
  the CHANGELOG, and opens the PR on GitHub. Use when the user says "create a
  PR", "open a pull request", "make a PR", "submit a PR", or "create a pull
  request".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Create PR

Generates a well-structured pull request from the current branch, updates the
CHANGELOG, and pushes everything.

## Instructions

### Step 1: Ensure tests pass

```bash
just loco-test
just demo-test
```

Stop if any tests fail.

### Step 2: Collect branch information

```bash
git log --oneline main..HEAD
git diff main...HEAD --stat
```

Extract the issue number from the branch name if present (e.g. `feat-45-...`
→ `#45`).

### Step 3: Read the PR template

Read `.github/pull_request_template.md` to understand the required sections.
Follow its structure exactly.

### Step 4: Draft the PR description

Produce a Markdown code block the user can copy/paste:

```markdown
## Context

Why this change is being made (from the issue or user's stated goal).

## Description

- Bullet-point summary of what changed
- Reference files using `code` tags, not backticks in prose

## Related Issues

Fixes #45

## Type of Change

- [x] New feature
- [ ] Bug fix
- [ ] Breaking change
- [ ] Documentation update
```

Rules:

- Do NOT hard-wrap the PR body at 80 characters. GitHub reflows it as prose,
  so write natural paragraphs (one line per paragraph) and let them wrap on
  render. Repo Markdown files still wrap at 80 — this exception applies only to
  text posted to GitHub (PR descriptions, issue bodies, comments).
- Use `Fixes #N` (not "Closes" or "Resolves") if an issue number is available.
- Mark the correct type with `[x]` (no spaces inside the brackets).
- Skip "Screenshots" and "Additional Notes" sections.
- File references must use `code` HTML tags, not backtick Markdown links.

### Step 5: Present the description for review

Show the full Markdown block and ask the user to confirm or edit before
proceeding.

### Step 6: Update the CHANGELOG

Check whether an `[Unreleased]` section exists at the top of `CHANGELOG.md`:

```bash
head -20 CHANGELOG.md
```

- If it exists, append new bullet items to the bottom of that section.
- If it does not exist, create the section header and add items beneath it.

Wrap every entry at 110 characters (continuation lines indented to align with
the text after the `- ` marker). Never split an inline code span, Markdown
link, or `<code>` tag across lines — only those unbreakable tokens may push a
line past 110. See the `update-changelog` skill for the full rules.

Follow the categorization rules:

| Change type | CHANGELOG section |
|-------------|-------------------|
| Component changes | Component Changes |
| Demo / docs changes | Demo / Docs Changes |
| General changes | General Changes |

### Step 7: Commit and push the CHANGELOG

```bash
git add CHANGELOG.md
git commit -m 'docs: Update CHANGELOG'
git push -u origin {branch-name}
```

### Step 8: Determine the correct labels

Before opening the PR, identify the right labels by checking the source
issue (if one exists) and the nature of the change:

1. If the branch has an issue number, read that issue's labels with
   `mcp__github__issue_read` (`method: get_labels`) and carry any
   applicable labels over to the PR.
2. Apply labels based on the change type:

| Change type | Label(s) |
|-------------|----------|
| New component | `new component` |
| Bug fix | `bug` |
| Documentation / demo only | `documentation` |
| Enhancement to existing component | `enhancement` |
| Test-only change | `test` |
| Internal tooling / skills / chore | `documentation` |

3. Never invent label names — only use labels that already exist on the
   repository. When in doubt, check existing issues and PRs for the label
   vocabulary in use.
4. **Always apply at least one label.** If no row above matches, fall back to
   `documentation` for internal/tooling changes or `enhancement` for anything
   additive. Never skip labeling.

### Step 9: Open the PR

The branch must already be pushed to the remote with local `git` (Step 7).

Open the PR using the GitHub MCP server's `create_pull_request` tool with the
drafted description, then **always** apply the labels determined in Step 8 via
the MCP server (e.g. its label/update-issue tools).

Fall back to the `gh` CLI only if an MCP tool is unavailable or fails (for
example, a `403` permissions error). When using the CLI, provide all arguments
explicitly so `gh pr create` does not hang waiting for interactive input:

```bash
gh pr create --title "{title}" --body "{body}" --head {branch-name} --base main
gh pr edit {PR_NUMBER} --add-label "{label}"
```

Multiple labels can be comma-separated:

```bash
gh pr edit {PR_NUMBER} --add-label "bug,documentation"
```

Report the PR URL to the user.

## Examples

**Example 1 — new component PR with issue**

Branch: `feat-45-add-badge-icon`

- Issue labels: `new component` → carry over to PR
- Issue: `Fixes #45`
- Type: `[x] Component update/addition`
- CHANGELOG section: Component Changes
- Labels to apply: `new component`

**Example 2 — bug fix PR with issue**

Branch: `bug-102-fix-modal-close`

- Issue labels: `bug` → carry over to PR
- Issue: `Fixes #102`
- Type: `[x] Bug fix`
- CHANGELOG section: Component Changes
- Labels to apply: `bug`

**Example 3 — documentation PR without issue**

Branch: `docs-update-card-docs`

- No issue reference
- Type: `[x] Documentation update`
- CHANGELOG section: Demo / Docs Changes
- Labels to apply: `documentation`

## Troubleshooting

**No commits ahead of main** — Confirm you are on the correct branch with
`git log --oneline main..HEAD`. If empty, no PR is needed yet.

**CHANGELOG merge conflict** — Resolve by keeping both the incoming `[Unreleased]`
items and the existing ones, then re-commit.

**PR template not found** — If `.github/pull_request_template.md` is missing,
use the structure in Step 4 as the default.
