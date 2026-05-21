---
description: >
  Run tests, stage all changes, generate a descriptive commit message using
  Markdown formatting, commit, and push to the remote branch. Follow this
  when asked to "commit", "commit and push", or "save my changes". Never
  commit unless explicitly requested.
---

# Commit and Push

Commit the current changes and push to origin: `$ARGUMENTS`

## Step 0 — Branch Safety Check

```bash
git branch --show-current
```

If you are on `main`, STOP and say:
> "You are on `main`. Please switch to a feature branch first."

Optionally validate the branch name convention:
```bash
go run .claude/commands/shared_scripts/check_branch/main.go
```

A warning (non-fatal) is shown if the branch name does not follow
`{type}-{issue_number}-{description}` convention.

## Step 1 — Run All Tests

```bash
just loco-test
```

```bash
just demo-test
```

If either test suite fails, STOP and report the failures. Do NOT commit
with failing tests.

## Step 2 — Check Status

```bash
git status --porcelain
```

If there are no changes to commit, report that and stop.

## Step 3 — Stage All Changes

```bash
git add .
```

## Step 4 — Review the Diff

```bash
git diff --staged
```

Review every modified file and note:
- What changed
- Why it changed (based on the task context)
- Whether it includes any unintended changes (debug logs, temp files, etc.)

## Step 5 — Check Branch for Issue Number

```bash
git branch --show-current
```

Extract the issue number from the branch name if present
(e.g., `feat-123-add-button` → issue `#123`).

## Step 6 — Generate Commit Message

Build a commit message using this structure:

```
{type}({Scope}): {Brief summary of changes}

### Changes

#### {File or Group 1}
- {Description of change}
- {Description of change}

#### {File or Group 2}
- {Description of change}

Fixes #{issue_number}  ← only if issue number was found
```

Rules:
- First line: `feat(Button): Add icon support` style — type, scope, summary
- Use Markdown headers and lists in the body
- Wrap lines at 80 characters
- Reference issue number with `Fixes #NNN` when present
- Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Step 7 — Commit

Surround the message in single quotes so backticks work:

```bash
git commit -m '$(cat <<'\''EOF'\''
feat(Scope): Summary

### Changes

...

Fixes #NNN
EOF
)'
```

Or equivalently via heredoc — use whatever works for the shell.

## Step 8 — Push

```bash
git push -u origin $(git branch --show-current)
```

If the push fails due to a network error, retry up to 4 times with
exponential backoff (2s, 4s, 8s, 16s).

## Step 9 — Prompt for Pull Request

After a successful push, ask:
> "Changes pushed successfully. Would you like to create a pull request?"

If yes, run `/create-pr`.

## Resources

- Branch validator: `.claude/commands/shared_scripts/check_branch/main.go`
- Committing rules: `.windsurf/rules/committing.md`
- Running commands: `.windsurf/rules/running_commands.md`
