---
description: >
  Review recently changed files against all LocoMotion coding standards
  before committing. Checks YARD docs, formatting, component rules,
  test coverage, and example view conventions. Use when asked to "check
  my code", "review before committing", or "verify coding standards".
---

# Code Check

Review changed files against LocoMotion coding standards: `$ARGUMENTS`

If `$ARGUMENTS` is empty, check all files changed since `main`. If a
file path is provided, check only that file.

## Step 1 — Identify Changed Files

```bash
git diff --name-only main...HEAD
git diff --name-only HEAD
```

Group by type:
- Ruby component files (`app/components/**/*.rb`)
- HAML templates (`app/components/**/*.html.haml`)
- Ruby spec files (`spec/**/*.rb`)
- Example view files (`docs/demo/app/views/examples/**/*.haml`)
- Documentation files (`*.md`)
- Library files (`lib/**/*.rb`)

## Step 2 — Ruby Component File Checks

For each `.rb` component file, verify:

### Branch Safety
- [ ] Not on `main` branch

### Class Structure
- [ ] Inherits from `LocoMotion::BaseComponent`
- [ ] Has `self.component_name = "..."` set
- [ ] Has `def before_render` calling `setup_component` then `super`
- [ ] Has `private` section with `def setup_component`
- [ ] NEVER defines `part(:component)` (auto-handled by BaseComponent)
- [ ] NEVER adds `_css` / `_html` properties for parts

### DaisyUI Styling
- [ ] No `size:`, `color:`, or variant parameters added
- [ ] CSS classes used directly (e.g., `btn-primary`, `btn-lg`)

### YARD Documentation
- [ ] Class has a description comment
- [ ] `@part` used for every `define_part` call
- [ ] `@slot` used for every `renders_one` / `renders_many` call
  - `renders_many` uses `@slot name+`
- [ ] All `@param` / `@option` are on `initialize`, NOT the class
- [ ] Blank line between each `@param` / `@option`
- [ ] `@loco_example` used (NOT `@example`)
- [ ] Examples use HAML syntax with `daisy_` helper
- [ ] Examples ordered simplest → most complex
- [ ] Lines wrapped at 80 characters

### General Ruby
- [ ] No inline comments explaining WHAT (use YARD for public API)
- [ ] No debug or leftover code

## Step 3 — HAML Template Checks

For each `.html.haml` template, verify:
- [ ] Starts with `= part(:component) do`
- [ ] No hardcoded text that should be dynamic
- [ ] Parts rendered in logical order

## Step 4 — Spec File Checks

For each `_spec.rb` file, verify:
- [ ] `require "rails_helper"` at the top
- [ ] Uses `RSpec.describe` with `type: :component`
- [ ] Tests basic render (CSS class present)
- [ ] Tests with custom CSS
- [ ] Tests with HTML attributes if applicable
- [ ] No tests removed

## Step 5 — Example View Checks

For each example `.html.haml` file, verify:
- [ ] Has `doc_title` with a description block (not a TODO)
- [ ] Each `doc_example` has a `doc.with_description` block
- [ ] Uses `daisy_` helper methods
- [ ] No hardcoded pixel values or magic numbers

## Step 6 — Markdown File Checks

For each `.md` file, verify:
- [ ] Lines wrapped at 80 characters
- [ ] Newline after all headers
- [ ] Two newlines before H1 headings
- [ ] No trailing whitespace

## Step 7 — Report Results

Output a checklist summary:

```
Code Check Results
──────────────────

app/components/daisy/actions/button_component.rb
  ✓ Inherits BaseComponent
  ✓ YARD documentation complete
  ✓ No variant parameters
  ✗ Line 47 exceeds 80 characters

spec/components/daisy/actions/button_component_spec.rb
  ✓ Basic render test present
  ✓ CSS class test present
  ✗ Missing test for `href` option
```

For each failure, provide:
1. The specific file and line number
2. What rule is violated
3. A suggested fix

## Step 8 — Fix Issues (if requested)

If the user says "fix them" or "go ahead", fix each identified issue.
Then run:
```bash
just loco-test
```

Do NOT fix issues without explicit user confirmation.

## Resources

- Coding rules: `.windsurf/rules/coding.md`
- Component implementation rules: `.windsurf/rules/component_implementation.md`
- Documentation rules: `.windsurf/rules/documenting_code.md`
- Non-code docs rules: `.windsurf/rules/non_code_documentation.md`
- YARD documentation: https://yardoc.org/
