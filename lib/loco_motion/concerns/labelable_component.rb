# frozen_string_literal: true

module LocoMotion
  module Concerns
    #
    # Can be included in relevant components to add labeling functionality.
    # This adds support for start, end, and floating labels that can either be
    # provided as plain text or customized via slots.
    #
    # @loco_example Basic usage with a start label
    #   class MyInputComponent < LocoMotion::BaseComponent
    #     include LocoMotion::Concerns::LabelableComponent
    #     # component implementation ...
    #   end
    #
    #   = daisy_my_input(name: "username", start: "Username")
    #
    # @loco_example With an end label (useful for checkboxes/radios)
    #   = daisy_checkbox(name: "terms", end: "I agree to the terms")
    #
    # @loco_example With a floating label
    #   = daisy_text_input(name: "email", floating: "Email Address")
    #
    # @loco_example Using a custom slot for the label
    #   = daisy_text_input(name: "password") do |input|
    #     - input.with_floating do
    #       Password
    #       %span.text-red-500 *
    #
    module LabelableComponent
      extend ActiveSupport::Concern

      #
      # Called when the module is included in a component class.
      # Sets up the necessary parts & slots for custom label content.
      #
      included do
        define_parts :label_wrapper, :start, :end, :floating

        renders_one :start
        renders_one :end
        renders_one :floating
      end

      #
      # Initializes the component and sets up the label options.
      #
      # @param instance_args [Array] Positional arguments passed to the component
      #
      # @param instance_kws [Hash] Keyword arguments passed to the component
      #
      # @option instance_kws [String, nil] :start Text to display in the start
      #   label position
      #
      # @option instance_kws [String, nil] :end Text to display in the end
      #   label position
      #
      # @option instance_kws [String, nil] :floating Text to display in the
      #   floating label position
      #
      # @param instance_block [Proc] Block passed to the component for rendering
      #   custom content
      #
      def initialize(*instance_args, **instance_kws, &instance_block)
        super(*instance_args, **instance_kws, &instance_block)

        @start = config_option(:start)
        @end = config_option(:end)
        @floating = config_option(:floating)
      end

      #
      # Sets up the tag names for the label parts before rendering the component.
      # This method is called automatically during the component rendering
      # lifecycle.
      #
      # Note that CSS classes for labels must be handled by the implementing
      # component since requirements differ for each type of input component.
      #
      def before_render
        super

        set_tag_name(:label_wrapper, :label)
        set_tag_name(:start, :span)
        set_tag_name(:end, :span)
        set_tag_name(:floating, :span)
      end

      #
      # Checks if any type of label is present.
      #
      # @return [Boolean] true if any label is present, false otherwise
      #
      def has_any_label?
        has_start_label? || has_end_label? || has_floating_label?
      end

      #
      # Checks if a start label is present.
      #
      # @return [Boolean] true if start label is present, false otherwise
      #
      def has_start_label?
        start? || config_option(:start).present?
      end

      #
      # Checks if an end label is present.
      #
      # @return [Boolean] true if end label is present, false otherwise
      #
      def has_end_label?
        end? || config_option(:end).present?
      end

      #
      # Checks if a floating label is present.
      #
      # @return [Boolean] true if floating label is present, false otherwise
      #
      def has_floating_label?
        floating? || config_option(:floating).present?
      end
    end
  end
end
