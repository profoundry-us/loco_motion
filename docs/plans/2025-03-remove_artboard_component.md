# Remove Artboard Component Plan

## Overview

DaisyUI 5 has removed the Artboard component. This plan outlines the steps to remove all references to this component from our codebase, including the component itself, examples, and helper registrations.

## External Resources

- [DaisyUI 5 Components](https://daisyui.com/components/)
- [DaisyUI 5 Migration Guide](https://daisyui.com/docs/migration/)

## Implementation Steps

### 1. Remove the Component Class

**Purpose**: Delete the Artboard component class as it's no longer supported in DaisyUI 5.

**File to Remove**: `app/components/daisy/layout/artboard_component.rb`

### 2. Remove Component Tests

**Purpose**: Remove the associated test files since the component is being removed.

**File to Remove**: `spec/components/daisy/layout/artboard_component_spec.rb`

### 3. Remove Example Views

**Purpose**: Remove example views for the deprecated Artboard component.

**File to Remove**: `docs/demo/app/views/examples/daisy/layout/artboards.html.haml`

### 4. Update Mockup Device Examples

**Purpose**: Update any examples that used Artboard with Device components.

**File to Edit**: `docs/demo/app/views/examples/daisy/mockup/devices.html.haml`

**Changes**: Remove or replace references to `daisy_artboard` with appropriate alternatives.

### 5. Update Device Component Documentation

**Purpose**: Update documentation of the Device component to remove references to Artboard.

**File to Edit**: `app/components/daisy/mockup/device_component.rb`

**Changes**: Update documentation to remove references to ArtboardComponent and provide alternative examples.

### 6. Unregister the Helper

**Purpose**: Remove the component registration from the helpers list.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Changes**: Remove the line registering the Artboard component helper.

### 7. Run Tests and Verify

**Purpose**: Ensure all tests pass after the component has been removed.

**Commands to Run**:
```bash
make loco-test
make demo-restart
```
