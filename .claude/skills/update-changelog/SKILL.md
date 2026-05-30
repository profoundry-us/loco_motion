---
name: update-changelog
description: Adds entries to CHANGELOG.md under the correct section following
  Keep-a-Changelog conventions. Use when the user says "update the changelog",
  "add a changelog entry", "update changelog", or "log this change".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Update Changelog

Adds one or more entries to `CHANGELOG.md` under the correct section and
category without altering any existing entries.

## Instructions

### Step 1: Read the current CHANGELOG

```bash
head -60 CHANGELOG.md
```

Identify whether an `[Unreleased]` section exists at the top of the file.

### Step 2: Determine the target section

Add new entries to `[Unreleased]` (creating it if absent). Never modify
entries in a versioned section (e.g. `## [1.2.3] - 2025-01-01`).

### Step 3: Categorize the change

Every entry goes under one of three subsections:

| Change type | Subsection header |
|-------------|-------------------|
| Component additions or changes | `### Component Changes` |
| Demo app or documentation updates | `### Demo / Docs Changes` |
| Everything else | `### General Changes` |

### Step 4: Collect the changes

Run the following to see what changed since the last release:

```bash
git log --oneline main..HEAD
git status --porcelain
git diff
```

Summarize each meaningful change in one clear bullet point.

### Step 5: Write the entries

Format each entry as a Markdown list item under the correct subsection:

```markdown
## [Unreleased]

### Component Changes

- Added icon part to `BadgeComponent` with YARD documentation.
- Fixed `ModalComponent` closing behavior on outside click.

### Demo / Docs Changes

- Updated Badge example view with icon usage examples.
```

Rules:

- Never delete or alter existing entries.
- Append new items to the **bottom** of the relevant subsection.
- Use sentence case for entry text and end with a period.
- Wrap all entry descriptions at 80 characters. Indent continuation lines to
  align with the text after the marker (2 spaces under a top-level `- ` item,
  4 spaces under a nested `  - ` item).
- Never break inside an inline code span (`` `...` ``), a Markdown link
  (`[text](url)`), or a `<code>...</code>` tag — keep each on one line. A line
  may exceed 80 characters only when a single one of these unbreakable tokens
  is itself longer than the remaining space (code/links are allowed to run
  long; prose is not).

### Step 6: Create the `[Unreleased]` section if missing

If the section does not exist, insert it at the very top of the file (before
any existing version sections):

```markdown
## [Unreleased]

### Component Changes

- {entry}
```

### Step 7: Verify the format

Re-read the top of `CHANGELOG.md` to confirm the structure matches the existing
format before saving.

## Examples

**Example 1 — adding a component entry**

```markdown
## [Unreleased]

### Component Changes

- Added `CountdownComponent` to the actions group with basic usage example.
```

**Example 2 — multiple categories**

```markdown
## [Unreleased]

### Component Changes

- Added `define_part :icon` to `BadgeComponent`.

### Demo / Docs Changes

- Added "With Icon" example to the badges demo view.

### General Changes

- Updated `lib/loco_motion/helpers.rb` to register `BadgeComponent`.
```

## Troubleshooting

**`[Unreleased]` section is missing** — Insert the section at the top of the
file. Do not remove or rename any existing version sections.

**Merge conflict in CHANGELOG** — Keep ALL entries from both sides. The correct
resolution is to union the lists, not pick one over the other.

**Unsure which category to use** — When in doubt, use `General Changes`. If the
change touches a component class or template, use `Component Changes`.
