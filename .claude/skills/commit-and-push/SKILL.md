---
name: commit-and-push
description: Stages all changes, writes a well-structured Markdown commit
  message, commits, and pushes to the remote branch. Use when the user says
  "commit", "commit and push", "push my changes", "save my work", or "ship
  this".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Commit and Push

Stages, commits, and pushes all current changes following the LocoMotion
commit conventions.

## Instructions

### Step 1: Gate on passing tests

Before committing, both test suites must pass:

```bash
just loco-test
just demo-test
```

If either suite fails, stop and fix the failures first.

### Step 2: Check the branch

```bash
python .claude/skills/shared-scripts/check_branch.py
```

Stop if on `main`. Commits must go to a feature branch.

### Step 3: See what changed

```bash
git status --porcelain
```

```bash
git diff
```

Review every modified file. Note any files that should NOT be committed
(`.env`, secrets, generated artifacts).

### Step 4: Stage all changes

```bash
git add .
```

### Step 5: Review the staged diff

```bash
git diff --staged
```

Iterate over every modified file and draft a brief description of its changes.

### Step 6: Compose the commit message

Structure:

```
{type}({Scope}): {Short imperative summary}

## Changes

### {File or area 1}
- {Change description}
- {Change description}

### {File or area 2}
- {Change description}
```

Rules:

- First line: `feat(Badge): Add icon part` style — type, optional scope in
  parens, short summary.
- Valid types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `task`.
- If the branch contains an issue number (e.g. `feat-123-add-badge`), append
  `Fixes #123` to the message body.
- Wrap body lines at 80 characters.
- Surround the full message in **single quotes** when passing to `git commit
  -m` so that backticks and Markdown are preserved.

### Step 7: Commit

```bash
git commit -m '$(cat <<'"'"'EOF'"'"'
feat(Badge): Add icon part

## Changes

### app/components/daisy/data_display/badge_component.rb
- Added `define_part :icon`
- Updated `setup_component` to add icon CSS

### spec/components/daisy/data_display/badge_component_spec.rb
- Added test for icon part rendering
EOF
)'
```

Use a heredoc to avoid quoting issues with backticks in the body.

### Step 8: Push

```bash
git push -u origin {branch-name}
```

Retry up to 4 times on network failure (2 s, 4 s, 8 s, 16 s backoff).

### Step 9: Prompt about a pull request

After a successful push, ask the user: "Would you like me to create a pull
request?"

## Examples

**Example 1 — simple feature commit**

Branch: `feat-45-add-badge-icon`

```
feat(Badge): Add icon part

## Changes

### app/components/daisy/data_display/badge_component.rb
- Added `define_part :icon` and YARD `@part` documentation
- Updated `setup_component` to prepend icon CSS class

### spec/components/daisy/data_display/badge_component_spec.rb
- Added RSpec example for icon rendering

Fixes #45
```

**Example 2 — documentation-only commit**

Branch: `docs-update-card-docs`

```
docs(Card): Improve YARD documentation

## Changes

### app/components/daisy/data_display/card_component.rb
- Added `@loco_example` blocks for header and footer slots
- Added `@slot` tags for all renders_one relationships
```

## Troubleshooting

**Pre-commit hook fails** — Do NOT use `--no-verify`. Fix the underlying issue
(lint errors, test failures) and create a new commit.

**Push rejected (non-fast-forward)** — Run `git pull origin {branch}` to
rebase, then push again. Do not force-push without explicit user permission.

**Tests fail after `git add .`** — Unstage with `git reset HEAD` and fix
before recommitting.
