# BottomNav to Dock Component Migration Plan

## Overview

DaisyUI 5 has replaced the `btm-nav` component with a new `dock` component. This
plan outlines the steps needed to migrate our existing `BottomNavComponent` to
the new `DockComponent` to align with DaisyUI 5's changes.

Issue: [#40 Update BottomNav to DaisyUI 5 Dock](https://github.com/profoundry-us/loco_motion/issues/40)

## External Resources

- [DaisyUI 5 Dock Component](https://daisyui.com/components/dock/)

## Implementation Steps

### 1. Update IconableComponent with Icon Rendering Methods

**Purpose**: Add helper methods to the IconableComponent concern to simplify icon rendering in components.

**File to Update**: `lib/loco_motion/concerns/iconable_component.rb`

**Key Changes**:
1. Add `render_left_icon` method to render the left icon
2. Add `render_right_icon` method to render the right icon

**Example Implementation**:

```ruby
module LocoMotion
  module Concerns
    module IconableComponent
      # ... existing code ...

      #
      # Renders the left icon using a hero icon.
      #
      # @param opts [Hash] Additional options to pass to the hero_icon helper
      # @return [String] The rendered HTML for the icon
      #
      def render_left_icon(opts = {})
        return unless @left_icon.present?

        variant = opts.delete(:variant) || :outline
        hero_icon(@left_icon, variant: variant, html: left_icon_html.merge(opts))
      end
      alias_method :render_icon, :render_left_icon

      #
      # Renders the right icon using a hero icon.
      #
      # @param opts [Hash] Additional options to pass to the hero_icon helper
      # @return [String] The rendered HTML for the icon
      #
      def render_right_icon(opts = {})
        return unless @right_icon.present?

        variant = opts.delete(:variant) || :outline
        hero_icon(@right_icon, variant: variant, html: right_icon_html.merge(opts))
      end
    end
  end
end
```

### 2. Rename and Update the Component Class

**Purpose**: Rename the BottomNavComponent to DockComponent and update its implementation
to align with DaisyUI 5's Dock component.

**File Changes**:
- Rename: `app/components/daisy/navigation/bottom_nav_component.rb` → `app/components/daisy/navigation/dock_component.rb`

**Reference Files**:
- `app/components/daisy/navigation/tabs_component.rb` (for implementation patterns)

**Key Changes**:
1. Rename the main component from `BottomNavComponent` to `DockComponent`
2. Rename the section component from `BottomNavSectionComponent` to `DockSectionComponent`
3. Update CSS classes from `btm-nav` to `dock` and `btm-nav-label` to `dock-label`
4. Utilize the LinkableComponent and IconableComponent concerns in DockSectionComponent

**Example Implementation**:

```ruby
module Daisy
  module Navigation
    class DockComponent < LocoMotion::BaseComponent

      #
      # A section within a Dock component.
      #
      # @part icon The icon element for the section.
      # @part title The title element for the section.
      #
      # @loco_example Basic section with icon
      #   = daisy_dock do |dock|
      #     - dock.with_section(icon: "home", href: "#")
      #
      # @loco_example Active section with title
      #   = daisy_dock do |dock|
      #     - dock.with_section(icon: "information-circle", href: "#", active: true, title: "Info")
      #
      # @loco_example Custom title content
      #   = daisy_dock do |dock|
      #     - dock.with_section(icon: "chart-bar", href: "#") do
      #       .font-bold.text-xs
      #         Stats
      #
      class DockSectionComponent < LocoMotion::BaseComponent
        include LocoMotion::Concerns::IconableComponent
        include LocoMotion::Concerns::LinkableComponent

        define_parts :icon, :title

        # Creates a new dock section.
        #
        # @param kws [Hash] The keyword arguments for the component.
        #
        # @option kws title [String] Optional text to display below the icon.
        #
        # @option kws active [Boolean] Whether this section is currently active (default: false).
        #
        # @option kws css [String] Additional CSS classes for styling. Common
        #   options include:
        #   - Text color: `text-primary`, `text-secondary`, `text-accent`
        #   - Custom colors: `text-[#449944]`
        #
        def initialize(**kws)
          super(**kws)

          @title = config_option(:title)
          @active = config_option(:active, false)
        end

        def before_render
          super # Execute IconableComponent and LinkableComponent setup

          # Set default tag to button if not set as link by LinkableComponent
          set_tag_name(:component, :button) unless @href.present?

          add_css(:component, "dock-active") if @active

          set_tag_name(:title, :span)
          add_css(:title, "dock-label")
        end

        def call
          part(:component) do
            # Use the new helper method from IconableComponent
            concat(render_icon({ class: "where:size-6" })) if @icon
            concat(part(:title) { @title }) if @title
            concat(content)
          end
        end
      end

      renders_many :sections, DockSectionComponent

      # Creates a new dock component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws css [String] Additional CSS classes for styling. Common
      #   options include:
      #   - Position: `relative`, `fixed bottom-0`
      #   - Width: `w-full`, `max-w-[400px]`
      #   - Border: `border`, `border-base-200`
      #   - Size: `dock-xs`, `dock-sm`, `dock-md`, `dock-lg`, `dock-xl`
      #
      def initialize(**kws)
        super(**kws)
      end

      def before_render
        add_css(:component, "dock")
      end

      def call
        part(:component) do
          sections.each do |section|
            concat(section)
          end

          concat(content)
        end
      end
    end
  end
end
```

### 3. Update Component Tests

**Purpose**: Update tests to match the renamed component.

**File Changes**:
- Rename: `spec/components/daisy/navigation/bottom_nav_component_spec.rb` → `spec/components/daisy/navigation/dock_component_spec.rb`

**Key Changes**:
1. Update class references from `BottomNavComponent` to `DockComponent`
2. Update CSS class assertions from `btm-nav` to `dock`
3. Add tests for different sizes via CSS classes
4. Test icon rendering using the IconableComponent concern

**Example Implementation**:

```ruby
RSpec.describe Daisy::Navigation::DockComponent, type: :component do
  it "renders with default classes" do
    render_inline(described_class.new)
    expect(page).to have_css(".dock")
  end

  it "applies size classes via CSS" do
    render_inline(described_class.new(css: "dock-xs"))
    expect(page).to have_css(".dock.dock-xs")

    render_inline(described_class.new(css: "dock-lg"))
    expect(page).to have_css(".dock.dock-lg")
  end

  it "renders sections" do
    render_inline(described_class.new) do |dock|
      dock.with_section(icon: "home")
      dock.with_section(icon: "info", active: true)
    end

    expect(page).to have_css(".dock button", count: 2)
    expect(page).to have_css(".dock-active", count: 1)
  end

  it "renders sections with titles" do
    render_inline(described_class.new) do |dock|
      dock.with_section(icon: "home", title: "Home")
    end

    expect(page).to have_css(".dock-label", text: "Home")
  end

  it "renders sections as links via LinkableComponent" do
    render_inline(described_class.new) do |dock|
      dock.with_section(icon: "home", href: "/home")
    end

    expect(page).to have_css(".dock a[href='/home']")
  end
end
```

### 4. Update Example Views

**Purpose**: Update the example views to demonstrate the new component.

**File Changes**:
- Rename: `docs/demo/app/views/examples/daisy/navigation/bottom_navs.html.haml` → `docs/demo/app/views/examples/daisy/navigation/docks.html.haml`

**Key Changes**:
1. Update component references from `daisy_bottom_nav` to `daisy_dock`
2. Add examples showing the different sizes via CSS classes
3. Update any references to old class names

**Example Implementation**:

```haml
= doc_title(title: "Dock", comp: @comp) do |title|
  :markdown
    The Dock component provides a navigation bar fixed to the bottom of the screen, commonly used in mobile interfaces.

= doc_example(title: "Basic Dock") do |doc|
  - doc.with_description do
    :markdown
      A simple dock component with three sections.

  = daisy_dock do |dock|
    - dock.with_section(icon: "home", href: "#")
    - dock.with_section(icon: "information-circle", href: "#", active: true)
    - dock.with_section(icon: "chart-bar", href: "#")

= doc_example(title: "Dock with Titles") do |doc|
  - doc.with_description do
    :markdown
      Dock sections can include titles beneath the icons.

  = daisy_dock do |dock|
    - dock.with_section(icon: "home", href: "#", title: "Home")
    - dock.with_section(icon: "information-circle", href: "#", title: "Info", active: true)
    - dock.with_section(icon: "chart-bar", href: "#", title: "Stats")

= doc_example(title: "Dock Sizes") do |doc|
  - doc.with_description do
    :markdown
      Dock components come in five different sizes through CSS classes: xs, sm, md (default), lg, and xl.

  = daisy_dock(css: "dock-xs mb-8") do |dock|
    - dock.with_section(icon: "home", title: "XS")
    - dock.with_section(icon: "information-circle", active: true, title: "XS")
    - dock.with_section(icon: "chart-bar", title: "XS")

  = daisy_dock(css: "dock-sm mb-8") do |dock|
    - dock.with_section(icon: "home", title: "SM")
    - dock.with_section(icon: "information-circle", active: true, title: "SM")
    - dock.with_section(icon: "chart-bar", title: "SM")

  = daisy_dock(css: "mb-8") do |dock|
    - dock.with_section(icon: "home", title: "MD (default)")
    - dock.with_section(icon: "information-circle", active: true, title: "MD")
    - dock.with_section(icon: "chart-bar", title: "MD")

  = daisy_dock(css: "dock-lg mb-8") do |dock|
    - dock.with_section(icon: "home", title: "LG")
    - dock.with_section(icon: "information-circle", active: true, title: "LG")
    - dock.with_section(icon: "chart-bar", title: "LG")

  = daisy_dock(css: "dock-xl mb-8") do |dock|
    - dock.with_section(icon: "home", title: "XL")
    - dock.with_section(icon: "information-circle", active: true, title: "XL")
    - dock.with_section(icon: "chart-bar", title: "XL")

= doc_example(title: "Colored Dock") do |doc|
  - doc.with_description do
    :markdown
      Dock sections can be styled with different colors.

  = daisy_dock do |dock|
    - dock.with_section(icon: "home", href: "#", css: "text-primary")
    - dock.with_section(icon: "information-circle", href: "#", css: "text-secondary")
    - dock.with_section(icon: "chart-bar", href: "#", css: "text-accent")
```

### 5. Update Helper Method

**Purpose**: Update the helper method to use the new component name.

**File to Update**: `lib/loco_motion/helpers.rb`

**Key Changes**:
1. Replace `daisy_bottom_nav` with `daisy_dock`

### 6. Update CHANGELOG

**Purpose**: Document the breaking change.

**File to Update**: `CHANGELOG.md`

**Key Changes**:
1. Add an entry for the migration from BottomNav to Dock

## Steps to Verify

1. Check that the new Dock component renders correctly in all example cases
2. Verify that all five sizes work correctly with CSS classes
3. Ensure the active state is properly applied with the new class names
4. Validate that icons and labels display correctly in the new component
5. Test that the new icon rendering helper methods work correctly
