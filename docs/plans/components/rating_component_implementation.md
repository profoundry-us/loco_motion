# Rating Component Implementation Plan

## Overview

This document outlines the implementation plan for a Rating component in the LocoMotion library. The component will be part of the Daisy UI data input components collection and will follow the existing patterns established by other input components, such as the Checkbox, Radio Button, and Range components.

## Implementation Details

### 1. Component Structure

#### File Locations
- Component: `app/components/daisy/data_input/rating_component.rb`
- Specs: `spec/components/daisy/data_input/rating_component_spec.rb`
- Example Usage: `docs/demo/app/views/examples/daisy/data_input/ratings.html.haml`
- Form Builder Helper Extension: Update `app/helpers/daisy/form_builder_helper.rb`
- Form Builder Helper Specs: Update `spec/helpers/daisy/form_builder_helper_spec.rb`
- Helper Registration: Update `lib/loco_motion/helpers.rb` to register the component

### 2. Component Design

#### Core Functionality
- Render a set of radio buttons that allow users to rate something
- Support both interactive (form input) and read-only modes
- Support different styles via CSS classes
- Work both standalone and with a form builder

#### Component API

```ruby
Daisy::DataInput::RatingComponent.new(
  name: "product_rating",  # Required: The name attribute for the radio inputs
  value: 3,               # Optional: The current rating value (default: nil)
  max: 5,                 # Optional: The maximum rating value, i.e., number of stars (default: 5)
  read_only: false,       # Optional: Whether the rating is read-only (default: false)
  required: false         # Optional: Whether the rating input is required (default: false)
)
```

### 3. Implementation Steps

1. **Create Component Class**
   - Create the `RatingComponent` class
   - Implement initialization method with appropriate parameters
   - Define component setup and rendering methods
   - Support both interactive and read-only modes
   - Add documentation with examples

2. **Create Tests**
   - Write tests for the component's functionality
   - Test rendering with different options and attributes
   - Test different CSS classes
   - Test read-only mode
   - Ensure proper HTML output and class assignments

3. **Create Example Views**
   - Create example usage in the demo app
   - Demonstrate different configuration options (max)
   - Show usage with different CSS classes for styling
   - Show both interactive and read-only modes
   - Show usage with form builders

4. **Update Form Builder Helper**
   - Add `daisy_rating` helper method to the form builder
   - Ensure consistency with other data input components

5. **Update Form Builder Helper Specs**
   - Add tests for the `daisy_rating` form builder method
   - Test proper object value binding
   - Test overriding default attributes
   - Test passing additional options to the component

6. **Update Helpers Registration**
   - Update `lib/loco_motion/helpers.rb` to register the component

### 4. Detailed Component Structure

```ruby
class Daisy::DataInput::RatingComponent < LocoMotion::BaseComponent
  attr_reader :name, :value, :max, :read_only, :required

  def initialize(**kws)
    super

    @name = config_option(:name)
    @value = config_option(:value)
    @max = config_option(:max, 5)
    @read_only = config_option(:read_only, false)
    @required = config_option(:required, false)
  end

  def before_render
    setup_component
  end

  def setup_component
    set_tag_name(:component, :div)
    add_css(:component, "rating")
  end

  def call
    content_tag(:component) do
      if @read_only
        render_read_only_rating
      else
        render_interactive_rating
      end
    end
  end

  def render_interactive_rating
    safe_join((1..@max).map do |rating|
      input_attrs = {
        type: "radio",
        name: @name,
        value: rating,
        class: "mask mask-star",
        checked: @value == rating,
        required: @required && rating == 1,
        "aria-label": "#{rating} star"
      }

      tag.input(**input_attrs)
    end)
  end

  def render_read_only_rating
    safe_join((1..@max).map do |rating|
      div_attrs = {
        class: "mask mask-star",
        "aria-label": "#{rating} star"
      }

      if @value && rating <= @value
        div_attrs["aria-current"] = "true"
      end

      tag.div(**div_attrs)
    end)
  end
end
```

### 5. Test Cases

- Renders a rating component with default options (5 stars)
- Renders with specified number of stars (max)
- Renders with a selected value
- Renders in read-only mode with the specified value
- Correctly handles required attribute
- Correctly renders with a form builder

### 6. Example Usage

#### Basic Rating
```haml
= daisy_label(for: "product_rating", title: "Product Rating")
= daisy_rating(name: "product_rating", id: "product_rating")
```

#### Rating with Different Star Style
```haml
= daisy_label(for: "product_rating2", title: "Product Rating (Star 2)")
= daisy_rating(name: "product_rating2", id: "product_rating2", css: "[&>input]:mask-star-2")
```

#### Rating with Different Colors
```haml
= daisy_label(for: "product_rating3", title: "Product Rating (Primary Color)")
= daisy_rating(name: "product_rating3", id: "product_rating3", css: "[&>input]:bg-primary")

= daisy_label(for: "product_rating4", title: "Product Rating (Warning Color)")
= daisy_rating(name: "product_rating4", id: "product_rating4", css: "[&>input]:bg-warning")

= daisy_label(for: "product_rating5", title: "Product Rating (Success Color)")
= daisy_rating(name: "product_rating5", id: "product_rating5", css: "[&>input]:bg-success")
```

#### Different Sizes
```haml
= daisy_label(for: "rating_xs", title: "Extra Small Rating")
= daisy_rating(name: "rating_xs", id: "rating_xs", css: "rating-xs")

= daisy_label(for: "rating_sm", title: "Small Rating")
= daisy_rating(name: "rating_sm", id: "rating_sm", css: "rating-sm")

= daisy_label(for: "rating_md", title: "Medium Rating (Default)")
= daisy_rating(name: "rating_md", id: "rating_md")

= daisy_label(for: "rating_lg", title: "Large Rating")
= daisy_rating(name: "rating_lg", id: "rating_lg", css: "rating-lg")
```

#### Half-Star Rating
```haml
= daisy_label(for: "half_star_rating", title: "Half-Star Rating")
= daisy_rating(name: "half_star_rating", id: "half_star_rating", max: 10, css: "[&>input:nth-of-type(odd)]:mask-star-2 [&>input:nth-of-type(odd)]:mask-half-1 [&>input:nth-of-type(even)]:mask-star-2 [&>input:nth-of-type(even)]:mask-half-2")
```

#### Read-Only Rating
```haml
= daisy_label(for: "read_only_rating", title: "Read-Only Rating (3/5)")
= daisy_rating(name: "read_only_rating", id: "read_only_rating", value: 3, read_only: true)
```

#### With Form Builder
```haml
= form_with(url: "#", method: :post, scope: :review, html: { class: "w-full max-w-xs space-y-2" }) do |form|
  .flex.items-center.gap-2
    = hero_icon("star", class: "w-4 h-4 inline-block")
    = form.daisy_label(:rating, "Your Rating")
  = form.daisy_rating(:rating, css: "[&>input]:mask-star-2")

  .flex.items-center.gap-2
    = hero_icon("chat-bubble-bottom-center-text", class: "w-4 h-4 inline-block")
    = form.daisy_label(:comment, "Your Comment")
  = form.text_area(:comment, class: "textarea textarea-bordered h-24")

  = form.submit "Submit Review", class: "btn btn-primary mt-4"
```

## Future Enhancements

1. Add support for displaying the numeric value alongside the stars
2. Add support for accessibility enhancements
3. Add support for custom colors for individual stars
4. Integrate with form validation
