# Simplified Component Implementation Template

## Overview

This is a simplified template for implementing new components in the LocoMotion
library. Each step includes:

1. A short sentence about the purpose of the file
2. The file to create
3. Two existing files to use as reference
4. Any additional notes about that specific file.
5. A code example showing how we might implement that file.

Below is an example implementation plan for a fictional `FakeComponent` in the
`DataInput` module.

## External Resources

- [DaisyUI Form Elements](https://daisyui.com/components/input/)
- [Rails View Components Guide](https://viewcomponent.org/guide/)

## Implementation Steps

### 1. Create the Component Class

**Purpose**: Define the core component class, including rendering,
configuration, and any necessary parts or slots.

**Parts**:

- label: For displaying a label.
- icon: For adding an icon.
- items (Multiple): For list-like components.
- caption: For displaying a caption.

**Slots**:

- top: For content above the main content of the component.
- bottom: For content below the main content of the component.

**File to Create**: `app/components/daisy/data_input/fake_component.rb`

**Reference Files**:
- `app/components/daisy/data_input/checkbox_component.rb`
- `app/components/daisy/data_input/range_component.rb`

**Example Implementation**:

```ruby
module Daisy
  module DataInput
    class FakeComponent < LocoMotion::BaseComponent
      self.component_name = "fake"

      part :label
      part :icon
      part :items, multiple: true
      part :caption

      renders_one :top
      renders_one :bottom

      # @param name [String] Required identifier for the component.
      # @param simple_caption [String] Optional simple caption text displayed below the component.
      #   For more complex content, use the `with_caption` slot.
      def initialize(name:, simple_caption: nil, **system_arguments)
        @name = name
        @simple_caption = simple_caption
        super(**system_arguments)
      end

      def before_render
        setup_component
        super # Call super after setup
      end

      private

      def setup_component
        # Add base component class
        add_css(:component, "fake")

        # Add data attribute if caption is present (either via part or simple_caption)
        add_html(:component, { data: { captioned: true } }) if caption? || @simple_caption

        # Set default tag if not already set (e.g., by LinkableComponent)
        set_tag_name(:component, :div)

        # Add standard data attributes
        add_html(:component, { data: { name: @name } })
      end
    end
  end
end
```

### 2.1. Create Component View

**Purpose**: Provide a standard HTML structure for the component.

**File to Create**: `app/components/daisy/data_input/fake_component.html.haml`

**Reference Files**:
- `app/components/daisy/data_input/checkbox_component.html.haml`
- `app/components/daisy/data_input/range_component.html.haml`

**Example Implementation**:

```haml
= top if top?

= part(:component) do
  = part(:label)
  = part(:icon)
  - part(:items).each do |item|
    = item

- if caption?
  = caption
- elsif @simple_caption
  = part(:caption) do
    = @simple_caption

= bottom if bottom?
```

### 2. Create Component Tests

**Purpose**: Ensure component functionality works as expected through
comprehensive test cases.

**File to Create**: `spec/components/daisy/data_input/fake_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_input/checkbox_component_spec.rb`
- `spec/components/daisy/data_input/range_component_spec.rb`

**Example Implementation**:

```ruby
RSpec.describe Daisy::DataInput::FakeComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new(name: "my_fake"))
    expect(page).to have_css(".fake")
  end

  it "renders with label and icon" do
    render_inline(described_class.new(name: "my_fake")) do |c|
      c.with_label { "My Label" }
      c.with_icon { "fake-icon" }
    end
    expect(page).to have_text("My Label")
    expect(page).to have_css(".fake-icon")
  end
end
```

### 3. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_input/fakes.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_input/checkboxes.html.haml`
- `docs/demo/app/views/examples/daisy/data_input/ranges.html.haml`

**Example Implementation**:

```haml
= doc_example(title: "Basic Fake") do
  = daisy_fake(name: "basic")

= doc_example(title: "Fake with Label and Icon") do
  = daisy_fake(name: "labelled") do |c|
    - c.with_label { "Click Me" }
    - c.with_icon { "star" }
```

### 4. Update Form Builder Helper

**Purpose**: Add form builder integration to allow usage with Rails form
builders.

**File to Edit**: `app/helpers/daisy/form_builder_helper.rb`

**Reference Files**:
- Current implementation in `app/helpers/daisy/form_builder_helper.rb` (checkbox methods)
- Current implementation in `app/helpers/daisy/form_builder_helper.rb` (range methods)

**Example Implementation**:

```ruby
module Daisy
  module FormBuilderHelper
    def fake_field(method, options = {}, &block)
      component = Daisy::DataInput::FakeComponent.new(
        name: method,
        **options.slice(:class, :css, :data, :id) # Add other relevant options
      )
      # Additional logic might be needed to handle value, checked state, etc.
      render component, &block
    end
  end
end
```

### 5. Update Form Builder Helper Specs

**Purpose**: Test the form builder integration for the new component.

**File to Edit**: `spec/helpers/daisy/form_builder_helper_spec.rb`

**Reference Files**:
- Current specs in `spec/helpers/daisy/form_builder_helper_spec.rb` (checkbox specs)
- Current specs in `spec/helpers/daisy/form_builder_helper_spec.rb` (range specs)

**Example Implementation**:

```ruby
describe "#fake_field" do
  it "renders the fake component" do
    render_form_for @user do |f|
      f.fake_field :agreed_to_terms
    end
    expect(page).to have_css(".fake[name='user[agreed_to_terms]']")
  end
end
```

### 6. Register the Helper

**Purpose**: Make the component available to the application by registering it.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/helpers.rb` (checkbox registration)
- Current implementation in `lib/loco_motion/helpers.rb` (range registration)

**Example Implementation**:

```ruby
module LocoMotion
  module Helpers
    # ... existing helpers ...

    def daisy_fake(name:, **options, &block)
      render Daisy::DataInput::FakeComponent.new(name: name, **options), &block
    end

    # ... other helper registrations ...
    register_helpers self, :daisy_fake
  end
end
