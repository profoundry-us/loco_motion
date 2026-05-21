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

### Step 8: Open the PR

Check the output of the last `git push` for a "Create a pull request" URL and
present it as a clickable link to the user.

If the GitHub MCP tools are available, use `mcp__github__create_pull_request`
to open the PR programmatically with the drafted description.

## Examples

**Example 1 — feature PR with issue**

Branch: `feat-45-add-badge-icon`

- Issue: `Fixes #45`
- Type: `[x] New feature`
- CHANGELOG section: Component Changes

**Example 2 — documentation PR without issue**

Branch: `docs-update-card-docs`

- No issue reference
- Type: `[x] Documentation update`
- CHANGELOG section: Demo / Docs Changes

## Troubleshooting

**No commits ahead of main** — Confirm you are on the correct branch with
`git log --oneline main..HEAD`. If empty, no PR is needed yet.

**CHANGELOG merge conflict** — Resolve by keeping both the incoming `[Unreleased]`
items and the existing ones, then re-commit.

**PR template not found** — If `.github/pull_request_template.md` is missing,
use the structure in Step 4 as the default.
