# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The Status component displays a small icon to visually show the current
    # status of an element, such as online, offline, error, etc. It follows
    # the DaisyUI status component pattern.
    #
    # Includes the {LocoMotion::Concerns::TippableComponent} module to enable
    # easy tooltip addition.
    #
    # @loco_example Basic Status
    #   = daisy_status()
    #
    # @loco_example Status with Size
    #   = daisy_status(css: "status-xs")
    #   = daisy_status(css: "status-sm")
    #   = daisy_status(css: "status-md")
    #   = daisy_status(css: "status-lg")
    #   = daisy_status(css: "status-xl")
    #
    # @loco_example Status with Color
    #   = daisy_status(css: "status-primary")
    #   = daisy_status(css: "status-secondary")
    #   = daisy_status(css: "status-accent")
    #   = daisy_status(css: "status-info")
    #   = daisy_status(css: "status-success")
    #   = daisy_status(css: "status-warning")
    #   = daisy_status(css: "status-error")
    #
    # @loco_example Status with Accessibility
    #   = daisy_status(css: "status-success", html: { aria: { label: "Status: Online" } })
    class StatusComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::TippableComponent

      #
      # Creates a new status component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws [String] :tip The tooltip text to display when hovering
      #   over the component.
      #
      # rubocop:disable Lint/UselessMethodDefinition
      def initialize(**kws, &block)
        super
      end
      # rubocop:enable Lint/UselessMethodDefinition

      def before_render
        setup_component
        super # Call super after setup
      end

      def call
        part(:component)
      end

      private

      def setup_component
        add_css(:component, "status")
      end
    end
  end
end
