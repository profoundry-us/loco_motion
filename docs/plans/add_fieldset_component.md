# Fieldset Component Implementation Plan

## Overview

This plan outlines the steps to implement the DaisyUI Fieldset component in the
LocoMotion library as part of the DataInput group. The Fieldset component provides
a way to group related form elements visually, often including a legend (title).
This component corresponds to issue
[#32](https://github.com/profoundry-us/loco_motion/issues/32).

## External Resources

- [DaisyUI Fieldset Component](https://daisyui.com/components/fieldset/)
- [Rails View Components Guide](https://viewcomponent.org/guide/)

## Implementation Steps

### 1. Create the Component Class

**Purpose**: Define the core component class, including slots for legend and
basic setup.

**Slots**:
- `renders_one :legend` (Optional): Renders the `<legend>` element.

**File to Create**: `app/components/daisy/data_input/fieldset_component.rb`

**Reference Files**:
- `app/components/daisy/data_input/input_component.rb`
- `app/components/daisy/data_input/select_component.rb`

**Example Implementation**:

```ruby
module Daisy
  module DataInput
    # Renders a fieldset element, optionally with a legend, to group
    # related form controls or content.
    #
    # @example Basic fieldset
    #   = render Daisy::DataInput::FieldsetComponent.new do
    #     Content inside fieldset
    #
    # @example Fieldset with legend slot
    #   = render Daisy::DataInput::FieldsetComponent.new do |c|
    #     - c.with_legend { "My Legend" }
    #     Content inside fieldset
    #
    # @example Fieldset with legend argument
    #   = render Daisy::DataInput::FieldsetComponent.new(legend: "My Legend") do
    #     Content inside fieldset
    #
    class FieldsetComponent < LocoMotion::BaseComponent
      self.component_name = :fieldset

      define_parts :legend

      # The legend (title) for the fieldset. Renders a `<legend>` tag.
      # Can be provided as a slot or via the `legend` argument.
      renders_one :legend, LocoMotion::BasicComponent.build(tag_name: :legend, css: "fieldset-legend")

      # @param legend [String] Optional simple text for the legend.
      #   Ignored if the `legend` slot is used.
      def initialize(legend: nil, **kws)
        @simple_legend = legend
        super(**kws)
      end

      def before_render
        setup_component
        super
      end

      private

      # Sets up default tags and classes for the component and its parts.
      def setup_component
        set_tag_name(:component, :fieldset)
        set_tag_name(:legend, :legend)
        add_css(:legend, "fieldset-legend")
        # No specific base DaisyUI class for fieldset itself.
        # Styling comes from legend/label classes and utilities applied.
      end
    end
  end
end

```

### 2. Create Component View

**Purpose**: Provide the standard HTML structure using HAML, rendering the
legend and main content block.

**File to Create**: `app/components/daisy/data_input/fieldset_component.html.haml`

**Reference Files**:
- `app/components/daisy/data_input/input_component.html.haml`
- `app/components/daisy/data_input/select_component.html.haml`

**Example Implementation**:

```haml
= part(:component) do
  - if legend?
    = legend
  - elsif @simple_legend
    = part(:legend) { @simple_legend }

  -# Render the main content passed to the component block
  = content
```

### 3. Create Component Specs

**Purpose**: Ensure component functionality works as expected, including
rendering with/without slots and applying custom classes.

**File to Create**: `spec/components/daisy/data_input/fieldset_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_input/input_component_spec.rb`
- `spec/components/daisy/data_input/select_component_spec.rb`

**Example Implementation**:

```ruby
require "rails_helper"

RSpec.describe Daisy::DataInput::FieldsetComponent, type: :component do
  it "renders basic fieldset with content" do
    render_inline(described_class.new) do
      "Fieldset Content"
    end
    expect(page).to have_selector("fieldset", text: "Fieldset Content")
    expect(page).not_to have_selector("legend.fieldset-legend")
  end

  it "renders with legend slot" do
    render_inline(described_class.new) do |c|
      c.with_legend { "My Legend Slot" }
      "Fieldset Content"
    end
    expect(page).to have_selector("fieldset legend.fieldset-legend", text: "My Legend Slot")
  end

  it "renders with legend argument" do
    render_inline(described_class.new(legend: "My Simple Legend")) do
      "Fieldset Content"
    end
    expect(page).to have_selector("fieldset legend.fieldset-legend", text: "My Simple Legend")
  end

  it "prioritizes legend slot over argument" do
    render_inline(described_class.new(legend: "My Simple Legend")) do |c|
      c.with_legend { "My Legend Slot" }
      "Fieldset Content"
    end
    expect(page).to have_selector("fieldset legend.fieldset-legend", text: "My Legend Slot")
    expect(page).not_to have_selector("fieldset legend.fieldset-legend", text: "My Simple Legend")
  end

  it "applies custom CSS classes" do
    render_inline(described_class.new(class: "my-custom-class p-4")) do
      "Fieldset Content"
    end
    expect(page).to have_selector("fieldset.my-custom-class.p-4")
  end

  it "accepts standard HTML attributes" do
    render_inline(described_class.new(id: "my-id", data: { test: "value" })) do
      "Fieldset Content"
    end
    expect(page).to have_selector("fieldset#my-id[data-test='value']")
  end
end
```

### 4. Create Example View

**Purpose**: Provide usage examples and visual demonstration of the component
in the demo application.

**File to Create**: `docs/demo/app/views/examples/daisy/data_input/fieldsets.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/layout/cards.html.haml`
- `docs/demo/app/views/examples/daisy/layout/stacks.html.haml`

### 5. Register the Helper

**Purpose**: Make the component available to the application via a helper
method (`daisy_fieldset`).

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Existing helper registrations in `lib/loco_motion/helpers.rb`

**Example Implementation**:

```ruby
module LocoMotion
  module Helpers
    # {{ ... existing helper code ... }}

    # Registers the Daisy::DataInput::FieldsetComponent under the helper name :fieldset
    register_component :fieldset, Daisy::DataInput::FieldsetComponent

    # {{ ... more existing helper code ... }}
  end
end
```

## Component Features and Options

The Fieldset component will support:

1. Rendering a standard HTML `<fieldset>` element.
2. An optional `legend` slot **or** `legend` argument to render a `<legend>`
   with the `fieldset-legend` class. (Slot takes precedence).
3. Rendering provided block content within the fieldset.
4. Accepting standard HTML attributes and Tailwind/DaisyUI utility classes.

## Example Usage

```haml
= daisy_fieldset(legend: "User Settings") do
  = daisy_input_group(label: "Username") do
    = text_field_tag :username, nil, class: "input input-bordered"
  = daisy_input_group(label: "Email") do
    = email_field_tag :email, nil, class: "input input-bordered"
```

```haml
= daisy_fieldset(class: "bg-base-200 border border-base-300 p-4 rounded-box") do
  = daisy_input_group(label: "Notification Settings") do
    = daisy_toggle(label: "Enable email notifications")
