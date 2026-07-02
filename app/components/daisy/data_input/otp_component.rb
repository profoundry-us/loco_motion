# frozen_string_literal: true

#
# The OTP component renders a DaisyUI styled input for one-time passwords —
# the 4-6 digit verification codes used in two-factor authentication and
# passwordless login flows. It draws one character box per digit while backing
# them with a single `<input>`, so the value submits like any other form
# field and no JavaScript is required.
#
# The wrapper is a `<label>`, so clicking anywhere on the boxes focuses the
# underlying input. The input is rendered with `inputmode="numeric"` (mobile
# numeric keypad), `autocomplete="one-time-code"` (OS auto-fill from SMS), and
# a `maxlength` / `pattern` matching the digit count.
#
# @note DaisyUI sizes the boxes for up to 8 digits, so `length` must be
#   between 1 and 8.
#
# @part digit The `<span>` character boxes; one is rendered per digit. Style
#   them all via `digit_css`.
# @part input The single underlying `<input>` element.
#
# @loco_example Basic Usage
#   = daisy_otp(name: "verification_code")
#
# @loco_example 6-Digit Code
#   = daisy_otp(name: "verification_code", length: 6)
#
# @loco_example Joined Boxes
#   = daisy_otp(name: "pin", css: "otp-joined")
#
# @loco_example Colors & Sizes
#   = daisy_otp(name: "code", css: "otp-primary otp-lg")
#
# @loco_example Required in a Form
#   = daisy_fieldset do |fieldset|
#     - fieldset.with_legend { "Enter Verification Code" }
#     = daisy_otp(name: "otp_code", length: 6, required: true)
#
module Daisy
  module DataInput
    class OtpComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::AriableComponent

      # The largest digit count DaisyUI's `otp` CSS can lay out.
      MAX_LENGTH = 8

      define_parts :digit, :input

      attr_reader :length, :name, :id, :value, :required

      #
      # Instantiate a new OTP component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws length [Integer] The number of digits in the code, from 1
      #   to 8. Also sets the input's `maxlength` and `pattern` (`\d{length}`)
      #   attributes. Defaults to 4.
      #
      # @option kws name [String] The name attribute for the underlying input.
      #
      # @option kws id [String] The ID attribute for the underlying input.
      #
      # @option kws value [String] An optional pre-filled value for the input.
      #
      # @option kws required [Boolean] Whether the input is required for form
      #   validation. Defaults to false.
      #
      def initialize(**kws)
        super

        @length = config_option(:length, 4)
        @name = config_option(:name)
        @id = config_option(:id)
        @value = config_option(:value, nil)
        @required = config_option(:required, false)

        return if (1..MAX_LENGTH).cover?(@length)

        raise ArgumentError,
              "daisy_otp length must be between 1 and #{MAX_LENGTH} " \
              "(got #{@length.inspect})."
      end

      #
      # Calls the {setup_component} method before rendering the component.
      #
      def before_render
        super

        setup_component
      end

      #
      # Sets up the wrapper `<label>`, the digit `<span>` boxes, and the
      # underlying `<input>` with its numeric / one-time-code attributes.
      #
      # The digit spans must precede the input: DaisyUI positions and sizes
      # the boxes with `nth-child` selectors that count every child of the
      # wrapper.
      #
      def setup_component
        set_tag_name(:component, :label)
        add_css(:component, "otp")

        set_tag_name(:digit, :span)

        set_tag_name(:input, :input)
        add_html(:input, {
                   type: "text",
                   inputmode: "numeric",
                   autocomplete: "one-time-code",
                   maxlength: @length,
                   pattern: "\\d{#{@length}}",
                   name: @name,
                   id: @id,
                   value: @value,
                   required: @required
                 })
      end
    end
  end
end
