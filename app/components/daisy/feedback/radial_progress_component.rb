#
# The RadialProgressComponent displays a circular progress indicator that can be
# customized with different sizes, thicknesses, and colors. The component can
# also contain content within its circular display.
#
# The progress is always displayed as a percentage (0-100) due to the way the
# component is rendered using CSS custom properties.
#
# @loco_example Basic Usage
#   = daisy_radial(value: 66) do
#     66%
#
# @loco_example With Icons
#   = daisy_radial(value: 68) do
#     = hero_icon("beaker", css: "size-8 text-purple-500")
#
#   = daisy_radial(value: 52, css: "text-success") do
#     52%
#
# @loco_example Custom Size and Styling
#   = daisy_radial(value: 19, size: "15rem", thickness: "4px",
#     css: "bg-primary text-primary-content text-3xl") do
#     19%
#
class Daisy::Feedback::RadialProgressComponent < LocoMotion::BaseComponent

  #
  # Creates a new Radial Progress component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the radial progress.
  #
  # @option kws value      [Integer] The current progress value as a
  #   percentage (0-100). Required for the progress to be displayed.
  #
  # @option kws size       [String] The size of the radial progress component.
  #   Must include CSS units (e.g., "5rem", "100px"). Defaults to "5rem".
  #
  # @option kws thickness [String] The thickness of the progress ring. Must
  #   include CSS units (e.g., "4px", "0.5rem"). Defaults to one-tenth of
  #   the size.
  #
  # @option kws css       [String] Additional CSS classes for styling. Common
  #   options include color classes like `text-success` or `text-error`,
  #   background colors like `bg-primary`, and text sizing like `text-3xl`.
  #
  def initialize(*args, **kws, &block)
    super

    @value = config_option(:value)
    @size = config_option(:size)
    @thickness = config_option(:thickness)
  end

  def before_render
    add_css(:component, "radial-progress")

    styles = []

    styles << "--value: #{@value}" if @value != nil
    styles << "--size: #{@size}" if @size != nil
    styles << "--thickness: #{@thickness}" if @thickness != nil

    add_html(:component, { role: "progressbar" })
    add_html(:component, { style: styles.join(";") }) if styles.present?
  end

  def call
    part(:component) { content }
  end

end
