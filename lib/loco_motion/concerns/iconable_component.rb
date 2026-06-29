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
      # @option kws icon       [String] The name of the icon to render. This is an
      #   alias of `left_icon`.
      #
      # @option kws icon_library [String, Symbol] The icon library to render the
      #   icon from. Defaults to
      #   `LocoMotion.configuration.default_icon_library` (`:heroicons`). Any
      #   library synced into the app is valid. Alias of `left_icon_library`.
      #
      # @option kws icon_variant [String, Symbol] The icon variant / weight.
      #   Defaults to `LocoMotion.configuration.default_icon_variant`
      #   (`:outline`). Alias of `left_icon_variant`.
      #
      # @option kws icon_css   [String] The CSS classes to apply to the icon. This
      #   is an alias of `left_icon_css`.
      #
      # @option kws icon_options [Hash] Options forwarded to the underlying
      #   {Hero::IconComponent} constructor — most notably `variant: :outline`
      #   or `variant: :solid` to pick the icon style. Use this (not
      #   `icon_html`) for icon component options; `icon_html` is for HTML
      #   attributes on the `<svg>`. This is an alias of `left_icon_options`.
      #
      # @option kws icon_html  [Hash] Additional HTML attributes to apply to the
      #   icon. This is an alias of `left_icon_html`.
      #
      # @option kws left_icon  [String] The name of the icon to render to the
      #   left of the content.
      #
      # @option kws left_icon_library [String, Symbol] The icon library for the
      #   left icon (defaults to `icon_library`).
      #
      # @option kws left_icon_variant [String, Symbol] The icon variant for the
      #   left icon (defaults to `icon_variant`).
      #
      # @option kws left_icon_css  [String] The CSS classes to apply to the left
      #   icon.
      #
      # @option kws left_icon_options [Hash] Options forwarded to the left
      #   {Hero::IconComponent} constructor (e.g. `variant: :outline`).
      #
      # @option kws left_icon_html [Hash] Additional HTML attributes to apply to
      #   the left icon.
      #
      # @option kws right_icon [String] The name of the icon to render to the
      #   right of the content.
      #
      # @option kws right_icon_library [String, Symbol] The icon library for the
      #   right icon (defaults to `icon_library`).
      #
      # @option kws right_icon_variant [String, Symbol] The icon variant for the
      #   right icon (defaults to `icon_variant`).
      #
      # @option kws right_icon_css [String] The CSS classes to apply to the right
      #   icon.
      #
      # @option kws right_icon_options [Hash] Options forwarded to the right
      #   {Hero::IconComponent} constructor (e.g. `variant: :outline`).
      #
      # @option kws right_icon_html [Hash] Additional HTML attributes to apply to
      #   the right icon.
      #
      def _initialize_iconable_component
        @icon = config_option(:icon)
        @icon_css = config_option(:icon_css, default_icon_size)
        @icon_options = config_option(:icon_options, {})
        @icon_html = config_option(:icon_html, {})
        @icon_library = config_option(:icon_library, LocoMotion.configuration.default_icon_library)
        @icon_variant = config_option(:icon_variant, LocoMotion.configuration.default_icon_variant)

        @left_icon = config_option(:left_icon, @icon)
        @left_icon_css = config_option(:left_icon_css, @icon_css)
        @left_icon_options = config_option(:left_icon_options, @icon_options)
        @left_icon_html = config_option(:left_icon_html, @icon_html)
        @left_icon_library = config_option(:left_icon_library, @icon_library)
        @left_icon_variant = config_option(:left_icon_variant, @icon_variant)

        @right_icon = config_option(:right_icon)
        @right_icon_css = config_option(:right_icon_css, @icon_css)
        @right_icon_options = config_option(:right_icon_options, {})
        @right_icon_html = config_option(:right_icon_html, @icon_html)
        @right_icon_library = config_option(:right_icon_library, @icon_library)
        @right_icon_variant = config_option(:right_icon_variant, @icon_variant)
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
      # Renders the left icon as a Hero::IconComponent instance.
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

      # The library whose icons LocoMotion still renders via rails_heroicon.
      HEROICONS_LIBRARY = "heroicons"

      #
      # Renders the `:left` or `:right` icon, picking the backend by library.
      # The default Heroicons library renders through `hero_icon`
      # (rails_heroicon) so it works without the consumer syncing any icons;
      # every other library renders through the `loco_icon` engine, which
      # resolves from the app's synced `app/assets/svg/icons`.
      #
      # NOTE: The Heroicons branch is transitional. Once Heroicons are synced /
      # vendored like every other library and `rails_heroicon` is removed, this
      # collapses to a single `loco_icon` call.
      #
      def render_managed_icon(side)
        ref = LocoMotion::Icons::Reference.parse(
          instance_variable_get("@#{side}_icon"),
          default_library: instance_variable_get("@#{side}_icon_library"),
          default_variant: instance_variable_get("@#{side}_icon_variant")
        )
        options = instance_variable_get("@#{side}_icon_options") || {}

        shared = {
          css: non_shrinking_icon_css(instance_variable_get("@#{side}_icon_css")),
          html: instance_variable_get("@#{side}_icon_html"),
          variant: ref[:variant]
        }.merge(options)

        if ref[:library].to_s == HEROICONS_LIBRARY
          hero_icon(ref[:name], **shared)
        else
          loco_icon(ref[:name], library: ref[:library], **shared)
        end
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
