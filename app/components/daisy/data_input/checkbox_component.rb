# frozen_string_literal: true

#
# The Checkbox component renders a DaisyUI styled checkbox input.
# It can be used standalone or with a form builder, and supports various styling
# options including toggle mode for switch-like appearance.
#
# @loco_example Basic Usage
#   = daisy_checkbox(name: "accept", id: "accept")
#
# @loco_example Checked Checkbox
#   = daisy_checkbox(name: "accept", id: "accept", checked: true)
#
# @loco_example Toggle Checkbox
#   = daisy_checkbox(name: "accept", id: "accept", toggle: true)
#
# @loco_example Disabled Checkbox
#   = daisy_checkbox(name: "accept", id: "accept", disabled: true)
#
class Daisy::DataInput::CheckboxComponent < LocoMotion::BaseComponent
  attr_reader :name, :id, :value, :checked, :toggle, :disabled, :required

  #
  # Instantiate a new Checkbox component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the checkbox input.
  #
  # @option kws id [String] The ID attribute for the checkbox input.
  #
  # @option kws value [String] The value attribute for the checkbox input.
  #   Defaults to "1".
  #
  # @option kws checked [Boolean] Whether the checkbox is checked. Defaults to
  #   false.
  #
  # @option kws toggle [Boolean] Whether the checkbox should be styled as a
  #   toggle switch. Defaults to false.
  #
  # @option kws disabled [Boolean] Whether the checkbox is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the checkbox is required for form
  #   validation. Defaults to false.
  #
  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value, "1")
    @checked = config_option(:checked, false)
    @toggle = config_option(:toggle, false)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    setup_component
  end

  #
  # Sets up the component by configuring the tag name, CSS classes, and HTML
  # attributes.
  #
  def setup_component
    set_tag_name(:component, :input)

    add_css(:component, @toggle ? "toggle" : "checkbox")

    add_html(:component, {
      type: "checkbox",
      name: @name,
      id: @id,
      value: @value,
      checked: @checked,
      disabled: @disabled,
      required: @required
    })
  end

  #
  # Renders the component inline with no additional whitespace.
  #
  def call
    part(:component)
  end
end
