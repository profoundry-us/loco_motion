# List Component Implementation Plan

## Overview

This plan outlines the steps to implement the DaisyUI List component in the
LocoMotion library as part of the DataDisplay group. The List component provides
a clean, consistent way to display items in a vertical layout for displaying
information in rows.

## External Resources

- [DaisyUI List Component](https://daisyui.com/components/list/)
- [Rails View Components Guide](https://viewcomponent.org/guide/)

## Implementation Steps

### 1. Create the Component Class

**Purpose**: Define the core component class that handles rendering and configuration.

**File to Create**: `app/components/daisy/data_display/list_component.rb`

**Reference Files**:
- `app/components/daisy/data_display/card_component.rb`
- `app/components/daisy/data_display/table_component.rb`

### 2. Create Component Template

**Purpose**: Define the HTML template for the list component.

**File to Create**: `app/components/daisy/data_display/list_component.html.haml`

**Reference Files**:
- `app/components/daisy/data_display/card_component.html.haml`
- `app/components/daisy/data_display/table_component.html.haml`

### 3. Create List Item Component Class

**Purpose**: Define a sub-component for individual list items (rows).

**File to Create**: `app/components/daisy/data_display/list_item_component.rb`

**Reference Files**:
- `app/components/daisy/data_display/timeline_event_component.rb`

### 4. Create List Item Component Template

**Purpose**: Define the HTML template for list items.

**File to Create**: `app/components/daisy/data_display/list_item_component.html.haml`

**Reference Files**:
- `app/components/daisy/data_display/timeline_event_component.html.haml`

### 5. Create Component Tests

**Purpose**: Ensure component functionality works as expected through comprehensive test cases.

**File to Create**: `spec/components/daisy/data_display/list_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_display/card_component_spec.rb`
- `spec/components/daisy/data_display/table_component_spec.rb`

### 6. Create List Item Component Tests

**Purpose**: Test the list item component separately.

**File to Create**: `spec/components/daisy/data_display/list_item_component_spec.rb`

**Reference Files**:
- `spec/components/daisy/data_display/timeline_event_component_spec.rb`

### 7. Create Example Views

**Purpose**: Provide usage examples and visual demonstration of the component.

**File to Create**: `docs/demo/app/views/examples/daisy/data_display/lists.html.haml`

**Reference Files**:
- `docs/demo/app/views/examples/daisy/data_display/cards.html.haml`
- `docs/demo/app/views/examples/daisy/data_display/tables.html.haml`

### 8. Register the Helper

**Purpose**: Make the component available to the application by registering it.

**File to Edit**: `lib/loco_motion/helpers.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/helpers.rb` (card registration)
- Current implementation in `lib/loco_motion/helpers.rb` (table registration)

## Component Features and Options

The List component will support the following features:

1. Basic list rendering with title and items
2. Support for custom content in list items
3. Rendering list items from a collection
4. Support for background, shadow, and border styling
5. Ability to customize row styles

The component will expose the following APIs:

1. `daisy_list` helper method for creating lists
2. `with_item` slot method for adding individual items
3. Support for collection rendering of items

## Example Usage

```haml
= daisy_list(title: "Most played songs this week") do |list|
  - songs.each do |song|
    - list.with_item do |item|
      - item.with_image(src: song.cover_image)
      .flex.flex-col
        = song.title
        .text-xs.opacity-60= song.artist
      = daisy_button(icon: "play")
```
