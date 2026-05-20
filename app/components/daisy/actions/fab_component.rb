#
# The FAB (Floating Action Button) component renders a floating button
# that stays in the corner of the screen. When clicked or focused, it
# can optionally show a speed dial of action buttons in a vertical or
# flower arrangement.
#
# The component follows the DaisyUI FAB pattern, using a focusable
# `<div>` with `tabindex="0"` and `role="button"` as the trigger
# instead of a `<button>` element to work around a long-standing
# Safari CSS focus bug.
#
# @note The trigger uses a `<div>` instead of a `<button>` because
#   Safari has a CSS bug since 2008 that prevents `<button>` elements
#   from being focused via CSS `:focus`. Using `<div tabindex="0"
#   role="button">` is the accessible workaround recommended by
#   DaisyUI.
#
# @part trigger The default trigger element rendered when no custom
#   button or activator slot is provided. Configured as a `<div>` with
#   `role="button"` and `tabindex="0"` for cross-browser focus
#   support.
#
# @slot button The main FAB trigger rendered as a `<div>` (not a
#   native `<button>`) with `role="button"`, `tabindex="0"`, and the
#   `btn` CSS class. Pass additional DaisyUI button classes such as
#   `btn-primary`, `btn-circle`, and `btn-lg` via the `css:` option.
# @slot activator A fully custom activator element for the FAB
#   trigger. Automatically adds `role="button"` and `tabindex="0"`
#   attributes for accessibility.
# @slot action+ The speed dial action buttons shown when the FAB is
#   opened. Each action renders a {Daisy::Actions::ButtonComponent}.
#
# @loco_example Basic FAB
#   = daisy_fab do |fab|
#     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
#       F
#
# @loco_example FAB with Speed Dial
#   = daisy_fab do |fab|
#     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
#       +
#     - fab.with_action(css: "btn-circle btn-lg") do
#       A
#     - fab.with_action(css: "btn-circle btn-lg") do
#       B
#     - fab.with_action(css: "btn-circle btn-lg") do
#       C
#
# @loco_example FAB Flower
#   = daisy_fab(css: "fab-flower") do |fab|
#     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
#       F
#     - fab.with_action(css: "btn-circle btn-lg") do
#       A
#     - fab.with_action(css: "btn-circle btn-lg") do
#       B
#     - fab.with_action(css: "btn-circle btn-lg") do
#       C
#
class Daisy::Actions::FabComponent < LocoMotion::BaseComponent

  define_parts :trigger

  renders_one :activator, LocoMotion::BasicComponent.build(
    html: { role: "button", tabindex: 0 }
  )

  renders_one :button, LocoMotion::BasicComponent.build(
    tag_name: :div,
    css: "btn",
    html: { role: "button", tabindex: 0 }
  )

  renders_many :actions, Daisy::Actions::ButtonComponent

  #
  # Creates a new instance of the FabComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  def initialize(**kws)
    super(**kws)
  end

  #
  # Adds the relevant DaisyUI classes to the component and sets up the
  # default trigger part.
  #
  def before_render
    setup_component
    setup_trigger
  end

  private

  #
  # Adds the `fab` CSS class to the component wrapper.
  #
  def setup_component
    add_css(:component, "fab")
  end

  #
  # Configures the default trigger part as a focusable `<div>` with
  # `role="button"` and `tabindex="0"` for cross-browser focus support.
  # Only used when no `button` or `activator` slot is provided.
  #
  def setup_trigger
    set_tag_name(:trigger, :div)
    add_html(:trigger, { role: "button", tabindex: 0 })
    add_css(:trigger, "btn")
  end
end
