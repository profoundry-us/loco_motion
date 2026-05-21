---
name: code-check
description: Reviews staged or recent code changes against LocoMotion coding
  conventions and Windsurf rules before committing. Use when the user says
  "check my code", "review my changes", "lint my code", "does this follow
  conventions", or "code check".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Code Check

Reviews code changes for adherence to LocoMotion conventions before committing
or opening a PR.

## Instructions

### Step 1: See what changed

```bash
git diff
git diff --staged
```

Read every modified file. Do not skip files.

### Step 2: Check against each rule category

Work through the checklist below. Flag every violation with the file path and
line number.

#### Branch safety

- [ ] Not on `main` branch — run `python .claude/skills/shared-scripts/check_branch.py`

#### Component Ruby class

- [ ] Uses `define_part` (not `define_parts`) for each part.
- [ ] Does NOT include `part(:component)` — handled by `BaseComponent`.
- [ ] Does NOT define `_css` or `_html` properties for parts.
- [ ] DaisyUI variants (size, color, etc.) are applied via `css:` kwarg, NOT
      added as parameters.
- [ ] `setup_component` uses `add_css` / `add_html` correctly.
- [ ] No methods longer than ~20 lines without explanation.

#### YARD documentation

- [ ] Class-level comment follows order: description → notes → parts → slots
      → examples.
- [ ] Uses `@loco_example` (NOT `@example`).
- [ ] All `@param` / `@option` tags are on `initialize`, NOT on the class.
- [ ] Blank lines between each `@param` / `@option` entry.
- [ ] `@part` tags document every `define_part` call.
- [ ] `@slot` tags document every `renders_one` / `renders_many` call.
- [ ] Lines wrapped at 80 characters.
- [ ] No positional `@param` docs if `initialize` doesn't use them.

#### HAML template

- [ ] Root element is `= part(:component) do`.
- [ ] Logic is minimal — belongs in the Ruby class.

#### Spec file

- [ ] Test file mirrors the component path under `spec/components/`.
- [ ] At least one basic "renders" test exists.
- [ ] New behavior added in the class has corresponding spec coverage.

#### Example view

- [ ] Uses `doc_title` and `doc_example` helpers.
- [ ] Each `doc_example` has a `doc.with_description` block.
- [ ] Demonstrates new behavior introduced in this change.

#### helpers.rb (if modified)

- [ ] New component entry uses exact class name string.
- [ ] All required keys present: `names`, `group`, `title`, `example`.

### Step 3: Run the test suite

```bash
make loco-test
```

All tests must pass.

### Step 4: Report findings

List every violation with:

- File path and line number
- Which rule is violated
- A specific fix suggestion

If no violations are found, report "All checks passed" and note the test
result.

## Examples

**Example 1 — clean code check**

Output: "All checks passed. 142 examples, 0 failures."

**Example 2 — violation found**

Output:

```
Violations found:

1. app/components/daisy/actions/button_component.rb:12
   Rule: @loco_example required (not @example)
   Fix: Replace `@example Basic button` with `@loco_example Basic button`

2. app/components/daisy/actions/button_component.rb:8
   Rule: DaisyUI size/color variants must not be added as parameters
   Fix: Remove the `size:` parameter. Users should pass `css: "btn-lg"`.

Tests: 142 examples, 0 failures.
```

## Troubleshooting

**Unsure about a rule** — Check `.windsurf/rules/` for the authoritative source.
Files: `coding.md`, `component_implementation.md`, `documenting_code.md`.

**Test suite cannot run** — Verify Docker containers are running:
`docker compose ps`. Start with `docker compose up -d` if needed.

**Large diff with many files** — Work file by file. Check component files first,
then specs, then views.
