---
description: Create the stubs for a new component.
---

# New Component Workflow

## Overview

This workflow guides the AI through creating basic stub files for a new LocoMotion component. The goal is to create minimal file templates without attempting to guess complex implementation details.

## Input Parameters

- `component_name`: The name of the component in snake_case (e.g., `text_input`)
- `component_group`: The component group (e.g., `data_input`, `data_display`, `layout`, `navigation`, `feedback`)

## Steps

### 1. Validate Inputs

- Ensure both `component_name` and `component_group` are provided
- Verify that `component_group` is one of the valid groups: `data_input`, `data_display`, `layout`, `navigation`, `feedback`

### 2. Create Component Class File

**File path**: `app/components/daisy/{component_group}/{component_name}_component.rb`

**Content template**:

```ruby
module Daisy
  module {ModuleName}
    class {ClassName}Component < LocoMotion::BaseComponent
      self.component_name = "{component_name}"

      # Define parts here (empty by default)
      # part :label
      # part :icon

      def initialize(**kws)
        super(**kws)
      end

      def before_render
        setup_component
        super # Call super after setup
      end

      private

      def setup_component
        # TODO - Add css, html, and possibly set tag name
      end
    end
  end
end
```

Where:
- `{ModuleName}` is the capitalized version of `component_group` (e.g., `DataInput`)
- `{ClassName}` is the capitalized version of `component_name` (e.g., `TextInput`)

### 3. Create Component Template File

**File path**: `app/components/daisy/{component_group}/{component_name}_component.html.haml`

**Content template**:

```haml
= part(:component) do
  -# Basic component structure
  {component_name}
```

### 4. Create Component Test File

**File path**: `spec/components/daisy/{component_group}/{component_name}_component_spec.rb`

**Content template**:

```ruby
RSpec.describe Daisy::{ModuleName}::{ClassName}Component, type: :component do
  it "renders basic component" do
    render_inline(described_class.new)
    expect(page).to have_css(".{component_name}")
  end
end
```

Where:
- `{ModuleName}` is the capitalized version of `component_group` (e.g., `DataInput`)
- `{ClassName}` is the capitalized version of `component_name` (e.g., `TextInput`)

### 5. Create Example File

**File path**: `docs/demo/app/views/examples/daisy/{component_group}/{plural_component_name}.html.haml`

Where:
- `{plural_component_name}` is the pluralized component name (e.g., if component_name is "button", use "buttons"; if it's "entry", use "entries")

**IMPORTANT RULES**:
- MUST add a doc_title section with TODO text
- MUST add a single doc_example section
- MUST follow conventions shown in template below

**Content template**:

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

Where:
- `{ComponentTitle}` is the title-cased version of the component name (e.g., "Text Input")
- `{component_name}` is the snake_case component name

**After Creation**:

Run the following command to restart the demo app and see the new example file:

```bash
make demo-restart
```

### 6. Register Component Helper

**File path**: `lib/loco_motion/helpers.rb`

Add the component to the `COMPONENTS` hash in `helpers.rb`. Find the appropriate section based on the component group and add a new entry.

**Example entry to add**:

```ruby
"Daisy::{ModuleName}::{ClassName}Component" => { names: "{component_name}", group: "{GroupDisplay}", title: "{PluralTitle}", example: "{plural_component_name}" },
```

Where:
- `{ModuleName}` is the capitalized version of `component_group` (e.g., `DataInput`)
- `{ClassName}` is the capitalized version of `component_name` (e.g., `TextInput`)
- `{GroupDisplay}` is the human-readable group name (e.g., `Data Input`)
- `{PluralTitle}` is the pluralized title for the component (e.g., `Text Inputs`)
- `{plural_component_name}` is the pluralized component name for example file (e.g., `text_inputs`)

## Example Usage

This is how the workflow should be used:

1. Ask for component name and group
2. Create the minimum stub files following the templates above
3. Inform the user of the files created and what they can do next

### Sample Output

When you use this workflow to create a component, report back with a structure like:

```
I've created the following stub files for the new {ComponentName} component:

1. Component class: `app/components/daisy/{component_group}/{component_name}_component.rb`
2. Component template: `app/components/daisy/{component_group}/{component_name}_component.html.haml`
3. Component spec: `spec/components/daisy/{component_group}/{component_name}_component_spec.rb`
4. Example file: `docs/demo/app/views/examples/daisy/{component_group}/{plural_component_name}.html.haml`
5. Added the component registration to: `lib/loco_motion/helpers.rb`

I've also restarted the demo app to make the new component available.

These files contain minimal implementations to get started. You can now:

- Add parts and slots to the component class
- Implement the component template
- Write comprehensive tests
```
