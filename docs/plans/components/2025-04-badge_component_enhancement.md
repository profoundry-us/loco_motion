# Badge Component Enhancement Plan

## Overview

This document outlines the implementation plan for enhancing the Badge component in the LocoMotion library. The Badge component will be updated to support icons (both left and right) and linking functionality, similar to what the ButtonComponent currently offers.

## External Resources

- [DaisyUI Badge Component](https://daisyui.com/components/badge/)
- [GitHub Issue #26](https://github.com/profoundry-us/loco_motion/issues/26)

## Implementation Steps

### 1. Create a Common Concern for Icon and Link Functionality

**Purpose**: Extract common functionality from ButtonComponent that both Button and Badge can use.

**File to Create**: `app/components/loco_motion/concerns/linkable_component.rb`

**Reference Files**:
- `app/components/daisy/actions/button_component.rb`
- `app/components/loco_motion/concerns/tippable_component.rb`

The concern should include:
- Logic for handling `href` and `target` attributes
- Changing the component tag to `<a>` when an href is provided
- Any relevant HTML attribute handling for links

### 2. Create a Common Concern for Icon Functionality

**Purpose**: Extract icon-related functionality from ButtonComponent that can be shared.

**File to Create**: `app/components/loco_motion/concerns/iconable_component.rb`

**Reference Files**:
- `app/components/daisy/actions/button_component.rb`
- `app/components/loco_motion/concerns/tippable_component.rb`

The concern should include:
- Logic for handling left and right icons
- Icon CSS class customization
- Icon HTML attribute customization

### 3. Update the Button Component to Use the New Concerns

**Purpose**: Refactor the Button component to use the newly extracted concerns.

**File to Modify**: `app/components/daisy/actions/button_component.rb`

**Reference Files**:
- `app/components/loco_motion/concerns/linkable_component.rb`
- `app/components/loco_motion/concerns/iconable_component.rb`

### 4. Create the Badge Component

**Purpose**: Implement the Badge component with icon and link support using the new concerns.

**File to Create**: `app/components/daisy/data_display/badge_component.rb`

**Reference Files**:
- `app/components/daisy/actions/button_component.rb`
- `app/components/loco_motion/concerns/linkable_component.rb`
- `app/components/loco_motion/concerns/iconable_component.rb`

The component will support:
- Basic badge functionality as per the existing spec
- Left and right icons using the Iconable concern
- Link transformation using the Linkable concern
- All existing badge variants and sizes

### 5. Update the Badge Component Template

**Purpose**: Modify the badge template to support icons and render as links when needed.

**File to Create/Modify**: `app/components/daisy/data_display/badge_component.html.haml`

**Reference Files**:
- `app/components/daisy/actions/button_component.html.haml`

The template should render:
- Left icon when specified
- Content (from title or block)
- Right icon when specified

### 6. Update the Badge Component Specs

**Purpose**: Extend the test coverage to include the new functionality.

**File to Modify**: `spec/components/daisy/data_display/badge_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/actions/button_component_spec.rb`

Add tests for:
- Link functionality (rendering as `<a>` with proper href)
- Left icon rendering
- Right icon rendering
- Combined functionality (links with icons)

### 7. Update Demo Examples

**Purpose**: Showcase the enhanced Badge component in the demo app.

**File to Modify**: `docs/demo/app/views/examples/daisy/data_display/badges.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/actions/buttons.html.haml`

Add examples for:
- Badges with left/right icons
- Badge links
- Badges with both links and icons

## Implementation Notes

1. Both the Button and Badge components already include the TippableComponent concern, which should be maintained.

2. The new concerns should be designed to work well with other components that might need similar functionality in the future.

3. The Badge component should maintain all its current styling and size variants while adding the new functionality.

4. The approach of extracting common concerns aligns with DRY principles and will make future maintenance easier.

5. When implementing the Badge component's link functionality, ensure that proper accessibility attributes are included.
