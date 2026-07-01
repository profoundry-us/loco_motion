# frozen_string_literal: true

require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # The IconableComponent concern provides functionality for components that
    # display icons. It supports both left and right icons and allows for
    # customization of their CSS classes and HTML attributes.
    #
    module IconableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.register_component_initializer(:_initialize_iconable_component)
        base.register_component_setup(:_setup_iconable_component)
      end

      protected

      #
      # Initialize icon-related options.
      #
      # @option kws icon       [String] The icon to render, as a qualified
      #   `[library:]name[/variant]` token (e.g. `"trash"`,
      #   `"phosphor:gear/bold"`, `"bolt/solid"`). The library and variant
      #   default to `LocoMotion.configuration.default_icon_library` /
      #   `default_icon_variant`. This is an alias of `left_icon`.
      #
      # @option kws icon_css   [String] The CSS classes to apply to the icon. This
      #   is an alias of `left_icon_css`.
      #
      # @option kws icon_options [Hash] Additional keyword arguments forwarded
      #   to the {Loco::IconComponent} (`loco_icon`) that renders the icon —
      #   the icon component's own options, not the icon library's. You rarely
      #   need this: the name, library, and variant live in the token, and CSS /
      #   HTML have dedicated `icon_css` / `icon_html` options. (A `tip:` tooltip
      #   generally belongs on the parent component rather than the icon.) It is
      #   kept as an escape hatch for advanced or future use. This is an alias of
      #   `left_icon_options`.
      #
      # @option kws icon_html  [Hash] Additional HTML attributes to apply to the
      #   icon. This is an alias of `left_icon_html`.
      #
      # @option kws left_icon  [String] The icon to render to the left of the
      #   content, as a qualified `[library:]name[/variant]` token.
      #
      # @option kws left_icon_css  [String] The CSS classes to apply to the left
      #   icon.
      #
      # @option kws left_icon_options [Hash] Additional keyword arguments
      #   forwarded to the left {Loco::IconComponent} (e.g. `tip:`).
      #
      # @option kws left_icon_html [Hash] Additional HTML attributes to apply to
      #   the left icon.
      #
      # @option kws right_icon [String] The icon to render to the right of the
      #   content, as a qualified `[library:]name[/variant]` token.
      #
      # @option kws right_icon_css [String] The CSS classes to apply to the right
      #   icon.
      #
      # @option kws right_icon_options [Hash] Additional keyword arguments
      #   forwarded to the right {Loco::IconComponent} (e.g. `tip:`).
      #
      # @option kws right_icon_html [Hash] Additional HTML attributes to apply to
      #   the right icon.
      #
      def _initialize_iconable_component
        @icon = config_option(:icon)
        @icon_css = config_option(:icon_css, default_icon_size)
        @icon_options = config_option(:icon_options, {})
        @icon_html = config_option(:icon_html, {})

        @left_icon = config_option(:left_icon, @icon)
        @left_icon_css = config_option(:left_icon_css, @icon_css)
        @left_icon_options = config_option(:left_icon_options, @icon_options)
        @left_icon_html = config_option(:left_icon_html, @icon_html)

        @right_icon = config_option(:right_icon)
        @right_icon_css = config_option(:right_icon_css, @icon_css)
        @right_icon_options = config_option(:right_icon_options, {})
        @right_icon_html = config_option(:right_icon_html, @icon_html)
      end

      #
      # Configure CSS classes for a component with icons.
      # This adds necessary classes for proper icon spacing and alignment.
      #
      def _setup_iconable_component
        return unless @icon || @left_icon || @right_icon

        add_css(:component, "where:inline-flex where:items-center where:gap-2")
      end

      def default_icon_size
        "where:size-5"
      end

      public # Ensure these helper methods remain public

      #
      # Returns the HTML attributes for the left icon.
      #
      # @return [Hash] HTML attributes for the left icon
      #
      def left_icon_html
        { class: @left_icon_css }.merge(@left_icon_html)
      end

      #
      # Returns the HTML attributes for the right icon.
      #
      # @return [Hash] HTML attributes for the right icon
      #
      def right_icon_html
        { class: @right_icon_css }.merge(@right_icon_html)
      end

      #
      # Determines if any icons are present in the component.
      #
      # @return [Boolean] true if any icons are configured, false otherwise
      #
      def has_icons?
        @left_icon.present? || @right_icon.present?
      end

      #
      # Renders the left icon through the `loco_icon` engine.
      #
      # @return [String] The rendered HTML for the icon
      #
      def render_left_icon
        return if @left_icon.blank?

        render_managed_icon(:left)
      end
      alias render_icon render_left_icon

      #
      # Renders the right icon.
      #
      # @return [String] The rendered HTML for the icon
      #
      def render_right_icon
        return if @right_icon.blank?

        render_managed_icon(:right)
      end

      private

      #
      # Renders the `:left` or `:right` icon through the `loco_icon` engine,
      # which resolves the SVG from the app's synced `app/assets/svg/icons`
      # (falling back to the icons LocoMotion bundles). Every library —
      # including the default Heroicons — flows through this single path.
      #
      def render_managed_icon(side)
        ref = LocoMotion::Icons::Reference.parse(
          instance_variable_get("@#{side}_icon"),
          default_library: LocoMotion.configuration.default_icon_library,
          default_variant: LocoMotion.configuration.default_icon_variant
        )
        options = instance_variable_get("@#{side}_icon_options") || {}

        shared = {
          css: non_shrinking_icon_css(instance_variable_get("@#{side}_icon_css")),
          html: instance_variable_get("@#{side}_icon_html")
        }.merge(options)

        # Re-encode the parsed reference as a fully-qualified token; loco_icon
        # takes the library and variant from the token, not separate options.
        loco_icon("#{ref[:library]}:#{ref[:name]}/#{ref[:variant]}", **shared)
      end

      #
      # Prepends `where:shrink-0` to the given icon CSS. `_setup_iconable_component`
      # lays the component out as an `inline-flex` row, so without this an icon
      # next to long content gets squished horizontally (it shrinks as a flex
      # item while its height stays fixed). The `where:` variant keeps it
      # overridable, and it is prepended so an explicit `shrink`/`grow` passed via
      # `icon_css` still wins.
      #
      # @param css [String] The caller-supplied icon CSS classes.
      #
      # @return [String] The icon CSS with a non-shrinking default prepended.
      #
      def non_shrinking_icon_css(css)
        "where:shrink-0 #{css}".strip
      end
    end
  end
end
