# Simplified Component Implementation Template

## Overview

This is a simplified template for implementing new components in the LocoMotion library. Each step includes:
1. A short sentence about the purpose of the file
2. The file to create
3. Two existing files to use as reference

Below is an example implementation plan for a fictional `FakeComponent` in the `DataInput` module.

## External Resources

- [DaisyUI Form Elements](https://daisyui.com/components/input/)
- [Rails View Components Guide](https://viewcomponent.org/guide/)

## Implementation Steps

### 1. Create the Component Class

**Purpose**: Define the core component class that handles rendering and configuration.

**File to Create**: `app/components/daisy/data_input/fake_component.rb`

**Reference Files**:
- `app/components/daisy/data_input/checkbox_component.rb`
- `app/components/daisy/data_input/range_component.rb`

### 2. Create Component Tests

**Purpose**: Ensure component functionality works as expected through comprehensive test cases.

**File to Create**: `spec/components/daisy/data_input/fake_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_input/checkbox_component_spec.rb`
- `spec/components/daisy/data_input/range_component_spec.rb`

### 3. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_input/fakes.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_input/checkboxes.html.haml`
- `docs/demo/app/views/examples/daisy/data_input/ranges.html.haml`

### 4. Update Form Builder Helper

**Purpose**: Add form builder integration to allow usage with Rails form builders.

**File to Edit**: `app/helpers/daisy/form_builder_helper.rb`

**Reference Files**:
- Current implementation in `app/helpers/daisy/form_builder_helper.rb` (checkbox methods)
- Current implementation in `app/helpers/daisy/form_builder_helper.rb` (range methods)

### 5. Update Form Builder Helper Specs

**Purpose**: Test the form builder integration for the new component.

**File to Edit**: `spec/helpers/daisy/form_builder_helper_spec.rb`

**Reference Files**:
- Current specs in `spec/helpers/daisy/form_builder_helper_spec.rb` (checkbox specs)
- Current specs in `spec/helpers/daisy/form_builder_helper_spec.rb` (range specs)

### 6. Register the Helper

**Purpose**: Make the component available to the application by registering it.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/helpers.rb` (checkbox registration)
- Current implementation in `lib/loco_motion/helpers.rb` (range registration)
