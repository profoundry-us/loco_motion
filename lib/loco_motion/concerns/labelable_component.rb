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

      # Warns about the deprecated `start` / `end` labelable API (renamed to
      # `leading` / `trailing` because `end` is a Ruby reserved word).
      DEPRECATOR = ActiveSupport::Deprecation.new("1.0", "LocoMotion")

      # Legacy keyword arguments and the `leading` / `trailing` options they
      # translate to.
      LEGACY_OPTION_MAP = {
        start: :leading,
        end: :trailing,
        start_css: :leading_css,
        end_css: :trailing_css,
        start_html: :leading_html,
        end_html: :trailing_html,
        start_aria: :leading_aria,
        end_aria: :trailing_aria,
        start_data: :leading_data,
        end_data: :trailing_data
      }.freeze

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
      # Legacy `start` / `end` options (and their `_css` / `_html` / `_aria` /
      # `_data` variants) are translated to `leading` / `trailing` with a
      # deprecation warning.
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
        LEGACY_OPTION_MAP.each do |legacy_key, new_key|
          next unless instance_kws.key?(legacy_key)

          DEPRECATOR.warn(
            "The `#{legacy_key}:` option is deprecated; use `#{new_key}:` " \
            "instead."
          )
          legacy_value = instance_kws.delete(legacy_key)
          instance_kws[new_key] = legacy_value unless instance_kws.key?(new_key)
        end

        super(*instance_args, **instance_kws, &instance_block)

        @floating_placeholder = config_option(:floating_placeholder)

        @leading = config_option(:leading)
        @trailing = config_option(:trailing)
        @floating = config_option(:floating, @floating_placeholder)
        @placeholder = config_option(:placeholder, @floating_placeholder)
      end

      #
      # Deprecated alias of `with_leading`.
      #
      def with_start(*args, **kws, &block)
        DEPRECATOR.warn("`with_start` is deprecated; use `with_leading` instead.")
        with_leading(*args, **kws, &block)
      end

      #
      # Deprecated alias of `with_trailing`.
      #
      def with_end(*args, **kws, &block)
        DEPRECATOR.warn("`with_end` is deprecated; use `with_trailing` instead.")
        with_trailing(*args, **kws, &block)
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
      # Deprecated alias of `has_leading_label?`.
      #
      def has_start_label?
        DEPRECATOR.warn("`has_start_label?` is deprecated; use `has_leading_label?` instead.")
        has_leading_label?
      end

      #
      # Deprecated alias of `has_trailing_label?`.
      #
      def has_end_label?
        DEPRECATOR.warn("`has_end_label?` is deprecated; use `has_trailing_label?` instead.")
        has_trailing_label?
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
