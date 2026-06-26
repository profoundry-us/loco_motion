# frozen_string_literal: true

require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # Include this module to enable link functionality in a component.
    # When an href is provided, the component will render as an <a> tag.
    #
    # Also pulls in {TurboableComponent} so every linkable component gains the
    # `turbo_frame`, `turbo_method`, and `turbo_confirm` options for free —
    # those Turbo data attributes only make sense on link/button elements.
    #
    module LinkableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.include(LocoMotion::Concerns::TurboableComponent)

        base.register_component_initializer(:_initialize_linkable_component)
        base.register_component_setup(:_setup_linkable_component)
      end

      protected

      #
      # Initialize link-related options.
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
