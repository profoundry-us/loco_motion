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

      def initialize(*instance_args, **instance_kws, &instance_block)
        super(*instance_args, **instance_kws, &instance_block)

        @start = config_option(:start)
        @end = config_option(:end)
        @floating = config_option(:floating)
      end

      def before_render
        super

        set_tag_name(:label_wrapper, :label)

        if has_floating_label?
          add_css(:label_wrapper, "floating-label")
        else
          add_css(:label_wrapper, "label")
        end

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
