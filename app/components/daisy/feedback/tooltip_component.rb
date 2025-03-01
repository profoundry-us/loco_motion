#
# The TooltipComponent displays informative text when users hover over an
# element. It can be used in two ways:
# 1. As a wrapper component around any HTML content.
# 2. Through the TippableComponent concern, which many components include.
#
# This component is also aliased as `daisy_tip` for convenience.
#
# @loco_example Basic Usage
#   = daisy_tip "Helpful information" do
#     %span Need help?
#
#   = daisy_tip "Delete this item", css: "tooltip-error" do
#     = hero_icon("trash", css: "size-5 text-error")
#
# @loco_example Positioned Tips
#   = daisy_tip "Opens settings menu", css: "tooltip-left" do
#     = daisy_button(title: "Settings", icon: "cog-6-tooth")
#
#   = daisy_tip "View user profile", css: "tooltip-bottom tooltip-info" do
#     = daisy_avatar(src: image_path("avatars/user.jpg"))
#
# @loco_example Component Integration
#   = daisy_button(title: "Save Changes",
#     css: "btn-primary",
#     tip: "Save your current progress")
#
#   = daisy_chat do |chat|
#     - chat.with_avatar(css: "tooltip-left tooltip-info",
#       tip: "Online",
#       src: image_path("avatars/user.jpg"))
#     - chat.with_bubble do
#       Hello!
#
class Daisy::Feedback::TooltipComponent < LocoMotion::BaseComponent

  #
  # Creates a new Tooltip component.
  #
  # @param args [Array] If provided, the first argument is used as the `tip`
  #   text.
  # @param kws  [Hash]  Keyword arguments for customizing the tooltip.
  #
  # @option kws tip [String] The text to display in the tooltip. Can be
  #   passed as the first positional argument or as a keyword argument.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Position modifiers: `tooltip-top`, `tooltip-bottom`,
  #     `tooltip-left`, `tooltip-right`
  #   - Colors: `tooltip-primary`, `tooltip-secondary`, `tooltip-accent`,
  #     `tooltip-info`, `tooltip-success`, `tooltip-warning`, `tooltip-error`
  #   - Open state: `tooltip-open`
  #
  def initialize(*args, **kws, &block)
    super

    # Accept a `tip` keyword argument, or the first positional argument
    @tip = config_option(:tip, args[0])
  end

  #
  # Sets up the component's CSS and HTML attributes.
  #
  def before_render
    add_css(:component, "tooltip")
    add_html(:component, { data: { tip: @tip } }) if @tip
  end

  #
  # Renders the component and its content (inline).
  #
  def call
    part(:component) { content }
  end

end
