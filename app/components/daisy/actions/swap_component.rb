#
# The Swap component allows toggling between two states, "on" and "off", with an
# optional indeterminate state. It provides a flexible way to create animated
# toggles, switches, or any other element that needs to alternate between
# different visual states. The component supports both simple text/emoji swaps
# and complex HTML content swaps.
#
# It also includes built-in animations that can be enabled through CSS classes
# like `swap-rotate` or `swap-flip`.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @part checkbox The checkbox input element that handles the toggle state.
# @part on Wraps the HTML content displayed when the swap is in the "on" state.
# @part off Wraps the HTML content displayed when the swap is in the "off" state.
# @part indeterminate Wraps the HTML content displayed when the swap is in an
#   indeterminate state. Only shown when the checkbox is in an indeterminate
#   state.
#
# @slot on The HTML content to be displayed when the swap is in the "on" state.
# @slot off The HTML content to be displayed when the swap is in the "off" state.
# @slot indeterminate The HTML content to be displayed when the swap is in an
#   indeterminate state.
#
# @loco_example Basic Text Swap
#   = daisy_swap(checked: true, on: "✅ On", off: "❌ Off", css: "swap-rotate")
#
# @loco_example Basic Usage with Args
#   = daisy_swap("✅ On", "❌ Off", true, css: "swap-rotate")
#
# @loco_example Icon Swap with Tooltip
#   = daisy_swap(tip: "Toggle Theme") do |swap|
#     - swap.with_on do
#       = heroicon_tag "sun", css: "size-6"
#     - swap.with_off do
#       = heroicon_tag "moon", css: "size-6"
#
# @loco_example Complex Content with Animation
#   = daisy_swap(css: "swap-flip") do |swap|
#     - swap.with_on do
#       .bg-primary.text-primary-content.p-4.rounded-lg
#         .font-bold Subscribed
#         %p You're all set!
#     - swap.with_off do
#       .bg-base-200.p-4.rounded-lg
#         .font-bold Subscribe
#         %p Click to join
#
# @loco_example With Indeterminate State
#   = daisy_swap(css: "swap-flip", tip: "Task Status") do |swap|
#     - swap.with_on do
#       .text-success
#         = heroicon_tag "check-circle"
#         %span Complete
#     - swap.with_off do
#       .text-error
#         = heroicon_tag "x-circle"
#         %span Failed
#     - swap.with_indeterminate do
#       .text-warning
#         = heroicon_tag "clock"
#         %span Processing
#
class Daisy::Actions::SwapComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  class SwapOn < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "swap-on")
    end
  end

  class SwapOff < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "swap-off")
    end
  end

  class SwapIndeterminate < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "swap-indeterminate")
    end
  end

  define_parts :checkbox, :on, :off

  renders_one :on, SwapOn
  renders_one :off, SwapOff
  renders_one :indeterminate, SwapIndeterminate

  # @return [String] The value of the `on` option. Usually text or emoji.
  attr_reader :simple_on

  # @return [String] The value of the `off` option. Usually text or emoji.
  attr_reader :simple_off

  #
  # Creates a new instance of the SwapComponent.
  #
  # @param on [String] Simple text/emoji to display in the "on" state. If provided
  #   along with `off`, enables simple text swap mode.
  #
  # @param off [String] Simple text/emoji to display in the "off" state. If provided
  #   along with `on`, enables simple text swap mode.
  #
  # @param checked [Boolean] Whether the swap should start in the checked ("on")
  #   state. Defaults to false.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws on [String] Simple text/emoji for the "on" state. Alternative to
  #   providing it as the first argument.
  #
  # @option kws off [String] Simple text/emoji for the "off" state. Alternative to
  #   providing it as the second argument.
  #
  # @option kws checked [Boolean] Whether the swap should start checked. Alternative
  #   to providing it as the third argument.
  #
  # @option kws indeterminate [Boolean] If true, starts the swap in an indeterminate
  #   state. Requires the indeterminate slot to be meaningful.
  #
  # @option kws tip [String] The tooltip text to display when hovering over
  #   the component.
  #
  def initialize(on = nil, off = nil, checked = nil, **kws, &block)
    super

    @checked = config_option(:checked, checked || false)
    @simple_on = config_option(:on, on)
    @simple_off = config_option(:off, off)
    
    initialize_tippable_component
  end

  #
  # Sets up the component with various CSS classes and HTML attributes.
  #
  def before_render
    setup_component
    setup_checkbox
    setup_on_off
  end

  private

  #
  # Sets up the main component structure. The component is rendered as a label
  # element to allow clicking anywhere on it to toggle the checkbox.
  #
  def setup_component
    set_tag_name(:component, :label)
    add_css(:component, "swap")
    setup_tippable_component
  end

  #
  # Sets up the checkbox input element that handles the toggle state.
  #
  def setup_checkbox
    set_tag_name(:checkbox, :input)
    add_html(:checkbox, { type: "checkbox", checked: @checked })
  end

  #
  # Sets up the CSS classes for the "on" and "off" states.
  #
  def setup_on_off
    add_css(:on, "swap-on")
    add_css(:off, "swap-off")
  end
end
