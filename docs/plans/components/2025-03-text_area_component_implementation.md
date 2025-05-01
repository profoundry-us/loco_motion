# TextArea Component Implementation Plan

## Overview

This plan outlines the implementation of the TextArea component for the LocoMotion library. The TextArea component will allow users to enter multi-line text with DaisyUI styling. It will support standard HTML textarea attributes and various styling options.

## External Resources

- [DaisyUI Textarea Component](https://v4.daisyui.com/components/textarea/)

## Implementation Steps

### 1. Create the Component Class

**Purpose**: Define the TextArea component class with necessary attributes and rendering logic.

**File to Create**: `app/components/daisy/data_input/text_area_component.rb`

**Reference Files**:
- `app/components/daisy/data_input/file_input_component.rb`
- `app/components/daisy/data_input/text_input_component.rb`

### 2. Create the Component Template

**Purpose**: Define the HTML structure for the TextArea component.

**File to Create**: `app/components/daisy/data_input/text_area_component.html.haml`

**Reference Files**:
- `app/components/daisy/data_input/file_input_component.html.haml`
- `app/components/daisy/data_input/text_input_component.html.haml`

### 3. Create Component Tests

**Purpose**: Ensure component functionality works correctly through test cases.

**File to Create**: `spec/components/daisy/data_input/text_area_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_input/file_input_component_spec.rb`
- `spec/components/daisy/data_input/text_input_component_spec.rb`

### 4. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_input/text_areas.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_input/file_inputs.html.haml`
- `docs/demo/app/views/examples/daisy/data_input/text_inputs.html.haml`

### 5. Update Form Builder Helper

**Purpose**: Add form builder integration for the TextArea component.

**File to Edit**: `app/helpers/daisy/form_builder_helper.rb`

**Reference Files**:
- Current implementation for `daisy_file_input` in `app/helpers/daisy/form_builder_helper.rb`
- Current implementation for `daisy_text_input` in `app/helpers/daisy/form_builder_helper.rb`

### 6. Update Form Builder Helper Specs

**Purpose**: Test the form builder integration for the TextArea component.

**File to Edit**: `spec/helpers/daisy/form_builder_helper_spec.rb`

**Reference Files**:
- Current specs for `daisy_file_input` in `spec/helpers/daisy/form_builder_helper_spec.rb`
- Current specs for `daisy_text_input` in `spec/helpers/daisy/form_builder_helper_spec.rb`

### 7. Register the Helper

**Purpose**: Make the component available to the application.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current registration for FileInput in `lib/loco_motion/helpers.rb`
- Current registration for TextInput in `lib/loco_motion/helpers.rb`

## Component API

```ruby
# Basic usage
= daisy_text_area(name: "message", id: "message")

# With placeholder
= daisy_text_area(name: "message", placeholder: "Enter your message here...")

# With initial value
= daisy_text_area(name: "message", value: "Initial text content")

# With specified rows
= daisy_text_area(name: "message", rows: 6)

# Disabled textarea
= daisy_text_area(name: "message", disabled: true)

# Required textarea
= daisy_text_area(name: "message", required: true)

# Readonly textarea
= daisy_text_area(name: "message", readonly: true)

# Form builder usage
= form_with(model: @user) do |form|
  = form.daisy_label(:bio)
  = form.daisy_text_area(:bio)
```

## Implementation Checklist

- [x] Create TextAreaComponent class
- [x] Create component tests
- [x] Create example views
- [x] Add form builder helper method
- [x] Add form builder helper specs
- [x] Register component in helpers.rb
- [x] Ensure all tests pass
