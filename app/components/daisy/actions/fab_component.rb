#
# The FAB (Floating Action Button) component stays in the bottom corner
# of the screen and can optionally show a speed dial of action buttons
# when opened.
#
# It provides a focusable trigger element with `role="button"` and
# `tabindex="0"` for accessibility, along with optional action buttons
# that appear in a vertical or flower arrangement.
#
# @note The trigger uses a `<div>` with `tabindex="0"` instead of a
#   `<button>` due to a long-standing Safari CSS bug that prevents
#   `<button>` elements from receiving focus properly.
#
# @slot button [Daisy::Actions::ButtonComponent] The main trigger
#   button for the FAB. Styled automatically as a DaisyUI button.
#
# @slot activator [LocoMotion::BasicComponent] A custom (non-button)
#   activator for the FAB. Automatically adds `role="button"` and
#   `tabindex="0"` for accessibility.
#
# @slot action+ [LocoMotion::BasicComponent] The speed dial action
#   buttons that appear when the FAB is opened.
#
# @slot close [LocoMotion::BasicComponent] An optional close button
#   shown when the FAB is open. Wraps content in a `fab-close`
#   container. Either use `close` or `main_action`, not both.
#
# @slot main_action [LocoMotion::BasicComponent] An optional main
#   action button shown when the FAB is open. Wraps content in a
#   `fab-main-action` container. Either use `main_action` or `close`,
#   not both.
#
# @loco_example Basic FAB
#   = daisy_fab do |fab|
#     - fab.with_button(css: "btn-circle btn-primary btn-lg") do
#       F
#
# @loco_example FAB with Speed Dial
#   = daisy_fab do |fab|
#     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
#       +
#     - fab.with_action do
#       = daisy_button(css: "btn-circle btn-lg") { "A" }
#     - fab.with_action do
#       = daisy_button(css: "btn-circle btn-lg") { "B" }
#     - fab.with_action do
#       = daisy_button(css: "btn-circle btn-lg") { "C" }
#
# @loco_example FAB Flower
#   = daisy_fab(css: "fab-flower") do |fab|
#     - fab.with_button(css: "btn-circle btn-primary btn-lg") do
#       F
#     - fab.with_action do
#       = daisy_button(css: "btn-circle btn-lg") { "A" }
#     - fab.with_action do
#       = daisy_button(css: "btn-circle btn-lg") { "B" }
#     - fab.with_action do
#       = daisy_button(css: "btn-circle btn-lg") { "C" }
#
class Daisy::Actions::FabComponent < LocoMotion::BaseComponent

  include ViewComponent::SlotableDefault

  renders_one :activator, LocoMotion::BasicComponent.build(
    html: { role: "button", tabindex: 0 }
  )
  renders_one :button, Daisy::Actions::ButtonComponent
  renders_many :actions
  renders_one :close, LocoMotion::BasicComponent.build(css: "fab-close")
  renders_one :main_action, LocoMotion::BasicComponent.build(
    css: "fab-main-action"
  )

  #
  # Creates a new instance of the FabComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  def initialize(**kws)
    super(**kws)
  end

  #
  # Adds the relevant Daisy classes to the component.
  #
  def before_render
    setup_component
  end

  private

  #
  # Add the `fab` CSS class to the component.
  #
  def setup_component
    add_css(:component, "fab")
  end
end
