# frozen_string_literal: true

#
# The Checkbox component renders a DaisyUI styled checkbox input.
# It can be used standalone or with a form builder, and supports various styling
# options including toggle mode for switch-like appearance.
#
# @part label_wrapper The wrapper element for labels (when using
#   start/end/floating labels).
# @part start The element that contains the start label (appears before the
#   checkbox).
# @part end The element that contains the end label (appears after the checkbox).
#
# @slot start Custom content for the start label.
# @slot end Custom content for the end label.
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
# @loco_example With End Label (common for checkboxes)
#   = daisy_checkbox(name: "terms", id: "terms", end: "I agree to the terms and conditions")
#
class Daisy::DataInput::CheckboxComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::LabelableComponent

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
    super

    setup_labels
    setup_component
  end

  def setup_labels
    add_css(:label_wrapper, "label") if has_any_label?
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
end
