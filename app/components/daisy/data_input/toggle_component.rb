# frozen_string_literal: true

#
# The Toggle component renders a DaisyUI styled toggle switch.
# It can be used standalone or with a form builder, and provides a visual way
# to toggle between two states (on/off).
#
# @part label_wrapper The wrapper element for labels (when using
#   start/end/floating labels).
# @part start The element that contains the start label (appears before the
#   toggle).
# @part end The element that contains the end label (appears after the toggle).
#
# @slot start Custom content for the start label.
# @slot end Custom content for the end label.
#
# @loco_example Basic Usage
#   = daisy_toggle(name: "notifications", id: "notifications")
#
# @loco_example Checked Toggle
#   = daisy_toggle(name: "notifications", id: "notifications", checked: true)
#
# @loco_example Colored Toggle
#   = daisy_toggle(name: "theme", id: "theme", css: "toggle-primary", checked: true)
#
# @loco_example Disabled Toggle
#   = daisy_toggle(name: "disabled", id: "disabled", disabled: true)
#
# @loco_example With End Label (common for toggles)
#   = daisy_toggle(name: "notifications", id: "notifications", end: "Enable notifications")
#
class Daisy::DataInput::ToggleComponent < Daisy::DataInput::CheckboxComponent
  #
  # Instantiate a new Toggle component.
  #
  # This component accepts the same options as {Daisy::DataInput::CheckboxComponent},
  # but always sets `toggle: true` to render the checkbox as a toggle switch.
  #
  # @param kws [Hash] The keyword arguments for the component. See
  #   {Daisy::DataInput::CheckboxComponent#initialize} for available options.
  #
  def initialize(**kws)
    # Always force toggle to be true
    kws[:toggle] = true

    super(**kws)
  end
end
