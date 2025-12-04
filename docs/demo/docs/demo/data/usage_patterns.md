# LocoMotion Usage Patterns

This document describes common usage patterns and conventions for the LocoMotion component library. These patterns help LLMs generate idiomatic and consistent code.

## Form Building Patterns

### Basic Form Fields
- Use `daisy_label` with `daisy_text_input` for form fields
- Wrap related inputs in `daisy_fieldset` for grouping
- Add validation errors with `daisy_alert` (error modifier)
- Use `daisy_text_area` for multi-line input

### Form Layout
```haml
= daisy_fieldset do
  = daisy_label("Name")
  = daisy_text_input(name: "name", id: "name", css: "input-bordered")

  = daisy_label("Email")
  = daisy_text_input(name: "email", id: "email", type: "email", css: "input-bordered")

  = daisy_label("Message")
  = daisy_text_area(name: "message", id: "message", css: "textarea-bordered")
```

### Select Fields and Options
- Use `daisy_select` with option groups for better organization
- Include `daisy_label` for accessibility
- Use `daisy_radio_button` for mutually exclusive choices
- Use `daisy_checkbox` for multiple selections

### File Uploads
- Use `daisy_file_input` with proper labeling
- Add validation feedback with `daisy_alert`
- Include help text with `daisy_label` descriptions

## Navigation Patterns

### Main Navigation
- Use `daisy_navbar` for primary site navigation
- Include `daisy_link` components for navigation items
- Add `daisy_dropdown` for sub-menus
- Use `daisy_breadcrumbs` for hierarchical navigation

### Sidebar Navigation
- Use `daisy_menu` for vertical sidebar navigation
- Apply `w-full` or specific width classes
- Use `daisy_link` for menu items
- Consider `daisy_drawer` for mobile navigation

### Navigation Example
```haml
= daisy_navbar(css: "bg-base-100") do
  .navbar-start
    = daisy_link("Home", "/", css: "btn btn-ghost")
    = daisy_link("About", "/about", css: "btn btn-ghost")

  .navbar-end
    = daisy_dropdown(css: "btn btn-ghost") do |dropdown|
      - dropdown.with_trigger do
        Account
      - dropdown.with_content do
        = daisy_link("Profile", "/profile")
        = daisy_link("Settings", "/settings")
```

## Layout Patterns

### Page Structure
- Use `daisy_hero` for page headers and introductions
- Wrap content in `daisy_card` for section grouping
- Use `daisy_divider` to separate content sections
- Apply `daisy_footer` for page footers

### Content Cards
- Use `daisy_card` for content grouping
- Include `daisy_button` for card actions
- Use `daisy_avatar` for user information
- Apply `daisy_badge` for status indicators

### Responsive Layout
- Use Tailwind flexbox utilities with components
- Apply `daisy_stack` for 3D layering effects
- Use `daisy_join` to connect related elements
- Consider `daisy_collapse` for expandable content

## Data Display Patterns

### Tables and Lists
- Use `daisy_table` for tabular data
- Apply `daisy_list` for vertical item displays
- Use `daisy_stat` for metrics and statistics
- Include `daisy_badge` for status and categorization

### Media Content
- Use `daisy_figure` for images with captions
- Apply `daisy_avatar` for user profiles
- Use `daisy_carousel` for image galleries
- Include `daisy_kbd` for keyboard shortcuts

### Data Visualization
- Use `daisy_progress` for progress bars
- Apply `daisy_radial_progress` for circular progress
- Use `daisy_countdown` for timers
- Include `daisy_stat` for key metrics

## Feedback Patterns

### User Feedback
- Use `daisy_alert` for notifications and warnings
- Apply `daisy_toast` for non-critical messages
- Use `daisy_loading` for loading states
- Include `daisy_skeleton` for content placeholders

### Interactive Feedback
- Use `daisy_tooltip` for contextual help
- Apply `daisy_modal` for dialogs and confirmations
- Use `daisy_swap` for toggle states
- Include `daisy_collapse` for expandable content

### Error Handling
```haml
= daisy_alert(modifier: :error) do
  %div
    %svg.w-6.h-6.inline-block.mr-2{fill: "none", stroke: "currentColor", viewBox: "0 0 24 24"}
      %path{stroke_linecap: "round", stroke_linejoin: "round", "stroke-width": "2", d: "M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"}
    Error: This field is required

= daisy_alert(modifier: :warning) do
  %div
    %svg.w-6.h-6.inline-block.mr-2{fill: "none", stroke: "currentColor", viewBox: "0 0 24 24"}
      %path{stroke_linecap: "round", stroke_linejoin: "round", "stroke-width": "2", d: "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"}
    Warning: Please review your input
```

## Rails Integration Patterns

### ViewComponent Integration
- All components inherit from `ViewComponent::Base`
- Use Rails helpers within components
- Access controller and request data when needed
- Follow Rails naming conventions

### Helper Method Usage
- Use `daisy_*` helper methods in views
- Apply `hero_*` helpers for icons
- Use standard Rails form helpers with components
- Leverage Rails URL helpers for links

### Asset Pipeline
- Include DaisyUI CSS in your application
- Add Tailwind CSS for utility classes
- Use Stimulus controllers for JavaScript interactions
- Follow Rails asset organization patterns

## Styling Conventions

### DaisyUI Classes
- Use semantic color classes: `btn-primary`, `input-error`
- Apply size modifiers: `btn-sm`, `input-lg`
- Use state classes: `btn-active`, `input-disabled`
- Apply ghost variants for borderless styles: `input-ghost`, `btn-ghost`

### Tailwind Integration
- Use utility classes for spacing: `m-4`, `p-2`
- Apply responsive utilities: `lg:flex`, `md:hidden`
- Use animation classes: `animate-pulse`, `animate-bounce`
- Apply layout utilities: `flex`, `grid`, `block`

### Custom CSS
- Use the `css:` parameter for additional styling
- Apply conditional classes based on state
- Use `html:` parameter for HTML attributes
- Include ARIA attributes for accessibility

## Accessibility Patterns

### Semantic HTML
- Use proper heading hierarchy
- Include ARIA labels and descriptions
- Ensure keyboard navigation support
- Provide alternative text for images

### Form Accessibility
```haml
= daisy_label("Full Name", for: "full_name")
= daisy_text_input(name: "user[full_name]", id: "full_name",
                   html: { aria: { required: true, describedby: "name_help" } })
%p#name_help.text-sm.text-gray-600 Enter your full name as it appears on official documents
```

### Interactive Elements
- Use `daisy_tooltip` for additional context
- Apply proper focus states
- Include skip links for navigation
- Ensure color contrast requirements

## Performance Patterns

### Component Optimization
- Avoid deeply nested component structures
- Use conditional rendering for expensive components
- Leverage Rails caching for repeated content
- Consider lazy loading for heavy components

### Asset Loading
- Load DaisyUI and Tailwind CSS efficiently
- Use Stimulus controllers judiciously
- Optimize image assets with proper sizing
- Consider progressive enhancement strategies
