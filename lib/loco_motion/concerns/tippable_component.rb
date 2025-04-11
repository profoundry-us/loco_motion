require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # Can be included in relevant components to allow a `tip` attribute that
    # automatically adds the `tooltip` CSS class and the `data-tip` attribute
    # to the component.
    #
    module TippableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.register_component_initializer(:_initialize_tippable_component)
        base.register_component_setup(:_setup_tippable_component)
      end

      protected

      #
      # Initialize tooltip-related options.
      #
      # @option kws tip [String] The tooltip text to display when hovering
      #
      def _initialize_tippable_component
        @tip = config_option(:tip)
      end

      #
      # Configure tooltip functionality for the component.
      # Adds the `tooltip` CSS class and the `data-tip` attribute if a tip is provided.
      #
      def _setup_tippable_component
        if @tip
          add_css(:component, "tooltip")
          add_html(:component, { data: { tip: @tip } })
        end
      end
    end
  end
end
