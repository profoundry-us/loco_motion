---
description: >
  Add entries to CHANGELOG.md for all current branch changes. Use when
  asked to "update the changelog", "add a changelog entry", or as part
  of the PR creation flow. Categorizes changes into Component Changes,
  Demo/Docs Changes, and General Changes.
---

# Update Changelog

Add changelog entries for the current branch: `$ARGUMENTS`

## Step 1 — Review Current Changes

Gather all changes since branching from `main`:

```bash
git log --oneline main..HEAD
git diff main...HEAD --stat
```

Read the full diff if needed:
```bash
git diff main...HEAD
```

Identify every file changed and what kind of change it is.

## Step 2 — Read the Existing CHANGELOG

```bash
head -80 CHANGELOG.md
```

- Note the current structure and style of existing entries.
- Identify whether an `[Unreleased]` section already exists.
- Match the tone and format of recent entries.

## Step 3 — Categorize the Changes

Sort every change into one of these sections:

### Component Changes
Any change to files in:
- `app/components/`
- `lib/loco_motion/`
- `spec/components/`

Format: `feat(Scope): Description` or `fix(Scope): Description`

### Demo / Docs Changes
Any change to files in:
- `docs/demo/app/views/examples/`
- `docs/demo/app/`
- `*.md` documentation files
- `docs/plans/`

Format: `add(Demo): Description` or `docs(Scope): Description`

### General Changes
Everything else:
- Configuration changes
- Dependency updates
- Build/tooling changes
- CI/CD changes

Format: Plain prose or `feat: Description`

## Step 4 — Write the Entries

Each entry should:
- Be a list item starting with `-`
- Start with an action prefix: `feat`, `fix`, `add`, `docs`, `chore`
- Include the scope in parentheses: `feat(Button):`
- Link to the GitHub issue when relevant:
  `([Fixes #NNN](https://github.com/profoundry-us/loco_motion/issues/NNN))`
- Be one line if possible; use continuation for necessary detail

Examples:
```markdown
- feat(Button): Add `icon`, `left_icon`, `right_icon` support via
  `IconableComponent` concern ([Fixes #84](https://github.com/...))
- fix(Diff): Replace comment-based Tailwind safelist with `ITEM_CLASSES`
  constant for v4 compatibility
- add(Demo): Add Hover 3D example page with basic and clickable card demos
```

## Step 5 — Update CHANGELOG.md

1. Open `CHANGELOG.md`.
2. If `[Unreleased]` section exists, add entries under the correct subsection
   at the bottom of that subsection's list.
3. If it does NOT exist, add this above the first versioned section:

```markdown
## [Unreleased]

### Component Changes

- {entry}

### Demo / Docs Changes

- {entry}

### General Changes

- {entry}
```

4. Only add subsections that have entries. Skip empty ones.
5. NEVER alter existing entries.

## Step 6 — Stage and Report

```bash
git diff CHANGELOG.md
```

Show the user the diff and say:
> "I've updated `CHANGELOG.md`. Here's what was added. This will be
> committed as part of the PR process — or you can commit it now."

Do NOT auto-commit this unless running as part of `/create-pr`.

## Resources

- CHANGELOG: `CHANGELOG.md`
- Updating changelog rules: `.windsurf/rules/updating_the_changelog.md`
- GitHub issues: `https://github.com/profoundry-us/loco_motion/issues`
