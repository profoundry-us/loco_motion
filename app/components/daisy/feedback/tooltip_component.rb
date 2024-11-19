#
# A component that displays a tooltip when the user hovers over it.
#
# @loco_example Basic Usage
#   = daisy_tooltip "This is a tooltip" do
#     %span Hover over me
#
class Daisy::Feedback::TooltipComponent < LocoMotion::BaseComponent

  #
  # Create a new instance of the Tooltip.
  #
  # @param args [Array] If provided, the first argument is considered the `tip`.
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws tip [String] The text to display in the tooltip. Can be passed
  #   as the first positional argument, or as a keyword argument.
  #
  def initialize(*args, **kws, &block)
    super

    # Accept a `tip` keyword argument, or the first positional argument
    @tip = config_option(:tip, args[0])
  end

  #
  # Sets up the components CSS and HTML attributes.
  #
  def before_render
    add_css(:component, "tooltip")
    add_html(:component, { data: { tip: @tip } }) if @tip
  end

  #
  # Renders the component and it's content (inline).
  #
  def call
    part(:component) { content }
  end

end
