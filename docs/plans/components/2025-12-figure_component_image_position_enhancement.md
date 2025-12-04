# Figure Component Image Position Enhancement

## Overview

Enhance the Figure component to allow users to control whether the image appears
above or below the content. Currently, the component only supports displaying
the image above the content, but users should be able to specify the position.

## External Resources

- GitHub Issue: https://github.com/profoundry-us/loco_motion/issues/65
- DaisyUI Figure Documentation: https://daisyui.com/components/figure/

## Implementation Steps

### 1. Update Component Class

**Purpose**: Add support for configurable image positioning in the Figure
component.

**File to Edit**: `app/components/daisy/data_display/figure_component.rb`

**Reference Files**:
- Current Figure component implementation
- Other DaisyUI components with configurable positioning

**Changes to Make**:

1. Add a new `position` parameter to the `initialize` method with default value
   `"top"` to maintain backward compatibility
2. Add validation to ensure position is either `"top"` or `"bottom"`
3. Modify the `call` method to conditionally render the image before or after
   the content based on the position parameter
4. Update the component documentation to include the new parameter and examples

### 2. Update Component Tests

**Purpose**: Add test coverage for the new image positioning functionality.

**File to Edit**: `spec/components/daisy/data_display/figure_component_spec.rb`

**Changes to Make**:

1. Add test context for `position: "top"` (default behavior)
2. Add test context for `position: "bottom"`
3. Add test to ensure validation rejects invalid positions
4. Update existing tests to ensure they still pass with default behavior

### 3. Update Example Views

**Purpose**: Demonstrate the new image positioning functionality in the demo
application.

**File to Edit**: `docs/demo/app/views/examples/daisy/data_display/figures.html.haml`

**Changes to Make**:

1. Add a new example section showing image positioned at the bottom
2. Update existing examples to explicitly show default top positioning
3. Add descriptive text explaining the positioning options

### 4. Update E2E Tests

**Purpose**: Ensure end-to-end tests cover the new positioning functionality.

**File to Edit**: `docs/demo/e2e/daisy/data_display/figures.spec.ts`

**Changes to Make**:

1. Add test cases for bottom-positioned figures
2. Verify that both top and bottom positioning render correctly

## Verification Steps

**Purpose**: Verify that the enhancement works correctly and maintains backward
compatibility.

**Commands to Run**:
```bash
# Run component tests
docker compose exec -it demo bundle exec rspec spec/components/daisy/data_display/figure_component_spec.rb

# Run E2E tests
docker compose exec -it demo yarn playwright test 'e2e/daisy/data_display/figures.spec.ts' --reporter dot --workers 1

# Start demo server to manually verify
docker compose exec -it demo bin/dev
```

**Expected Results**:

1. All existing tests pass (backward compatibility maintained)
2. New tests for bottom positioning pass
3. Demo application shows figures with images positioned both top and bottom
4. Invalid position values are properly rejected with clear error messages
5. Default behavior (top positioning) remains unchanged when no position is
   specified
