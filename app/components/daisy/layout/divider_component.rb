#
# The DividerComponent creates a visual separator between content sections,
# either horizontally or vertically. It can include optional text or content
# in the center and supports various colors to match your theme.
#
# Common use cases include:
# - Separating sections of a page.
# - Creating visual breaks between cards or content blocks.
# - Providing alternative options with "OR" text.
# - Organizing form sections.
#
# @loco_example Basic Dividers
#   = daisy_divider
#
#   = daisy_divider do
#     OR
#
# @loco_example Vertical Dividers
#   .flex.grow
#     = daisy_card(css: "h-48") do
#       Left Content
#
#     = daisy_divider(css: "divider-horizontal") do
#       OR
#
#     = daisy_card(css: "h-48") do
#       Right Content
#
# @loco_example Colored Dividers
#   = daisy_divider(css: "divider-primary") do
#     Primary
#
#   = daisy_divider(css: "divider-accent") do
#     Accent
#
#   = daisy_divider(css: "divider-success") do
#     Success
#
class Daisy::Layout::DividerComponent < LocoMotion::BaseComponent

  #
  # Creates a new Divider component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the divider.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Orientation: `divider-horizontal` for vertical divider
  #   - Colors: `divider-neutral`, `divider-primary`, `divider-secondary`,
  #     `divider-accent`, `divider-info`, `divider-success`,
  #     `divider-warning`, `divider-error`
  #
  def initialize(title = nil, **kws, &block)
    super

    @simple_title = config_option(:title, title)
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "divider")
  end

  #
  # Renders the component and its content.
  #
  def call
    part(:component) { content || @simple_title }
  end

end
