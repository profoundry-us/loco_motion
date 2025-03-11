# Radio Button Component Implementation Plan

## Overview

This document outlines the implementation plan for a Radio Button component in the LocoMotion library. The component will be part of the Daisy UI data input components collection and will follow the existing patterns established by the Checkbox and Label components.

## Implementation Details

### 1. Component Structure

#### File Locations
- Component: `app/components/daisy/data_input/radio_button_component.rb`
- Specs: `spec/components/daisy/data_input/radio_button_component_spec.rb`
- Example Usage: `docs/demo/app/views/examples/daisy/data_input/radio_buttons.html.haml`
- Form Builder Helper Extension: Update `app/helpers/daisy/form_builder_helper.rb`
- Form Builder Helper Specs: Update `spec/helpers/daisy/form_builder_helper_spec.rb`
- Helper Registration: Update `lib/loco_motion/helpers.rb` to register the component

### 2. Component Design

#### Core Functionality
- Render a radio button input element
- Support common attributes (name, id, value, checked, disabled, required)
- Support styling options via DaisyUI classes
- Work both standalone and with a form builder

#### Component API

```ruby
Daisy::DataInput::RadioButtonComponent.new(
  name: "option",           # Required: The name attribute for grouping radio buttons
  id: "option1",           # Optional: The ID attribute for the radio button
  value: "1",             # Required: The value attribute for the radio button
  checked: false,          # Optional: Whether the radio button is checked
  disabled: false,         # Optional: Whether the radio button is disabled
  required: false,         # Optional: Whether the radio button is required
)
```

### 3. Implementation Steps

1. **Create Component Class**
   - Create the `RadioButtonComponent` class
   - Implement initialization method with appropriate parameters
   - Define component setup and rendering methods
   - Add documentation with examples

2. **Create Tests**
   - Write tests for the component's functionality
   - Test rendering with different options and attributes
   - Ensure proper HTML output and class assignments

3. **Create Example Views**
   - Create example usage in the demo app
   - Demonstrate different configuration options
   - Show usage with labels and form builders

4. **Update Form Builder Helper**
   - Add `daisy_radio` helper method to the form builder
   - Ensure consistency with other data input components

5. **Update Form Builder Helper Specs**
   - Add tests for the `daisy_radio` form builder method
   - Test proper object value binding (checked state based on object value)
   - Test ID generation with value included (e.g., `user_gender_male`)
   - Test overriding default attributes
   - Test passing additional options to the component

6. **Update Helpers Registration**
   - Update `lib/loco_motion/helpers.rb` to register the component

### 4. Detailed Component Structure

```ruby
class Daisy::DataInput::RadioButtonComponent < LocoMotion::BaseComponent
  attr_reader :name, :id, :value, :checked, :disabled, :required

  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value)
    @checked = config_option(:checked, false)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
  end

  def before_render
    setup_component
  end

  def setup_component
    set_tag_name(:component, :input)

    add_css(:component, "radio")

    add_html(:component, {
      type: "radio",
      name: @name,
      id: @id,
      value: @value,
      checked: @checked,
      disabled: @disabled,
      required: @required
    })
  end

  def call
    part(:component)
  end
end
```

### 5. Test Cases

- Renders a radio button input
- Renders with a specific value
- Renders as checked when specified
- Renders as disabled when specified
- Renders as required when specified
- Does not output an ID unless provided
- Uses the provided ID when specified

### 6. Example Usage

#### Basic Radio Buttons
```haml
= daisy_label(for: "option1") do
  = daisy_radio(name: "option", id: "option1", value: "1")
  Option 1

= daisy_label(for: "option2") do
  = daisy_radio(name: "option", id: "option2", value: "2", checked: true)
  Option 2
```

#### With Form Builder
```haml
= form_with(url: "#", method: :post, scope: :user) do |form|
  = form.daisy_label(:gender_male) do
    = form.daisy_radio(:gender, value: "male")
    Male

  = form.daisy_label(:gender_female) do
    = form.daisy_radio(:gender, value: "female")
    Female
```

## Future Enhancements

1. Add support for radio button groups
2. Add support for custom styling and sizing
3. Integrate with form validation
4. Consider accessibility improvements

## Dependencies

- LocoMotion BaseComponent
- DaisyUI CSS framework
- Existing Label component for proper usage
