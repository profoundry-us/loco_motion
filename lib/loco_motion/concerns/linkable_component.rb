# frozen_string_literal: true

require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # Include this module to enable link functionality in a component.
    # When an href is provided, the component will render as an <a> tag.
    #
    # Also pulls in {TurboableComponent} and {ActionableComponent} so every
    # linkable component gains the `turbo_frame`, `turbo_method`,
    # `turbo_confirm`, and `action` options for free — those Turbo and Stimulus
    # data attributes only make sense on link/button elements.
    #
    module LinkableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.include(LocoMotion::Concerns::TurboableComponent)
        base.include(LocoMotion::Concerns::ActionableComponent)

        base.register_component_initializer(:_initialize_linkable_component)
        base.register_component_setup(:_setup_linkable_component)
      end

      protected

      #
      # Initialize link-related options.
      #
      # @option kws href [String] The URL to link to. When present, the
      #   component's tag switches to `<a>` and this becomes its `href`
      #   attribute; when absent, the component renders as normal and none
      #   of this concern's other options have any effect.
      #
      # @option kws target [String] The HTML `target` attribute for the
      #   `<a>` tag (e.g. `"_blank"`). Only applied when `href` is present.
      #
      # @option kws title [String] The HTML `title` attribute for the
      #   `<a>` tag. Only applied when `href` is present.
      #
      def _initialize_linkable_component
        @href = config_option(:href)
        @target = config_option(:target)
        @title = config_option(:title)
      end

      #
      # Sets the component's tag to <a> if an href is provided and configures the
      # appropriate HTML attributes.
      #
      def _setup_linkable_component
        return unless @href

        set_tag_name(:component, :a)
        add_html(:component, { href: @href, target: @target, title: @title })
      end
    end
  end
end
