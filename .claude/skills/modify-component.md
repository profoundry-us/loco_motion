---
description: >
  Modify an existing LocoMotion component following all project coding
  and documentation standards. Use when the user asks to update, enhance,
  add a feature to, or fix a specific component.
---

# Modify Component

## When to Use

- "Add icon support to LinkComponent"
- "Update the Alert component to support auto-dismiss"
- "Fix the tooltip not showing on mobile"
- "Enhance CardComponent with a new slot"

## Pre-Flight

Confirm we are **not** on `main`:
```bash
python .claude/skills/shared_scripts/check_branch.py
```

## Step 1 — Read Everything First

Find and read all files for the target component before touching anything:

```bash
# Component class
find app/components -name "*<name>*_component.rb"

# Template
find app/components -name "*<name>*_component.html.haml"

# Spec
find spec/components -name "*<name>*_component_spec.rb"

# Example view
find docs/demo/app/views/examples -name "*<name>*"
```

Also read any concerns the component includes:
```bash
ls lib/loco_motion/concerns/
```

## Step 2 — Identify Patterns

Before writing, note:
- Which `define_part` calls exist
- Which `renders_one` / `renders_many` slots exist
- Which concerns are included (Tippable, Linkable, Iconable, etc.)
- What CSS classes `setup_component` applies

## Step 3 — DaisyUI Styling Rule

**Never** add `size:`, `color:`, or style variant parameters.
Callers apply variants via `css:`:

```haml
= daisy_button(css: "btn-primary btn-lg")  ✓
= daisy_button(color: :primary, size: :lg) ✗
```

Only add a parameter when it changes **behavior**, not appearance.

## Step 4 — Implement Changes

Make changes in this order:

### Component class (`.rb`)

Adding a keyword option:
```ruby
def initialize(**kws)
  @new_option = config_option(:new_option, default_value)
  super(**kws)
end

def setup_component
  add_html(:component, { "data-foo": @new_option }) if @new_option
end
```

Adding a part:
```ruby
define_part :new_part

def setup_component
  add_css(:new_part, "css-class")
end
```

Including a concern:
```ruby
include LocoMotion::Concerns::TippableComponent
include LocoMotion::Concerns::LinkableComponent
include LocoMotion::Concerns::IconableComponent
```

### Template (`.html.haml`)

Only update if structure changes:
```haml
= part(:component) do
  = part(:new_part)   # ← add new parts in logical order
  = content
```

### Spec (`_spec.rb`)

Add cases for every new behavior. Never remove existing cases:
```ruby
context "with new_option" do
  let(:component) { described_class.new(new_option: "value") }
  before { render_inline(component) }

  it "applies the expected attribute" do
    expect(page).to have_css("[data-foo='value']")
  end
end
```

### Example view (`.html.haml`)

Add a `doc_example` for each new feature:
```haml
= doc_example(title: "New Feature") do |doc|
  - doc.with_description do
    :markdown
      Description of what this demonstrates.

  = daisy_<name>(new_option: "value")
```

### YARD docs

Update `initialize` options and add a `@loco_example` for each new
usage. See the `document-component` skill for full rules.

## Step 5 — Run Tests

```bash
just loco-test
```

If an example view changed, also run the relevant Playwright spec:
```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/<group>/<component>.spec.ts' --reporter dot --workers 1
```

## Step 6 — Prompt for Review

Before committing, explicitly tell the user what was changed and ask
them to review the modified files.

## Resources

- Component rules: `.windsurf/rules/component_implementation.md`
- Coding rules: `.windsurf/rules/coding.md`
- Documentation rules: `.windsurf/rules/documenting_code.md`
- Concerns: `lib/loco_motion/concerns/`
- DaisyUI components: https://daisyui.com/components/
- Modification plan template: `docs/plans/templates/component_modification.md`
