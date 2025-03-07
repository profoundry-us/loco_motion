# Select Component Implementation Plan

## Overview

This document outlines the implementation plan for a Select component in the LocoMotion library. The component will be part of the Daisy UI data input components collection and will follow the existing patterns established by other input components such as Checkbox, Radio Button, Range, and Rating components.

## Implementation Details

### 1. Component Structure

#### File Locations
- Component: `app/components/daisy/data_input/select_component.rb`
- Template: `app/components/daisy/data_input/select_component.html.haml`
- Specs: `spec/components/daisy/data_input/select_component_spec.rb`
- Example Usage: `docs/demo/app/views/examples/daisy/data_input/selects.html.haml`
- Form Builder Helper Extension: Update `app/helpers/daisy/form_builder_helper.rb`
- Form Builder Helper Specs: Update `spec/helpers/daisy/form_builder_helper_spec.rb`
- Helper Registration: Update `lib/loco_motion/helpers.rb` to register the component

### 2. Component Design

#### Core Functionality
- Render a select dropdown that allows users to choose from a list of options
- Support both standalone mode and form builder integration
- Support different styles via CSS classes
- Support disabled and required states
- Support placeholder options
- Allow custom option rendering through content blocks

#### Component API

```ruby
Daisy::DataInput::SelectComponent.new(
  name: "country",         # Required: The name attribute for the select
  id: "country",           # Optional: The ID attribute for the select
  value: "us",             # Optional: The current selected value
  placeholder: "Select a country", # Optional: Placeholder text for the select
  disabled: false,         # Optional: Whether the select is disabled
  required: false,         # Optional: Whether the select input is required
  options: [               # Optional: Array of options for the select
    { value: "us", label: "United States" },
    { value: "ca", label: "Canada" }
  ],
  options_css: "",        # Optional: CSS classes to apply to each option
  options_html: {}         # Optional: HTML attributes to apply to each option
)
```

### 3. Implementation Steps

1. **Create Component Class**
   - Create the `SelectComponent` class
   - Implement initialization method with appropriate parameters
   - Define component setup and rendering methods
   - Support options rendering both from the options array and from content blocks
   - Add documentation with examples

2. **Create Tests**
   - Write tests for the component's functionality
   - Test rendering with different options and attributes
   - Test different CSS classes
   - Test disabled and required states
   - Test placeholder options
   - Test custom option rendering
   - Ensure proper HTML output and class assignments

3. **Create Example Views**
   - Create example usage in the demo app
   - Demonstrate different configuration options (sizing, colors)
   - Show usage with different CSS classes for styling
   - Show both standalone and form builder usage
   - Show usage with custom option rendering

4. **Update Form Builder Helper**
   - Add `daisy_select` helper method to the form builder
   - Ensure consistency with other data input components

5. **Update Form Builder Helper Specs**
   - Add tests for the `daisy_select` form builder method
   - Test proper object value binding
   - Test overriding default attributes
   - Test passing additional options to the component

6. **Update Helpers Registration**
   - Update `lib/loco_motion/helpers.rb` to register the component

### 4. Detailed Component Structure

