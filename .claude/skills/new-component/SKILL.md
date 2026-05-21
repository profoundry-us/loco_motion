---
name: new-component
description: Creates all stub files for a new LocoMotion DaisyUI ViewComponent.
  Generates the component class, HAML template, RSpec spec, demo example view,
  and registers the component in helpers.rb. Use when the user says "create a
  new component", "add a component", "scaffold a component", or "new component
  workflow".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# New Component

Creates the minimum set of stub files for a new LocoMotion DaisyUI component
and registers it in the helper registry.

## Instructions

### Step 1: Validate inputs

Confirm you have both `component_name` (snake_case, e.g. `text_input`) and
`component_group`. Valid groups:

- `actions`
- `data_display`
- `data_input`
- `feedback`
- `layout`
- `navigation`

If either value is missing, ask the user before continuing.

### Step 2: Check the branch

Run the branch check script to ensure you are not on `main`:

```bash
python .claude/skills/shared-scripts/check_branch.py
```

If the script exits non-zero, stop and tell the user to switch to a feature
branch.

### Step 3: Derive naming conventions

From the inputs compute:

- `ModuleName` — PascalCase of `component_group` (e.g. `DataInput`)
- `ClassName` — PascalCase of `component_name` (e.g. `TextInput`)
- `plural_name` — pluralized `component_name` (e.g. `text_inputs`)
- `ComponentTitle` — title-cased, space-separated (e.g. `Text Input`)

### Step 4: Create the component class

**Path**: `app/components/daisy/{component_group}/{component_name}_component.rb`

```ruby
module Daisy
  module {ModuleName}
    class {ClassName}Component < LocoMotion::BaseComponent
      self.component_name = "{component_name}"

      def initialize(**kws)
        super(**kws)
      end

      def before_render
        setup_component
        super
      end

      private

      def setup_component
        # TODO: Add css, html, and possibly set tag name
      end
    end
  end
end
```

### Step 5: Create the HAML template

**Path**: `app/components/daisy/{component_group}/{component_name}_component.html.haml`

```haml
= part(:component) do
  -# Basic component structure
  {component_name}
```

### Step 6: Create the RSpec spec

**Path**: `spec/components/daisy/{component_group}/{component_name}_component_spec.rb`

```ruby
RSpec.describe Daisy::{ModuleName}::{ClassName}Component, type: :component do
  it "renders basic component" do
    render_inline(described_class.new)
    expect(page).to have_css(".{component_name}")
  end
end
```

### Step 7: Create the demo example view

**Path**: `docs/demo/app/views/examples/daisy/{component_group}/{plural_name}.html.haml`

```haml
= doc_title(title: "{ComponentTitle}", comp: @comp) do |title|
  :markdown
    TODO: Add description of the {component_name} component


= doc_example(title: "Basic Usage", allow_reset: true) do |doc|
  - doc.with_description do
    :markdown
      TODO: Add description of basic {component_name} usage

  = daisy_{component_name}
```

### Step 8: Register the component in helpers.rb

Open `lib/loco_motion/helpers.rb` and add an entry to the `COMPONENTS` hash
under the appropriate group section:

```ruby
"Daisy::{ModuleName}::{ClassName}Component" => {
  names: "{component_name}",
  group: "{GroupDisplay}",
  title: "{PluralTitle}",
  example: "{plural_name}"
},
```

### Step 9: Restart the demo app

Because `lib/loco_motion/helpers.rb` was modified, restart the demo app:

```bash
just demo-restart
```

### Step 10: Validate

Run the validation script to confirm all files exist and the component is
registered:

```bash
python .claude/skills/shared-scripts/validate_component.py {component_name} {component_group}
```

All checks must pass before reporting success.

## Examples

**Example 1 — data_display component**

User: "Create a new stat component in data_display"

- `component_name` = `stat`
- `component_group` = `data_display`
- `ModuleName` = `DataDisplay`
- `ClassName` = `Stat`
- `plural_name` = `stats`
- Helper entry group: `"Data Display"`

**Example 2 — actions component**

User: "Scaffold a dropdown component for actions"

- `component_name` = `dropdown`
- `component_group` = `actions`
- `ModuleName` = `Actions`
- `ClassName` = `Dropdown`
- `plural_name` = `dropdowns`

## Troubleshooting

**validate_component.py reports a missing file** — Check that the path uses the
correct `component_group` subdirectory. Recreate any missing file following the
templates in Steps 4–7.

**demo-restart fails** — Run `docker compose ps` to confirm the `demo` container
is running. If not, run `docker compose up -d demo`.

**Component not visible in demo nav** — Confirm the `helpers.rb` entry uses the
exact class name string and that `just demo-restart` completed successfully.
