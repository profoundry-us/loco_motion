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
    #   = daisy_my_input(name: "username", start_label: "Username")
    #
    # @loco_example With an end label (useful for checkboxes/radios)
    #   = daisy_checkbox(name: "terms", end_label: "I agree to the terms")
    #
    # @loco_example With a floating label
    #   = daisy_text_input(name: "email", floating_label: "Email Address")
    #
    # @loco_example Using a custom slot for the label
    #   = daisy_text_input(name: "password") do |input|
    #     - input.with_floating_label do
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
        define_parts :label_wrapper, :start_label, :end_label, :floating_label

        renders_one :start_label
        renders_one :end_label
        renders_one :floating_label
      end

      def initialize(*instance_args, **instance_kws, &instance_block)
        super(*instance_args, **instance_kws, &instance_block)

        @start_label = config_option(:start_label)
        @end_label = config_option(:end_label)
        @floating_label = config_option(:floating_label)
      end

      def before_render
        super

        set_tag_name(:label_wrapper, :label)
        add_css(:label_wrapper, "label")

        set_tag_name(:start_label, :span)
        set_tag_name(:end_label, :span)
        set_tag_name(:floating_label, :span)
      end

      #
      # Checks if any type of label is present.
      #
      # @return [Boolean] true if any label is present, false otherwise
      #
      def has_any_label?
        start_label? ||
        end_label? ||
        floating_label? ||
        config_option(:start_label).present? ||
        config_option(:end_label).present? ||
        config_option(:floating_label).present?
      end
    end
  end
end
