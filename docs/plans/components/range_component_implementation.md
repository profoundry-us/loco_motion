# Range Component Implementation Plan

## Overview

This document outlines the implementation plan for a Range component in the LocoMotion library. The component will be part of the Daisy UI data input components collection and will follow the existing patterns established by other input components, such as the Checkbox and Radio Button components.

## Implementation Details

### 1. Component Structure

#### File Locations
- Component: `app/components/daisy/data_input/range_component.rb`
- Specs: `spec/components/daisy/data_input/range_component_spec.rb`
- Example Usage: `docs/demo/app/views/examples/daisy/data_input/ranges.html.haml`
- Form Builder Helper Extension: Update `app/helpers/daisy/form_builder_helper.rb`
- Form Builder Helper Specs: Update `spec/helpers/daisy/form_builder_helper_spec.rb`
- Helper Registration: Update `lib/loco_motion/helpers.rb` to register the component

### 2. Component Design

#### Core Functionality
- Render a range input element (HTML5 slider)
- Support common attributes (name, id, min, max, step, value, disabled, required)
- Support styling options via DaisyUI classes
- Work both standalone and with a form builder
- Support for steps with visual indicators

#### Component API

```ruby
Daisy::DataInput::RangeComponent.new(
  name: "volume",          # Required: The name attribute for the range input
  id: "volume_control",    # Optional: The ID attribute for the range input
  min: 0,                 # Optional: The minimum value (default: 0)
  max: 100,               # Optional: The maximum value (default: 100)
  step: 1,                # Optional: The step increment (default: 1)
  value: 50,              # Optional: The current value (default: min)
  disabled: false,        # Optional: Whether the range input is disabled
  required: false,        # Optional: Whether the range input is required
)
```

### 3. Implementation Steps

1. **Create Component Class**
   - Create the `RangeComponent` class
   - Implement initialization method with appropriate parameters
   - Define component setup and rendering methods
   - Add documentation with examples

2. **Create Tests**
   - Write tests for the component's functionality
   - Test rendering with different options and attributes
   - Test different values, min/max ranges, and step sizes
   - Ensure proper HTML output and class assignments

3. **Create Example Views**
   - Create example usage in the demo app
   - Demonstrate different configuration options (min/max, step)
   - Show usage with labels and form builders
   - Show examples with step indicators

4. **Update Form Builder Helper**
   - Add `daisy_range` helper method to the form builder
   - Ensure consistency with other data input components

5. **Update Form Builder Helper Specs**
   - Add tests for the `daisy_range` form builder method
   - Test proper object value binding
   - Test ID generation
   - Test overriding default attributes
   - Test passing additional options to the component

6. **Update Helpers Registration**
   - Update `lib/loco_motion/helpers.rb` to register the component

### 4. Detailed Component Structure

```ruby
class Daisy::DataInput::RangeComponent < LocoMotion::BaseComponent
  attr_reader :name, :id, :min, :max, :step, :value, :disabled, :required

  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @min = config_option(:min, 0)
    @max = config_option(:max, 100)
    @step = config_option(:step, 1)
    @value = config_option(:value, @min)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
  end

  def before_render
    setup_component
  end

  def setup_component
    set_tag_name(:component, :input)

    add_css(:component, "range")

    add_html(:component, {
      type: "range",
      name: @name,
      id: @id,
      min: @min,
      max: @max,
      step: @step,
      value: @value,
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

- Renders a range input
- Renders with specified min and max values
- Renders with specified step value
- Renders with specified initial value
- Renders as disabled when specified
- Renders as required when specified
- Does not output an ID unless provided
- Uses the provided ID when specified
- Default value is min when not specified

### 6. Example Usage

#### Basic Range
```haml
= daisy_label(for: "volume", title: "Volume")
= daisy_range(name: "volume", id: "volume", min: 0, max: 100, value: 50)
```

#### Range with Different Colors
```haml
= daisy_label(for: "primary_range", title: "Primary Range")
= daisy_range(name: "primary_range", id: "primary_range", value: 60, css: "range-primary")

= daisy_label(for: "secondary_range", title: "Secondary Range")
= daisy_range(name: "secondary_range", id: "secondary_range", value: 70, css: "range-secondary")

= daisy_label(for: "accent_range", title: "Accent Range")
= daisy_range(name: "accent_range", id: "accent_range", value: 80, css: "range-accent")

= daisy_label(for: "success_range", title: "Success Range")
= daisy_range(name: "success_range", id: "success_range", value: 90, css: "range-success")

= daisy_label(for: "warning_range", title: "Warning Range")
= daisy_range(name: "warning_range", id: "warning_range", value: 30, css: "range-warning")

= daisy_label(for: "error_range", title: "Error Range")
= daisy_range(name: "error_range", id: "error_range", value: 10, css: "range-error")
```

#### Range with Steps and Visual Indicators
```haml
.w-full.max-w-xs
  = daisy_label(for: "step_range", title: "Satisfaction Level")
  = daisy_range(name: "step_range", id: "step_range", min: 0, max: 100, step: 25, value: 50)
  .flex.justify-between.px-2.mt-2.text-xs
    %span |
    %span |
    %span |
    %span |
    %span |
  .flex.justify-between.px-2.mt-2.text-xs
    %span 1
    %span 2
    %span 3
    %span 4
    %span 5
```

#### With Form Builder
```haml
= form_with(url: "#", method: :post, scope: :user) do |form|
  = form.daisy_label(:volume, "Volume Control")
  = form.daisy_range(:volume, min: 0, max: 100, step: 5)
  
  = form.daisy_label(:brightness, "Brightness")
  = form.daisy_range(:brightness)
```

## Future Enhancements

1. Add support for displaying the current value next to the slider
2. Add support for custom styling and sizing
3. Add support for vertical orientation
4. Support for dual-handle range (min and max selectors)
5. Integrate with form validation
6. Consider accessibility improvements

## Dependencies

- LocoMotion BaseComponent
- DaisyUI CSS framework
- Existing Label component for proper usage
