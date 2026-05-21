---
description: >
  Add CHANGELOG.md entries for all changes on the current branch. Use when
  asked to update the changelog, add a changelog entry, or as part of the
  create-pr flow. Categorizes changes correctly and never alters existing
  entries.
---

# Update Changelog

## When to Use

- "Update the changelog"
- "Add a changelog entry for this"
- "What should go in the CHANGELOG?"
- Automatically as part of the `create-pr` skill

## Step 1 — Review Branch Changes

```bash
git log --oneline main..HEAD
git diff main...HEAD --stat
git diff main...HEAD
```

Identify every changed file and what kind of change it is.

## Step 2 — Read the Existing CHANGELOG

```bash
head -80 CHANGELOG.md
```

Note the style of existing entries so new ones match — tone, format,
level of detail.

## Step 3 — Categorize Every Change

### Component Changes

Files in `app/components/`, `lib/loco_motion/`, `spec/components/`:

```markdown
- feat(Button): Add `icon`, `left_icon`, `right_icon` support via
  `IconableComponent` ([Fixes #84](https://github.com/...))
- fix(Diff): Replace comment-based Tailwind safelist with `ITEM_CLASSES`
  constant for v4 compatibility
```

### Demo / Docs Changes

Files in `docs/demo/app/views/examples/`, `docs/`, `*.md`:

```markdown
- add(Demo): Add Hover 3D examples page with basic and clickable card demos
- docs(Alert): Update examples with closable and auto-dismiss patterns
```

### General Changes

Config, tooling, CI, dependency updates, everything else:

```markdown
- chore: Upgrade DaisyUI to v5.5.19 and TailwindCSS to v4.2.1
- build: Add Dockerfile.demo.cloud for network-restricted environments
```

## Step 4 — Write Entries

Rules:
- Each entry is a `- ` list item
- Start with `feat`, `fix`, `add`, `docs`, or `chore` prefix
- Scope in parentheses: `feat(Button):`
- Link to the issue when relevant using full Markdown link syntax
- One line where possible; indent continuation by two spaces
- **Never alter existing entries**

## Step 5 — Edit CHANGELOG.md

1. If `[Unreleased]` section exists, append entries to the bottom of
   each relevant subsection.
2. If it does not exist, add at the top of the file:

```markdown
## [Unreleased]

### Component Changes

- {entry}

### Demo / Docs Changes

- {entry}

### General Changes

- {entry}
```

Only include subsections that have entries.

## Step 6 — Show the Diff

```bash
git diff CHANGELOG.md
```

Present the diff to the user. Do not auto-commit unless running inside
the `create-pr` skill.

## Resources

- CHANGELOG: `CHANGELOG.md`
- Changelog rules: `.windsurf/rules/updating_the_changelog.md`
- GitHub issues: https://github.com/profoundry-us/loco_motion/issues
