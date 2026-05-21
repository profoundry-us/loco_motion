---
description: >
  Scaffold all required files for a new LocoMotion DaisyUI component.
  Use when the user asks to create, add, or scaffold a new component.
  Requires a component name (snake_case) and a component group.
---

# New Component

## When to Use

- "Create a new X component"
- "Add a Y component to the Z group"
- "Scaffold the FooBar component"
- "I need a new component for DaisyUI's X"

## Pre-Flight

1. Confirm we are **not** on `main`:
   ```bash
   python .claude/skills/shared_scripts/check_branch.py
   ```
   If on `main`, stop and ask the user to switch branches.

2. Identify `component_name` (snake_case) and `component_group` from the
   conversation. Valid groups: `actions`, `data_display`, `data_input`,
   `feedback`, `layout`, `navigation`, `mockup`. Ask if unclear.

3. Run the validator to see what already exists:
   ```bash
   python .claude/skills/shared_scripts/validate_component.py \
     <component_name> <component_group>
   ```

## Step 1 — Component Class

**Path**: `app/components/daisy/<group>/<name>_component.rb`

**Reference files**:
- `app/components/daisy/data_input/fieldset_component.rb`
- `app/components/daisy/actions/button_component.rb`

Rules:
- Inherit from `LocoMotion::BaseComponent`
- Set `self.component_name = "<name>"`
- `def before_render` must call `setup_component` then `super`
- Keep `setup_component` in a `private` section
- **Never** define `part(:component)` — BaseComponent handles it
- **Never** add `size:`, `color:`, or style variant parameters;
  callers use `css:` directly
- Include YARD docs following the `document-component` skill

## Step 2 — Component Template

**Path**: `app/components/daisy/<group>/<name>_component.html.haml`

**Reference files**:
- `app/components/daisy/data_input/fieldset_component.html.haml`
- `app/components/daisy/actions/button_component.html.haml`

Rules:
- Open with `= part(:component) do`
- Render parts and slots in logical order inside the block

## Step 3 — Component Spec

**Path**: `spec/components/daisy/<group>/<name>_component_spec.rb`

**Reference files**:
- `spec/components/daisy/actions/button_component_spec.rb`

Rules:
- Start with `require "rails_helper"`
- `RSpec.describe Daisy::<ModuleGroup>::<ClassName>Component, type: :component`
- Must include: basic render, CSS class presence, custom `css:` passthrough

## Step 4 — Example View

**Path**:
`docs/demo/app/views/examples/daisy/<group>/<plural_name>.html.haml`

**Reference files**:
- `docs/demo/app/views/examples/daisy/actions/buttons.html.haml`

Rules:
- Use `doc_title` with a description block
- At least one `doc_example` with `doc.with_description`
- Use the `daisy_<name>` helper

## Step 5 — Register in helpers.rb

**File**: `lib/loco_motion/helpers.rb`

Add inside the correct group section:

```ruby
"Daisy::<ModuleGroup>::<ClassName>Component" => {
  names: "<name>",
  group: "<GroupDisplay>",
  title: "<PluralTitle>",
  example: "<plural_name>"
},
```

## Post-Creation

1. Restart the demo app (always required after editing `lib/loco_motion`):
   ```bash
   just demo-restart
   ```

2. Validate all files were created:
   ```bash
   python .claude/skills/shared_scripts/validate_component.py \
     <name> <group>
   ```

3. Run the library tests:
   ```bash
   just loco-test
   ```

4. Report the created files to the user and prompt them to review
   before committing.

## Resources

- Validation script: `.claude/skills/shared_scripts/validate_component.py`
- Workflow reference: `.windsurf/workflows/new_component_workflow.md`
- Component rules: `.windsurf/rules/component_implementation.md`
- Documentation rules: `.windsurf/rules/documenting_code.md`
- DaisyUI components: https://daisyui.com/components/
- ViewComponent guide: https://viewcomponent.org/guide/
