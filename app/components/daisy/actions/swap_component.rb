#
# The Swap component allows toggling between two states, "on" and "off", with an
# optional indeterminate state. It is designed to be used as a switch or toggle
# button.
#
# @part checkbox The checkbox input element that handles the toggle state.
# @part on Wraps the HTML content displayed when the swap is in the "on" state.
# @part off Wraps the HTML content displayed when the swap is in the "off" state.
# @part indeterminate Wraps the HTML content displayed when the swap is in an
#   indeterminate state.
#
# @slot on The HTML content to be displayed when the swap is in the "on" state.
# @slot off The HTML content to be displayed when the swap is in the "off" state.
# @slot indeterminate The HTML content to be displayed when the swap is in an
#   indeterminate state.
#
# @loco_example Basic Usage
#   = daisy_swap(checked: true, on: "✅ On", off: "❌ Off", css: "swap-rotate")
#
# @loco_example Basic Usage with Args
#   = daisy_swap("✅ On", "❌ Off", true, css: "swap-rotate")
#
# @loco_example Custom Swap with Indeterminate State
#   = daisy_swap(tip: "I'm special") do |swap|
#     - swap.with_on do
#       %span On
#     - swap.with_off do
#       %span Off
#     - swap.with_indeterminate do
#       %span Indeterminate
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
  # Instantiate a new Swap component. The component can be initialized either with
  # positional arguments or keyword arguments.
  #
  # @param on      [String] A simple text or emoji to display when the swap is in
  #   the "on" state.
  #
  # @param off     [String] A simple text or emoji to display when the swap is in
  #   the "off" state.
  #
  # @param checked [Boolean] Whether the swap should start in the checked state.
  #   Defaults to false.
  #
  # @param kwargs  [Hash] The keyword arguments for the component.
  #
  # @option kwargs checked [Boolean] Whether the swap should start in the
  #   checked state. Defaults to false.
  #
  # @option kwargs on [String] A simple text or emoji to display when the swap
  #   is in the "on" state (see {simple_on}).
  #
  # @option kwargs off [String] A simple text or emoji to display when the swap
  #   is in the "off" state (see {simple_off}).
  #
  def initialize(*args, **kwargs, &block)
    super

    on, off, checked = args
    @checked = config_option(:checked, checked || false)
    @simple_on = config_option(:on, on)
    @simple_off = config_option(:off, off)
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
