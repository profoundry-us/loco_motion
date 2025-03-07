# frozen_string_literal: true

#
# The Range component renders a DaisyUI styled range input slider.
# It can be used standalone or with a form builder, and supports customization
# of min/max values, step increments, and color variants.
#
# @loco_example Basic Usage
#   = daisy_range(name: "volume", id: "volume", min: 0, max: 100, value: 50)
#
# @loco_example Range with Steps
#   = daisy_range(name: "step_range", id: "step_range", min: 0, max: 100, step: 25)
#
# @loco_example Range with Different Colors
#   = daisy_range(name: "primary_range", id: "primary_range", css: "range-primary")
#   = daisy_range(name: "error_range", id: "error_range", css: "range-error")
#
class Daisy::DataInput::RangeComponent < LocoMotion::BaseComponent
  attr_reader :name, :id, :min, :max, :step, :value, :disabled, :required

  #
  # Instantiate a new Range component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the range input.
  #
  # @option kws id [String] The ID attribute for the range input.
  #
  # @option kws min [Integer] The minimum value (default: 0).
  #
  # @option kws max [Integer] The maximum value (default: 100).
  #
  # @option kws step [Integer] The step increment (default: 1).
  #
  # @option kws value [Integer] The current value (default: min).
  #
  # @option kws disabled [Boolean] Whether the range input is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the range input is required for form
  #   validation. Defaults to false.
  #
  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @min = config_option(:min, 0)
    @max = config_option(:max, 100)
    @step = config_option(:step, 1)
    @value = config_option(:value, @min)
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
  # attributes. Sets the tag to input with type 'range' and adds the 'range' CSS class.
  #
  # This configures the min, max, step values along with name, id, value, disabled state, 
  # and required state of the range input.
  #
  def setup_component
    set_tag_name(:component, :input)

    add_css(:component, "range")

    add_html(:component, {
      type: "range",
      name: @name,
      id: @id,
      min: @min,
      max: @max,
      step: @step,
      value: @value,
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
