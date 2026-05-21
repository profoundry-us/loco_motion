---
description: >
  Add or improve YARD documentation for a LocoMotion component. Use when
  a component is missing docs, has incomplete @part or @slot tags, lacks
  @loco_example blocks, or when creating a new component that needs docs
  written before the PR is opened.
---

# Document Component

## When to Use

- "Document the X component"
- "Add YARD docs to Y"
- "The Z component is missing examples"
- Automatically after creating a new component via the `new-component` skill

## Step 1 — Read the Component

Read the full `.rb` file before writing anything. Note:
- What the component renders
- What DaisyUI class it applies
- Every `define_part` call
- Every `renders_one` / `renders_many` call
- Every keyword argument in `initialize`

## Step 2 — Read a Well-Documented Reference

Pick the closest analogue and study its doc style:
- `app/components/daisy/actions/button_component.rb`
  (rich examples, concern docs, positional + keyword args)
- `app/components/daisy/data_input/fieldset_component.rb`
  (slots, simple args)
- `app/components/daisy/data_display/card_component.rb`
  (complex slot hierarchy)

## Step 3 — Class-Level Documentation Order

Write the class comment in this exact order:

```ruby
# 1. Description — one or two sentences: what it renders, what DaisyUI
#    class it applies, and any notable behavior.
#
# 2. @note (optional) — behavioral warnings or caveats.
#
# 3. @part lines — one per define_part call.
#    Format:  @part name - Brief description of the part's purpose.
#
# 4. @slot lines — one per renders_one / renders_many.
#    renders_one  → @slot name [Type] Description.
#    renders_many → @slot name+ [Type] Description.  (+ = multiple)
#    Use @see to reference related methods when helpful.
#
# 5. @loco_example blocks — ordered simplest to most complex.
```

## Step 4 — `initialize` Documentation

All `@param` and `@option` tags go on `initialize`, never on the class.

```ruby
#
# Instantiate a new WidgetComponent.
#
# @param title [String] The display title.
#
# @option kws css  [String] Additional CSS classes applied to the root.
#
# @option kws html [Hash] Additional HTML attributes for the root element.
#
def initialize(title = nil, **kws)
```

Rules:
- `@param` for positional arguments only; omit if `initialize` ignores them
- `@option` for every keyword argument the caller might set
- One blank `#` line between each `@param` / `@option` entry
- Type in square brackets: `[String]`, `[Boolean]`, `[Hash]`, `[Integer]`

## Step 5 — `@loco_example` Blocks

Use `@loco_example` (not `@example`). Every example needs a title.

```ruby
# @loco_example Basic Usage
#   = daisy_widget
#
# @loco_example With Content
#   = daisy_widget do
#     Some content
#
# @loco_example Primary Style
#   = daisy_widget(css: "widget-primary")
#
# @loco_example With Slot
#   = daisy_widget do |w|
#     - w.with_header { "Title" }
#     Body content
```

Rules:
- Use the `daisy_` helper (not `render ClassName.new`)
- Valid HAML syntax — indented with two spaces inside the example block
- Ordered: no args → with content → with CSS → with slots → complex

## Step 6 — Formatting

- Wrap all lines at 80 characters
- One blank `#` line between sections
- Use `{ClassName}` in prose for YARD cross-references

## Step 7 — Verify

Check for YARD warnings:
```bash
docker compose exec -it loco bundle exec yard doc --no-output 2>&1 | grep -i warn
```

Run tests:
```bash
just loco-test
```

## Resources

- Documentation rules: `.windsurf/rules/documenting_code.md`
- Reference component: `app/components/daisy/actions/button_component.rb`
- YARD tag reference: https://rubydoc.info/gems/yard/file/docs/Tags.md
- YARD getting started: https://yardoc.org/
