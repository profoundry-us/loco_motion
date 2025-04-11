module LocoMotion
  module Concerns
    #
    # Can be included in relevant components to allow a new `tip` attibute that
    # automatically adds the `tooltip` CSS class and the `data-tip` attribute
    # to the component.
    #
    module TippableComponent
      #
      # Initialize tooltip-related options.
      #
      # @option kws tip [String] The tooltip text to display when hovering
      #
      def initialize_tippable_component
        @tip = config_option(:tip)
      end

      #
      # Configure tooltip functionality for the component.
      # Adds the `tooltip` CSS class and the `data-tip` attribute if a tip is provided.
      #
      def setup_tippable_component
        if @tip
          add_css(:component, "tooltip")
          add_html(:component, { data: { tip: @tip } })
        end
      end
    end
  end
end