```ruby
class Daisy::DataInput::SelectComponent < LocoMotion::BaseComponent
  class SelectOptionComponent < LocoMotion::BasicComponent
    attr_reader :value, :label, :selected

    def initialize(value:, label:, selected: false, **kws)
      super(**kws)
      @value = value
      @label = label
      @selected = selected
    end

    def before_render
      set_tag_name(:component, :option)
    end

    def call
      add_html(:component, {
        value: @value,
        selected: @selected
      })

      safe_join([part(:component) { label }])
    end
  end

  renders_many :options, SelectOptionComponent

  attr_reader :name, :id, :value, :placeholder, :disabled, :required, :options_list, :options_css, :options_html

  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value)
    @placeholder = config_option(:placeholder)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
    @options_list = config_option(:options, [])
    @options_css = config_option(:options_css, "")
    @options_html = config_option(:options_html, {})
  end

  def before_render
    setup_component
  end

  def setup_component
    set_tag_name(:component, :select)

    add_css(:component, "select")
    add_css(:component, "select-bordered")

    add_html(:component, {
      name: @name,
      id: @id,
      disabled: @disabled,
      required: @required
    })
  end

  def default_options
    # If no options provided via content block, use the options_list
    return [] if options_list.blank?

    options_list.map do |option|
      value = option.is_a?(Hash) ? option[:value] : option
      label = option.is_a?(Hash) ? option[:label] : option.to_s

      SelectOptionComponent.new(
        value: value,
        label: label,
        selected: value.to_s == @value.to_s,
        css: @options_css,
        html: @options_html
      )
    end
  end

  def placeholder_option
    content_tag(:option, @placeholder, {
      value: "",
      disabled: @required,
      selected: @value.blank?
    })
  end
end
```

The component will use a template file to handle the rendering of options.

```haml
# app/components/daisy/data_input/select_component.html.haml
= part(:component) do
  - if @placeholder
    = placeholder_option

  - if options?
    - options.each do |option|
      - option.set_loco_parent(component_ref)
      = option
  - elsif content?
    = content
  - elsif default_options.present?
    - default_options.each do |option|
      - option.set_loco_parent(component_ref)
      = render(option)
```

### 5. Test Cases

- Renders a select component with default options
- Renders with a specified placeholder
- Renders with a selected value
- Correctly handles disabled attribute
- Correctly handles required attribute
- Renders with custom options provided via block
- Renders with options provided via array
- Correctly renders with a form builder
- Applies appropriate CSS classes

### 6. Example Usage

Below are some basic examples, but we will expand upon these by adding titles,
descriptions, and notes similar to how the other example files are built.

#### Basic Select
```haml
= daisy_label(for: "country", title: "Country")
= daisy_select(name: "country", id: "country", placeholder: "Select a country") do |select|
  - select.with_option(value: "us", label: "United States")
  - select.with_option(value: "ca", label: "Canada")
  - select.with_option(value: "mx", label: "Mexico")
```

#### Select with Options Array
```haml
- language_options = [
  { value: "en", label: "English" },
  { value: "fr", label: "French" },
  { value: "es", label: "Spanish" }
]

= daisy_label(for: "language", title: "Language")
= daisy_select(name: "language", id: "language", options: language_options, placeholder: "Select a language")
```

#### Select with Different Colors
```haml
- select_options = [
  { value: "option1", label: "Option 1" },
  { value: "option2", label: "Option 2" }
]

= daisy_label(for: "color_default", title: "Default")
= daisy_select(name: "color_default", id: "color_default", options: select_options)

= daisy_label(for: "color_primary", title: "Primary")
= daisy_select(name: "color_primary", id: "color_primary", css: "select-primary", options: select_options)

= daisy_label(for: "color_secondary", title: "Secondary")
= daisy_select(name: "color_secondary", id: "color_secondary", css: "select-secondary", options: select_options)

= daisy_label(for: "color_accent", title: "Accent")
= daisy_select(name: "color_accent", id: "color_accent", css: "select-accent", options: select_options)

= daisy_label(for: "color_info", title: "Info")
= daisy_select(name: "color_info", id: "color_info", css: "select-info", options: select_options)

= daisy_label(for: "color_success", title: "Success")
= daisy_select(name: "color_success", id: "color_success", css: "select-success", options: select_options)

= daisy_label(for: "color_warning", title: "Warning")
= daisy_select(name: "color_warning", id: "color_warning", css: "select-warning", options: select_options)

= daisy_label(for: "color_error", title: "Error")
= daisy_select(name: "color_error", id: "color_error", css: "select-error", options: select_options)
```

