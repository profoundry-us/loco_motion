---
description: >
  Add or improve YARD documentation for a LocoMotion component class.
  Use when asked to "document component X", "add YARD docs", "improve
  documentation for", or when a component is missing documentation. Also
  runs automatically after /new-component creates a stub class.
---

# Document Component

Add YARD documentation to a LocoMotion component: `$ARGUMENTS`

`$ARGUMENTS` should be the component name or file path
(e.g., `ButtonComponent`, `daisy/actions/button_component`).

## Step 1 — Locate the Component

Find the component file:
```bash
find app/components -name "*{name}*_component.rb"
```

Read the full file before writing any documentation.

## Step 2 — Study a Well-Documented Reference

Read a similar, well-documented component for style guidance:
- `app/components/daisy/actions/button_component.rb` (rich examples,
  concern docs)
- `app/components/daisy/data_input/fieldset_component.rb` (slots + parts)
- `app/components/daisy/data_display/card_component.rb` (complex slots)

## Step 3 — Documentation Structure

Follow this order exactly in the class-level documentation:

```ruby
# 1. Description — brief explanation of the component's purpose.
#    What does it render? What DaisyUI class does it apply?
#
# 2. @note (optional) — important behavioral warnings.
#
# 3. @part declarations — one per define_part call.
#    Format: @part name - Description of the part's purpose.
#
# 4. @slot declarations — one per renders_one / renders_many call.
#    - renders_one:  @slot name [Type] Description.
#    - renders_many: @slot name+ [Type] Description (+ = multiple allowed).
#    Include @see references for related methods.
#
# 5. @loco_example blocks — ordered simplest to most complex.
#    Use HAML syntax. Each needs a descriptive title.
```

## Step 4 — Document the `initialize` Method

All `@param` and `@option` docs go on `initialize`, NOT on the class.

Rules:
- Use `@param` only for positional arguments.
- Use `@option` for all keyword arguments.
- Add a blank line between each `@param` / `@option`.
- Include the type in square brackets: `[String]`, `[Boolean]`, `[Hash]`.
- If `initialize` does not use the positional args, omit `@param` entirely.

Format:
```ruby
# Instantiate a new {ClassName} component.
#
# @param title [String] The title text.
#
# @option kws css    [String] Additional CSS classes.
#
# @option kws html   [Hash] Additional HTML attributes.
#
def initialize(title = nil, **kws)
```

## Step 5 — Write `@loco_example` Blocks

```ruby
# @loco_example Basic Usage
#   = daisy_{name}
#
# @loco_example With Custom Style
#   = daisy_{name}(css: "{name}-primary")
#
# @loco_example With Content Block
#   = daisy_{name} do
#     Content here
```

Rules:
- Use `@loco_example` — NOT `@example`
- Use the `daisy_` helper method, not the class directly
- Examples must be valid HAML
- Order: simplest → most complex

## Step 6 — Formatting Rules

- Wrap all comment lines at 80 characters
- One blank `#` line between sections
- Use `{ClassName}` in descriptions to reference the class (YARD will link it)
- For multi-line option descriptions, indent continuation with spaces

## Step 7 — Verify Documentation

Run YARD to check for warnings:
```bash
docker compose exec -it loco bundle exec yard doc --no-output 2>&1 | grep -i warn
```

If YARD reports errors or warnings, fix them before completing.

## Step 8 — Run Tests

```bash
just loco-test
```

Confirm nothing broke after the documentation changes.

## Resources

- YARD documentation: https://yardoc.org/
- YARD tags reference: https://rubydoc.info/gems/yard/file/docs/Tags.md
- Documentation rules: `.windsurf/rules/documenting_code.md`
- Well-documented reference: `app/components/daisy/actions/button_component.rb`
