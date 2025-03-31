<!-- omit from toc -->
# Theme Controller Refactoring for Multiple UI Representations

This ADR explores approaches for refactoring the ThemeController to allow
multiple UI representations while maintaining a consistent backend.

## Current Status

**Approved** - This document has been reviewed and the approach has been approved for implementation.

## Authors / Stakeholders

- Topher Fangio - Author

## Context

Currently, the LocoMotion library has a ThemeControllerComponent that provides
functionality for switching between different DaisyUI themes. This component
renders a simple list of radio buttons for theme selection.

However, the demo application header implements a different UI representation
of the theme selector using a dropdown with visual previews of each theme.

The goal is to refactor this code to allow users to choose from multiple UI
representations of the theme selector while maintaining consistent underlying
functionality.

### Constraints

- Must maintain backward compatibility with existing ThemeController usage
- Must use the same Stimulus controller for all UI variations
- Should follow LocoMotion's component design patterns
- Should make it easy for users to implement their own custom theme selectors

### Resources

- Current ThemeControllerComponent implementation in `app/components/daisy/actions/theme_controller_component.rb`
- Current theme controller Stimulus implementation in `app/components/daisy/actions/theme_controller.js`
- Dropdown theme selector implementation in the demo app header

## Proposed Solutions

Below are three potential approaches to refactoring the ThemeController:

### 1. Single Component with Variants

This approach would extend the existing ThemeControllerComponent to support
different UI variants through a `variant` option.

**Pros:**
- Simple implementation that maintains a single component
- Clear naming convention with variants like `simple`, `dropdown`, etc.
- Minimal changes to existing codebase

**Cons:**
- Template file becomes more complex with conditional rendering
- Adding new variants requires modifying the core component
- Less flexibility for highly custom implementations
- May become unwieldy as more variants are added

### 2. Multiple Specialized Components

This approach would create separate components for each UI representation,
all sharing the same Stimulus controller.

**Pros:**
- Clean separation of concerns with each component focused on a specific UI
- Easier to maintain individual components
- More flexibility for custom implementations
- Templates remain simple and focused

**Cons:**
- Potential code duplication for shared functionality
- More components to maintain
- Need for clear naming conventions

### 3. Component with Builder Methods

This approach would refactor the ThemeControllerComponent to provide builder
methods that generate different UI representations while maintaining consistent
underlying functionality.

**Pros:**
- High flexibility allowing users to use pre-built UIs or create custom ones
- Follows a clear naming convention with `build_` prefixed methods
- Maintains a single component while providing modular building blocks
- Provides a discoverable API for building theme selectors

**Cons:**
- More complex implementation initially
- Higher learning curve for users
- May introduce some method complexity

## Recommendation

After evaluating the options, **Option 2: Multiple Specialized Components** is
recommended for the following reasons:

1. It provides clean separation of concerns with each component focused on a specific UI representation, making the components easier to understand and maintain.

2. It allows for templates to remain simple and focused on their specific representation, rather than having complex conditional logic.

3. Components can be implemented and tested independently, making for a more modular architecture.

4. For consistency and ease of use, we'll provide helper methods that function like builders but internally create instances of the appropriate components.

Implementation would involve:

1. Creating a base abstract ThemeControllerComponent that contains shared functionality and configuration:
   ```ruby
   # Base component with shared functionality
   class Daisy::Actions::ThemeControllerComponent < LocoMotion::BaseComponent
     # Shared configuration and methods
   end
   ```

2. Creating specialized components for each UI representation:
   ```ruby
   # Radio list representation (current default)
   class Daisy::Actions::ThemeRadioListComponent < Daisy::Actions::ThemeControllerComponent
     # Implementation specific to radio list
   end

   # Dropdown representation
   class Daisy::Actions::ThemeDropdownComponent < Daisy::Actions::ThemeControllerComponent
     # Implementation specific to dropdown
   end

   # Button group representation
   class Daisy::Actions::ThemeButtonGroupComponent < Daisy::Actions::ThemeControllerComponent
     # Implementation specific to button group
   end
   ```

3. Providing helper methods for easy instantiation (functioning like builders):
   ```ruby
   module Daisy::ThemeControllerHelper
     # Create a radio list theme selector
     def build_radio_list(themes: nil, **options)
       Daisy::Actions::ThemeRadioListComponent.new(themes: themes, **options)
     end

     # Create a dropdown theme selector
     def build_dropdown(themes: nil, button_icon: "swatch", **options)
       Daisy::Actions::ThemeDropdownComponent.new(
         themes: themes,
         button_icon: button_icon,
         **options
       )
     end

     # Create a button group theme selector
     def build_button_group(themes: nil, show_labels: false, **options)
       Daisy::Actions::ThemeButtonGroupComponent.new(
         themes: themes,
         show_labels: show_labels,
         **options
       )
     end
   end
   ```

4. Support for custom components that can use the shared Stimulus controller:
   ```ruby
   # Custom theme implementation
   = theme_radio_list(themes: ["light", "dark", "synthwave"])

   # Or with a custom component
   class MyCustomThemeComponent < Daisy::Actions::ThemeControllerComponent
     # Custom implementation
   end
   ```

5. Maintaining the same Stimulus controller for consistent behavior across
   all representations, which each specialized component would connect to.

## ADR Tasks

- [x] Initial exploration of the current implementation
- [x] Draft the core of the ADR
- [x] Evaluate different approaches
- [x] Submit for review
- [ ] If approved, create implementation tickets
