# frozen_string_literal: true

#
# The Radio Button component renders a DaisyUI styled radio button input.
# It can be used standalone or with a form builder, and is ideal for creating
# option groups where users must select exactly one choice.
#
# @part label_wrapper The wrapper element for labels (when using
#   start/end/floating labels).
# @part start The element that contains the start label (appears before the
#   radio button).
# @part end The element that contains the end label (appears after the radio
#   button).
#
# @slot start Custom content for the start label.
# @slot end Custom content for the end label.
#
# @loco_example Basic Usage
#   = daisy_radio(name: "option", id: "option1", value: "1")
#
# @loco_example Checked Radio Button
#   = daisy_radio(name: "option", id: "option2", value: "2", checked: true)
#
# @loco_example Disabled Radio Button
#   = daisy_radio(name: "option", id: "option3", value: "3", disabled: true)
#
# @loco_example With Start Label
#   = daisy_radio(name: "option", id: "option1", value: "1", start: "Option:")
#
# @loco_example With End Label (common for radio buttons)
#   = daisy_radio(name: "option", id: "option1", value: "1", end: "Option 1")
#
# @loco_example With Custom Start Content
#   = daisy_radio(name: "option", id: "option1", value: "1") do |radio|
#     - radio.with_start do
#       %span.text-primary Option:
#
# @loco_example With Custom End Content
#   = daisy_radio(name: "option", id: "option1", value: "1") do |radio|
#     - radio.with_end do
#       %span.text-secondary Option 1
#
class Daisy::DataInput::RadioButtonComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::LabelableComponent
  include LocoMotion::Concerns::AriableComponent

  set_component_name :radio

  attr_reader :name, :id, :value, :checked, :disabled, :required

  #
  # Instantiate a new Radio Button component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the radio button input.
  #
  # @option kws id [String] The ID attribute for the radio button input.
  #
  # @option kws value [String] The value attribute for the radio button input.
  #
  # @option kws checked [Boolean] Whether the radio button is checked. Defaults to
  #   false.
  #
  # @option kws disabled [Boolean] Whether the radio button is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the radio button is required for form
  #   validation. Defaults to false.
  #
  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value)
    @checked = config_option(:checked, false)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    super

    setup_labels
    setup_component
  end

  def setup_labels
    add_css(:label_wrapper, "label") if has_any_label?
  end

  #
  # Sets up the component by configuring the tag name, CSS classes, and HTML
  # attributes. Sets the tag to input with type 'radio' and adds the 'radio' CSS class.
  #
  # This configures the name, id, value, disabled state, required state, and
  # checked state of the radio button.
  #
  def setup_component
    set_tag_name(:component, :input)

    add_css(:component, "radio") unless @skip_styling

    add_html(:component, {
      type: "radio",
      name: @name,
      id: @id,
      value: @value,
      checked: @checked,
      disabled: @disabled,
      required: @required
    })
  end

end
