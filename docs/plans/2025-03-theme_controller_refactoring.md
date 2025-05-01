# Theme Controller Refactoring Implementation Plan

## Overview

This implementation plan outlines the steps to refactor the ThemeController
component to support multiple UI representations through specialized components
with a shared base class, based on the approved ADR.

## External Resources

- [DaisyUI Themes](https://daisyui.com/docs/themes/)
- [Rails View Components Guide](https://viewcomponent.org/guide/)
- [Stimulus Controllers](https://stimulus.hotwired.dev/handbook/controllers)

## Implementation Steps

### 1. Update Base Theme Controller Component

**Purpose**: Refactor the existing component to function as an abstract base component that contains shared functionality for all theme controller variants.

**File to Modify**: `app/components/daisy/actions/theme_controller_component.rb`

**Reference Files**:
- `app/components/loco_motion/base_component.rb`
- `app/components/daisy/base_component.rb`

### 2. Create Theme Radio List Component

**Purpose**: Implement the classic radio list representation (current default).

**File to Create**: `app/components/daisy/actions/theme_radio_list_component.rb`

**Reference Files**:
- Current `app/components/daisy/actions/theme_controller_component.rb`
- `app/components/daisy/data_input/radio_group_component.rb`

### 3. Create Theme Radio List Template

**Purpose**: Provide the template for the radio list representation.

**File to Create**: `app/components/daisy/actions/theme_radio_list_component.html.haml`

**Reference Files**:
- Current `app/components/daisy/actions/theme_controller_component.html.haml`
- `app/components/daisy/data_input/radio_group_component.html.haml`

### 4. Create Theme Dropdown Component

**Purpose**: Implement the dropdown representation for theme selection.

**File to Create**: `app/components/daisy/actions/theme_dropdown_component.rb`

**Reference Files**:
- `app/components/daisy/actions/dropdown_component.rb`
- Current implementation in demo header

### 5. Create Theme Dropdown Template

**Purpose**: Provide the template for the dropdown representation.

**File to Create**: `app/components/daisy/actions/theme_dropdown_component.html.haml`

**Reference Files**:
- `app/components/daisy/actions/dropdown_component.html.haml`
- Current implementation in demo header

### 6. Create Theme Button Group Component

**Purpose**: Implement the button group representation for theme selection.

**File to Create**: `app/components/daisy/actions/theme_button_group_component.rb`

**Reference Files**:
- `app/components/daisy/actions/button_group_component.rb`
- `app/components/daisy/actions/button_component.rb`

### 7. Create Theme Button Group Template

**Purpose**: Provide the template for the button group representation.

**File to Create**: `app/components/daisy/actions/theme_button_group_component.html.haml`

**Reference Files**:
- `app/components/daisy/actions/button_group_component.html.haml`
- `app/components/daisy/actions/button_component.html.haml`

### 8. Create Theme Controller Helper Module

**Purpose**: Implement helper methods for easy instantiation of theme controller
components.

**File to Create**: `app/helpers/daisy/theme_controller_helper.rb`

**Reference Files**:
- `app/helpers/daisy/dropdown_helper.rb`
- `app/helpers/daisy/button_helper.rb`

### 9. Update or Create Common Partials

**Purpose**: Create any shared partial templates needed across multiple theme
components.

**Files to Create**:
- `app/components/daisy/actions/theme_controller/_theme_preview.html.haml`

**Reference Files**:
- Current implementation in demo header

### 10. Create Basic Component Tests

**Purpose**: Test the base theme controller component functionality.

**File to Create**: `spec/components/daisy/actions/theme_controller_component_spec.rb`

**Reference Files**:
- Current `spec/components/daisy/actions/theme_controller_component_spec.rb`
- `spec/components/loco_motion/base_component_spec.rb`

### 11. Create Radio List Component Tests

**Purpose**: Test the radio list component functionality.

**File to Create**: `spec/components/daisy/actions/theme_radio_list_component_spec.rb`

**Reference Files**:
- Current `spec/components/daisy/actions/theme_controller_component_spec.rb`
- `spec/components/daisy/data_input/radio_group_component_spec.rb`

### 12. Create Dropdown Component Tests

**Purpose**: Test the dropdown component functionality.

**File to Create**: `spec/components/daisy/actions/theme_dropdown_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/actions/dropdown_component_spec.rb`

### 13. Create Button Group Component Tests

**Purpose**: Test the button group component functionality.

**File to Create**: `spec/components/daisy/actions/theme_button_group_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/actions/button_group_component_spec.rb`

### 14. Create Helper Module Tests

**Purpose**: Test the theme controller helper methods.

**File to Create**: `spec/helpers/daisy/theme_controller_helper_spec.rb`

**Reference Files**:
- `spec/helpers/daisy/dropdown_helper_spec.rb`
- `spec/helpers/daisy/button_helper_spec.rb`

### 15. Register the Helpers

**Purpose**: Make the component helpers available to the application.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/helpers.rb`

### 16. Update Demo Examples

**Purpose**: Create examples to showcase the different theme controller representations.

**File to Create**: `docs/demo/app/views/examples/daisy/actions/theme_controllers.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/actions/buttons.html.haml`
- `docs/demo/app/views/examples/daisy/actions/dropdowns.html.haml`

### 17. Update Demo Header

**Purpose**: Update the demo header to use the new theme dropdown component.

**File to Edit**: `docs/demo/app/views/application/_header.html.haml`

**Reference Files**:
- Current implementation in `docs/demo/app/views/application/_header.html.haml`

### 18. Update Documentation

**Purpose**: Update the documentation to reflect the new theme controller components.

**Files to Edit**:
- `docs/components/daisy/actions.md`

**Reference Files**:
- Current documentation

## Backward Compatibility

To maintain backward compatibility:
1. Ensure the existing `daisy_theme_controller` helper continues to work by
   making it use the new radio list component by default
2. Maintain the same Stimulus controller for all implementations
3. Ensure old tests continue to pass with the new implementation
