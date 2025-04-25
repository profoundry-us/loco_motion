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
      # @option kws icon       [String] The name of Hero icon to render. This is an
      #   alias of `left_icon`.
      #
      # @option kws icon_css   [String] The CSS classes to apply to the icon. This
      #   is an alias of `left_icon_css`.
      #
      # @option kws icon_html  [Hash] Additional HTML attributes to apply to the
      #   icon. This is an alias of `left_icon_html`.
      #
      # @option kws left_icon  [String] The name of Hero icon to render to the
      #   left of the content.
      #
      # @option kws left_icon_css  [String] The CSS classes to apply to the left
      #   icon.
      #
      # @option kws left_icon_html [Hash] Additional HTML attributes to apply to
      #   the left icon.
      #
      # @option kws right_icon [String] The name of Hero icon to render to the
      #   right of the content.
      #
      # @option kws right_icon_css [String] The CSS classes to apply to the right
      #   icon.
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
        @left_icon_options = config_option(:left_icon_options, @icon_html)
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
        if @icon || @left_icon || @right_icon
          add_css(:component, "where:inline-flex where:items-center where:gap-2")
        end
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
        return unless @left_icon.present?

        hero_icon(@left_icon, css: @left_icon_css, html: @left_icon_html, **@left_icon_options)
      end
      alias_method :render_icon, :render_left_icon

      #
      # Renders the right icon using a hero icon.
      #
      # @return [String] The rendered HTML for the icon
      #
      def render_right_icon
        return unless @right_icon.present?

        hero_icon(@right_icon, css: @right_icon_css, html: @right_icon_html, **@right_icon_options)
      end
    end
  end
end
