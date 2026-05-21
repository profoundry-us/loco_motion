---
description: >
  Run tests, stage all changes, generate a well-structured Markdown commit
  message, commit, and push to the remote branch. Use when the user asks
  to commit, save changes, or push their work. Never run unless explicitly
  requested.
---

# Commit and Push

## When to Use

- "Commit these changes"
- "Push my work"
- "Save and push"
- Never run proactively — always wait for an explicit request

## Step 0 — Branch Check

```bash
python .claude/skills/shared_scripts/check_branch.py
```

If on `main`, stop:
> "You're on `main`. Please switch to a feature branch first."

A non-fatal warning is shown if the branch name doesn't match the
convention — the commit can still proceed.

## Step 1 — Run Tests

```bash
just loco-test
just demo-test
```

If either suite fails, stop and report the failures. Do **not** commit
with failing tests.

## Step 2 — Check Status

```bash
git status --porcelain
```

If there is nothing to commit, say so and stop.

## Step 3 — Stage Everything

```bash
git add .
```

## Step 4 — Review the Diff

```bash
git diff --staged
```

Scan every file for:
- Unintended changes (debug statements, leftover TODOs, temp files)
- Files that shouldn't be committed (`.env`, credentials, large binaries)

Report any concerns to the user before continuing.

## Step 5 — Find Issue Number

```bash
git branch --show-current
```

Extract the issue number if present in the branch name
(e.g., `feat-123-add-button` → `#123`).

## Step 6 — Build the Commit Message

Structure:

```
{type}({Scope}): {Brief one-line summary}

### Changes

#### {File or logical group 1}
- {What changed and why}

#### {File or logical group 2}
- {What changed and why}

Fixes #{issue}   ← only include if an issue number was found
```

Rules:
- First line: `feat(Button): Add icon support` style
- Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
- Use Markdown in the body for formatting
- Wrap body lines at 80 characters
- Surround the full message in **single quotes** so backticks work

## Step 7 — Commit

```bash
git commit -m 'feat(Scope): Summary

### Changes

...

Fixes #NNN'
```

## Step 8 — Push

```bash
git push -u origin $(git branch --show-current)
```

Retry up to 4 times on network failure with backoff: 2s, 4s, 8s, 16s.

## Step 9 — Offer a Pull Request

After a successful push, ask:
> "Pushed successfully. Would you like to create a pull request?"

If yes, proceed with the `create-pr` skill.

## Resources

- Branch validator: `.claude/skills/shared_scripts/check_branch.py`
- Committing rules: `.windsurf/rules/committing.md`
- Running commands: `.windsurf/rules/running_commands.md`
