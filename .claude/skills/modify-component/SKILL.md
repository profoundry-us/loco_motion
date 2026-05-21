---
name: modify-component
description: Modifies an existing LocoMotion DaisyUI ViewComponent — adding parts,
  slots, CSS tweaks, or behavioral changes — while keeping all related files in
  sync. Use when the user says "update a component", "modify a component", "add
  a part to", "change the component", or "fix a component".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Modify Component

Updates an existing LocoMotion component while keeping its class, template,
spec, and example view consistent.

## Instructions

### Step 1: Identify the component

Confirm `component_name` and `component_group`. If not provided, ask.

Key file locations:

- Class: `app/components/daisy/{group}/{name}_component.rb`
- Template: `app/components/daisy/{group}/{name}_component.html.haml`
- Spec: `spec/components/daisy/{group}/{name}_component_spec.rb`
- Example: `docs/demo/app/views/examples/daisy/{group}/{plural_name}.html.haml`

### Step 2: Check the branch

```bash
python .claude/skills/shared-scripts/check_branch.py
```

Stop if on `main`.

### Step 3: Read existing files before editing

Read all four component files plus `lib/loco_motion/helpers.rb` before writing
any changes. Never modify a file you have not read in this session.

### Step 4: Apply the requested changes

**DaisyUI styling rule — critical**: Never add `size:`, `color:`, or other
visual-variant parameters to a component. Users apply DaisyUI variant classes
directly via `css: "btn-primary btn-lg"`. Only add params for structural or
behavioral differences.

**Parts**:
- Use `define_part :name` in the class.
- NEVER include `part(:component)` — that is handled by `BaseComponent`.
- NEVER add `_css` / `_html` props for parts — also handled by `BaseComponent`.
- Document with `@part name - Description` in the class YARD comment.

**Slots**:
- Use `renders_one :name, ComponentClass` or `renders_many :name+`.
- Document with `@slot` in the class YARD comment.

**CSS/HTML setup**:
- Apply classes and HTML attributes in `setup_component` using `add_css` and
  `add_html`.

### Step 5: Update the HAML template

Keep the template thin — logic belongs in the Ruby class. Use `part(:name)` to
render defined parts.

### Step 6: Update the spec

Add or update tests for every new behavior. Run tests after changes:

```bash
just loco-test
```

All tests must pass before proceeding.

### Step 7: Update the example view

Add or update `doc_example` blocks in the example HAML to demonstrate new
behavior. Follow the existing pattern:

```haml
= doc_example(title: "With Icon", allow_reset: true) do |doc|
  - doc.with_description do
    :markdown
      Shows the component with an icon part.

  = daisy_{component_name}(css: "...") do |c|
    - c.with_icon { "..." }
```

### Step 8: Restart demo if helpers.rb changed

Only restart if `lib/loco_motion/helpers.rb` was modified:

```bash
just demo-restart
```

### Step 9: Review

Read through the final versions of all modified files and verify they follow
the coding and documentation rules before reporting completion.

## Examples

**Example 1 — adding a part**

User: "Add an icon part to the Badge component"

1. Read `badge_component.rb`, add `define_part :icon` and `@part icon - ...`
2. Update template to render `part(:icon)` before the badge text
3. Add spec: `expect(page).to have_css(".badge .icon")`
4. Add `doc_example` showing `c.with_icon`

**Example 2 — adding a slot**

User: "Add a header slot to CardComponent"

1. Add `renders_one :header, HeaderComponent` in the class
2. Document with `@slot header [HeaderComponent] - ...`
3. Update template to call `header` slot if present
4. Add spec and example view entry

## Troubleshooting

**Tests fail after template changes** — Double-check that `part(:component)` is
used at the root of the template and that `part(:name)` matches the symbol
passed to `define_part`.

**Demo doesn't reflect changes** — Run `just demo-restart` only when
`lib/loco_motion` files changed. For component files, a browser refresh is
sufficient.

**Slot not rendering** — Ensure the template calls the slot method (e.g.
`= header` inside the component block) and that the slot is defined with
`renders_one` or `renders_many` in the class.
