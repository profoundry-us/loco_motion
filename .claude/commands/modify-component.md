---
description: >
  Modify an existing LocoMotion component following project standards.
  Use when asked to "update component X", "add Y to the Z component",
  "fix the W component", or "enhance component V". Follows the
  component_modification plan template and coding rules.
---

# Modify Component

Modify an existing LocoMotion component: `$ARGUMENTS`

`$ARGUMENTS` should describe what component to modify and what change to
make (e.g., `Add icon support to LinkComponent`).

## Step 0 — Branch Safety Check

```bash
git branch --show-current
```

If on `main`, STOP:
> "You are on `main`. Please switch to a feature branch first."

## Step 1 — Read Existing Component Files

Find and read all relevant files for the component:

```bash
# Component class
find app/components -name "*{name}*_component.rb" | head -5

# Component template
find app/components -name "*{name}*_component.html.haml" | head -5

# Spec file
find spec/components -name "*{name}*_component_spec.rb" | head -5

# Example view
find docs/demo/app/views/examples -name "*{name}*" | head -5
```

Read each file completely before writing any changes.

## Step 2 — Understand the Patterns

Before modifying, identify:

1. **What parts does the component define?** (via `define_part`)
2. **What slots does it use?** (via `renders_one` / `renders_many`)
3. **What concerns does it include?** (TippableComponent, LinkableComponent,
   IconableComponent, etc.)
4. **What CSS classes does it apply?** (in `setup_component`)

Read any included concerns to understand what they provide:
```bash
find lib/loco_motion/concerns -name "*.rb" | head -10
```

## Step 3 — DaisyUI Styling Rules

**NEVER** add `size:`, `color:`, or variant parameters to components.

Instead, use CSS classes directly:
```haml
= daisy_button(css: "btn-primary btn-lg")
= daisy_badge(css: "badge-success badge-outline")
```

Only add parameters when behavior (not just style) changes.

## Step 4 — Implement the Changes

Make changes in this order:

1. **Component class** (`.rb`) — add new options, update `setup_component`
2. **Component template** (`.html.haml`) — update structure if needed
3. **Tests** (`.rb`) — add tests for the new behavior
4. **Example view** (`.html.haml`) — add new examples demonstrating the change
5. **YARD documentation** — update `initialize` docs and add new examples

### Adding a New Option

```ruby
def initialize(**kws)
  @new_option = config_option(:new_option, default_value)
  super(**kws)
end

def setup_component
  add_html(:component, { "data-new": @new_option }) if @new_option
end
```

### Adding a New Part

```ruby
define_part :new_part

def setup_component
  add_css(:new_part, "some-css-class")
end
```

In the template:
```haml
= part(:component) do
  = part(:new_part)
  = content
```

### Including a Concern

```ruby
include LocoMotion::Concerns::TippableComponent
include LocoMotion::Concerns::LinkableComponent
include LocoMotion::Concerns::IconableComponent
```

## Step 5 — Update Tests

Add test cases for every new behavior:

```ruby
context "with new_option" do
  let(:component) { described_class.new(new_option: "value") }

  before { render_inline(component) }

  it "applies the expected attribute" do
    expect(page).to have_css("[data-new='value']")
  end
end
```

Never remove existing test cases.

## Step 6 — Update Example View

Add one or more `doc_example` blocks for the new feature:

```haml
= doc_example(title: "New Feature Example") do |doc|
  - doc.with_description do
    :markdown
      Description of the new feature.

  = daisy_{name}(new_option: "value")
```

## Step 7 — Run Tests

```bash
just loco-test
```

If tests fail, fix them before continuing.

Optionally run the related Playwright tests if an example view changed:
```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/{group}/{component}.spec.ts' --reporter dot --workers 1
```

## Step 8 — Review Before Committing

Review changes against all applicable rules:
- `.windsurf/rules/coding.md`
- `.windsurf/rules/component_implementation.md`
- `.windsurf/rules/documenting_code.md`

Then explicitly prompt the user:
> "Changes are complete. Please review the modified files before I commit."

## Resources

- Component implementation rules: `.windsurf/rules/component_implementation.md`
- Coding rules: `.windsurf/rules/coding.md`
- Documentation rules: `.windsurf/rules/documenting_code.md`
- Concerns: `lib/loco_motion/concerns/`
- DaisyUI components: https://daisyui.com/components/
- Modification plan template: `docs/plans/templates/component_modification.md`
