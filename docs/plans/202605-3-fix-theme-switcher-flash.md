# Fix Theme Switcher Flash of Content

## Overview

This implementation plan outlines the steps to fix the flash of content that
occurs when the demo site loads with a non-default theme (particularly dark
themes). The flash happens because the page initially renders with the default
light theme, then JavaScript runs to set the saved theme, causing a noticeable
color shift in the header and other components.

## External Resources

- [GitHub Issue #49](https://github.com/profoundry-us/loco_motion/issues/49)
- [DaisyUI Themes](https://daisyui.com/docs/themes/)
- [Stimulus Controllers](https://stimulus.hotwired.dev/handbook/controllers)

## Implementation Steps

### 1. Analyze Current Implementation

**Purpose**: Understand how the theme is currently set and where the flash
occurs.

**Files to Review**:
- `docs/demo/app/views/layouts/application.html.haml`
- `docs/demo/app/javascript/controllers/index.js`
- `app/components/daisy/actions/theme_controller.js`

**Key Concerns**:
- The `<html>` element does not have a `data-theme` attribute set initially
- The Stimulus controller's `connect()` method runs after the page has already
  rendered
- localStorage is read in JavaScript, not during server-side rendering
- The header and other components render with default light theme colors
  before the JavaScript can apply the saved theme

### 2. Create Theme Helper with Inline Script

**Purpose**: Create a helper method that outputs the inline script to set the
`data-theme` attribute before the page renders. This makes the fix reusable
across all LocoMotion apps.

**File to Create**: `app/helpers/daisy/theme_helper.rb`

**Changes to Make**:
- Create a new helper module for theme-related utilities
- Add a method `theme_preload_script` that returns the inline script as a
  string
- The script should:
  - Read the `savedTheme` from localStorage
  - If a theme is found, set the `data-theme` attribute on the `<html>` element
  - Execute synchronously to ensure it runs before the page renders
  - Handle the case where localStorage is not available (e.g., in private
    browsing mode)

**Implementation Details**:
- Use plain JavaScript (no framework dependencies needed)
- Keep it minimal and fast to avoid blocking page load
- Wrap in a try-catch to handle localStorage access errors
- Return the script as a string that can be output in the layout

### 3. Register the Theme Helper

**Purpose**: Make the theme helper available to applications using LocoMotion.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Changes to Make**:
- Add `Daisy::ThemeHelper` to the list of helpers
- Follow the existing pattern for registering helpers

### 4. Update Demo Layout to Use Helper

**Purpose**: Update the demo layout to use the new helper method instead of
hardcoding the script.

**File to Edit**: `docs/demo/app/views/layouts/application.html.haml`

**Changes to Make**:
- Add a call to the helper method in the `<head>` section
- Place it immediately after the `<head>` tag or before the first stylesheet
- Use `= theme_preload_script` to output the inline script

### 5. Update Stimulus Controller

**Purpose**: Ensure the Stimulus controller still works correctly and doesn't
conflict with the inline script.

**File to Edit**: `app/components/daisy/actions/theme_controller.js`

**Changes to Make**:
- The controller should still read from localStorage and set the theme
- Ensure it updates the `data-theme` attribute when themes change
- The inline script handles the initial load, the controller handles dynamic
  changes
- No major changes needed, just verify compatibility

### 6. Test the Fix

**Purpose**: Verify that the flash of content is eliminated.

**Commands to Run**:
```bash
# Open the demo site in a browser and test:
# 1. Set a dark theme
# 2. Refresh the page
# 3. Observe that there is no flash of light theme
# 4. Test with different themes (synthwave, retro, etc.)
# 5. Test clearing the theme
# 6. Test in private browsing mode (localStorage disabled)
```

**Expected Results**:
- No visible flash of light theme when loading with a dark theme
- Theme switcher still functions correctly
- All theme options work as expected
- Graceful degradation when localStorage is unavailable

### 7. Update Documentation

**Purpose**: Document the helper method for developers using LocoMotion.

**Files to Edit**:
- Add documentation about the `theme_prevention_script` helper
- Update relevant documentation files to mention this helper

**Changes to Make**:
- Document the helper method in the theme controller documentation
- Explain that apps should call `= theme_preload_script` in their layout's
  `<head>` section
- Reference the GitHub issue #49
- Explain why this is needed (flash of content prevention)

## Verification Steps

**Purpose**: Ensure the fix works across different scenarios.

**Test Cases**:
1. Load page with no saved theme (should use default)
2. Load page with saved dark theme (no flash)
3. Load page with saved synthwave theme (no flash)
4. Change theme dynamically (should work via Stimulus controller)
5. Clear theme (should revert to default)
6. Test in private browsing mode (should handle gracefully)
7. Test with JavaScript disabled (should still render with default theme)

**Commands to Run**:
```bash
# Manual testing in browser
# No automated tests needed for this UI fix
```

## Backward Compatibility

This change is backward compatible:
- The helper method is optional - apps can choose to use it or not
- The Stimulus controller continues to work as before
- No API changes or breaking changes to components
- Users without localStorage will still see the default theme
- Apps that don't call the helper will still work (just with the flash)
