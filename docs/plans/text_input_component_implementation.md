# TextInput Component Implementation Plan

## Overview

This document outlines the implementation plan for the TextInput component in the LocoMotion library. The TextInput component will provide a styled text input field following DaisyUI's design patterns, with support for various attributes and states.

## External Resources

- [DaisyUI Input Elements](https://v4.daisyui.com/components/input/)
- [Rails View Components Guide](https://viewcomponent.org/guide/)

## Implementation Steps

### 1. Create the Component Class

**Purpose**: Define the core component class that handles rendering and configuration of text input fields.

**File to Create**: `app/components/daisy/data_input/text_input_component.rb`

**Reference Files**:
- `app/components/daisy/data_input/file_input_component.rb`
- `app/components/daisy/data_input/range_component.rb`

The component will support the following attributes:
- `name`: The name attribute for the input
- `id`: The ID attribute for the input
- `value`: The initial value of the input
- `placeholder`: Placeholder text for the input
- `type`: Input type (text, password, email, etc.)
- `disabled`: Whether the input is disabled
- `required`: Whether the input is required for form validation
- `maxlength`: Maximum character length
- `minlength`: Minimum character length
- `pattern`: Regular expression pattern for validation
- `readonly`: Whether the input is read-only

### 2. Create Component Tests

**Purpose**: Ensure component functionality works as expected through comprehensive test cases.

**File to Create**: `spec/components/daisy/data_input/text_input_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_input/file_input_component_spec.rb`
- `spec/components/daisy/data_input/range_component_spec.rb`

Tests will cover:
- Basic rendering with various attributes
- Different input types (text, password, email, etc.)
- Disabled and required states
- Various CSS classes and styling options

### 3. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the text input component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_input/text_inputs.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_input/file_inputs.html.haml`
- `docs/demo/app/views/examples/daisy/data_input/ranges.html.haml`

Examples will include:
- Basic text input
- Different input types (password, email, number, etc.)
- Inputs with placeholders
- Disabled and required inputs
- Inputs with various sizes
- Inputs with different styling (bordered, ghost, etc.)
- Color variants (primary, secondary, etc.)
- Form integration examples

### 4. Update Form Builder Helper

**Purpose**: Add form builder integration to allow usage with Rails form builders.

**File to Edit**: `app/helpers/daisy/form_builder_helper.rb`

**Reference Files**:
- Current implementation in `app/helpers/daisy/form_builder_helper.rb` (file_input methods)
- Current implementation in `app/helpers/daisy/form_builder_helper.rb` (range methods)

Add the `daisy_text_input` method to integrate with Rails form builders, allowing for:
- Automatic name and ID generation based on the object and method
- Easy integration with form validation
- Support for all supported text input attributes

### 5. Update Form Builder Helper Specs

**Purpose**: Test the form builder integration for the text input component.

**File to Edit**: `spec/helpers/daisy/form_builder_helper_spec.rb`

**Reference Files**:
- Current specs in `spec/helpers/daisy/form_builder_helper_spec.rb` (file_input specs)
- Current specs in `spec/helpers/daisy/form_builder_helper_spec.rb` (range specs)

Tests will verify:
- Correct rendering of the text input component
- Proper name and ID generation
- Passing of additional options to the component

### 6. Register the Helper

**Purpose**: Make the component available to the application by registering it.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/helpers.rb` (file_input registration)
- Current implementation in `lib/loco_motion/helpers.rb` (range registration)

Register the TextInput component with appropriate name, group, title, and example path.
