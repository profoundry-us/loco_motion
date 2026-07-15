# frozen_string_literal: true

module LocoMotion
  #
  # The BasicComponent class is used for all slots that don't provide a
  # component so that users can pass in all of the same CSS and HTML options
  # that a standard component would have.
  #
  class BasicComponent < LocoMotion::BaseComponent
    # Renders the component's root part, yielding the block content into it.
    def call
      part(:component) do
        content
      end
    end

    # Hard-coded so ViewComponent's template/sidecar lookup keeps resolving
    # to BasicComponent's own view when this class is used as the default
    # component for slots that don't specify one.
    def self.name
      "BasicComponent"
    end
  end
end
