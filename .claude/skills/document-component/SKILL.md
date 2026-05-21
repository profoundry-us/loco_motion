---
name: document-component
description: Adds or improves YARD documentation for a LocoMotion component class
  and its initialize method. Use when the user says "document a component",
  "add YARD docs", "write the docs", "document this component", or "add
  documentation".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Document Component

Writes or updates YARD documentation for a LocoMotion component following
project conventions.

## Instructions

### Step 1: Read the component class

Read the full component Ruby file before writing anything. Also read a similar
well-documented component (e.g. `CardComponent`, `ButtonComponent`) to use as
a style reference.

### Step 2: Follow the required doc order

Within the class body, YARD documentation must appear in this order:

1. **Description** — one or two sentences on what the component renders
2. **Notes** (optional) — `@note` for important behavioral caveats
3. **Parts** — `@part name - Description` for each `define_part` call
4. **Slots** — `@slot name [Type] - Description` for each `renders_one` /
   `renders_many` call
5. **Examples** — `@loco_example` blocks (see below)

All of 1–5 go in the **class-level** doc comment. Parameter docs go on
`initialize` only (see Step 4).

### Step 3: Write the class-level comment

```ruby
# Brief description of what this component renders.
#
# @note Any important behavioral note.
#
# @part icon - The optional leading icon.
#
# @slot header [HeaderComponent] - Optional card header slot.
#
# @loco_example Basic Usage
#   = daisy_button
#
# @loco_example With CSS variant
#   = daisy_button(css: "btn-primary btn-lg")
```

Rules:
- Use `@loco_example` (NOT `@example`).
- Examples must be valid HAML using `daisy_` helper methods.
- Order examples simplest → most complex.
- Wrap lines at 80 characters.

### Step 4: Document initialize

Place ALL `@param` and `@option` tags on the `initialize` method — never on
the class.

```ruby
# @param args [Array] Positional arguments passed to the parent.
# @param kws [Hash] Keyword arguments passed to the parent.
#
# @option kws [String] :css Additional CSS classes for the component.
```

Rules:
- Use `@param` for positional arguments, `@option` for keyword arguments.
- If `initialize` does not use positional args, omit `@param args`.
- Add a blank line between each `@param` / `@option` entry.
- Document only params that the component itself uses or that callers need to
  know about.

### Step 5: Document parts and slots inline

For each `define_part` call, add a `@part` tag in the class comment:

```ruby
# @part label - The visible text label inside the badge.
```

For each `renders_one` / `renders_many`, add a `@slot` tag:

```ruby
# @slot items+ [ItemComponent] - Repeating item rows.
```

Use `+` after the name for `renders_many` slots.

### Step 6: Verify the documentation

Re-read the updated file and confirm:

- No `@example` tags (must be `@loco_example`).
- All `@param` / `@option` on `initialize`, not the class.
- Lines wrapped at 80 characters.
- Proper punctuation on all list items and descriptions.

## Examples

**Example 1 — minimal component**

```ruby
# Renders a DaisyUI badge element.
#
# @loco_example Basic badge
#   = daisy_badge
#
# @loco_example Colored badge
#   = daisy_badge(css: "badge-primary")
class BadgeComponent < LocoMotion::BaseComponent
  # @param args [Array] Positional arguments.
  # @param kws [Hash] Keyword arguments.
  #
  # @option kws [String] :css Additional CSS classes.
  def initialize(*args, **kws)
    super
  end
end
```

**Example 2 — component with a part and a slot**

```ruby
# Renders a DaisyUI card with an optional header.
#
# @part figure - The card's image or media area.
#
# @slot header [Card::HeaderComponent] - Optional card header.
#
# @loco_example Basic card
#   = daisy_card do
#     Plain card body
class CardComponent < LocoMotion::BaseComponent
```

## Troubleshooting

**YARD ignores `@loco_example`** — This is a custom tag defined by the project.
It only renders correctly in the project's YARD configuration; do not switch to
`@example`.

**Long lines** — Wrap prose at 80 characters. HAML in examples may exceed 80
characters when needed for readability.

**`@param` on the class** — Move all param/option docs to `initialize`. The
class comment should contain only the description, notes, parts, slots, and
examples.
