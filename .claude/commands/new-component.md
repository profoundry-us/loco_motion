---
description: >
  Create all stub files for a new LocoMotion DaisyUI component. Accepts
  component_name and component_group, creates the component class, template,
  spec, example view, and registers the helper. Triggers automatically when
  user says "create a new X component", "add a Y component", or "scaffold
  component Z".
---

# New Component

Create stub files for a new LocoMotion component: `$ARGUMENTS`

## Pre-Flight Checks

1. Confirm you are NOT on the `main` branch. If you are, stop and say:
   > "You are on `main`. Please switch to a feature branch first."

2. Parse `$ARGUMENTS` to extract:
   - `component_name` — snake_case (e.g., `text_input`, `radio_button`)
   - `component_group` — one of: `actions`, `data_display`, `data_input`,
     `feedback`, `layout`, `navigation`, `mockup`

   If either value is missing or the group is invalid, ask the user before
   continuing.

3. Run the validation script to see if files already exist:
   ```bash
   go run .claude/commands/shared_scripts/validate_component/main.go \
     <component_name> <component_group>
   ```
   If all files are already present, confirm with the user before overwriting.

## File Creation Steps

Create each file below **in order**. Use the indicated reference files to match
style, indentation, and patterns.

### 1. Component Class

**Path**: `app/components/daisy/{group}/{name}_component.rb`

**Reference files**:
- `app/components/daisy/data_input/fieldset_component.rb`
- `app/components/daisy/actions/button_component.rb`

**Rules**:
- Inherit from `LocoMotion::BaseComponent`
- Set `self.component_name = "{name}"`
- Include `def initialize(**kws)` calling `super`
- Include `def before_render` calling `setup_component` then `super`
- Keep `setup_component` in a `private` section
- Follow YARD documentation rules (see `/document-component`)
- NEVER add `part(:component)` — it is handled by `BaseComponent`
- Use DaisyUI CSS classes directly; do NOT create `size:` or `color:`
  parameters

### 2. Component Template

**Path**: `app/components/daisy/{group}/{name}_component.html.haml`

**Reference files**:
- `app/components/daisy/data_input/fieldset_component.html.haml`
- `app/components/daisy/actions/button_component.html.haml`

**Rules**:
- Start with `= part(:component) do`
- Render parts and slots in logical order inside the block

### 3. Component Spec

**Path**: `spec/components/daisy/{group}/{name}_component_spec.rb`

**Reference files**:
- `spec/components/daisy/actions/button_component_spec.rb`
- `spec/components/daisy/data_input/fieldset_component_spec.rb` (if exists)

**Rules**:
- Start with `require "rails_helper"`
- Use `RSpec.describe Daisy::{ModuleGroup}::{ClassName}Component, type: :component`
- Include at minimum: basic render, CSS class presence, and custom CSS test

### 4. Example View

**Path**:
`docs/demo/app/views/examples/daisy/{group}/{plural_name}.html.haml`

**Reference files**:
- `docs/demo/app/views/examples/daisy/actions/buttons.html.haml`
- `docs/demo/app/views/examples/daisy/data_input/fieldsets.html.haml`

**Rules**:
- Use `doc_title` with a TODO description block
- Include at least one `doc_example` with a `doc.with_description` block
- Use `daisy_{component_name}` helper (the registered name)

### 5. Register Component Helper

**File to edit**: `lib/loco_motion/helpers.rb`

Find the appropriate group section and add:

```ruby
"Daisy::{ModuleGroup}::{ClassName}Component" => {
  names: "{name}",
  group: "{GroupDisplay}",
  title: "{PluralTitle}",
  example: "{plural_name}"
},
```

Where `{GroupDisplay}` is human-readable (e.g., `"Data Input"`) and
`{PluralTitle}` is the pluralized component title (e.g., `"Text Inputs"`).

## Post-Creation Steps

1. Restart the demo app (required when `lib/loco_motion` files change):
   ```bash
   just demo-restart
   ```

2. Run the validation script to confirm all files were created:
   ```bash
   go run .claude/commands/shared_scripts/validate_component/main.go \
     <component_name> <component_group>
   ```

3. Run the RSpec tests to confirm nothing is broken:
   ```bash
   just loco-test
   ```

4. Report back with the summary format from `new_component_workflow.md`.

5. Prompt the user to review the created files before committing.

## Resources

- [DaisyUI Components](https://daisyui.com/components/)
- [ViewComponent Guide](https://viewcomponent.org/guide/)
- Validation script: `.claude/commands/shared_scripts/validate_component/main.go`
- Reference workflow: `.windsurf/workflows/new_component_workflow.md`
- Component implementation rules: `.windsurf/rules/component_implementation.md`
- Documentation rules: `.windsurf/rules/documenting_code.md`
