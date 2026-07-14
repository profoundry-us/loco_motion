# frozen_string_literal: true

module Daisy
  module Navigation
    #
    # The Megamenu component renders a large, horizontal navigation menu where
    # each item opens a popover holding a big block of navigation links — a
    # DaisyUI menu, multi-column lists, images, or any custom content. It is
    # intended to be used once, near the top of the page.
    #
    # Everything is native HTML: each item is a `<button popovertarget>` paired
    # with a `<div popover>`, and DaisyUI positions the popovers (and the sliding
    # hover highlight) with CSS anchor positioning — no JavaScript required.
    #
    # The megamenu is best suited to large screens. Add `max-sm:megamenu-vertical`
    # via `css:` to collapse it on small screens, where the always-rendered
    # toggle button (hidden at `sm` and up) opens the menu as a full-width
    # popover instead.
    #
    # @note The hover highlight and popover placement use CSS anchor positioning.
    #   Browsers without it still show and open the menus — they just skip the
    #   anchored styling.
    #
    # @part toggle The small-screen toggle `<button>` that opens the megamenu.
    #   Rendered before the megamenu container with `btn sm:hidden` by default;
    #   customize via `toggle_css` / `toggle_html`, or skip it entirely with
    #   `toggle: false`.
    # @part active_indicator The `<span class="megamenu-active">` that slides
    #   under the hovered / open item. Rendered automatically.
    #
    # @slot toggle Custom content for the toggle button (an icon, styled text,
    #   etc.). Without it, the button shows the `toggle_text` option.
    # @slot item+ The megamenu items. Each takes a `title:` for its button and a
    #   block for its popover content.
    #
    # @loco_example Basic Usage
    #   = daisy_megamenu(css: "max-sm:megamenu-vertical p-2 border border-base-300") do |mega|
    #     - mega.with_item(title: "Services") do
    #       = daisy_menu do |menu|
    #         - menu.with_item do
    #           = link_to "Enterprise", "#"
    #         - menu.with_item do
    #           = link_to "Security", "#"
    #     - mega.with_item(title: "Cloud") do
    #       = daisy_menu do |menu|
    #         - menu.with_item do
    #           = link_to "Storage Solutions", "#"
    #
    # @loco_example Wide Popovers
    #   = daisy_megamenu(css: "megamenu-wide max-sm:megamenu-vertical") do |mega|
    #     - mega.with_item(title: "Products") do
    #       = daisy_menu(css: "menu-horizontal") do |menu|
    #         - menu.with_item do
    #           = link_to "UI Kit", "#"
    #         - menu.with_item do
    #           = link_to "Themes", "#"
    #
    # @loco_example Custom Toggle
    #   = daisy_megamenu(css: "max-sm:megamenu-vertical") do |mega|
    #     - mega.with_toggle do
    #       = loco_icon("bars-3", css: "size-6")
    #     - mega.with_item(title: "Navigation") do
    #       = daisy_menu do |menu|
    #         - menu.with_item do
    #           = link_to "Home", "#"
    #
    class MegamenuComponent < LocoMotion::BaseComponent
      #
      # One megamenu item: a `<button popovertarget>` immediately followed by
      # its `<div popover>` content block. The pairing IDs are generated
      # automatically (or pass `id:` to control them).
      #
      class ItemComponent < LocoMotion::BasicComponent
        define_parts :button, :popover

        # @return [String] The ID shared by the popover and the button's
        #   `popovertarget`.
        attr_reader :popover_id

        # @option kws title [String] The text for the item's always-visible
        #   button.
        #
        # @option kws id [String] A custom ID for the item's popover. Defaults
        #   to a generated unique ID.
        def initialize(**kws)
          super

          @title = config_option(:title)
          @popover_id = config_option(:id, "megamenu-item-#{SecureRandom.uuid}")
        end

        def before_render
          set_tag_name(:button, :button)
          add_html(:button, { type: "button", popovertarget: @popover_id })

          set_tag_name(:popover, :div)
          add_html(:popover, { id: @popover_id, popover: "auto" })

          # See MegamenuComponent#popover_anchor: wide/full popovers must
          # anchor to their own megamenu, not DaisyUI's shared `--megamenu`.
          if (anchor = loco_parent&.popover_anchor)
            add_html(:popover, { style: "position-anchor:#{anchor}" })
          end

          super
        end

        #
        # Renders the button / popover pair with no extra wrapper: DaisyUI
        # finds each item's popover with an adjacent-sibling selector and
        # anchors it via the buttons' `nth-of-type` position, so both must be
        # direct children of the megamenu container.
        #
        def call
          safe_join([render_button, render_popover])
        end

        private

        def render_button
          part(:button) { @title }
        end

        def render_popover
          part(:popover) { content }
        end
      end

      define_parts :toggle, :active_indicator

      renders_one :toggle
      renders_many :items, ItemComponent

      # @return [String] The megamenu container's ID (used as the toggle
      #   button's `popovertarget`).
      attr_reader :id

      #
      # Creates a new Megamenu component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws id [String] A custom ID for the megamenu container. Also
      #   used as the toggle button's `popovertarget`. Defaults to a generated
      #   unique ID.
      #
      # @option kws toggle_text [String] The text for the default small-screen
      #   toggle button. Defaults to "Menu". For richer content, use the
      #   `toggle` slot instead.
      #
      # @option kws toggle [Boolean] Pass `false` to skip rendering the toggle
      #   button entirely. Defaults to true.
      #
      # @option kws css [String] Additional CSS classes for styling. Common
      #   options include:
      #   - Responsive: `max-sm:megamenu-vertical` (collapse on small screens)
      #   - Layout: `megamenu-wide`, `megamenu-full`
      #   - Size: `megamenu-xs`, `megamenu-sm`, `megamenu-md`, `megamenu-lg`,
      #     `megamenu-xl`
      #
      def initialize(**kws)
        super

        @id = config_option(:id, "megamenu-#{SecureRandom.uuid}")
        @toggle_text = config_option(:toggle_text, "Menu")
        @show_toggle = config_option(:toggle, true)
        @anchored = config_option(:css, "").to_s.match?(/megamenu-(wide|full)/)
      end

      #
      # The per-instance CSS anchor name used by `megamenu-wide` /
      # `megamenu-full` popovers, or nil for a default megamenu.
      #
      # DaisyUI anchors wide/full popovers to a hard-coded `--megamenu`
      # anchor name, which assumes a single megamenu per page — with several
      # on one page, every wide/full popover resolves to the *last* one in
      # the document and opens in the wrong place. When those modifiers are
      # present, the component overrides the pair (`anchor-name` on the
      # container, `position-anchor` on each item popover) with a unique
      # name so every instance anchors to itself.
      #
      # @return [String, nil] The anchor name (e.g. `--megamenu-<id>`).
      #
      def popover_anchor
        @anchored ? "--#{@id}" : nil
      end

      #
      # @return [Boolean] Whether the small-screen toggle button should render.
      #
      def show_toggle?
        @show_toggle
      end

      #
      # @return [String] The default text for the toggle button.
      #
      attr_reader :toggle_text

      #
      # Calls the {setup_component} method before rendering the component.
      #
      def before_render
        setup_component
        super
      end

      private

      #
      # Sets up the megamenu container (which is itself a popover so the
      # small-screen toggle can open it), the toggle button, and the active
      # indicator span.
      #
      def setup_component
        add_css(:component, "megamenu")
        add_html(:component, { id: @id, popover: "auto" })
        add_html(:component, { style: "anchor-name:#{popover_anchor}" }) if popover_anchor

        set_tag_name(:toggle, :button)
        add_css(:toggle, "btn sm:hidden")
        add_html(:toggle, { type: "button", popovertarget: @id })

        set_tag_name(:active_indicator, :span)
        add_css(:active_indicator, "megamenu-active")
      end
    end
  end
end
