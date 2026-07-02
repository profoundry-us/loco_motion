# frozen_string_literal: true

#
# The TextInput component renders a DaisyUI styled text input field.
# It can be used standalone or with a form builder, and supports
# various styling options including different types, sizes and variants.
#
# @note Input fields have a border by default and a width of 20rem. Use
#   `input-ghost` to remove the border.
#
# @part label_wrapper The wrapper element for labels (when using
#   leading/trailing/floating labels).
# @part leading The element that contains the leading label (appears before
#   the input).
# @part trailing The element that contains the trailing label (appears after
#   the input).
# @part floating The element that contains the floating label (appears floating
#   above the input).
#
# @slot leading Content to display before the input field.
# @slot trailing Content to display after the input field.
# @slot floating Custom content for the floating label.
#
# @loco_example Basic Usage
#   = daisy_text_input(name: "username", id: "username")
#
# @loco_example With Placeholder
#   = daisy_text_input(name: "email", id: "email", placeholder: "Enter your email")
#
# @loco_example Ghost Style (No Border)
#   = daisy_text_input(name: "search", id: "search", css: "input-ghost")
#
# @loco_example Different Types
#   = daisy_text_input(name: "password", id: "password", type: "password")
#   = daisy_text_input(name: "email", id: "email", type: "email")
#
# @loco_example With Leading Label
#   = daisy_text_input(name: "username", id: "username", leading: "Username:")
#
# @loco_example With Trailing Label
#   = daisy_text_input(name: "email", id: "email", trailing: "@example.com")
#
# @loco_example With Floating Label
#   = daisy_text_input(name: "username", id: "username", floating: "Username")
#
# @loco_example With Icons
#   = daisy_text_input(name: "search", placeholder: "Search...") do |text_input|
#     - text_input.with_leading do
#       = loco_icon("magnifying-glass", css: "size-5 text-gray-400")
#
# @loco_example With Leading and Trailing Content
#   = daisy_text_input(name: "email", placeholder: "Email address") do |text_input|
#     - text_input.with_leading do
#       = loco_icon("envelope", css: "size-5 text-gray-400")
#     - text_input.with_trailing do
#       = daisy_button(title: "Verify", css: "h-full rounded-l-none")
#
# @loco_example Disabled Text Input
#   = daisy_text_input(name: "username", id: "username", disabled: true)
#
module Daisy
  module DataInput
    class TextInputComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::LabelableComponent
      include LocoMotion::Concerns::AriableComponent

      attr_reader :name, :id, :value, :type, :disabled, :required, :readonly

      #
      # Instantiate a new TextInput component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws name [String] The name attribute for the text input.
      #
      # @option kws id [String] The ID attribute for the text input.
      #
      # @option kws value [String] The initial value of the text input.
      #
      # @option kws type [String] The type of input (text, password, email, etc.).
      #   Defaults to "text".
      #
      # @option kws disabled [Boolean] Whether the text input is disabled. Defaults to
      #   false.
      #
      # @option kws required [Boolean] Whether the text input is required for form
      #   validation. Defaults to false.
      #
      # @option kws readonly [Boolean] Whether the text input is read-only. Defaults to
      #   false.
      #
      def initialize(**kws)
        super

        @name = config_option(:name)
        @id = config_option(:id)
        @value = config_option(:value, nil)
        @type = config_option(:type, "text")
        @disabled = config_option(:disabled, false)
        @required = config_option(:required, false)
        @readonly = config_option(:readonly, false)
        @change = config_option(:change)
      end

      #
      # Calls the {setup_component} method before rendering the component.
      #
      def before_render
        super

        setup_component
      end

      #
      # Sets up the component by configuring the tag name, CSS classes, and HTML
      # attributes. Sets the tag to input with appropriate type and adds the 'input'
      # CSS class.
      #
      # This configures various attributes of the text input including name, id, value,
      # placeholder, type, and states like disabled, required, and readonly.
      #
      def setup_component
        set_tag_name(:component, :input)

        if has_floating_label?
          add_css(:label_wrapper, "floating-label input")
        elsif has_leading_label? || has_trailing_label?
          add_css(:label_wrapper, "input")
        else
          add_css(:component, "input")
        end

        add_html(:component, {
                   type: @type,
                   name: @name,
                   id: @id,
                   value: @value,
                   placeholder: @placeholder,
                   disabled: @disabled,
                   required: @required,
                   readonly: @readonly
                 })

        add_html(:component, { onchange: "document.getElementById('#{@change}').value = this.value" }) if @change
      end
    end
  end
end
