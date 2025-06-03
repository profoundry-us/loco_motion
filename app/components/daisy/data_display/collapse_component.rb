#
# The Collapse component creates an expandable/collapsible section of content
# with a title that toggles visibility. It's similar to the Accordion component
# but designed for standalone use rather than groups.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @part title The clickable title bar that toggles the content visibility.
# @part wrapper The container for the collapsible content.
#
# @slot title Custom content for the title bar. You can also provide a simple
#   title string via the title option.
#
# @loco_example Basic Usage
#   = daisy_collapse(title: "Click to expand") do
#     This content can be shown or hidden.
#
# @loco_example With Custom Title
#   = daisy_collapse do |collapse|
#     - collapse.with_title do
#       .flex.items-center.gap-2
#         = heroicon "chevron-down"
#         Advanced Settings
#     %p These are some advanced configuration options.
#     = daisy_button("Apply Settings")
#
# @loco_example With Focus Mode
#   = daisy_collapse(checkbox: false) do |collapse|
#     - collapse.with_title do
#       Click or use keyboard to toggle
#     This content can be focused and toggled with the keyboard.
#
# @loco_example With Arrow
#   = daisy_collapse(title: "Expandable Section", css: "collapse-arrow") do
#     This section has an arrow indicator.
#
# @loco_example With Plus/Minus
#   = daisy_collapse(title: "Expandable Section", css: "collapse-plus") do
#     This section has a plus/minus indicator.
#
class Daisy::DataDisplay::CollapseComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent

  define_parts :title, :wrapper

  renders_one :title

  # @return [String] The title text when using the simple title option.
  attr_reader :simple_title

  # @return [Boolean] Whether to use a checkbox for toggle state (true) or
  #   focus/tabindex mode (false).
  attr_reader :checkbox

  #
  # Creates a new collapse component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws title [String] The text to display in the title bar. You can
  #   also provide custom title content using the title slot.
  #
  # @option kws checkbox [Boolean] Whether to use a checkbox for toggle state
  #   (true) or focus/tabindex mode (false). Defaults to true.
  #
  # @option kws tip [String] The tooltip text to display when hovering over
  #   the component.
  #
  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title)
    @checkbox = config_option(:checkbox, true)
  end

  def before_render
    setup_component # Set base styles/attributes
    super           # Run concern setup hooks
    setup_title     # Set title part styles
    setup_wrapper   # Set wrapper part styles
  end

  def setup_component
    add_css(:component, "collapse")
    add_html(:component, { tabindex: 0 }) unless @checkbox
  end

  def setup_title
    add_css(:title, "collapse-title")
  end

  def setup_wrapper
    add_css(:wrapper, "collapse-content")
  end

  def has_title?
    title? || @simple_title.present?
  end
end
