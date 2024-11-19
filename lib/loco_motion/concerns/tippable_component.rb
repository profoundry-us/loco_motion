module LocoMotion
  module Concerns
    #
    # Can be included in relevant components to allow a new `tip` attibute that
    # automatically adds the `tooltip` CSS class and the `data-tip` attribute
    # to the component.
    #
    module TippableComponent
      #
      # Calls the parent `before_render`. Then adds the `tooltip` CSS class and
      # the `data-tip` attribute to the component if the `tip` attribute is
      # present.
      #
      def before_render
        super

        tip = config_option(:tip)

        if tip
          add_css(:component, "tooltip")
          add_html(:component, { data: { tip: tip } })
        end
      end
    end
  end
end
