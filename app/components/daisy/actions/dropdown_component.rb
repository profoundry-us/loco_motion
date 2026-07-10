# frozen_string_literal: true

#
# The Dropdown component shows a Button, or any other component you wish, with a
# hovering menu that opens on click (or hover). It provides a flexible way to
# create dropdown menus with customizable triggers and content.
#
# Note that the dropdown uses slots for both the activator and menu items,
# allowing for maximum flexibility in how the dropdown is triggered and what
# content it displays.
#
# @part menu The default / styled menu rendered by the dropdown. Contains all
#   menu items and provides the dropdown's positioning and animation.
# @part menu_item The styles for every item in the dropdown. Provides consistent
#   spacing and hover states.
#
# @slot button The button that triggers the dropdown. This is the default trigger
#   and is styled automatically.
# @slot activator A custom (i.e. non-button) activator for the dropdown.
#   Automatically adds the `role="button"` and `tabindex="0"` attributes.
# @slot item+ The items in the dropdown. Pass a block for fully custom content,
#   or use the structured options (`label:`, `href:`, `selected:`) and the
#   item's `leading` / `trailing` slots to build a selectable row.
#
# @loco_example Basic Usage
#   = daisy_dropdown do |dropdown|
#     - dropdown.with_button do
#       Click me!
#     - dropdown.with_item do
#       Item 1
#     - dropdown.with_item do
#       Item 2
#
# @loco_example Custom Activator
#   = daisy_dropdown do |dropdown|
#     - dropdown.with_activator do
#       = loco_icon("bars-3", css: "size-6")
#     - dropdown.with_item do
#       Menu Item 1
#     - dropdown.with_item do
#       Menu Item 2
#
# @loco_example Complex Items
#   = daisy_dropdown do |dropdown|
#     - dropdown.with_button do
#       User Settings
#     - dropdown.with_item do
#       .flex.gap-2.items-center
#         = loco_icon("user-circle")
#         Profile
#     - dropdown.with_item do
#       .flex.gap-2.items-center
#         = loco_icon("cog-6-tooth")
#         Settings
#     - dropdown.with_item do
#       .flex.gap-2.items-center.text-error
#         = loco_icon("arrow-right-on-rectangle")
#         Logout
#
# @loco_example Selectable Items (leading / label / trailing / selected)
#   = daisy_dropdown(title: "Sort by") do |dropdown|
#     - dropdown.with_item(label: "Newest", href: "#", selected: true) do |item|
#       - item.with_trailing do
#         = loco_icon("check", css: "size-4")
#     - dropdown.with_item(label: "Oldest", href: "#")
#     - dropdown.with_item(href: "#") do |item|
#       - item.with_leading do
#         = loco_icon("star", css: "size-4")
#       Favorites
#
module Daisy
  module Actions
    class DropdownComponent < LocoMotion::BaseComponent
      include ViewComponent::SlotableDefault

      #
      # A single dropdown menu item (`<li class="menu-item">`). Pass a block for
      # fully custom content (the original behavior), or use the structured
      # options/slots to build a selectable row: a `leading` slot, a label, a
      # `trailing` slot, and an active (`selected`) state.
      #
      # @slot leading Content rendered before the label (e.g. an icon or color
      #   swatch).
      #
      # @slot trailing Content rendered after the label (e.g. a checkmark or a
      #   shortcut hint).
      #
      class ItemComponent < LocoMotion::BasicComponent
        renders_one :leading
        renders_one :trailing

        # @option kws label [String] Text for the item's label. You can also
        #   pass the label as block content.
        #
        # @option kws href [String] When present, the row is rendered as an
        #   `<a>` link to this URL.
        #
        # @option kws selected [Boolean] Marks the row active, adding DaisyUI's
        #   `menu-active` class. Defaults to false.
        def initialize(label: nil, href: nil, selected: false, **kws)
          @label = label
          @href = href
          @selected = selected

          super(**kws)
        end

        def before_render
          set_tag_name(:component, :li)
          add_css(:component, "menu-item")

          super
        end

        def call
          part(:component) do
            structured? ? render_row : content
          end
        end

        private

        # Render the structured row only when a structured affordance is used; a
        # bare content block stays verbatim for backwards compatibility.
        def structured?
          @label.present? || @href.present? || @selected || leading? || trailing?
        end

        def render_row
          body = safe_join([leading_content, label_content, trailing_content].compact)

          if @href
            link_to(@href, class: row_css) { body }
          else
            content_tag(:span, body, class: row_css)
          end
        end

        def leading_content
          leading if leading?
        end

        def label_content
          text = @label.presence || content
          content_tag(:span, text, class: "grow") if text.present?
        end

        def trailing_content
          trailing if trailing?
        end

        def row_css
          classes = %w[flex items-center gap-2]
          classes << "menu-active" if @selected
          classes.join(" ")
        end
      end

      define_parts :menu

      renders_one :activator, LocoMotion::BasicComponent.build(html: { role: "button", tabindex: 0 })
      renders_one :button, Daisy::Actions::ButtonComponent
      renders_many :items, ItemComponent

      #
      # Creates a new instance of the DropdownComponent.
      #
      # @param title [String] The title of the dropdown. Will be used as the button
      #   text if no custom button or activator is provided.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws title [String] The title of the dropdown. You can also pass this
      #   as the first argument.
      #
      def initialize(title = nil, **kws, &block)
        super

        @simple_title = config_option(:title, title)
      end

      #
      # Adds the relevant Daisy classes to the component.
      #
      def before_render
        setup_component
        setup_menu
      end

      #
      # Add the `dropdown` CSS class to the component.
      #
      def setup_component
        add_css(:component, "dropdown")
      end

      #
      # Make the menu a `<ul> / <li>` element and add the relevant Daisy classes.
      #
      # The default border keeps the menu visible when it opens over content
      # that shares its background color, and the vertical margin separates it
      # from the trigger (only the margin on the side the menu opens from takes
      # effect). The `where:` prefix keeps both overridable (e.g.
      # `menu_css: "border-0 my-0"`).
      #
      def setup_menu
        # Setup menu itself
        set_tag_name(:menu, :ul)
        add_css(:menu,
                "dropdown-content where:menu where:bg-base-100 where:rounded-box where:border where:border-base-300 " \
                "where:my-0.5 where:shadow where:w-52 where:p-2 where:z-[1]")
      end

      #
      # Provides a default button if no button or custom activator is provided.
      #
      def default_button
        Daisy::Actions::ButtonComponent.new(title: @simple_title)
      end
    end
  end
end
