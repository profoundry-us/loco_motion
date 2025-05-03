# Filter Component Implementation Plan

## Overview

This document outlines the implementation plan for adding the new Filter component
from DaisyUI 5 to the LocoMotion library. The Filter component is a group of
radio buttons where choosing one of the options will hide the others and show a
reset button next to the chosen option. It provides an intuitive way for users to
filter content.

## External Resources

- [DaisyUI Filter Component](https://daisyui.com/components/filter/)
- [GitHub Issue #33](https://github.com/profoundry-us/loco_motion/issues/33)

## Implementation Steps

### 1. Create the Filter Component Class

**Purpose**: Define the core component class, including rendering, configuration,
and any necessary parts or slots.

**File to Create**: `app/components/daisy/data_input/filter_component.rb`

**Reference Files**:
- `app/components/daisy/data_input/radio_button_component.rb`
- `app/components/daisy/data_input/checkbox_component.rb`

**Example Implementation**:

```ruby
module Daisy
  module DataInput
    class FilterComponent < LocoMotion::BaseComponent
      class FilterOptionComponent < Daisy::DataInput::RadioButtonComponent
        #
        # Initialize a new filter option component.
        #
        # @param kws [Hash] The keyword arguments for the component.
        #
        # @option kws label [String] The aria-label for the radio button.
        #
        def initialize(**kws)
          super(**kws)

          @label = config_option(:label)
        end

        #
        # Setup the component before rendering.
        #
        def before_render
          # Call the parent setup first
          super

          # Add btn class for styling
          add_css(:component, "btn")

          # Add aria-label if specified
          if @label.present?
            add_html(:component, { "aria-label": @label })
          end
        end
      end

      class FilterResetComponent < Daisy::Actions::ButtonComponent
        #
        # Initialize a new filter reset component.
        #
        # @param kws [Hash] The keyword arguments for the component.
        #
        # @option kws icon [String] The name of the icon to use. Defaults to "x-mark".
        #
        # @option kws disabled [Boolean] Whether the reset button is disabled. Defaults to false.
        #
        def initialize(**kws)
          # Set default icon if not provided
          kws[:icon] ||= "x-mark"

          super(**kws)
        end

        #
        # Setup the component before rendering.
        #
        def before_render
          # Call parent setup first
          super

          # Add square styling
          add_css(:component, "where:btn-square")

          # Set type to reset
          add_html(:component, { type: "reset" })
        end
      end

      renders_one :reset_button, FilterResetComponent
      renders_many :options, FilterOptionComponent

      #
      # Initialize a new filter component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws name [String] Required name attribute for the radio button group.
      #
      # @option kws options [Array] An array of options to display in the filter.
      #   Can be an array of strings, symbols, or hashes with :label keys.
      #
      def initialize(**kws)
        super

        @name = config_option(:name)
        @options_list = config_option(:options)
      end

      #
      # Setup the component before rendering.
      #
      def before_render
        super

        setup_component
      end

      #
      # Converts the options array into FilterOptionComponent instances.
      # Handles both hash options (with label keys) and simple string/symbol options.
      #
      # @return [Array<FilterOptionComponent>] Array of option components or empty array if @options_list is nil.
      #
      def default_options
        return [] unless @options_list

        options_list.map do |option|
          label = option.is_a?(Hash) ? option[:label] : option.to_s

          Daisy::DataInput::FilterComponent::FilterOptionComponent.new(
            name: @name,
            label: label,
            value: option.is_a?(Hash) ? option[:value] : option
          )
        end
      end

      #
      # Renders the filter options based on the configuration.
      # This method is used by the template to render options consistently.
      #
      # @return [String] The HTML for all options in the filter.
      #
      def render_filter_options
        result = ""

        if options?
          options.each do |option|
            option.set_loco_parent(component_ref)
            result += option.call
          end
        elsif default_options.present?
          default_options.each do |option|
            option.set_loco_parent(component_ref)
            result += render(option)
          end
        end

        result.html_safe
      end

      private

      #
      # Sets up the component by configuring the tag name, CSS classes, and HTML attributes.
      #
      def setup_component
        # Add base component class
        add_css(:component, "filter")
      end

      #
      # Ensures the options list is always an array, even if a single option is provided.
      #
      # @return [Array] The list of options as an array.
      #
      def options_list
        @options_list.is_a?(Array) ? @options_list : [@options_list]
      end
    end
  end
end
```

### 2. Create Component View Template

**Purpose**: Provide the HTML structure for the component.

**File to Create**: `app/components/daisy/data_input/filter_component.html.haml`

**Reference Files**:
- `app/components/daisy/data_input/radio_button_component.html.haml`
- Other component templates

**Example Implementation**:

```haml
= part(:component) do
  = reset_button if reset_button?
  = render_filter_options
```

### 3. Register Component Helper

**Purpose**: Register the component helper method.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/helpers.rb`

### 4. Create Component Tests

**Purpose**: Ensure component functionality works as expected through
comprehensive test cases.

**File to Create**: `spec/components/daisy/data_input/filter_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_input/radio_button_component_spec.rb`
- Other component specs

**Example Implementation**:

```ruby
RSpec.describe Daisy::DataInput::FilterComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new(name: "filters"))
    expect(page).to have_css("div.filter")
  end

  it "renders reset button and options" do
    component = described_class.new(name: "filters")

    # Add reset button
    component.with_reset_button(value: "×")

    # Add options
    component.with_option(name: "filters", label: "Option 1")
    component.with_option(name: "filters", label: "Option 2")

    render_inline(component)

    expect(page).to have_css(".filter input[type='reset']")
    expect(page).to have_css(".filter input[type='radio'][aria-label='Option 1']")
    expect(page).to have_css(".filter input[type='radio'][aria-label='Option 2']")
  end

  context "with custom HTML attributes" do
    it "passes attributes to the component" do
      render_inline(described_class.new(
        name: "filters",
        html: { id: "custom-filter", data: { test: "value" } }
      ))
      expect(page).to have_css(".filter#custom-filter[data-test='value']")
    end

    it "applies custom classes" do
      render_inline(described_class.new(name: "filters", css: "custom-class"))
      expect(page).to have_css(".filter.custom-class")
    end
  end

  describe Daisy::DataInput::FilterComponent::FilterOptionComponent do
    it "renders a radio button with btn class" do
      component = described_class.new(name: "filters", label: "Option")
      render_inline(component)
      expect(page).to have_css("input[type='radio'].btn[aria-label='Option']")
    end

    it "applies custom btn variants through CSS classes" do
      component = described_class.new(name: "filters", label: "Option", css: "btn-outline btn-success")
      render_inline(component)
      expect(page).to have_css("input[type='radio'].btn.btn-outline.btn-success")
    end
  end

  describe Daisy::DataInput::FilterComponent::FilterResetComponent do
    it "renders a reset button with proper icon and btn-square class" do
      component = described_class.new(icon: "x-mark")
      render_inline(component)
      expect(page).to have_css("button[type='reset'].btn.btn-square")
      expect(page).to have_css("svg[data-slot='icon']")
    end

    it "allows customizing the icon" do
      component = described_class.new(icon: "trash")
      render_inline(component)
      expect(page).to have_css("button[type='reset']")
      # Note: We can't easily test the specific icon in this example
    end

    it "applies button variants through CSS classes" do
      component = described_class.new(icon: "x-mark", css: "btn-error")
      render_inline(component)
      expect(page).to have_css("button[type='reset'].btn-error")
    end
  end
end
```

### 5. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_input/filters.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_input/checkboxes.html.haml`
- Other component example views

**Example Implementation**:

```haml
= doc_title(title: "Filter", comp: @comp) do |title|
  :markdown
    Filter is a group of radio buttons. Choosing one of the options will hide the
    others and shows a reset button next to the chosen option.

= doc_example(title: "Basic Filter") do |doc|
  - doc.with_description do
    :markdown
      The basic filter component uses a div element with a reset button and radio
      buttons styled as buttons.

  = daisy_filter(name: "frameworks", options: ["Svelte", "Vue", "React"])

= doc_example(title: "Filter Within Form") do |doc|
  - doc.with_description do
    :markdown
      This example shows how to use the Filter component within a Rails form_with block
      for form submission.

  :markdown
    ```haml
    = form_with(model: @search, url: search_path) do |form|
      = daisy_filter(name: "categories") do |f|
        - f.with_reset_button(icon: "x-mark")
        - f.with_option(name: "categories", label: "Category 1")
        - f.with_option(name: "categories", label: "Category 2")
      = form.submit "Apply Filters", class: "btn btn-primary mt-4"
    ```

= doc_example(title: "Filter with Different Button Styles") do |doc|
  - doc.with_description do
    :markdown
      You can combine filter with different button styles, such as outline or bordered
      buttons.

  = daisy_filter(name: "priorities") do |f|
    - f.with_reset_button(icon: "x-mark", css: "btn-error")
    - f.with_option(name: "priorities", label: "Low", css: "btn-outline btn-success")
    - f.with_option(name: "priorities", label: "Medium", css: "btn-outline btn-warning")
    - f.with_option(name: "priorities", label: "High", css: "btn-outline btn-error")

= doc_example(title: "Using Filter-Reset Option") do |doc|
  - doc.with_description do
    :markdown
      Another approach is to use one of the radio buttons as a reset button by adding
      the `filter-reset` class.

  = daisy_filter(name: "metaframeworks") do |f|
    - f.with_option(name: "metaframeworks", label: "All", css: "filter-reset")
    - f.with_option(name: "metaframeworks", label: "Sveltekit")
    - f.with_option(name: "metaframeworks", label: "Nuxt")
    - f.with_option(name: "metaframeworks", label: "Next.js")

### 6. Register the Helper

**Purpose**: Make the component available to the application.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current component registrations in `lib/loco_motion/helpers.rb`

**Example Implementation**:

```ruby
module LocoMotion
  # This module defines the helper methods exposed to users of this library.
  module Helpers
    # ... existing registered helpers ...

    def daisy_filter(...)  # register the daisy_filter helper
  end
end
```

## Implementation Notes

1. The Filter component is essentially a group of styled radio buttons with a reset
   button, leveraging DaisyUI 5's CSS classes.

2. The component will be placed in the `data_input` namespace since it's primarily
   used for user input/interaction in filtering content.

3. The implementation follows the pattern established in SelectComponent, with
   nested component classes for filter options and reset buttons, and support for
   passing options directly as a parameter.

4. The filter inherits button styles from DaisyUI, allowing for customization
   through various button CSS classes.

5. Since filters are used to create interactive UIs for filtering content, we'll
   ensure proper accessibility with aria labels.

6. For Rails form integration, users should wrap the filter component within their
   own `form_with` blocks when submission functionality is needed. Example:

   ```haml
   = form_with(model: @search, url: search_path) do |form|
     = daisy_filter(name: "categories") do |f|
       - f.with_reset_button(icon: "x-mark")
       - f.with_option(name: "categories", label: "Category 1")
       - f.with_option(name: "categories", label: "Category 2")
     = form.submit "Apply Filters", class: "btn btn-primary mt-4"
   ```