#### Select with Different Sizes
```haml
- select_options = [
  { value: "option1", label: "Option 1" },
  { value: "option2", label: "Option 2" }
]

= daisy_label(for: "select_xs", title: "Extra Small Select")
= daisy_select(name: "select_xs", id: "select_xs", css: "select-xs", options: select_options)

= daisy_label(for: "select_sm", title: "Small Select")
= daisy_select(name: "select_sm", id: "select_sm", css: "select-sm", options: select_options)

= daisy_label(for: "select_md", title: "Medium Select (Default)")
= daisy_select(name: "select_md", id: "select_md", options: select_options)

= daisy_label(for: "select_lg", title: "Large Select")
= daisy_select(name: "select_lg", id: "select_lg", css: "select-lg", options: select_options)
```

#### Required Select
```haml
= daisy_label(for: "required_select", title: "Required Select")
= daisy_select(name: "required_select", id: "required_select", required: true, placeholder: "Select an option", options: [
    { value: "option1", label: "Option 1" },
    { value: "option2", label: "Option 2" }
  ])
```

#### Disabled Select
```haml
= daisy_label(for: "disabled_select", title: "Disabled Select")
= daisy_select(name: "disabled_select", id: "disabled_select", disabled: true, value: "option1", options: [
    { value: "option1", label: "Option 1" },
    { value: "option2", label: "Option 2" }
  ])
```

#### Rails Form Builder Example
```haml
- country_options = [
  { value: "us", label: "United States" },
  { value: "ca", label: "Canada" },
  { value: "mx", label: "Mexico" }
]

= form_with(url: "#", method: :post, scope: :user, html: { class: "w-full max-w-xs space-y-4" }) do |form|
  .space-y-2
    = form.daisy_label(:country)
    = form.daisy_select(:country, options: country_options, placeholder: "Select your country")

  - language_options = [
    { value: "en", label: "English" },
    { value: "fr", label: "French" },
    { value: "es", label: "Spanish" }
  ]

  .space-y-2
    = form.daisy_label(:language)
    = form.daisy_select(:language, placeholder: "Select your preferred language") do |select|
      - language_options.each do |option|
        - select.with_option(value: option[:value], label: option[:label])

  = form.submit "Save Preferences", class: "btn btn-primary"
```

#### Comparison with Standard Rails Form Helpers
```haml
- # Define options for select helpers
- language_collection = [
  ["English", "en"],
  ["French", "fr"],
  ["Spanish", "es"]
]
- country_options = [
  { value: "us", label: "United States" },
  { value: "ca", label: "Canada" },
  { value: "mx", label: "Mexico" }
]

= form_with(url: "#", method: :post, scope: :user, html: { class: "w-full max-w-xs space-y-4" }) do |form|
  %h3.text-lg.font-medium Standard Rails Select
  .space-y-2
    = form.label :country, class: "label"
    = form.select :country, options_for_select(language_collection), { include_blank: "Select your country" }, { class: "select select-bordered w-full" }

  %h3.text-lg.font-medium.mt-6 DaisyUI Select Component
  .space-y-2
    = form.daisy_label(:language)
    = form.daisy_select(:language, options: country_options, placeholder: "Select your country")

  = form.submit "Save Preferences", class: "btn btn-primary mt-4"
```

### 8. Form Builder Helper Implementation

```ruby
# In app/helpers/daisy/form_builder_helper.rb

def daisy_select(method, options: nil, placeholder: nil, options_css: nil, options_html: {}, **args, &block)
  # Extract the name from the form builder's object_name and method
  name = "#{object_name}[#{method}]"

  # Get the current value from the object
  value = object.try(method)

  # Build the component with the extracted form values and any additional options
  render(
    Daisy::DataInput::SelectComponent.new(
      name: name,
      id: args[:id] || dom_id(object, method),
      value: value,
      options: options,
      options_css: options_css,
      options_html: options_html,
      placeholder: placeholder,
      **args,
      &block
    )
  )
end
```
