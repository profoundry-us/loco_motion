# frozen_string_literal: true

#
# The TextArea component renders a DaisyUI styled textarea field.
# It can be used standalone or with a form builder, and supports
# various styling options and states.
#
# @note Text areas have a border by default. Use `textarea-ghost` to remove the
#   border.
#
# @part component The main textarea element that users can type into.
#
# @loco_example Basic Usage
#   = daisy_text_area(name: "message", id: "message")
#
# @loco_example With Placeholder
#   = daisy_text_area(name: "message", placeholder: "Enter your message here...")
#
# @loco_example With Initial Value
#   = daisy_text_area(name: "message", value: "Initial text content")
#
# @loco_example With Specified Rows
#   = daisy_text_area(name: "message", rows: 6)
#
# @loco_example Borderless Style
#   = daisy_text_area(name: "message", css: "textarea-ghost")
#
# @loco_example Different Colors
#   .flex.flex-col.gap-4
#     = daisy_text_area(name: "primary", placeholder: "Primary", css: "textarea-primary")
#     = daisy_text_area(name: "secondary", placeholder: "Secondary", css: "textarea-secondary")
#     = daisy_text_area(name: "accent", placeholder: "Accent", css: "textarea-accent")
#
# @loco_example Disabled TextArea
#   = daisy_text_area(name: "message", disabled: true)
#
# @loco_example Required TextArea
#   = daisy_text_area(name: "message", required: true)
#
# @loco_example Readonly TextArea
#   = daisy_text_area(name: "message", readonly: true, value: "This content cannot be edited.")
#
class Daisy::DataInput::TextAreaComponent < LocoMotion::BaseComponent
  attr_reader :name, :id, :value, :placeholder, :rows, :cols, :disabled, :required, :readonly

  #
  # Instantiate a new TextArea component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the textarea.
  #
  # @option kws id [String] The ID attribute for the textarea.
  #
  # @option kws value [String] The initial value of the textarea.
  #
  # @option kws placeholder [String] Placeholder text for the textarea.
  #
  # @option kws rows [Integer] The number of visible text lines. Defaults to 4.
  #
  # @option kws cols [Integer] The visible width of the textarea. Defaults to nil.
  #
  # @option kws disabled [Boolean] Whether the textarea is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the textarea is required for form
  #   validation. Defaults to false.
  #
  # @option kws readonly [Boolean] Whether the textarea is read-only. Defaults to
  #   false.
  #
  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value, nil)
    @placeholder = config_option(:placeholder, nil)
    @rows = config_option(:rows, 4)
    @cols = config_option(:cols, nil)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
    @readonly = config_option(:readonly, false)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    setup_component
  end

  #
  # Sets up the component by configuring the tag name, CSS classes, and HTML
  # attributes. Sets the tag to textarea and adds the 'textarea' CSS class.
  #
  # This configures various attributes of the textarea including name, id, value,
  # placeholder, rows, cols, and states like disabled, required, and readonly.
  #
  def setup_component
    set_tag_name(:component, :textarea)

    add_css(:component, "textarea")

    add_html(:component, {
      name: @name,
      id: @id,
      placeholder: @placeholder,
      rows: @rows,
      cols: @cols,
      disabled: @disabled,
      required: @required,
      readonly: @readonly
    })
  end

  #
  # Renders the component with its value as content.
  #
  def call
    if @value
      part(:component) { @value }
    else
      part(:component)
    end
  end
end
