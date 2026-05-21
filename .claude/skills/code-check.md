---
description: >
  Review recently changed files against all LocoMotion coding standards:
  YARD documentation, DaisyUI styling rules, component structure, test
  coverage, and formatting. Use when asked to review code, check standards,
  or verify work before committing.
---

# Code Check

## When to Use

- "Check my code before committing"
- "Review the changes"
- "Does this follow the project standards?"
- Automatically before opening a PR

## Step 1 — Find Changed Files

```bash
git diff --name-only main...HEAD
git diff --name-only HEAD
```

Group by type:
- Ruby component files: `app/components/**/*.rb`
- HAML templates: `app/components/**/*.html.haml`
- Spec files: `spec/**/*.rb`
- Example views: `docs/demo/app/views/examples/**/*.haml`
- Markdown docs: `**/*.md`
- Library files: `lib/**/*.rb`

## Step 2 — Ruby Component Checks

For each `*_component.rb`:

**Class structure:**
- [ ] Inherits from `LocoMotion::BaseComponent`
- [ ] `self.component_name` is set
- [ ] `before_render` calls `setup_component` then `super`
- [ ] `setup_component` is in a `private` section
- [ ] No `part(:component)` defined (BaseComponent handles it)
- [ ] No `_css` / `_html` parameters for parts

**DaisyUI styling:**
- [ ] No `size:`, `color:`, or style variant keyword args added
- [ ] CSS applied via `css:` kwarg by callers, not baked-in params

**YARD documentation:**
- [ ] Class has a description comment
- [ ] Every `define_part` has a `@part` tag on the class
- [ ] Every `renders_one` has a `@slot` tag; `renders_many` uses `@slot name+`
- [ ] All `@param` / `@option` are on `initialize`, not the class
- [ ] Blank line between each `@param` / `@option`
- [ ] `@loco_example` used (not `@example`)
- [ ] Examples use HAML with the `daisy_` helper
- [ ] Lines wrapped at 80 characters

## Step 3 — HAML Template Checks

For each `*_component.html.haml`:

- [ ] Starts with `= part(:component) do`
- [ ] No hardcoded copy that should come from params or content

## Step 4 — Spec File Checks

For each `*_spec.rb`:

- [ ] Starts with `require "rails_helper"`
- [ ] `RSpec.describe` has `type: :component`
- [ ] Tests that the root CSS class is present
- [ ] Tests that custom `css:` is passed through
- [ ] Tests for any new behavior added in this branch
- [ ] No existing test cases removed

## Step 5 — Example View Checks

For each example `.html.haml`:

- [ ] `doc_title` has a real description (not a TODO)
- [ ] Every `doc_example` has a `doc.with_description` block
- [ ] Uses `daisy_` helper methods

## Step 6 — Markdown File Checks

For each `.md`:

- [ ] Lines wrapped at 80 characters
- [ ] One newline after each header
- [ ] Two newlines before any H1

## Step 7 — Report

Output a per-file checklist:

```
Code Check
──────────

app/components/daisy/actions/button_component.rb
  ✓ Class structure
  ✓ DaisyUI styling rules
  ✗ Line 52 exceeds 80 characters in YARD comment
  ✗ Missing @loco_example for href usage

spec/components/daisy/actions/button_component_spec.rb
  ✓ Basic render test
  ✗ No test for the new `action:` kwarg
```

For each failure, include:
1. File and line number
2. Which rule is violated
3. A one-line suggested fix

## Step 8 — Fix (if requested)

Only fix issues when the user explicitly asks ("fix them", "go ahead").
After fixing:
```bash
just loco-test
```

## Resources

- Coding rules: `.windsurf/rules/coding.md`
- Component rules: `.windsurf/rules/component_implementation.md`
- Documentation rules: `.windsurf/rules/documenting_code.md`
- Markdown rules: `.windsurf/rules/non_code_documentation.md`
