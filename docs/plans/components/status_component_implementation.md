# Status Component Implementation Plan

## Overview

This document outlines the implementation plan for adding the new Status
component from DaisyUI 5 to the LocoMotion library. The Status component is a
small icon that visually shows the current status of an element, such as online,
offline, error, etc.

## External Resources

- [DaisyUI Status Component](https://daisyui.com/components/status/)
- [GitHub Issue #30](https://github.com/profoundry-us/loco_motion/issues/30)

## Implementation Steps

### 1. Create the Status Component Class

**Purpose**: Define the core component class, including rendering,
configuration, and any necessary parts or slots.

**File to Create**: `app/components/daisy/data_display/status_component.rb`

**Reference Files**:
- `app/components/daisy/data_display/badge_component.rb`
- `app/components/daisy/data_display/indicator_component.rb`

**Example Implementation**:

```ruby
module Daisy
  module DataDisplay
    class StatusComponent < LocoMotion::BaseComponent
      def initialize(**kws)
        super(**kws)
      end

      def before_render
        setup_component
        super # Call super after setup
      end

      def call
        part(:component)
      end

      private

      def setup_component
        # Add base component class
        add_css(:component, "status")

        # Set default tag if not already set
        set_tag_name(:component, :div)
      end
    end
  end
end
```

### 2. Create Component Helper

**Purpose**: Create a helper method to simplify component usage in views.

**File to Edit**: `app/helpers/daisy/component_helper.rb`

**Reference Files**:
- Current implementation in `app/helpers/daisy/component_helper.rb`

**Example Implementation**:

```ruby
module Daisy
  module ComponentHelper
    # ... existing helper methods ...

    # Renders a status indicator
    #
    # @param kws [Hash] Additional HTML attributes to include in the rendered component
    #
    # @return [ActionView::OutputBuffer] HTML output of the component
    def daisy_status(**kws)
      render(Daisy::DataDisplay::StatusComponent.new(
        **kws
      ))
    end
  end
end
```

### 3. Create Component Tests

**Purpose**: Ensure component functionality works as expected through
comprehensive test cases.

**File to Create**: `spec/components/daisy/data_display/status_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_display/badge_component_spec.rb`
- `spec/components/daisy/data_display/indicator_component_spec.rb`

**Example Implementation**:

```ruby
RSpec.describe Daisy::DataDisplay::StatusComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new)
    expect(page).to have_css(".status")
  end

  context "with custom HTML attributes" do
    it "passes attributes to the component" do
      render_inline(described_class.new(html: { id: "custom-status", data: { test: "value" } }))
      expect(page).to have_css(".status#custom-status[data-test='value']")
    end

    it "applies custom classes" do
      render_inline(described_class.new(css: "status-primary status-lg"))
      expect(page).to have_css(".status.status-primary.status-lg")
    end
  end
end
```

### 4. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_display/statuses.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_display/badges.html.haml`
- `docs/demo/app/views/examples/daisy/data_input/checkboxes.html.haml`

**Example Implementation**:

```haml
= doc_title(title: "Status", comp: @comp) do |title|
  :markdown
    Status is a really small icon to visually show the current status of an
    element, like online, offline, error, etc.

= doc_example(title: "Basic Status") do |doc|
  - doc.with_description do
    :markdown
      The basic status component is a simple dot indicator with no additional styling.

  = daisy_status

= doc_example(title: "Status Sizes") do |doc|
  - doc.with_description do
    :markdown
      Status indicators come in five sizes: extra small, small, medium (default), large, and extra large.

  .flex.flex-col.items-start.gap-2
    .flex.items-center.gap-2
      = daisy_status(css: "status-xs mr-2")
      %span Extra Small

    .flex.items-center.gap-2
      = daisy_status(css: "status-sm mr-2")
      %span Small

    .flex.items-center.gap-2
      = daisy_status(css: "status-md mr-2")
      %span Medium (Default)

    .flex.items-center.gap-2
      = daisy_status(css: "status-lg mr-2")
      %span Large

    .flex.items-center.gap-2
      = daisy_status(css: "status-xl mr-2")
      %span Extra Large

= doc_example(title: "Status Colors") do |doc|
  - doc.with_description do
    :markdown
      Status indicators can use different colors to represent various states or
      conditions.

  .flex.flex-col.items-start.gap-2
    .flex.items-center.gap-2
      = daisy_status(css: "status-primary mr-2")
      %span Primary

    .flex.items-center.gap-2
      = daisy_status(css: "status-secondary mr-2")
      %span Secondary

    .flex.items-center.gap-2
      = daisy_status(css: "status-accent mr-2")
      %span Accent

    .flex.items-center.gap-2
      = daisy_status(css: "status-neutral mr-2")
      %span Neutral

    .flex.items-center.gap-2
      = daisy_status(css: "status-info mr-2")
      %span Info

    .flex.items-center.gap-2
      = daisy_status(css: "status-success mr-2")
      %span Success

    .flex.items-center.gap-2
      = daisy_status(css: "status-warning mr-2")
      %span Warning

    .flex.items-center.gap-2
      = daisy_status(css: "status-error mr-2")
      %span Error

= doc_example(title: "Status with Aria Label") do |doc|
  - doc.with_description do
    :markdown
      For accessibility, status indicators should include descriptive ARIA
      labels.

  = daisy_status(css: "status-md status-success", html: { aria: { label: "Status: Online" } })
```

### 5. Register the Helper

**Purpose**: Make the component available to the application.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current registration for FileInput in `lib/loco_motion/helpers.rb`
- Current registration for TextInput in `lib/loco_motion/helpers.rb`

## Implementation Notes

1. The Status component is a simple visual indicator that doesn't require
   interactivity or complex behaviors like some other components.

2. The component should be placed in the `data_display` namespace since it is
   primarily used to display status information rather than collect user input.

3. Size and color variants are applied directly through CSS classes (such as
   `status-xs`, `status-primary`) rather than through component parameters,
   as these are handled by DaisyUI's CSS.

4. For accessibility purposes, we'll add support for aria labels to effectively
   communicate the status to screen readers.

5. While in DaisyUI documentation some examples use `<span>` and others use
   `<div>` elements, we'll standardize on `<div>` with an option to override the
   tag via kws if needed.

6. Since the component's template is extremely simple (just rendering a single
   component part), we use the `call` method directly in the component class
   rather than creating a separate HAML template file.
