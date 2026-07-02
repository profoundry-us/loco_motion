# frozen_string_literal: true

module LocoMotion
  module Concerns
    #
    # Can be included in relevant components to add labeling functionality.
    # This adds support for leading, trailing, and floating labels that can
    # either be provided as plain text or customized via slots.
    #
    # @loco_example Basic usage with a leading label
    #   class MyInputComponent < LocoMotion::BaseComponent
    #     include LocoMotion::Concerns::LabelableComponent
    #     # component implementation ...
    #   end
    #
    #   = daisy_my_input(name: "username", leading: "Username")
    #
    # @loco_example With a trailing label (useful for checkboxes/radios)
    #   = daisy_checkbox(name: "terms", trailing: "I agree to the terms")
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
        define_parts :label_wrapper, :leading, :trailing, :floating

        renders_one :leading
        renders_one :trailing
        renders_one :floating

        # NOTE: We DO NOT define attr_reader properties here because it can
        # cause confusion / problems with the parts and slots.
      end

      #
      # Initializes the component and sets up the label options.
      #
      # @param instance_args [Array] Positional arguments passed to the component
      #
      # @param instance_kws [Hash] Keyword arguments passed to the component
      #
      # @option instance_kws [String, nil] :leading Text to display in the
      #   leading label position (before the input)
      #
      # @option instance_kws [String, nil] :trailing Text to display in the
      #   trailing label position (after the input)
      #
      # @option instance_kws [String, nil] :floating Text to display in the
      #   floating label position
      #
      # @option instance_kws [String, nil] :placeholder The input's placeholder
      #   text.  If not provided and `floating_placeholder` is set, it will use
      #   that value.
      #
      # @option instance_kws [String, nil] :floating_placeholder Text to use for
      #   both the floating label and the input placeholder. This is a
      #   convenience option that sets both the `floating` and `placeholder`
      #   options to the same value. Both `floating` and `placeholder` take
      #   precedence over `floating_placeholder`.
      #
      # @param instance_block [Proc] Block passed to the component for rendering
      #   custom content
      #
      def initialize(*instance_args, **instance_kws, &instance_block)
        super(*instance_args, **instance_kws, &instance_block)

        @floating_placeholder = config_option(:floating_placeholder)

        @leading = config_option(:leading)
        @trailing = config_option(:trailing)
        @floating = config_option(:floating, @floating_placeholder)
        @placeholder = config_option(:placeholder, @floating_placeholder)
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
        set_tag_name(:leading, :span)
        set_tag_name(:trailing, :span)
        set_tag_name(:floating, :span)
      end

      #
      # Checks if any type of label is present.
      #
      # @return [Boolean] true if any label is present, false otherwise
      #
      def has_any_label?
        has_leading_label? || has_trailing_label? || has_floating_label?
      end

      #
      # Checks if a leading label is present.
      #
      # @return [Boolean] true if leading label is present, false otherwise
      #
      def has_leading_label?
        leading? || @leading || config_option(:leading).present?
      end

      #
      # Checks if a trailing label is present.
      #
      # @return [Boolean] true if trailing label is present, false otherwise
      #
      def has_trailing_label?
        trailing? || @trailing || config_option(:trailing).present?
      end

      #
      # Checks if a floating label is present.
      #
      # @return [Boolean] true if floating label is present, false otherwise
      #
      def has_floating_label?
        floating? || @floating || config_option(:floating).present?
      end
    end
  end
end
